//
//  CollectionLayout.swift
//  ratchakan
//
//  Created by JJsobtid on 5/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class CollectionLayout: UICollectionViewFlowLayout {
	
	var innerSpace: CGFloat = MARGIN
	var numberOfColumn: CGFloat = 1.0
	var cellHeight: CGFloat = 91
	
    init(withcol col: CGFloat, height: CGFloat, axis: UICollectionView.ScrollDirection = .vertical, innerLine: CGFloat = MARGIN, innerInteritem: CGFloat = MARGIN) {
		super.init()
		innerSpace = innerInteritem
		minimumLineSpacing = innerLine
		minimumInteritemSpacing = innerInteritem
		cellHeight = height
		numberOfColumn = col + 0.0001
		scrollDirection = axis
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func cellWidth() -> CGFloat {
		
		return (collectionView!.frame.size.width - (innerSpace * (numberOfColumn + 1)))/numberOfColumn//(collectionView!.frame.size.width/numberOfColumn) - (1/numberOfColumn+1)*innerSpace
	}
	
	override var itemSize: CGSize {
		set {
			self.itemSize = CGSize(width: cellWidth(), height: cellHeight)
		}
		get {
			return CGSize(width: cellWidth(), height:cellHeight)
		}
	}
	
	override var estimatedItemSize: CGSize {
		set {
			self.estimatedItemSize = CGSize(width: cellWidth(), height: 1.0)
		}
		get {
			return CGSize(width: cellWidth(), height: 1.0)
		}
	}
}

protocol PinterestLayoutDelegate {
	// 1. Method to ask the delegate for the height of the image
	func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
	//1. Pinterest Layout Delegate
	var delegate: PinterestLayoutDelegate?
	
	//2. Configurable properties
	fileprivate var numberOfColumns = (IS_IPAD ? 2 : 1)
	fileprivate var cellPadding: CGFloat = MARGIN
	
	//3. Array to keep a cache of attributes.
	fileprivate var cache = [UICollectionViewLayoutAttributes]()
	
	//4. Content height and size
	fileprivate var contentHeight: CGFloat = 0
	
	fileprivate var contentWidth: CGFloat {
		guard let collectionView = collectionView else {
			return 0
		}
		let insets = collectionView.contentInset
		return collectionView.bounds.width - (insets.left + insets.right)
	}
	
	override var collectionViewContentSize: CGSize {
		return CGSize(width: contentWidth, height: contentHeight)
	}
	
	override func prepare() {
		// 1. Only calculate once
		guard cache.isEmpty == true, let collectionView = collectionView else {
			return
		}
		// 2. Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
		let columnWidth = contentWidth / CGFloat(numberOfColumns)
		var xOffset = [CGFloat]()
		for column in 0 ..< numberOfColumns {
			xOffset.append(CGFloat(column) * columnWidth)
		}
		var column = 0
		var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
		
		// 3. Iterates through the list of items in the first section
		for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
			
			let indexPath = IndexPath(item: item, section: 0)
			
			// 4. Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
			let photoHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
			let height = cellPadding * 2 + (photoHeight ?? 0)
			let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
			let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
			
			// 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
			let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
			attributes.frame = insetFrame
			cache.append(attributes)
			
			// 6. Updates the collection view content height
			contentHeight = max(contentHeight, frame.maxY)
			yOffset[column] = yOffset[column] + height
			
			column = column < (numberOfColumns - 1) ? (column + 1) : 0
		}
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		
		var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
		
		// Loop through the cache and look for items in the rect
		for attributes in cache {
			if attributes.frame.intersects(rect) {
				visibleLayoutAttributes.append(attributes)
			}
		}
		return visibleLayoutAttributes
	}
	
	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return cache[indexPath.item]
	}
}

protocol GridLayoutDelegate: class {
	func headerFlexibleDimension(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat
	func itemDimension(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, atIndex index: Int) -> TypeDashboard
}

extension GridLayoutDelegate {

	func headerFlexibleDimension(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat {
		return 0
	}
	func itemDimension(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, atIndex index: Int) -> TypeDashboard {
		return TypeDashboard.banner
	}
}

class GridLayout: UICollectionViewLayout, GridLayoutDelegate {
	override var collectionViewContentSize: CGSize {
		return CGSize(width: contentWidth, height: contentHeight)
	}
	
	// User-configurable 'knobs'
	
