//
//  PretestCollectionView.swift
//  ratchakan
//
//  Created by JJsobtid on 13/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

enum TypePretest {
	case promotion
	case myevent
	case pastevent
	case allevent
}

protocol PretestDelegate {
	func AllPretestLoaded(havePretest: Bool)
	func nowPage(type: TypePretest)
}

class PretestCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

	var refreshHeader: HeaderRefreshControl!
	var collectionView: UICollectionView!
	var collectionLayout: CollectionLayout!
	var collectionData:[Any] = []
	var api: API!
	var nodataView: NoDataView!
	
	var collectionModel: PretestCollectionModel!
	var collectionViewModel: PretestCollectionViewModelFromCollectionModel!
	var firstAppear: Bool = false
	var firstLoad: Bool = true
	var firstMove: Bool = true
	
	var delegate: PretestDelegate?
	
	var loadingView: LoadingView!
	
	var type: TypePretest? {
		didSet {
			if firstLoad && firstAppear {
				setFirst()
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .brandcolor_bg
		
		
		collectionLayout = CollectionLayout(withcol: (IS_IPAD ? 2 : 1), height: (IS_IPAD ? SCREEN_WIDTH/2 : SCREEN_WIDTH)*282/382, axis: .vertical)
		collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionLayout)
		collectionView.hideScrollIndicatior()
		collectionView.alwaysBounceVertical = true
		collectionView.setUp(self, bg: .clear)
		var bottomInset = MARGIN
		if !Utility.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_11() {
			bottomInset += TABBAR_HEIGHT
		}
		
        collectionView.contentInset = UIEdgeInsets(top: MARGIN + NAV_HEIGHT, left: MARGIN, bottom: MARGIN+bottomInset, right: MARGIN)
		
		collectionView.register(PretestCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
		
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

		NotificationCenter.default.addObserver(self, selector: #selector(checkLogin(_:)), name: Notification.Name(rawValue: NotiCenter.checkLogIn), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(checkLogin(_:)), name: Notification.Name(rawValue: NotiCenter.logOut), object: nil)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		firstAppear = true
		if type != nil {
			setFirst()
		}
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		delegate?.nowPage(type: type!)
	}
	
	@objc func checkLogin(_ Notification: Notification) {
		firstLoad = true
		collectionData = []
		collectionView.reloadData()
		setFirst()
	}
	
	func setFirst() {
		if !isViewLoaded || type == nil {
			return
		}
		
		if firstLoad {
			collectionModel = PretestCollectionModel([], type: type!)
			collectionViewModel =  PretestCollectionViewModelFromCollectionModel(pretestCollection: collectionModel)
			
			loadingView.startLoading()
			collectionViewModel.loadPretestList()
			collectionViewModel.loaded.bindAndFire { (loaded) in
				if loaded && !self.firstLoad {
					self.loadingView.stopLoading()
					self.refreshHeader.endRefreshing()
					if self.collectionViewModel.pretestCollectionData.value.isEmpty {
						self.nodataView.show()
					} else {
						self.nodataView.hide()
					}
					self.collectionData = self.collectionViewModel.pretestCollectionData.value
					self.collectionView.reloadData()
					if self.type! == .allevent && self.firstMove {
						self.firstMove = false
						self.delegate?.AllPretestLoaded(havePretest: self.collectionData.count != 0)
					}
				}
				if self.firstLoad {
					self.firstLoad = false
				}
			}
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@objc func reloadData() {
		if refreshHeader != nil {
			refreshHeader.setTitleBeginRefreshing()
		}
		loadingView.startLoading()
		nodataView.hide()
		collectionViewModel.loadPretestList()
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return collectionData.count
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PretestCollectionViewCell
		cell.backgroundColor = .clear
		let cellModel = collectionData[indexPath.item]
		if (cellModel as AnyObject).isKind(of: PretestModel.self) {
			cell.pretestViewModel = PretestViewModelFromPretest(pretest: cellModel as! PretestModel)
			cell.promotionViewModel = nil
		} else {
			cell.pretestViewModel = nil
			cell.promotionViewModel = PromotionViewModelFromPromotion(promotion: cellModel as! PromotionPretestModel)
		}
		cell.type = type
		cell.setLayout()
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let cell = collectionView.cellForItem(at: indexPath) as! PretestCollectionViewCell
		if let pretestViewModel = cell.pretestViewModel {
			pretestViewModel.getPretestData().roundFirst = true
			let nav: Nav = Nav(title: cell.pretestTitle.text!, isBack: true, isRight: false, color: UIColor.color(fromHexString: pretestViewModel.colorHEX))
            var typePretest:Int = 1
            if pretestViewModel.getPretestData().round.value.count > 0 {
                for item in pretestViewModel.getPretestData().round.value {
                    if item["action"] as! Int == 0 || item["action"] as! Int == 2 {
                        typePretest = 0
                    }else{
                        typePretest = 1
                    }
                }
            }
			if typePretest == 0 {
				let pretestDetailRoundViewController = PretestDetailRoundViewController()
				pretestDetailRoundViewController.nav = nav
				pretestDetailRoundViewController.setBanner((pretestViewModel.banner["tablet"] as? dictStringAny ?? ["path":""])["path"] as? String ?? "")
				pretestDetailRoundViewController.pretestList = [pretestViewModel.getPretestData()]
				navigationController?.pushViewController(pretestDetailRoundViewController, animated: true)
			} else if typePretest == 1 {
				let detailView = PretestDetailViewController()
				detailView.pretestModel = pretestViewModel.getPretestData()
				detailView.myPretest = pretestViewModel.getPretestData().ownerPretest.value
				let nav = Nav(title: pretestViewModel.pretestName, isBack: true, isRight: false, color: .brandcolor1)
				detailView.nav = nav
				navigationController?.pushViewController(detailView, animated: true)
			}
		} else if let promotionViewModel = cell.promotionViewModel {
			loadingView.startLoading()
			
			promotionViewModel.pretestLoaded.bindAndFire({ (loaded) in
				self.loadingView.stopLoading()
				if loaded {
					for pretest in promotionViewModel.pretestListData {
						pretest.roundFirst = true
					}
					let nav: Nav = Nav(title: cell.pretestTitle.text!, isBack: true, isRight: false, color: UIColor.color(fromHexString: promotionViewModel.colorHEX))
					let pretestDetailRoundViewController = PretestDetailRoundViewController()
					pretestDetailRoundViewController.promotionModel = promotionViewModel.getModel()
					pretestDetailRoundViewController.nav = nav
					pretestDetailRoundViewController.setBanner((promotionViewModel.banner["tablet"] as? dictStringAny ?? ["path":""])["path"] as? String ?? "")
					pretestDetailRoundViewController.pretestList = promotionViewModel.pretestListData
					self.navigationController?.pushViewController(pretestDetailRoundViewController, animated: true)
				}
			})
		}
		
	}
}
