//
//  PretestHistoryViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 12/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class PretestHistoryViewController: CustomViewControllerPresentNavAndNoTabbar, CustomNavDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
	var refreshHeader: HeaderRefreshControl!
	var collectionView: UICollectionView!
	var collectionLayout: CollectionLayout!
	
	var loadingView: LoadingView!
	
	var historyListModel: PretestHistoryListModel!
	var name: String!
	var db: Databases?
	var collectionData: [[String: Any]] = []

	init(pretestId: String, pretestName: String) {
		super.init(nibName: nil, bundle: nil)
		historyListModel = PretestHistoryListModel(id: pretestId)
		name = pretestName
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .brandcolor_bg

        topView = UIView()
        topView.backgroundColor = .navbrandcolor

		loadingView = LoadingView(withSuperview: view)
		
		collectionLayout = CollectionLayout(withcol: (IS_IPAD ? 2 : 1), height: 136, axis: .vertical)
		collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionLayout)
		collectionView.hideScrollIndicatior()
		collectionView.alwaysBounceVertical = true
		collectionView.setUp(self, bg: .clear)
		var topInset = MARGIN
		if !Utility.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_11() {
			topInset -= MARGIN
		}
		
		if HAVE_NOTCH {
			
		} else {
            collectionView.contentInset = UIEdgeInsets(top: topInset, left: MARGIN, bottom: MARGIN, right: MARGIN)
		}
		collectionView.register(PretestHistoryCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
		
		refreshHeader = HeaderRefreshControl(withColor: .brandcolor1, titleAttribute: Utility.setStringAttributes(string.en_pull_refresh, textColor: .brandcolor1, font: .kanitReg14, underline: false), target: (self ,#selector(reloadData)))
		if #available(iOS 10.0, *) {
			collectionView.refreshControl = refreshHeader
		} else {
			collectionView.insertSubview(refreshHeader, at: 0)
		}
		// Do any additional setup after loading the view.
		fillUI()
		reloadData()
		historyListModel.historyLoading.bindAndFire { (finished, isFirsttime) in
			if !isFirsttime {
				self.loadingView.stopLoading()
				if finished {
				}
				self.collectionView.reloadData()
				self.refreshHeader.endRefreshing()
			}
		}
	}

	
	fileprivate func fillUI() {
		if !isViewLoaded {
			return
		}
        
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
        navTitleLabel.set(text: string.th_pretest_history)
        topView.addSubview(navTitleLabel)
		
		view.insertSubview(collectionView, belowSubview: loadingView.loadingAnimation)
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
		
	}
	
	@objc func reloadData() {
		historyListModel.loadHistory()
		loadingView.startLoading()
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return historyListModel.getNumber()
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PretestHistoryCollectionViewCell
		cell.backgroundColor = .clear
		cell.setCellData(historyListModel.getHistory(atIndex: indexPath.item), name: name, type: "pretest")
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let pretestSummaryView = PretestSummaryViewController(withPretest: historyListModel.getHistory(atIndex: indexPath.item))
		navigationController?.pushViewController(pretestSummaryView, animated: true)
	}
	
	func back() {
		dismiss(animated: true, completion: nil)
	}
}
