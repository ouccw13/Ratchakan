//
//  ExamHistoryGroupViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 2/3/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class ExamHistoryGroupViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

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
		
		collectionLayout = CollectionLayout(withcol: (IS_IPAD ? 2 : 1), height: 106, axis: .vertical)
		collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionLayout)
		collectionView.hideScrollIndicatior()
		collectionView.alwaysBounceVertical = true
		collectionView.setUp(self, bg: .clear)
		var bottomInset = MARGIN
		
        collectionView.contentInset = UIEdgeInsets(top: MARGIN + NAV_HEIGHT, left: MARGIN, bottom: bottomInset, right: MARGIN)
		
		collectionView.register(PretestHistoryCollectionViewCell.self, forCellWithReuseIdentifier: PretestHistoryCollectionViewCell.cellIdentifier)
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
			reloadData()
			firstLoad = false
			
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return collectionData.count
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PretestHistoryCollectionViewCell.cellIdentifier, for: indexPath) as! PretestHistoryCollectionViewCell
		cell.backgroundColor = .clear
		cell.setCellData(collectionData[indexPath.item], type: "exam")

		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as! PretestHistoryCollectionViewCell
		
		loadingView.startLoading()
		api.getExamHistroy({ (finished, response) in
			self.loadingView.stopLoading()
			if finished {
				let solutionVC = ExamSolutionViewController(examId: cell.memberExamId, parameter: Validation.anyIsArrayAny(Validation.anyIsDictionary(response!, with: "result"), with: "questions"), answers: [])
				solutionVC.nav = Nav(title: string.th_solution, isBack: true, isRight: false)
				self.navigationController?.pushViewController(solutionVC, animated: true)
			} else {
				dropdownAlert.errorNTryAgain()
			}
			return
		}, memberExamId: cell.memberExamId)
	}
	
	fileprivate func checkData() {
		collectionView.reloadData()
		if collectionData.count == 0 {
			self.nodataView.show()
		} else {
			self.nodataView.hide()
		}
	}
	
	@objc func reloadData() {
		if refreshHeader != nil {
			refreshHeader.setTitleBeginRefreshing()
		}
		if type == "" {
			if not(firstLoad) {
				loadingView.startLoading()
				api.getAllExamHistory { (finished, response) in
					self.loadingView.stopLoading()
					if finished {
						self.collectionData = Utility.sortArrayOfDictionary(Validation.anyIsArrayAny(Validation.anyIsDictionary(response!, with: "result"), with: "memberExams"), withInt: "testDate", ascending: false)
					}
					self.checkData()
					self.refreshHeader.endRefreshing()
					return
				}
			} else {
				checkData()
			}
		} else {
			loadingView.startLoading()
			DispatchQueue.main.async {
				self.api.getGroupExamHistory({ (finished, response) in
					self.loadingView.stopLoading()
					if finished {
						self.collectionData = Utility.sortArrayOfDictionary(Validation.anyIsArrayAny(Validation.anyIsDictionary(response!, with: "result"), with: "memberExams"), withInt: "testDate", ascending: false)
						self.checkData()
					} else {
						self.nodataView.show()
					}
					self.refreshHeader.endRefreshing()
					return
				}, groupId: self.type)
			}
		}
	}

}
