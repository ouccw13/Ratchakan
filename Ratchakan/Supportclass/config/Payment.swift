//
//  Payment.swift
//  ratchakan
//
//  Created by JJsobtid on 19/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation
import StoreKit
import UIKit

typealias completeTransation = (_ complete: Bool, _ response: dictStringAny?, _ transaction: SKPaymentTransaction) -> Void

final class Payment: NSObject, SKPaymentTransactionObserver, SKProductsRequestDelegate, UIAlertViewDelegate {
	
	var products: [SKProduct]?
	var paymentTransaction: SKPaymentTransaction?
	var product: SKProduct?
	var alert: UIAlertController?
	
	lazy var api = API()
	
	var parameter: [String: Any]?
	
	class var storeObserverSharedInstance: Payment {
		struct Static {
			static let instance: Payment = Payment()
		}
		return Static.instance
	}
	
	private override init() {
		super.init()
		alert = UIAlertController(title: string.th_error, message: "", preferredStyle: .alert)
		alert?.addAction(UIAlertAction(title: string.th_ok, style: .default, handler: nil))
	}
	
	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
		for transaction in transactions {
			if let name = transaction.payment.applicationUsername {
				print(str: name)
			}
            let currentView = Utility.getCurrentViewController()
            if !currentView.isKind(of: NoteDetailViewController.classForCoder()) {
                switch transaction.transactionState {
                case .purchasing :
                    print("Payment Purchasing")
                    api.serverLog(parameter: parameter ?? ["type" : "payment",
														   "id" : transaction.transactionIdentifier ?? ""]) { (_, _) in
					}
				case .deferred :
                    print("Payment deferred")
				case .failed :
                    print("Payment failed")
					failedTransaction(transaction)
                case .purchased:
                    print("Payment purchased")
					if let p = parameter, let transactionId = transaction.transactionIdentifier {
						UserDefaults.standard.set(p, forKey: transactionId)
					}
					completedTransacion(transaction, sandbox: false)
                case .restored:
                    print("Payment restored")
                    SKPaymentQueue.default().finishTransaction(transaction)
                }
            }
		}
	}
	
	func completedTransacion(_ transaction: SKPaymentTransaction, sandbox: Bool) {
        validateRecieptData(transaction) { (finished, response, trans: SKPaymentTransaction) in
            self.paymentTransaction = trans
            return
        }
	}
	
	func validateProductIdentifiers(productIdentifiers: [String]) {
		let productsRequest = SKProductsRequest.init(productIdentifiers: Set(productIdentifiers))
		productsRequest.delegate = self
		productsRequest.start()
	}
	
	func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count == 0 {
            DispatchQueue.main.async {
                Utility.showAlert(title: "เกิดข้อผิดพลาด", detail: "ไม่สามารถเชื่อมต่อกับ itune store ได้")
            }
        }
        else{
            for product in response.products {
                let payment = SKPayment(product: product)
                SKPaymentQueue.default().add(payment)
            }
        }
	}
	
	func failedTransaction(_ transaction: SKPaymentTransaction) {
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotiCenter.purchaseComplete), object: nil)
		if let error = transaction.error as? SKError {
			print(str: error)
			api.serverLog(parameter: [ "type" : "payment",
									   "status" : "false",
									   "code" : "\(error.errorCode)",
									   "error" : error.localizedDescription ]) { (_, _) in
			}
            Utility.showAlert(title: "In App Purchase Error", detail: "ยกเลิกการซื้อภายในแอพ")
			SKPaymentQueue.default().finishTransaction(transaction)
			var transactionID: String
			if transaction.original != nil {
				transactionID = (transaction.original?.transactionIdentifier)!
			} else {
				transactionID = transaction.transactionIdentifier ?? "transactioniOS14"
			}
			if let _ = UserDefaults.standard.dictionary(forKey: transactionID) {
				UserDefaults.standard.removeObject(forKey: transactionID)
				parameter = nil
			}
		} else {
			alert?.message = "กรุณาปิดแอป​ฯเปิดใหม่ หรือ ติดต่อแอดมิน"
			Utility.getCurrentViewController().present(alert!, animated: true, completion: nil)
		}
	}
	
	func validateRecieptData(_ transaction: SKPaymentTransaction,_ complete: @escaping completeTransation) {
		let receiptURL = Bundle.main.appStoreReceiptURL
		
		guard let receipt = try? Data(contentsOf: receiptURL!) else {
			complete(false, ["message" : "No reciept"], transaction)
			return
		}
		var transactionID = ""
		if transaction.original != nil {
			transactionID = (transaction.original?.transactionIdentifier)!
		} else {
			transactionID = transaction.transactionIdentifier!
		}
		if let parameterData = UserDefaults.standard.dictionary(forKey: transactionID) {
			api.serverLog(parameter: parameterData) { (_, _) in
			}
		}
        
        let api = API()
        if transaction.payment.productIdentifier.split(separator: ".").contains("pretest") {
            if let parameterData = UserDefaults.standard.dictionary(forKey: transactionID) {
                api.purchasePretest(receipt: receipt.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)), round: parameterData["round"] as! [dictStringAny], channel: parameterData["channel"] as! Int, transactionId: transactionID, memberEmail: parameterData["member"] as! String) { (finished, response) in
                    if finished {
                        SKPaymentQueue.default().finishTransaction(transaction)
                        UserDefaults.standard.removeObject(forKey: transactionID)
                        self.parameter = nil
                        let message = "\(string.th_order_code) \(Validation.anyIsString(Validation.anyIsDictionary(response!, with: "result"), with: "paymentCode"))\n\(string.th_start_pretest)"
                        Utility.showAlert(title: string.th_order_complete, detail: message)
                    } else {
                        Utility.showAlert(title: string.th_error, detail: "กรุณาติดต่อ admin")
                    }
                    return
                }
            }
        } else if transaction.payment.productIdentifier.split(separator: ".").contains("promotion") {
            if let parameterData = UserDefaults.standard.dictionary(forKey: transactionID) {
                api.purchasePretest(promotionId: Validation.anyIsString(parameterData, with: "id"), receipt: receipt.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)), round: parameterData["pretests"] as! [dictStringAny], channel: parameterData["channel"] as! Int, transactionId: transactionID, memberEmail: parameterData["member"] as! String) { (finished, response) in
                    if finished {
                        SKPaymentQueue.default().finishTransaction(transaction)
                        UserDefaults.standard.removeObject(forKey: transactionID)
                        self.parameter = nil
                        let message = "\(string.th_order_code) \(Validation.anyIsString(Validation.anyIsDictionary(response!, with: "result"), with: "paymentCode"))\n\(string.th_start_pretest)"
                        Utility.showAlert(title: string.th_order_complete, detail: message)
                    } else {
                        Utility.showAlert(title: string.th_error, detail: "กรุณาติดต่อ admin")
                    }
                    return
                }
            }
        } else if transaction.payment.productIdentifier.split(separator: ".").contains("note"){
            SKPaymentQueue.default().finishTransaction(transaction)
            UserDefaults.standard.removeObject(forKey: transactionID)
        } else {
            if let parameterData = UserDefaults.standard.dictionary(forKey: transactionID) {
                api.purchasePackages(receipt: receipt.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)), ids: Validation.anyIsArrayString(parameterData, with: "packages"), channel: PurchaseType.inapp.rawValue, member: Validation.anyIsString(parameterData, with: "member"), transactionId: transactionID, { (finished, response) in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotiCenter.purchaseComplete), object: nil)
                    if finished {
                        SKPaymentQueue.default().finishTransaction(transaction)
                        UserDefaults.standard.removeObject(forKey: transactionID)
                        self.parameter = nil
                        let message = "\(string.th_order_code) \(Validation.anyIsString(Validation.anyIsDictionary(response!, with: "result"), with: "paymentCode"))\nดูแพ็กเกจที่ซื้อแล้วได้ที่หน้า \"แพ็กเกจที่ซื้อแล้ว\""
                        Utility.showAlert(title: string.th_order_complete, detail: message)
                        api.checkProfile({ (_, _) in
                            NotificationCenter.default.post(name: Notification.Name(rawValue: NotiCenter.checkLogIn), object: nil)
                            return
                        })
                    } else {
                        let errorDesc = Validation.anyIsString(Validation.anyIsDictionary(response!, with: "error"), with: "description")
                        if errorDesc == "member was not found." {
                        } else if errorDesc == "packages is invalid." {
                            
                        }
                        Utility.showAlert(title: errorDesc, detail: "กรุณาติดต่อ admin")
                    }
                    return
                })
            }
        }
    }
    
    func restoredPurchased() {
        print("Restored Purchased")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}


