//
//  ExamGroupViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 16/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import ObjectMapper
protocol ExamGroupViewControllerDelegate {
	func viewDidShow(index: Int)
}

class ExamGroupViewController:CustomUIViewControllerWithNav, UICollectionViewDelegate, UICollectionViewDataSource, CustomNavDelegate {
	
	var topView: CustomNav!
	var refreshHeader: HeaderRefreshControl!
	var collectionView: UICollectionView!
	
	var nodataView: NoDataView!
	var loadingView: LoadingView!
	
	lazy var api: API! = API()
	var examModel: ExamTab = ExamTab()
    var examsList:[Exams] = []
	var id: (group: String, subject: String)!
	var reload: Bool = true
	var collectionData: [[String: Any]] = []
	
	var delegate: ExamGroupViewControllerDelegate?
	var groupId: String?
	var searchText: String?
	
	var nav: Nav! {
		didSet {
			fillUI()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		topView = CustomNav(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TOP_VIEW))
		view.backgroundColor = .brandcolor_bg
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .vertical
		flowLayout.minimumLineSpacing = MARGIN
		flowLayout.minimumInteritemSpacing = MARGIN
		flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
		flowLayout.headerReferenceSize = CGSize(width: SCREEN_WIDTH - 2*MARGIN, height: 53)
		
		collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: flowLayout)
		collectionView.hideScrollIndicatior()
		collectionView.alwaysBounceVertical = true
		collectionView.setUp(self, bg: .clear)
		var bottomInset = MARGIN
		if !Utility.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_11() {
			bottomInset += TABBAR_HEIGHT
		}
		
