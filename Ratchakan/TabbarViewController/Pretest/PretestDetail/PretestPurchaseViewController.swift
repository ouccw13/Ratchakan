//
//  PretestPurchaseViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 16/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import StoreKit

class PretestPurchaseViewController: CustomUIViewControllerWithNav, CustomNavDelegate, UITableViewDelegate, UITableViewDataSource, CustomButtonClick, PretestFieldDelegate/*, SKProductsRequestDelegate*/, PretestSelectPaymentDelegate {
	
	lazy var globalParameter = GlobalParameter.storeObserverSharedInstance
	lazy var paymentInstance = Payment.storeObserverSharedInstance
	
//	var topView: CustomNav!
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
	var tablePurchaseDetailView: UITableView!
	var regisButton: CustomBottomButton!
	
	var selectPayment: String!
	var type: PurchaseType = .free
	lazy var api = API()
	
	var payment: SKPayment!
	var request: SKProductsRequest!
	var selectProduct: SKProduct!
	var products: [SKProduct]!
	
	var loadingView: LoadingView!
	
	var headerSection: [String] = [string.th_choose_purchase, string.th_detail_purchase, string.th_detail_user]
	var price: Int!
	var arrayRound: [dictStringAny]!
	var transactionInApp: SKPaymentTransaction!
	var receiptString: String!
	
	var promotionModel: PromotionPretestModel?
	var pretestList: [PretestModel]?
	var member: member!
	
	let customButton: BottomButton = BottomButton(title: string.th_purchase, color: .brandcolor1)
	var nav: Nav? {
		didSet {
			fillUI()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .brandcolor_bg
		
		arrayRound = []
		for pretest in pretestList! {
			arrayRound.append(["pretestId" : pretest.pretestID,
							   "round" : pretest.selectedRound.round])
		}
		if let promotion = promotionModel {
			price = promotion.regularPrice.counterservice
		} else if let pretest = pretestList!.first {
			price = pretest.regularPrice.counterservice
		}
		if price == 0 {
			headerSection = [string.th_detail_purchase, string.th_detail_user]
			selectPayment = ""
		}
		
		hideKeyboardWhenTappedAround()
		moveViewWhenKeyboradAppear()
		
		member = API().getMember()
		
//		topView = CustomNav(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TOP_VIEW))
        topView = UIView()
        topView.backgroundColor = .navbrandcolor
		
		tablePurchaseDetailView = UITableView(frame: CGRect(), style: .grouped)
        tablePurchaseDetailView.contentInset = UIEdgeInsets(top: MARGIN, left: 0, bottom: 2*MARGIN, right: 0)
		tablePurchaseDetailView.backgroundColor = .clear
		tablePurchaseDetailView.separatorColor = .clear
		tablePurchaseDetailView.register(PretestPurchaseTableViewCell.self, forCellReuseIdentifier: PretestPurchaseTableViewCell.cellIdentified)
		
		regisButton = CustomBottomButton(frame: CGRect(x:0, y:0, width: SCREEN_WIDTH, height: BOTTOM_BAR))
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
		
		hideTabbar()
		
	}
	
	func hideTabbar() {
		navigationController?.isNavigationBarHidden = true
		navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
		tabBarController?.tabBar.isHidden = true
	}

	func back() {
		navigationController?.popViewController(animated: true)
	}
	
    func next(tag: Int) {
        if selectPayment == "inapp" {
            if let promotion = promotionModel {
                let data: [String: Any] = ["type":"promotion",
                                           "id" : promotion.promotionID,
                                           "member" : member.email,
                                           "channel": type.rawValue,
                                           "pretests": arrayRound]
                paymentInstance.parameter = data
                paymentInstance.validateProductIdentifiers(productIdentifiers: [promotion.regularPrice.inappID])
            } else if let pretest = pretestList!.first {
                let data: [String: Any] = ["type":"pretest",
                                           "id" : pretest.pretestID,
                                           "member" : member.email,
                                           "channel": type.rawValue,
                                           "round": arrayRound]
                paymentInstance.parameter = data
                paymentInstance.validateProductIdentifiers(productIdentifiers: [pretest.regularPrice.inappID])
            }
        } else {
            purchasePretest()
        }
    }
	
	fileprivate func purchasePretest() {
		loadingView.startLoading()
		regisButton.isUserInteractionEnabled = false
		api.purchasePretest(promotionId: promotionModel?.promotionID, receipt: receiptString ?? "", round: arrayRound, channel: type.rawValue, transactionId: transactionInApp?.transactionIdentifier, memberEmail: member.email) { (finished, response) in
			self.loadingView.stopLoading()
			self.regisButton.isUserInteractionEnabled = true
			self.checkResult(finished: finished, response: response)
		}
	}
	func checkResult(finished: Bool, response: dictStringAny?) {
		if finished {
			if self.type == PurchaseType.inapp {
						if self.selectPayment == "inapp" {
							var transactionID = ""
							if self.transactionInApp.original != nil {
								transactionID = (self.transactionInApp.original?.transactionIdentifier)!
							} else {
								transactionID = self.transactionInApp.transactionIdentifier!
							}
							UserDefaults.standard.removeObject(forKey: transactionID)
							SKPaymentQueue.default().finishTransaction(self.transactionInApp)
							self.paymentInstance.parameter = nil
						}
						self.showSuccessView(data: response!)
			} else {
				self.showSuccessView(data: response!)
			}
		} else {
			dropdownAlert.errorNTryAgain()
		}
	}
	
	func showSuccessView(data: dictStringAny) {
		let purchaseSuccessView = PretestPurchaseSuccessViewController(Validation.anyIsDictionary(data, with: "result"), price: promotionModel?.regularPrice ?? pretestList!.first!.regularPrice)
		purchaseSuccessView.nav = Nav(title: string.th_conc_purchase, isBack: true, isRight: false)
		navigationController?.pushViewController(purchaseSuccessView, animated: true)
	}
	
	func fillUI() {
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
        navTitleLabel.set(text: nav?.title)
        topView.addSubview(navTitleLabel)
		
		let regisModel = CustomBottomButtonFromModel(withButton: customButton)
		regisButton.viewModel = regisModel
		regisButton.delegate = self
		if price != 0 {
			regisButton.setColorButton(.darkgraybg, canTouch: true)
		} else {
			regisButton.setTitle("สมัครฟรี")
		}
		
		view.addSubview(topView)
		topView.snp.makeConstraints { (make) in
			make.top.equalTo(0)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
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
		
		view.addSubview(regisButton)
		regisButton.snp.makeConstraints { (make) in
			make.bottom.equalTo(view.snp.bottom)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
			make.height.equalTo(BOTTOM_BAR)
		}
		
		view.insertSubview(tablePurchaseDetailView, belowSubview: topView)
		tablePurchaseDetailView.snp.makeConstraints { (make) in
			make.top.equalTo(topView.snp.bottom)
			make.leading.equalTo(view.snp.leading)
			make.bottom.equalTo(regisButton.snp.top)
			make.trailing.equalTo(view.snp.trailing)
		}
		loadingView = LoadingView(withSuperview: view)
		tablePurchaseDetailView.delegate = self
		tablePurchaseDetailView.dataSource = self
		
		tablePurchaseDetailView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
	}
	
	// MARK: - TABLE VIEW DELEGATE
	func numberOfSections(in tableView: UITableView) -> Int {
		return headerSection.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == headerSection.index(of: string.th_detail_user) {
			return DataConfig.formPretest.count
		}
		return 1
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 29))
		view.backgroundColor = .clear
		
		let headerLabel = UILabel(frame: CGRect(x: MARGIN, y: 4, width: 150, height: 21))
		headerLabel.setParameter(font: .kanitLight14, color: .Celllabel)
		headerLabel.text = headerSection[section]

		view.addSubview(headerLabel)
		return view
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return nil
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 29
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		if section == headerSection.index(of: string.th_detail_user) {
			return 40
		}
		return MARGIN
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == headerSection.index(of: string.th_choose_purchase) {
			if !self.globalParameter.newMoreStore {
				return (50 * 2) + (MARGIN * 3)
			} else {
				return 50 + (MARGIN * 2)
			}
		} else if indexPath.section == headerSection.index(of: string.th_detail_purchase) {
			return 61
		}
		return 53
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: PretestPurchaseTableViewCell.cellIdentified, for: indexPath) as! PretestPurchaseTableViewCell
		cell.fieldDelegate = self
		
