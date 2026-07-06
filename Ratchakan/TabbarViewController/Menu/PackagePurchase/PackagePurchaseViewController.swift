//
//  PackagePurchaseViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 23/3/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import StoreKit

protocol PackagePurchaseDelegate {
	func nowPurchase(_ purchase: Bool)
}

class PackagePurchaseViewController: CustomViewControllerPushNavAndNoTabbar,UICollectionViewDelegate, UICollectionViewDataSource, CustomButtonClick {
	
	var refreshHeader: HeaderRefreshControl!
	var collectionView: UICollectionView!
	var collectionLayout: CollectionLayout!

	var summaryView: UIView!
	var totalPackageLabel, discostLabel, totalPriceLabel, lastPriceLabel, totalPriceTextLabel: UILabel!
	
	var buyPackageButton: CustomBottomButton!
	let customButton: BottomButton = BottomButton(title: "ซื้อแพ็กเกจ", color: .brandcolor1)
    var restoredPurchasedButton: UIButton!
	
	var packageData: [Package]!
	var bundleData: [PackageBundle]!
	
	var inAppId: [String]!
	var nowInAppId: String!
	var packageSelected: [String]!
	var namePackage: [String]!
	lazy var totalPrice: Int = 0
	lazy var discountPrice: Int = 0
	
	lazy var api = API()
	
	var dictProducts: [Int: SKProduct]!
	
	lazy var paymentInstance = Payment.storeObserverSharedInstance
	
	var payment: SKPayment!
	var request: SKProductsRequest!
	var selectProduct: SKProduct!
	var products: [SKProduct]!
	var transactionInApp: SKPaymentTransaction!
	
	var loadingView: LoadingView!
	
	var delegate: PackagePurchaseDelegate?
	
	@objc func stopLoading() {
		delegate?.nowPurchase(false)
		loadingView.stopLoading()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		listenNotiLogInOut(#selector(initAPI(_:)))
		NotificationCenter.default.addObserver(self, selector: #selector(stopLoading), name: NSNotification.Name(rawValue: NotiCenter.purchaseComplete), object: nil)
		
		packageData = []
		bundleData = []
		
		buyPackageButton = CustomBottomButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: BOTTOM_BAR))
		let buyButtonModel = CustomBottomButtonFromModel(withButton: customButton)
		buyPackageButton.viewModel = buyButtonModel
		buyPackageButton.delegate = self
		
		collectionLayout = CollectionLayout(withcol: (IS_IPAD ? 2 : 1), height: 114, axis: .vertical)
		collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionLayout)
		collectionView.hideScrollIndicatior()
		collectionView.alwaysBounceVertical = true
        collectionView.setUp(self, bg: .clear)
        collectionView.contentInset = UIEdgeInsets(top: MARGIN, left: MARGIN, bottom: MARGIN, right: MARGIN)
		collectionView.register(PackageCollectionViewCell.self, forCellWithReuseIdentifier: PackageCollectionViewCell.cellIdentifier)
		
