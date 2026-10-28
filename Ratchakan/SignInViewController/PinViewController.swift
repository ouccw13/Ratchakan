//
//  PinViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 2/4/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

enum TypeDashboard {
	case banner
	case menu
	case bankTitle
	case bankImage
	case other
	
	func returnHeight() -> CGFloat {
		switch self {
		case .banner:
			return 1.5
		default:
			return 1
		}
	}
}

class PinViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, GridLayoutDelegate {

	typealias CellData = (index: Int, typeCell: TypeDashboard, title: String)
	var flexibleCollectionView: UICollectionView!
	let collectionData: [CellData] = [(1, .banner, "Banner"),
								(2, .menu, "Appointment"),
								(3, .menu, "2"),
								(4, .menu, "3"),
								(5, .menu, "4"),
								(6, .menu, "5"),
//								(7, .menu, "2"),
								(8, .bankTitle, "1"),
								(9, .bankImage, "1"),
								(10, .bankTitle, "2"),
								(11, .bankImage, "2"),
								(12, .bankTitle, "3"),
								(13, .bankImage, "3"),
								(14, .bankTitle, "4"),
								(15, .bankImage, "4"),
								(16, .other, "1"),
								(17, .other, "2")]
	
	var pinCollectionView: UICollectionView!
	let pinNum = [1,2,3,4,5,6,7,8,9,10,0,12]

	let cellWidth: CGFloat = 80
	let innerSpace: CGFloat = 10
	
	var pinLabel: UILabel!
	var pinText: String!
	var nowPinIndex: Int!
	
	var pinBefore: String!
	
	@objc func back(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()

		let flexibleCollectionLayout = GridLayout()
		flexibleCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: flexibleCollectionLayout)
		flexibleCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
		flexibleCollectionView.delegate = self
		flexibleCollectionView.dataSource = self
		flexibleCollectionView.contentInset = UIEdgeInsets(top: MARGIN, left: MARGIN, bottom: MARGIN, right: MARGIN)
		
		flexibleCollectionLayout.delegate = self
		flexibleCollectionLayout.itemSpacing = MARGIN
		flexibleCollectionLayout.fixedDivisionCount = 3
		flexibleCollectionLayout.scrollDirection = .vertical
		
		nowPinIndex = 0
		pinText = "------"
		pinLabel = UILabel()
		pinLabel.setParameter(font: UIFont.systemFont(ofSize: 30), color: .white, alignment: .center)
		pinLabel.text = pinText.inserting(separator: " ", every: 1)
		
		let backButton = UIButton(frame: CGRect(x: 10, y: TOP_VIEW, width: 100, height: 30))
		backButton.setParameter("back", textColor: .white, font: UIFont.systemFont(ofSize: 18), backgroundColor: .clear)
		backButton.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
		view.addSubview(backButton)
		
		view.backgroundColor = .lightGray
	
		let collectionWidth: CGFloat = cellWidth*3 + 4*innerSpace
		let collectionHeight: CGFloat = cellWidth*4 + 3*innerSpace
		let collectionLayout = CollectionLayout(withcol: 3, height: cellWidth, axis: .vertical, innerLine: innerSpace, innerInteritem: innerSpace)
		pinCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: collectionWidth, height: collectionHeight), collectionViewLayout: collectionLayout)
        pinCollectionView.setUp(self, bg: .clear, inset: UIEdgeInsets(top: 0, left: innerSpace, bottom: 0, right: innerSpace))
		pinCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
		
		view.addSubview(flexibleCollectionView)//pinCollectionView)
		flexibleCollectionView.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize(width: collectionWidth, height: collectionHeight))
			make.centerX.equalTo(view.snp.centerX)
			make.centerY.equalTo(view.snp.centerY).offset(TOP_VIEW)
		}
		view.addSubview(pinLabel)
//		pinLabel.snp.makeConstraints { (make) in
//			make.leading.equalTo(pinCollectionView.snp.leading)
//			make.trailing.equalTo(pinCollectionView.snp.trailing)
//			make.height.equalTo(35)
//			make.bottom.equalTo(pinCollectionView.snp.top).offset(-MARGIN)
//		}
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	fileprivate func endSetPin() {
		if let beforePin = pinBefore {
			if beforePin == pinText {
				back(UIButton())
			} else {
				pinText = "------"
				nowPinIndex = 0
			}
		} else {
			pinBefore = pinText
			pinText = "------"
			nowPinIndex = 0
		}
		pinLabel.text = pinText.inserting(separator: " ", every: 1)
	}
	
	@objc func setPinAction(_ sender: UIButton) {
        pinText = pinText.replacing(at: nowPinIndex, with: "\(sender.tag)".first!)
		if nowPinIndex < 5 {
			nowPinIndex = nowPinIndex + 1
		} else if nowPinIndex == 5 {
			Utility.delayFunc(endSetPin())
		}
		pinLabel.text = pinText.inserting(separator: " ", every: 1)
	}
	@objc func deletePinAction(_ sender: UIButton) {
		pinText = pinText.replacing(at: nowPinIndex, with: "-")
		if nowPinIndex != 0 {
			nowPinIndex = nowPinIndex - 1
		}
		pinLabel.text = pinText.inserting(separator: " ", every: 1)
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == flexibleCollectionView {
			return collectionData.count
		}
		return pinNum.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
		
		if collectionView == flexibleCollectionView {
			cell.backgroundColor = .white
			cell.cornerView(radius: 4)
		} else {
			if pinNum[indexPath.item] != 10 && pinNum[indexPath.item] != 12 {
				let numButton = UIButton()
				numButton.setParameter("\(pinNum[indexPath.item])", textColor: .white, font: UIFont.systemFont(ofSize: 26), backgroundColor: .clearCanTouch)
				numButton.cornerView(radius: cellWidth/2)
				numButton.borderView(color: .white, width: 1.0)
				numButton.tag = pinNum[indexPath.item]
				cell.contentView.addSubview(numButton)
				numButton.snp.remakeConstraints { (make) in
					make.edges.equalTo(cell.contentView.snp.edges)
				}
				numButton.addTarget(self, action: #selector(setPinAction(_:)), for: .touchUpInside)
				
			} else if pinNum[indexPath.item] == 12 {
				let deleteButton = UIButton()
				deleteButton.setImage(#imageLiteral(resourceName: "backIcon"), for: .normal)
				deleteButton.backgroundColor = .clearCanTouch
				cell.contentView.addSubview(deleteButton)
				deleteButton.snp.remakeConstraints { (make) in
					make.edges.equalTo(cell.contentView.snp.edges)
				}
				deleteButton.addTarget(self, action: #selector(deletePinAction(_:)), for: .touchUpInside)
			}
		}
		return cell
	}
	
	func itemDimension(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, atIndex index: Int) -> TypeDashboard {
		return collectionData[index].typeCell
	}
}

