//
//  StatSubjectGroupViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 19/3/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class StatSubjectGroupViewController: CustomViewControllerPushNavAndNoTabbar, CustomNavDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
	
	var refreshHeader: HeaderRefreshControl!
	var collectionView: UICollectionView!
	var collectionLayout: CollectionLayout!
	
	var nodataView: NoDataView!
	
	lazy var api = API()
	
	var statData: StatModel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		statData = StatModel([])
		
        topView = UIView()
        topView.backgroundColor = .navbrandcolor
		view.backgroundColor = .brandcolor_bg
		
        backButton = UIButton()
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.setAnimatedTouch()
        backButton.adjustsImageWhenHighlighted = false
        backButton.adjustsImageWhenDisabled = false
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        topView.addSubview(backButton)
        
        navTitleLabel = UILabel()
        navTitleLabel.setParameter(font: .navTitleFont, color: .cellWhiteLabel)
        navTitleLabel.numberOfLines = 2
        navTitleLabel.lineBreakMode = .byWordWrapping
        navTitleLabel.set(text: string.th_test_stats)
        topView.addSubview(navTitleLabel)
		view.addSubview(topView)
		topView.snp.makeConstraints { (make) in
			make.top.equalTo(0)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			make.height.equalTo(TOP_VIEW)
		}
        
        if IS_IPAD {
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY)
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY)
                make.centerX.equalTo(topView.snp.centerX)
            }
        }else{
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.centerX.equalTo(topView.snp.centerX)
            }
        }
		
        collectionLayout = CollectionLayout(withcol: (IS_IPAD ? 2 : 1), height:/* 56*/70, axis: .vertical)
		collectionLayout.headerReferenceSize = CGSize(width: SCREEN_WIDTH, height: 24)
        collectionLayout.sectionInset = UIEdgeInsets(top: MARGIN, left: 0, bottom: MARGIN, right: 0)
		
		collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionLayout)
		collectionView.hideScrollIndicatior()
		collectionView.alwaysBounceVertical = true
		collectionView.setUp(self, bg: .clear)
		var bottomInset = MARGIN
		if !Utility.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_11() {
			bottomInset += TABBAR_HEIGHT
		}
		
		if HAVE_NOTCH {
			
		} else {
            collectionView.contentInset = UIEdgeInsets(top: MARGIN, left: MARGIN, bottom: bottomInset, right: MARGIN)
		}
		collectionView.register(StatSubjectGroupCollectionViewCell.self, forCellWithReuseIdentifier: StatSubjectGroupCollectionViewCell.cellIdentifier)
        collectionView.register(HeaderSectionCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSectionCollectionView.headerIdentifier)
		
		refreshHeader = HeaderRefreshControl(withColor: .brandcolor1, titleAttribute: Utility.setStringAttributes(string.en_pull_refresh, textColor: .brandcolor1, font: .kanitReg14, underline: false), target: (self ,#selector(reloadData)))
		if #available(iOS 10.0, *) {
			collectionView.refreshControl = refreshHeader
		} else {
			collectionView.insertSubview(refreshHeader, at: 0)
		}
		
		view.insertSubview(collectionView, belowSubview: topView)
		collectionView.snp.makeConstraints { (make) in
			make.top.equalTo(topView.snp.bottom)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			make.bottom.equalTo(self.view.snp.bottom)
		}
		
		refreshHeader.snp.makeConstraints({ (make) in
			make.centerX.equalTo(self.view.snp.centerX)
			make.width.equalTo(300)
			make.height.equalTo(60)
			make.bottom.equalTo(self.collectionView.contentOffset.y).offset(-30)
		})
		
		nodataView = NoDataView(view.frame)
		collectionView.addSubview(nodataView)
		nodataView.snp.makeConstraints {
			$0.edges.equalTo(view.snp.edges)
		}
		nodataView.hide()
        // Do any additional setup after loading the view.
		reloadData()
    }

	@objc func reloadData() {
		if refreshHeader != nil {
			refreshHeader.setTitleBeginRefreshing()
		}
		api.getExamStat({ (finished, response) in
			self.statData = StatModel([])
			if finished {
				self.statData = StatModel(Validation.anyIsArrayAny(response!, with: "result"))
			}
			self.collectionView.reloadData()
			self.statData.subjectGroup.isEmpty ? self.nodataView.show() : self.nodataView.hide()
			self.refreshHeader.endRefreshing()
			return
		})
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return statData.subjectGroup[section].examArray.count
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return statData.subjectGroup.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatSubjectGroupCollectionViewCell.cellIdentifier, for: indexPath) as! StatSubjectGroupCollectionViewCell
		cell.backgroundColor = .clear
		cell.setCellData(statData.subjectGroup[indexPath.section].examArray[indexPath.item], group: statData.subjectGroup[indexPath.section])
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let cell = collectionView.cellForItem(at: indexPath) as! StatSubjectGroupCollectionViewCell

		let statSubjectInGroupView = StatSubjectPageViewController(parameter: cell.statGroupData.examArray, index: indexPath.item, title: cell.statGroupData.name)

		navigationController?.pushViewController(statSubjectInGroupView, animated: true)
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		switch kind {
			
        case UICollectionView.elementKindSectionHeader:
			
			let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSectionCollectionView.headerIdentifier, for: indexPath) as! HeaderSectionCollectionView
			
			headerView.backgroundColor = .clear
			headerView.setTitleHeader(statData.subjectGroup[indexPath.section].name)
			
			return headerView
			
		default:
			assert(false, "Unexpected element kind")
			fatalError("Unexpected element kind")
		}
	}
	
	func back() {
		navigationController?.popViewController(animated: true)
	}
}

class HeaderSectionCollectionView: UICollectionReusableView {
	
	static let headerIdentifier = "HeaderSectionCollectionView"
	
	var groupTitle: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		groupTitle = UILabel()
		groupTitle.setParameter(font: .kanitReg16, color: .Celllabel)
		groupTitle.text = "แนวข้อสอบ"
		
		addSubview(groupTitle)
		
		setLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setTitleHeader(_ title: String) {
		groupTitle.text = title
	}
	
	func setLayout() {
		groupTitle.snp.makeConstraints { (make) in
			make.leading.equalTo(snp.leading).offset(MARGIN)
			make.trailing.equalTo(snp.trailing).offset(-MARGIN)
			make.top.equalTo(snp.top)
			make.bottom.equalTo(snp.bottom)
		}
	}
}