		refreshHeader = HeaderRefreshControl(withColor: .brandcolor1, titleAttribute: Utility.setStringAttributes(string.en_pull_refresh, textColor: .brandcolor1, font: .kanitReg14, underline: false), target: (self ,#selector(reloadData)))
		if #available(iOS 10.0, *) {
			collectionView.refreshControl = refreshHeader
		} else {
			collectionView.insertSubview(refreshHeader, at: 0)
		}
        
        restoredPurchasedButton = {
            let button = UIButton()
            button.setParameter("กู้คืนการซื้อภายในแอป", textColor: .redPurchase, font: .kanitReg14, backgroundColor: .clearCanTouch)
            button.addTarget(self, action: #selector(restoredPurchase), for: .touchUpInside)
            return button
        }()
        view.addSubview(restoredPurchasedButton)
		
		summaryView = UIView()
		summaryView.backgroundColor = .white
		
		let lineView = UIView()
		lineView.backgroundColor = .guestcolor
		
		totalPackageLabel = UILabel()
		totalPackageLabel.setParameter(font: .kanitLight14, color: .placeholdercolor)
		totalPackageLabel.text = "0 แพ็กเกจที่เลือกไว้"
		
		discostLabel = UILabel()
		discostLabel.setParameter(font: .kanitLight14, color: .brandcolor1)
		discostLabel.text = "ส่วนลด 0%"
		
		totalPriceLabel = UILabel()
		totalPriceLabel.setParameter(font: .kanitReg14, color: .placeholdercolor)
		totalPriceLabel.text = "0"
		
		lastPriceLabel = UILabel()
		lastPriceLabel.setParameter(font: .kanitMed18, color: .brandcolor1, alignment: .right)
		lastPriceLabel.text = "0 บาท"
		
		totalPriceTextLabel = UILabel()
		totalPriceTextLabel.text = "ราคารวม"
		totalPriceTextLabel.setParameter(font: .kanitLight14, color: .guestcolor, alignment: .right)
		
		totalPriceLabel.addSubview(lineView)
		lineView.snp.makeConstraints { (make) in
			make.leading.equalTo(totalPriceLabel.snp.leading)
			make.trailing.equalTo(totalPriceLabel.snp.trailing).offset(-4.5)
			make.centerY.equalTo(totalPriceLabel.snp.centerY)
			make.height.equalTo(1.5)
		}
		
		summaryView.addsubviews([totalPackageLabel, discostLabel, totalPriceLabel, lastPriceLabel, totalPriceTextLabel])
		totalPackageLabel.snp.makeConstraints { (make) in
			make.top.equalTo(summaryView.snp.top).offset(10)
			make.leading.equalTo(summaryView.snp.leading).offset(MARGIN)
			make.height.equalTo(21)
			make.trailing.equalTo(totalPriceTextLabel.snp.leading).offset(-MARGIN)
		}
		totalPriceTextLabel.snp.makeConstraints { (make) in
			make.top.equalTo(totalPackageLabel.snp.top)
			make.width.equalTo(55)
			make.trailing.equalTo(summaryView.snp.trailing).offset(-MARGIN)
			make.height.equalTo(totalPackageLabel.snp.height)
		}
		discostLabel.snp.makeConstraints { (make) in
			make.top.equalTo(totalPackageLabel.snp.bottom)
			make.leading.equalTo(totalPackageLabel.snp.leading)
			make.height.equalTo(21)
			make.trailing.equalTo(summaryView.snp.centerX)
		}
		lastPriceLabel.snp.makeConstraints { (make) in
			make.bottom.equalTo(discostLabel.snp.bottom).offset(1)
			make.height.equalTo(25)
			make.width.equalTo(80)
			make.trailing.equalTo(totalPriceTextLabel.snp.trailing)
		}
		totalPriceLabel.snp.makeConstraints { (make) in
			make.width.equalTo(20)
			make.height.equalTo(21)
			make.bottom.equalTo(discostLabel.snp.bottom)
			make.trailing.equalTo(lastPriceLabel.snp.leading).offset(-4)
		}
		
		view.addsubviews([collectionView, summaryView, buyPackageButton])
		
		buyPackageButton.snp.makeConstraints { (make) in
			make.height.equalTo(BOTTOM_BAR)
			make.leading.equalTo(view.snp.leading)
			make.bottom.equalTo(view.snp.bottom)
			make.trailing.equalTo(view.snp.trailing)
		}
		buyPackageButton.setColorButton(.darkgraybg, canTouch: false)
		buyPackageButton.hide()
		summaryView.snp.makeConstraints { (make) in
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
			make.bottom.equalTo(buyPackageButton.snp.top)
			make.height.equalTo(0)
		}
		summaryView.hide()
		collectionView.snp.makeConstraints { (make) in
			make.top.equalTo(view.snp.top).offset(PAGEBAR_HEIGHT)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(restoredPurchasedButton.snp.top).offset(-MARGIN)
		}
        restoredPurchasedButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-60)
            make.centerX.equalTo(view.snp.centerX)
        }
		refreshHeader.snp.makeConstraints({ (make) in
			make.centerX.equalTo(view.snp.centerX)
			make.width.equalTo(300)
			make.height.equalTo(60)
			make.bottom.equalTo(collectionView.contentOffset.y).offset(-30)
		})
        
		loadingView = LoadingView(withSuperview: view)