    var scrollDirection: UICollectionView.ScrollDirection = .vertical
	
	// Spacing between items
	var itemSpacing: CGFloat = 0
	
	// Prevent the user from giving an invalid fixedDivisionCount
	var fixedDivisionCount: UInt {
		get {
			return UInt(intFixedDivisionCount)
		}
		set {
			intFixedDivisionCount = newValue == 0 ? 1 : Int(newValue)
		}
	}
	
	weak var delegate: GridLayoutDelegate?
	
	/// Backing variable for fixedDivisionCount, is an Int since indices don't like UInt
	private var intFixedDivisionCount = 1
	private var contentWidth: CGFloat = 0
	private var contentHeight: CGFloat = 0
	private var itemFixedDimension: CGFloat = 0
	private var itemFlexibleDimension: CGFloat = 0
	private var rowHeight: CGFloat = 0
	
	/// This represents a 2 dimensional array for each section, indicating whether each block in the grid is occupied
	/// It is grown dynamically as needed to fit every item into a grid
	private var sectionedItemGrid: Array<Array<Array<Bool>>> = []
	
	/// The cache built up during the `prepare` function
	private var itemAttributesCache: Array<UICollectionViewLayoutAttributes> = []
	
	/// The header cache built up during the `prepare` function
	private var headerAttributesCache: Array<UICollectionViewLayoutAttributes> = []
	
	/// A convenient tuple for working with items
	private typealias ItemFrame = (section: Int, rowIndex: Float, columnIndex: Float, type: TypeDashboard)
	
	// MARK: - UICollectionView Layout
	
	override func prepare() {
		// On rotation, UICollectionView sometimes calls prepare without calling invalidateLayout
		guard itemAttributesCache.isEmpty, headerAttributesCache.isEmpty, let collectionView = collectionView else { return }
		
		let fixedDimension: CGFloat
		if scrollDirection == .vertical {
			fixedDimension = collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)
			contentWidth = fixedDimension
		} else {
			fixedDimension = collectionView.frame.height - (collectionView.contentInset.top + collectionView.contentInset.bottom)
			contentHeight = fixedDimension
		}
		
		var additionalSectionSpacing: CGFloat = 0
		let headerFlexibleDimension = (delegate ?? self).headerFlexibleDimension(inCollectionView: collectionView, withLayout: self, fixedDimension: fixedDimension)
		
		itemFixedDimension = (fixedDimension - (CGFloat(fixedDivisionCount) * itemSpacing) + itemSpacing) / CGFloat(fixedDivisionCount)
		itemFlexibleDimension = itemFixedDimension
		
		for section in 0 ..< collectionView.numberOfSections {
			let itemCount = collectionView.numberOfItems(inSection: section)
			
			// Calculate header attributes
			if headerFlexibleDimension > 0.0 && itemCount > 0 {
				if headerAttributesCache.count > 0 {
					additionalSectionSpacing += itemSpacing
				}
				
				let frame: CGRect
				if scrollDirection == .vertical {
					frame = CGRect(x: 0, y: additionalSectionSpacing, width: fixedDimension, height: headerFlexibleDimension)
				} else {
					frame = CGRect(x: additionalSectionSpacing, y: 0, width: headerFlexibleDimension, height: fixedDimension)
				}
                let headerLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: section))
				headerLayoutAttributes.frame = frame
				
				headerAttributesCache.append(headerLayoutAttributes)
				additionalSectionSpacing += headerFlexibleDimension
			}
			
			if headerFlexibleDimension > 0.0 || section > 0 {
				additionalSectionSpacing += itemSpacing
			}
			
			// Calculate item attributes
			let sectionOffset = additionalSectionSpacing
			sectionedItemGrid.append([])
			
