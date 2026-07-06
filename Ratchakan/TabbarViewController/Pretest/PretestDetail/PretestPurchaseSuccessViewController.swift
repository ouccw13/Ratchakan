//
//  PretestPurchaseSuccessViewController.swift
//  
//
//  Created by JJsobtid on 16/1/2561 BE.
//

import UIKit

class PretestPurchaseSuccessViewController: CustomUIViewControllerWithNav, CustomNavDelegate, UITableViewDelegate, UITableViewDataSource, CustomButtonClick {
	
	
	var topView: CustomNav!
	var scrollView: UIScrollView!
	
	var topSuccessView: UIView!
	var successImage: UIImageView!
	var successLabel: UILabel!
	
	var detailView: UIView!
	var titlePretest, titleId, titleDate, titleTime, titlePrice, titleDiscount, titleTotal: UILabel!
	var detailPretest, detailId, detailDate, detailTime, detailPrice, detailDiscount, detailTotal: UILabel!
	var separateTop, separateBottom: UIView!
	
	var confirmButton: CustomBottomButton!
	var firstTime: Bool = true
	var haveURL: Bool = false
	
	let customButton: BottomButton = BottomButton(title: string.th_ok, color: .brandcolor1)
	var nav: Nav? {
		didSet {
			fillUI()
		}
	}
	
	var pretestPurchaseData: dictStringAny!
	var priceData: Price!
	
	convenience init(_ data: dictStringAny, price: Price) {
		
		self.init(nibName: nil, bundle: nil)
		
		print(str: Utility.jsonLog(data))
		pretestPurchaseData = data
		priceData = price
		haveURL = Validation.dictionary(pretestPurchaseData, with: "url")
		
	}
	
	override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .brandcolor_bg
		