		reloadData()
	}
	
	deinit {
		viewDisappear()
	}
	
	@objc func initAPI(_ sender: NSNotification) {
		api = API()
	}
    
    @objc func restoredPurchase() {
        let confirmAlert = UIAlertController(title: "คุณต้องการกู้คืนข้อมูลการซื้อภายในแอพหรือไม่ ?", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        confirmAlert.addAction(UIAlertAction(title: string.th_cancel, style: .cancel, handler: nil))
        confirmAlert.addAction(UIAlertAction(title: string.th_confirm, style: .default, handler: { action in
            self.paymentInstance.restoredPurchased()
            dropdownAlert.title(string.th_noti, message: "กู้คืนการซื้อภายในแอพเรียบร้อยแล้ว", backgroundColor: .successgreen, textColor: .white)
        }))
        present(confirmAlert, animated: true, completion: nil)
    }
	
	@objc func reloadData() {
		packageSelected = []
		namePackage = []
		inAppId = []
		totalPrice = 0
		discountPrice = 0
		nowInAppId = ""
		loadingView.startLoading()
		api.getPackages { (finished, response) in
			self.dictProducts = [:]
			self.packageData = []
			self.bundleData = []
			self.inAppId = []
			self.totalPrice = 0
			self.discountPrice = 0
			self.nowInAppId = ""
			if finished {
				for package in Validation.anyIsArrayAny(Validation.anyIsDictionary(response!, with: "result"), with: "packages") {
					if Validation.anyIsBool(package, with: "isBundle") {
                        if package["packageId"] as! String == "YLRJvEbS" || package["packageId"] as! String == "JyWaQTC0" || package["packageId"] as! String == "f2eMhw8f" {
                            self.bundleData.append(PackageBundle(withDictionary: package))
                            self.inAppId.append(self.bundleData.last!.price.inappID)
                        }
					} else {
                        if package["packageId"] as! String == "YLRJvEbS" || package["packageId"] as! String == "JyWaQTC0" || package["packageId"] as! String == "f2eMhw8f" {
                            self.packageData.append(Package(withDictionary: package))
                            self.inAppId.append(self.packageData.last!.price.inappID)
                        }
					}
				}
				self.collectionView.reloadData()
				
				self.buyPackageButton.setColorButton(.darkgraybg, canTouch: false)
				UIView.animate(withDuration: 0.25) {
					self.summaryView.snp.updateConstraints({ (make) in
						make.height.equalTo(0)
					})
					self.summaryView.removeShadow()
				}
				self.nowInAppId = ""
			}
			
			self.loadingView.stopLoading()
			self.refreshHeader.endRefreshing()
			return
		}
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return bundleData.count + packageData.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PackageCollectionViewCell.cellIdentifier, for: indexPath) as! PackageCollectionViewCell
	
		let packageAtIndex = indexPath.item < bundleData.count ? bundleData[indexPath.item] : packageData[indexPath.item-bundleData.count]
		cell.setCellData(packageAtIndex, withType: "purchase")
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		if indexPath.item < bundleData.count {
			namePackage = bundleData[indexPath.item].details
			packageSelected = [bundleData[indexPath.item].packageId]
		} else {
			namePackage = [packageData[indexPath.item-bundleData.count].name]
			packageSelected = [packageData[indexPath.item-bundleData.count].id]
		}
		nowInAppId = inAppId[indexPath.item]
        if Utility.checkLogIn(member: api.getDatabase().getMember()) {
            if let index = inAppId.index(of: nowInAppId) {
                if nowInAppId != "" {
					var message = "คุณต้องการซื้อแพ็กเกจ?"
					var detail = ""
					for packageName in namePackage {
						detail += "  - " + packageName + "\n"
					}
					if index > packageData.count - 1 {
						
					} else {
						for examGroupId in packageData[index].examGroups {
							if api.packages[examGroupId] ?? 0 >= Datetime.getCurrentTimestamp() {
								message = "คุณต้องการ \"ต่ออายุ\" แพ็กเกจ?"
							}
						}
					}
                    let confirmAlert = UIAlertController(title: message, message: detail, preferredStyle: UIAlertController.Style.alert)
					confirmAlert.addAction(UIAlertAction(title: string.th_cancel, style: .cancel, handler: nil))
					confirmAlert.addAction(UIAlertAction(title: string.th_confirm, style: .default, handler: { action in
                        self.paymentInstance.parameter = ["packages": self.packageSelected ?? [],
														  "member" : self.api.member_id ?? ""]
						self.loadingView.startLoading()
						self.delegate?.nowPurchase(true)
                        self.paymentInstance.validateProductIdentifiers(productIdentifiers: [self.nowInAppId])
					}))
					present(confirmAlert, animated: true, completion: nil)
				} else {
					dropdownAlert.errorNTryAgain()
				}
			} else {
				dropdownAlert.errorNTryAgain()
			}
		}
	}
	
	// MARK: - Button Action
	func next(tag: Int) {
		if Utility.checkLogIn(member: api.getDatabase().getMember()) {
            if let index = inAppId.firstIndex(of: nowInAppId) {
				if dictProducts[index] != nil {
					var message = "คุณต้องการซื้อแพ็กเกจ?"
					var detail = ""
					for packageName in namePackage {
						detail += "  - " + packageName + "\n"
					}
					if index > packageData.count - 1 {
						
					} else {
						for examGroupId in packageData[index].examGroups {
							if api.packages[examGroupId] ?? 0 >= Datetime.getCurrentTimestamp() {
								message = "คุณต้องการต่ออายุแพ็กเกจ?"
							}
						}
					}
                    let confirmAlert = UIAlertController(title: message, message: detail, preferredStyle: UIAlertController.Style.alert)
					confirmAlert.addAction(UIAlertAction(title: string.th_cancel, style: .cancel, handler: nil))
					confirmAlert.addAction(UIAlertAction(title: string.th_confirm, style: .default, handler: { action in
                        self.paymentInstance.parameter = ["packages": self.packageSelected ?? [],
														  "member" : self.api.member_id ?? ""]
						self.loadingView.startLoading()
						self.delegate?.nowPurchase(true)
						self.payment = SKPayment(product: self.dictProducts[index]!)
						SKPaymentQueue.default().add(self.payment)
					}))
					present(confirmAlert, animated: true, completion: nil)
				} else {
					dropdownAlert.errorNTryAgain()
				}
			} else {
				dropdownAlert.errorNTryAgain()
			}
		}
	}
}
