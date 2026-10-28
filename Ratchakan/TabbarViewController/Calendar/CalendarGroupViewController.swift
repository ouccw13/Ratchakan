//
//  CalendarGroupViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 13/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class CalendarGroupViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

	var refreshHeader: HeaderRefreshControl!
	var collectionView: UICollectionView!
	var collectionLayout: CollectionLayout!
	var collectionData: [dictStringAny] = []
	lazy var api = API()
	var nodataView: NoDataView!
	var loadingView: LoadingView!
	
	var type: String! {
		didSet {
			if firstLoad && firstAppear {
				setFirst()
			}
		}
	}
	var firstAppear: Bool = false
	var firstLoad: Bool = true
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .vertical
		flowLayout.minimumLineSpacing = MARGIN
		flowLayout.minimumInteritemSpacing = MARGIN
		flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
		
		collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: flowLayout)
		collectionView.hideScrollIndicatior()
		collectionView.alwaysBounceVertical = true
		collectionView.setUp(self, bg: .clear)
		var bottomInset = MARGIN
		if !Utility.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_11() {
			bottomInset += TABBAR_HEIGHT
		}
		
        collectionView.contentInset = UIEdgeInsets(top: MARGIN + NAV_HEIGHT, left: MARGIN, bottom: bottomInset, right: MARGIN)
		
		collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
		refreshHeader = HeaderRefreshControl(withColor: .brandcolor1, titleAttribute: Utility.setStringAttributes(string.en_pull_refresh, textColor: .brandcolor1, font: .kanitReg14, underline: false), target: (self ,#selector(reloadData)))
		if #available(iOS 10.0, *) {
			collectionView.refreshControl = refreshHeader
		} else {
			collectionView.insertSubview(refreshHeader, at: 0)
		}
		
		view.addSubview(collectionView)
		collectionView.snp.makeConstraints { (make) in
			make.edges.equalTo(view.snp.edges)
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
		
		loadingView = LoadingView(withSuperview: view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		firstAppear = true
		if type != nil {
			setFirst()
		}
	}
	
	func setFirst() {
		if !isViewLoaded || type == nil {
			return
		}
		
		if firstLoad {
			firstLoad = false
			reloadData()

		}
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return collectionData.count
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarCollectionViewCell
		cell.backgroundColor = .clear
		cell.setData(collectionData[indexPath.item], type: "general")
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let calendarDetailViewController = DetailCalendarViewController()
		calendarDetailViewController.calendarData = collectionData[indexPath.item]
		calendarDetailViewController.nav = Nav(title: string.th_detail, isBack: true, isRight: true, imageRight: "downloadIcon", color: .navbrandcolor)
		
		present(calendarDetailViewController, animated: true, completion: nil)
	}
	
	@objc func reloadData() {
		if refreshHeader != nil {
			refreshHeader.setTitleBeginRefreshing()
		}
		DispatchQueue.main.async {
			self.loadingView.startLoading()
			self.api.getCalendar(type: self.type) { (finished, response) in
				self.loadingView.stopLoading()
				if finished {
					self.collectionData = Utility.sortArrayOfDictionary(Validation.anyIsArrayAny(response!, with: "result"), withInt: "dateFrom", ascending: true)
					self.collectionView.reloadData()
					if self.collectionData.count == 0 {
						self.nodataView.show()
					} else {
						self.nodataView.hide()
					}
				} else {
					self.nodataView.show()
				}
				self.refreshHeader.endRefreshing()
			}
		}
	}
}
