//
//  CalendarSearchViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 13/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

enum SearchType {
	case main
	case detail
}

class CalendarSearchViewController: CustomViewControllerPushNavAndNoTabbar, CustomNavDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
	var refreshHeader: HeaderRefreshControl!
	var collectionView: UICollectionView!
	var collectionData: [dictStringAny] = []
	lazy var api = API()
	var nodataView: NoDataView!
	
	var searchText: String!
	var type: SearchType!
	
	var nav: Nav? {
		didSet {
			fillUI()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		
		view.backgroundColor = .brandcolor_bg
        topView = UIView()
        topView.backgroundColor = .navbrandcolor
        
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
        navTitleLabel.set(text: self.searchText)
        topView.addSubview(navTitleLabel)
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .vertical
		flowLayout.minimumLineSpacing = MARGIN
		flowLayout.minimumInteritemSpacing = MARGIN
		flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
		
		collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: flowLayout)
		collectionView.hideScrollIndicatior()
		collectionView.alwaysBounceVertical = true
		collectionView.setUp(self, bg: .clear)
		
		var topInset = TOP_VIEW
		if !Utility.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_11() {
			topInset += MARGIN
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
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 ? 12 : 24)
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 ? 12 : 24)
                make.centerX.equalTo(topView.snp.centerX)
            }
        }
		
        collectionView.contentInset = UIEdgeInsets(top: topInset, left: MARGIN, bottom: MARGIN, right: MARGIN)
		
		collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
		
		view.addSubview(collectionView)
		collectionView.snp.makeConstraints { (make) in
			make.edges.equalTo(view.snp.edges)
		}
		
		nodataView = NoDataView(view.frame)
		collectionView.addSubview(nodataView)
		nodataView.snp.makeConstraints {
			$0.edges.equalTo(view.snp.edges)
		}
		nodataView.hide()
        // Do any additional setup after loading the view.
		fillUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	fileprivate func fillUI() {
		if !isViewLoaded || nav == nil {
			return
		}

		view.addSubview(topView);
		topView.snp.makeConstraints { (make) in
			make.top.equalTo(0)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			make.height.equalTo(TOP_VIEW)
		}
		
		if type == .main {
			refreshHeader = HeaderRefreshControl(withColor: .brandcolor1, titleAttribute: Utility.setStringAttributes(string.en_pull_refresh, textColor: .brandcolor1, font: .kanitReg14, underline: false), target: (self ,#selector(reloadData)))
			if #available(iOS 10.0, *) {
				collectionView.refreshControl = refreshHeader
			} else {
				collectionView.insertSubview(refreshHeader, at: 0)
			}
			refreshHeader.snp.makeConstraints({ (make) in
				make.centerX.equalTo(self.view.snp.centerX)
				make.width.equalTo(300)
				make.height.equalTo(60)
				make.bottom.equalTo(self.collectionView.contentOffset.y).offset(-30)
			})
			reloadData()
		}
	}
	
	@objc func back() {
		navigationController?.popViewController(animated: true)
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

		if type == .main {
			cell.setData(collectionData[indexPath.item], type: "bureau")
		} else {
			cell.setData(collectionData[indexPath.item], type: "detailBureau")
		}

		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let cell = collectionView.cellForItem(at: indexPath) as! CalendarCollectionViewCell
		if type == .main {
			let searchDetailViewController = CalendarSearchViewController()
			searchDetailViewController.type = .detail
			searchDetailViewController.collectionData = Utility.sortArrayOfDictionary(Validation.anyIsArrayAny(collectionData[indexPath.item], with: "calendars"), withInt: "dateFrom", ascending: true) 
			let nav = Nav(title: cell.calendarTitle.text!, isBack: true, isRight: false)
			searchDetailViewController.nav = nav
			navigationController?.pushViewController(searchDetailViewController, animated: true)
			
		} else {
			let calendarDetailViewController = DetailCalendarViewController()
			calendarDetailViewController.calendarData = collectionData[indexPath.item]
			calendarDetailViewController.nav = Nav(title: string.th_detail, isBack: true, isRight: true, imageRight: "downloadIcon", color: .navbrandcolor)
			present(calendarDetailViewController, animated: true, completion: nil)
			
		}

	}
	
	@objc func reloadData() {
		if refreshHeader != nil {
			refreshHeader.setTitleBeginRefreshing()
		}
		api.getCalendar(searchText, type: nil) { (finished, response) in
			if finished {
				self.collectionData = Validation.anyIsArrayAny(response!, with: "result")
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