		if indexPath.section == headerSection.index(of: string.th_choose_purchase) {
			cell.fillUI(.purchase, row: indexPath.item, data: ["inapp" : promotionModel?.regularPrice.inapp ?? pretestList!.first!.regularPrice.inapp,
																"counterService" : promotionModel?.regularPrice.counterservice ?? pretestList!.first!.regularPrice.counterservice])
			cell.selectPaymentDelegate = self
		} else if indexPath.section == headerSection.index(of: string.th_detail_purchase) {
			cell.fillUI(.detailPretest, row: indexPath.item, data: ["name" : promotionModel?.promotionName ?? pretestList!.first!.pretestName,
																	"date" : promotionModel?.startRegisDate ?? pretestList!.first!.round.value.first!["pretestDate"] as! Int])
		} else if indexPath.section == headerSection.index(of: string.th_detail_user) {
			cell.fillUI(.detailUser, row: indexPath.item, data: ["name": member.name,
																 "surname": member.surname,
																 "email": member.email])
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		
	}
	
	// MARK: - PRETEST PURCHASE TABLE VIEW CELL DELEGATE
	func editField(_ textField: UITextField) {
		var heightKey = KEYBOARD_HEIGHT
		if HAVE_NOTCH {
			heightKey = heightKey - 20
		}
        moveViewUp(IS_IPHONE_6 ? heightKey - 40 : (IS_IPAD ? heightKey + 10 : heightKey))
	}
	func selectPayment(_ type: String) {
		selectPayment = type
		regisButton.setColorButton(.brandcolor1, canTouch: true)
		if type == "inapp" {
			self.type = .inapp
		} else if type == "counterService" {
			self.type = .counterService
		} else {
			self.type = .mol
		}
	}
}