		if HAVE_NOTCH {
			
		} else {
            collectionView.contentInset = UIEdgeInsets(top: 0, left: MARGIN, bottom: bottomInset, right: MARGIN)
		}
		collectionView.register(ExamCollectionViewCell.self, forCellWithReuseIdentifier: ExamCollectionViewCell.cellIdentifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")

		// Do any additional setup after loading the view.
		view.addSubview(collectionView)
		collectionView.snp.makeConstraints { (make) in
			make.top.equalTo(PAGEBAR_HEIGHT)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
			make.bottom.equalTo(view.snp.bottom)
		}
		
		refreshHeader = HeaderRefreshControl(withColor: .brandcolor1, titleAttribute: Utility.setStringAttributes(string.en_pull_refresh, textColor: .brandcolor1, font: .kanitReg14, underline: false), target: (self ,#selector(reloadData)))
		if #available(iOS 10.0, *) {
			collectionView.refreshControl = refreshHeader
		} else {
			collectionView.insertSubview(refreshHeader, at: 0)
		}
		refreshHeader.snp.remakeConstraints({ (make) in
			make.centerX.equalTo(self.view.snp.centerX)
			make.width.equalTo(300)
			make.height.equalTo(60)
			make.bottom.equalTo(self.collectionView.contentOffset.y).offset(-30)
		})
		
		loadingView = LoadingView(withSuperview: view)
		
		nodataView = NoDataView(CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
		collectionView.addSubview(nodataView)
		nodataView.snp.makeConstraints {
			$0.centerY.equalTo(view.snp.centerY)
			$0.leading.equalTo(view.snp.leading)
			$0.height.equalTo(200)
			$0.trailing.equalTo(view.snp.trailing)
		}
		nodataView.hide()

		fillUI()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if Validation.anyIsNumber(api.packages, with: id.group) != 0 && Validation.anyIsNumber(api.packages, with: id.group) >= Datetime.getCurrentTimestamp() {
			
		} else {
			delegate?.viewDidShow(index: view.tag)
		}
		if reload {
			reload = !reload
			reloadData()
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	fileprivate func fillUI() {
		if !isViewLoaded || nav == nil {
			return
		}
	}

	@objc func reloadData() {
		if refreshHeader != nil {
			refreshHeader.setTitleBeginRefreshing()
		}
		loadingView.startLoading()
		api.getExamInGroupTab(id.group, subjectId: id.subject) { (finished, response) in
			self.loadingView.stopLoading()
			if finished {
                let examInGroupTab =  Mapper<ExamsInTab>().map(JSON: response!)
				self.examModel.reloadExam()
                if let exams = examInGroupTab?.result?.exams {
                    for exam in exams {
                        self.examModel.addExamList(exam)
                    }
                }
			} 
			self.collectionView.reloadData()
			self.collectionView.collectionViewLayout.invalidateLayout()
			self.examModel.getExamNumber() == 0 ? self.nodataView.show() : self.nodataView.hide()
			self.refreshHeader.endRefreshing()
		}
	}
	
	// MARK: - CollectionView Delegate
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return examModel.getExamNumber()
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		
		switch kind {
        case UICollectionView.elementKindSectionHeader:
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! HeaderView
			var filter = "ข้อสอบทั้งหมด"
			if examModel.filterType == .done {
				filter = "ข้อสอบที่ทำแล้ว"
			} else if examModel.filterType == .notDone {
				filter = "ข้อสอบที่ยังไม่ได้ทำ"
			}
			reusableview.setFilter(numResult: "\(examModel.getExamNumber())", detail: "\(filter)  ")
			reusableview.detailLabel.addTarget(self, selector: #selector(filterAction(_:)))
			
			return reusableview
		default:
			fatalError("Unexpected element kind")
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExamCollectionViewCell.cellIdentifier, for: indexPath) as! ExamCollectionViewCell
		cell.backgroundColor = .clear
		cell.setCell(withExam: examModel.getExam(atIndex: indexPath.item), indexPath: indexPath)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let cell = collectionView.cellForItem(at: indexPath) as! ExamCollectionViewCell
		
		reload = true
		let examDetailView = ExamDetailViewController()
		examDetailView.newexamDetailData = examModel.getExam(atIndex: indexPath.item)
		examDetailView.nav = Nav(title: cell.subjectTitle.text!, isBack: true, isRight: false)
		navigationController?.pushViewController(examDetailView, animated: true)
	}
	
	@objc func filterAction(_ sender: UITapGestureRecognizer) {
        let filterAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
		filterAlert.addAction(UIAlertAction(title: "ข้อสอบที่ยังไม่ได้ทำ", style: .default, handler: { action in
			self.setFilterAndReload(.notDone)
		}))
		filterAlert.addAction(UIAlertAction(title: "ข้อสอบที่ทำแล้ว", style: .default, handler: { action in
			self.setFilterAndReload(.done)
		}))
		filterAlert.addAction(UIAlertAction(title: "ข้อสอบทั้งหมด", style: .default, handler: { action in
			self.setFilterAndReload(.total)
		}))
		filterAlert.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel, handler: nil))
		
		if IS_IPAD {
			if let popoverController = filterAlert.popoverPresentationController {
				popoverController.sourceView = view
				popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
				popoverController.permittedArrowDirections = []
			}
		}
		present(filterAlert, animated: true, completion: nil)
	}
	
	func back() {
		navigationController?.popViewController(animated: true)
	}
	
	func search(_ text: String) {
		
	}
	
	func cancelSearch(_ text: String) {
		
	}
	
	func setFilterAndReload(_ type: ExamFilter) {
		examModel.setFilter(type)
		examModel.getExamNumber() == 0 ? self.nodataView.show() : self.nodataView.hide()
		collectionView.reloadData()
		collectionView.collectionViewLayout.invalidateLayout()
	}
	
	//MARK: - Header
	class HeaderView: UICollectionReusableView {
		
		var titleLabel, detailLabel: UILabel!
		var filterButton: UIButton!
		
		override init(frame: CGRect) {
			super.init(frame: frame)
			
			titleLabel = UILabel()
			titleLabel.setParameter(font: .kanitReg14, color: .placeholdercolor)
			detailLabel = UILabel()
			detailLabel.setParameter(font: .kanitReg14, color: .Celllabel, alignment: .right)
			
			addsubviews([titleLabel, detailLabel])
			titleLabel.snp.makeConstraints { (make) in
				make.leading.equalTo(snp.leading)
				make.centerY.equalTo(snp.centerY)
				make.height.equalTo(19)
				make.width.equalTo(100)
			}
			detailLabel.snp.makeConstraints { (make) in
				make.leading.equalTo(titleLabel.snp.trailing).offset(MARGIN)
				make.centerY.equalTo(snp.centerY)
				make.trailing.equalTo(snp.trailing)
			}
		}
		
		required init?(coder aDecoder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		func setFilter(numResult: String, detail: String) {
			let attachment = NSTextAttachment()
			attachment.image = UIImage(named: "chevronDown")
			let attachmentString = NSAttributedString(attachment: attachment)
			let myString = NSMutableAttributedString(string: detail)
			myString.append(attachmentString)
			detailLabel.attributedText = myString
			
			titleLabel.text = "\(numResult) ชุดข้อสอบ"

		}
	}
}

