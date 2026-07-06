//
//  CustomPageControl.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 21/8/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit
import CGMath

class CustomPageControl: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    var pages: Int = 0 {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }
    
    var selectedPage: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var dotColor: UIColor = .gray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var selectedColor: UIColor = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var dotSize: CGFloat = 6 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var spacing: CGFloat = 6 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var collectionView: UICollectionView!
    
    override var intrinsicContentSize: CGSize {
        let pages = min(7, self.pages)
        let width = CGFloat(pages) * dotSize + CGFloat(pages - 1) * spacing
        let height = dotSize
        return .init(width: width, height: height)
    }

    init() {
        super.init(frame: .zero)
        isOpaque = true
        
        let layout: UICollectionViewFlowLayout = {
            let lo = UICollectionViewFlowLayout()
            lo.itemSize = CGSize(width: dotSize, height: dotSize)
            lo.minimumInteritemSpacing = spacing
            lo.minimumLineSpacing = spacing
            lo.scrollDirection = .horizontal
            return lo
        }()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(DotCell.self, forCellWithReuseIdentifier: DotCell.identifier)
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        }
        
    }
    
    func selectPage(indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DotCell.identifier, for: indexPath) as! DotCell
        
        cell.color = dotColor
        cell.selectedColor = selectedColor
        
        cell.colorView.layer.cornerRadius = dotSize/2
        return cell
    }
}

fileprivate class DotCell: UICollectionViewCell {
    
    static let identifier = "DotCell"
    
    let colorView = UIView()
    
    var color: UIColor = .black {
        didSet {
            colorView.backgroundColor = color
        }
    }
    
    var selectedColor: UIColor = .white
    
    override var isSelected: Bool {
        didSet {
            colorView.backgroundColor = isSelected ? selectedColor : color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(colorView)
        
        colorView.backgroundColor = color
        colorView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
