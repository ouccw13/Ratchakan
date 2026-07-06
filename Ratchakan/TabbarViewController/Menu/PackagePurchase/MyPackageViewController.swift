//
//  MyPackageViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 19/4/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class MyPackageViewController: CustomViewControllerPushNavAndNoTabbar, UICollectionViewDelegate, UICollectionViewDataSource {

	var refreshHeader: HeaderRefreshControl!
	var collectionView: UICollectionView!
	var collectionLayout: CollectionLayout!
	
	var nodataView: NoDataView!
	
	var collectionData: dictStringAny! = [:]
	var packagesKey: [String]! = []
	
	lazy var api = API()
	
	var loadingView: LoadingView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		collectionLayout = CollectionLayout(withcol: (IS_IPAD ? 2 : 1), height: 104, axis: .vertical)
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
		collectionView.register(PackageCollectionViewCell.self, forCellWithReuseIdentifier: PackageCollectionViewCell.cellIdentifier)
		
		refreshHeader = HeaderRefreshControl(withColor: .brandcolor1, titleAttribute: Utility.setStringAttributes(string.en_pull_refresh, textColor: .brandcolor1, font: .kanitReg14, underline: false), target: (self ,#selector(reloadData)))
		if #available(iOS 10.0, *) {
			collectionView.refreshControl = refreshHeader
		} else {
			collectionView.insertSubview(refreshHeader, at: 0)
		}
		
		view.addSubview(collectionView)
		collectionView.snp.makeConstraints { (make) in
			make.top.equalTo(view.snp.top).offset(PAGEBAR_HEIGHT)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
			make.bottom.equalTo(view.snp.bottom)
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
		
		loadingView = LoadingView(withSuperview: self.view)
		
		reloadData()
        // Do any additional setup after loading the view.
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		reloadData()
	}
	
	@objc func reloadData() {
		loadingView.startLoading()
		
		api.getMyPackage { (finished, response) in
			self.collectionData = [:]
			self.packagesKey = []
			if finished {
				self.collectionData = Validation.anyIsDictionary(response!, with: "result")
				for (key, _) in self.collectionData {
					self.packagesKey.append(key)
				}
			}
			self.refreshHeader.endRefreshing()
			self.collectionView.reloadData()
			self.loadingView.stopLoading()
			self.collectionData.isEmpty ? self.nodataView.show() : self.nodataView.hide()
			return
		}
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return collectionData.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PackageCollectionViewCell.cellIdentifier, for: indexPath) as! PackageCollectionViewCell
		
		cell.setCellData(collectionData[packagesKey[indexPath.item]] ?? [:], withType: "myPackage")
		return cell
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