		topView = CustomNav(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TOP_VIEW))
		confirmButton = CustomBottomButton(frame: CGRect(x:0, y:0, width: SCREEN_WIDTH, height: BOTTOM_BAR))
		
		scrollView = UIScrollView()
		topSuccessView = UIView()
		topSuccessView.backgroundColor = .white
		successImage = UIImageView()
		successImage.setParameter(name: "purchaseSuccessImage", mode: .scaleAspectFit)
		successLabel = UILabel()
		successLabel.setParameter(font: .kanitReg16, color: .Celllabel, alignment: .center)
		successLabel.text = string.th_purchase_success
		
		titlePretest = UILabel(); titleId = UILabel(); titleDate = UILabel(); titleTime = UILabel(); titlePrice = UILabel(); titleDiscount = UILabel(); titleTotal = UILabel()
		let stringTitle = ["ข้อสอบ PRETEST", "คำสั่งซื้อ", "วันที่ทำรายการ", "ราคา", "ส่วนลด", "ราคารวม"]
		detailPretest = UILabel(); detailId = UILabel(); detailDate = UILabel(); detailTime = UILabel(); detailPrice = UILabel(); detailDiscount = UILabel(); detailTotal = UILabel()
		separateTop = UIView(); separateBottom = UIView()
		
		let arrTitle: [UILabel] = [titlePretest, titleId, titleDate, titlePrice, titleDiscount, titleTotal]
		let arrDetail: [UILabel] = [detailPretest, detailId, detailDate, detailPrice, detailDiscount, detailTotal]
		let separateView: [UIView] = [separateTop, separateBottom]
		detailView = UIView()
		detailView.backgroundColor = .white
		
		var i = 0
		for title in arrTitle {
			title.setParameter(font: .kanitReg14, color: .guestcolor)
			title.text = stringTitle[i]
			i = i + 1
		}
		var priceBefore = 0
		let priceAfter = Validation.anyIsNumber(pretestPurchaseData, with: "amount")
		for detail in arrDetail {
			detail.setParameter(font: .kanitReg16, color: .Celllabel, alignment: .right)
			detail.text = Validation.anyIsString(pretestPurchaseData, with: "name")//"Test รหัสอ้างอิง : 673M8Y"
			if detail == detailPretest {
				detail.textAlignment = .left
			} else if detail == detailId {
				detail.text = Validation.anyIsString(pretestPurchaseData, with: "paymentCode")
			} else if detail == detailDate {
				detail.text = Datetime().showDate(Validation.anyIsNumber(pretestPurchaseData, with: "transactionDate"), short: true, showTime: true)
			} else if detail == detailPrice {
				switch (Validation.anyIsNumber(pretestPurchaseData, with: "channel")) {
				case 2:
					priceBefore = priceData.mol
					break
				case 4:
					priceBefore = priceData.counterservice
					break
				case 5:
					priceBefore = priceData.inapp
					break
				case 7:
					priceBefore = 0
					break
				default:
					break
				}
				detail.text = "\(priceData.mol) บาท"
			} else if detail == detailDiscount {
				if priceBefore == priceAfter {
					detail.text = "-"
				} else {
					detail.text = "\(priceBefore - priceAfter) บาท"
				}
			} else if detail == detailTotal {
				detail.text = priceAfter == 0 ? "ฟรี" : "\(priceAfter) บาท"
				detail.textColor = .brandcolor1
			}
		}
		for line in separateView {
			line.lineView(withColor: .Collectionbg)
		}
		
		// Do any additional setup after loading the view.
		fillUI()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		hideTabbar()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if haveURL && firstTime {
			firstTime = false
			Utility.open(url: Validation.anyIsString(pretestPurchaseData, with: "url"))
		}
		hideTabbar()
	}
	
	func hideTabbar() {
		navigationController?.isNavigationBarHidden = true
		navigationController?.interactivePopGestureRecognizer?.delegate = nil
		navigationController?.interactivePopGestureRecognizer?.isEnabled = false
		tabBarController?.tabBar.isHidden = true
	}
	
	func back() {
		var isRound = false
		for view in (navigationController?.viewControllers ?? []) {
			if view.isKind(of: PretestDetailRoundViewController.self) {
				isRound = true
				navigationController?.popToViewController(view, animated: true)
			}
		}
		if !isRound {
			navigationController?.popToRootViewController(animated: true)
		}
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		
		return cell
	}
	
	func next(tag: Int) {
		
		if haveURL {
			Utility.open(url: Validation.anyIsString(pretestPurchaseData, with: "url"))
		} else {
			back()
		}
	}
	
	func fillUI() {
		if !isViewLoaded {
			return
		}
		
		let navViewModel = CustomViewModelFromNav(withNav: nav!)
		topView.viewModel = navViewModel
		topView.delegate = self
		
		let regisModel = CustomBottomButtonFromModel(withButton: customButton)
		confirmButton.viewModel = regisModel
		confirmButton.delegate = self
		if haveURL {
			confirmButton.setTitle("ดูข้อมูลเพิ่มเติม")
		}
		
		view.addSubview(topView);
		topView.snp.makeConstraints { (make) in
			make.top.equalTo(0)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			make.height.equalTo(TOP_VIEW)
		}
		
		view.addSubview(confirmButton)
		confirmButton.snp.makeConstraints { (make) in
			make.bottom.equalTo(self.view.snp.bottom)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			make.height.equalTo(BOTTOM_BAR)
		}
		
		topSuccessView.addsubviews([successImage, successLabel])
		detailView.addsubviews([titlePretest, titleId, titleDate, titlePrice, titleDiscount, titleTotal, detailPretest, detailId, detailDate, detailPrice, detailDiscount, detailTotal, separateTop, separateBottom])
		scrollView.addsubviews([topSuccessView, detailView])
		view.insertSubview(scrollView, belowSubview: topView)
		
		scrollView.snp.makeConstraints { (make) in
			make.top.equalTo(topView.snp.bottom)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
			make.bottom.equalTo(confirmButton.snp.top)
		}
		topSuccessView.snp.makeConstraints { (make) in
			make.top.equalTo(scrollView.snp.top)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
			make.height.equalTo(172)
		}
		successImage.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize(width: 96, height: 76))
			make.centerX.equalTo(topSuccessView.snp.centerX)
			make.top.equalTo(topSuccessView.snp.top).offset(32)
		}
		successLabel.snp.makeConstraints { (make) in
			make.height.equalTo(24)
			make.top.equalTo(successImage.snp.bottom).offset(MARGIN)
			make.leading.equalTo(topSuccessView.snp.leading).offset(2*MARGIN)
			make.trailing.equalTo(topSuccessView.snp.trailing).offset(-2*MARGIN)
		}
		
		detailView.snp.makeConstraints { (make) in
			make.top.equalTo(topSuccessView.snp.bottom).offset(MARGIN)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
			make.height.equalTo(333 - 24 - MARGIN)
		}
		titlePretest.snp.makeConstraints { (make) in
			make.leading.equalTo(detailView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(detailView.snp.trailing).offset(-MARGIN)
			make.top.equalTo(detailView.snp.top).offset(MARGIN)
			make.height.equalTo(21)
		}
		detailPretest.snp.makeConstraints { (make) in
			make.leading.equalTo(titlePretest.snp.leading)
			make.trailing.equalTo(titlePretest.snp.trailing)
			make.top.equalTo(titlePretest.snp.bottom)
			make.height.equalTo(24)
		}
		separateTop.snp.makeConstraints { (make) in
			make.leading.equalTo(detailView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(detailView.snp.trailing).offset(-MARGIN)
			make.top.equalTo(detailPretest.snp.bottom).offset(MARGIN)
			make.height.equalTo(1)
		}
		titleId.snp.makeConstraints { (make) in
			make.leading.equalTo(detailView.snp.leading).offset(MARGIN)
			make.width.equalTo(100)
			make.top.equalTo(separateTop.snp.bottom).offset(MARGIN)
			make.height.equalTo(21)
		}
		detailId.snp.makeConstraints { (make) in
			make.leading.equalTo(titleId.snp.trailing).offset(SMALLINSET)
			make.trailing.equalTo(detailView.snp.trailing).offset(-MARGIN)
			make.centerY.equalTo(titleId.snp.centerY)
			make.height.equalTo(24)
		}
		titleDate.snp.makeConstraints { (make) in
			make.leading.equalTo(detailView.snp.leading).offset(MARGIN)
			make.width.equalTo(100)
			make.top.equalTo(titleId.snp.bottom).offset(MARGIN)
			make.height.equalTo(21)
		}
		detailDate.snp.makeConstraints { (make) in
			make.leading.equalTo(titleDate.snp.trailing).offset(SMALLINSET)
			make.trailing.equalTo(detailView.snp.trailing).offset(-MARGIN)
			make.centerY.equalTo(titleDate.snp.centerY)
			make.height.equalTo(24)
		}
		titlePrice.snp.makeConstraints { (make) in
			make.leading.equalTo(detailView.snp.leading).offset(MARGIN)
			make.width.equalTo(100)
			make.top.equalTo(titleDate.snp.bottom).offset(MARGIN)
			make.height.equalTo(21)
		}
		detailPrice.snp.makeConstraints { (make) in
			make.leading.equalTo(titlePrice.snp.trailing).offset(SMALLINSET)
			make.trailing.equalTo(detailView.snp.trailing).offset(-MARGIN)
			make.centerY.equalTo(titlePrice.snp.centerY)
			make.height.equalTo(24)
		}
		titleDiscount.snp.makeConstraints { (make) in
			make.leading.equalTo(detailView.snp.leading).offset(MARGIN)
			make.width.equalTo(100)
			make.top.equalTo(titlePrice.snp.bottom).offset(MARGIN)
			make.height.equalTo(21)
		}
		detailDiscount.snp.makeConstraints { (make) in
			make.leading.equalTo(titleDiscount.snp.trailing).offset(SMALLINSET)
			make.trailing.equalTo(detailView.snp.trailing).offset(-MARGIN)
			make.centerY.equalTo(titleDiscount.snp.centerY)
			make.height.equalTo(24)
		}
		separateBottom.snp.makeConstraints { (make) in
			make.leading.equalTo(detailView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(detailView.snp.trailing).offset(-MARGIN)
			make.top.equalTo(titleDiscount.snp.bottom).offset(MARGIN)
			make.height.equalTo(1)
		}
		titleTotal.snp.makeConstraints { (make) in
			make.leading.equalTo(detailView.snp.leading).offset(MARGIN)
			make.width.equalTo(100)
			make.top.equalTo(separateBottom.snp.bottom).offset(MARGIN)
			make.height.equalTo(21)
		}
		detailTotal.snp.makeConstraints { (make) in
			make.leading.equalTo(titleTotal.snp.trailing).offset(SMALLINSET)
			make.trailing.equalTo(detailView.snp.trailing).offset(-MARGIN)
			make.centerY.equalTo(titleTotal.snp.centerY)
			make.height.equalTo(24)
		}
		scrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: 314 + 172 + (2*MARGIN))
	}
}