			var rowIndex: Float = 0, columnIndex: Float = 0
			for item in 0 ..< itemCount {
				
				let typeCell = (delegate ?? self).itemDimension(inCollectionView: collectionView, withLayout: self, atIndex: item)
				if typeCell == .bankTitle && columnIndex != 0 {
					columnIndex = 0
					rowIndex += 1
					rowHeight += (itemFixedDimension * TypeDashboard.menu.returnHeight()) + itemSpacing
				}
				let itemIndexPath = IndexPath(item: item, section: section)
				let intendedFrame = ItemFrame(section, rowIndex, columnIndex, typeCell)
				
				let itemAttributes = layoutAttributes(for: itemIndexPath, at: intendedFrame, with: sectionOffset)
				
				itemAttributesCache.append(itemAttributes)
				
				// Update flexible dimension
				if scrollDirection == .vertical {
					if itemAttributes.frame.maxY > contentHeight {
						contentHeight = itemAttributes.frame.maxY
					}
					if itemAttributes.frame.maxY > additionalSectionSpacing {
						additionalSectionSpacing = itemAttributes.frame.maxY
					}
				} else {
					// .horizontal
					if itemAttributes.frame.maxX > contentWidth {
						contentWidth = itemAttributes.frame.maxX
					}
					if itemAttributes.frame.maxX > additionalSectionSpacing {
						additionalSectionSpacing = itemAttributes.frame.maxX
					}
				}
				
				if typeCell == .banner || typeCell == .bankImage {
					columnIndex = 0
					rowIndex += 1
					rowHeight += (itemFixedDimension * typeCell.returnHeight()) + itemSpacing
				} else if typeCell == .menu {
					if columnIndex < 2 {
						columnIndex += 1
					} else {
						columnIndex = 0
						rowIndex += 1
						rowHeight += (itemFixedDimension * typeCell.returnHeight()) + itemSpacing
					}
				} else if typeCell == .bankTitle {
					columnIndex += 2
				} else if typeCell == .other {
					if columnIndex <= 0.1 {
						columnIndex += 1.5
					} else {
						columnIndex = 0
						rowIndex += 1
						rowHeight += (itemFixedDimension * typeCell.returnHeight()) + itemSpacing
					}
				}
			}
		}
		sectionedItemGrid = [] // Only used during prepare, free up some memory
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		let headerAttributes = headerAttributesCache.filter {
			$0.frame.intersects(rect)
		}
		let itemAttributes = itemAttributesCache.filter {
			$0.frame.intersects(rect)
		}
		
		return headerAttributes + itemAttributes
	}
	
	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return itemAttributesCache.first {
			$0.indexPath == indexPath
		}
	}
	
	override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard elementKind == UICollectionView.elementKindSectionHeader else { return nil }
		
		return headerAttributesCache.first {
			$0.indexPath == indexPath
		}
	}
	
	override func invalidateLayout() {
		super.invalidateLayout()
		
		itemAttributesCache = []
		headerAttributesCache = []
		contentWidth = 0
		contentHeight = 0
	}
	
	// MARK: - Private
	private func layoutAttributes(for indexPath: IndexPath, at itemFrame: ItemFrame, with sectionOffset: CGFloat) -> UICollectionViewLayoutAttributes {
		let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
		
		let columnIndexOffset = CGFloat(itemFrame.columnIndex) * (itemSpacing + itemFixedDimension)
		let rowIndexOffset = rowHeight+sectionOffset//CGFloat(itemFrame.rowIndex) * (itemSpacing + itemFlexibleDimension) + sectionOffset
		var itemScaledTransverseDimension: CGFloat = 0//itemFixedDimension + (CGFloat(itemFrame.scale) * (itemSpacing + itemFixedDimension))
		var itemScaledLongitudinalDimension: CGFloat = (itemFixedDimension * itemFrame.type.returnHeight()) //itemFlexibleDimension + (CGFloat(itemFrame.scale) * (itemSpacing + itemFlexibleDimension))
		if itemFrame.type == .banner {
			itemScaledTransverseDimension = itemFlexibleDimension * 3.0 + itemSpacing * 2.0
			itemScaledLongitudinalDimension = (itemFixedDimension * itemFrame.type.returnHeight())
		} else if itemFrame.type == .bankTitle {
			itemScaledTransverseDimension = itemFlexibleDimension * 2.0 + itemSpacing
		} else if itemFrame.type == .other {
			itemScaledTransverseDimension = itemFlexibleDimension * 1.5 + itemSpacing * 0.5
		} else {
			itemScaledTransverseDimension = itemFlexibleDimension
		}
		if scrollDirection == .vertical {
			layoutAttributes.frame = CGRect(x: columnIndexOffset, y: rowIndexOffset, width: itemScaledTransverseDimension, height: itemScaledLongitudinalDimension)
		} else {
			layoutAttributes.frame = CGRect(x: rowIndexOffset, y: columnIndexOffset, width: itemScaledLongitudinalDimension, height: itemScaledTransverseDimension)
		}
		
		return layoutAttributes
	}
}

