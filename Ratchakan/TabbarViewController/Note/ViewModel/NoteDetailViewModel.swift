//
//  NoteDetailViewModel.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 4/9/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import Foundation
import StoreKit

class NoteDetailViewModel: NSObject {
    
    private let id: String!
    
    private let api = API()
    
    var note: Note!
    
    var isFree: Bool! {
        get {
            return note.priceTier.cash.price == 0
        }
    }
    
    var products: [SKProduct] = []
    private let paymentQueue = SKPaymentQueue.default()
    var paymentTransaction: SKPaymentTransaction?
    var purchaseCallback: ((Bool, Bool) -> ())!
    var failedInAppCallback: ((Bool) -> ())!
    
    init(withId id: String) {
        self.id = id
    }
    
    func loadDetail(whenDataIsLoaded: @escaping (() -> ())) {
        api.getNoteDetail(withId: id) { (finished, response) in
            self.note = response!["result"] as? Note
            whenDataIsLoaded()
        }
    }
    
    func purchaseNote() {
        
        if isFree {
            let parameter: [String : Any] = [ "noteId" : note.id,
                                              "channel" : PurchaseType.free.rawValue ]
            postApiPurchaseNote(parameter: parameter)
            
        } else {
            let productSet: Set = [note.priceTier.cash.inAppId ?? ""]
            let request = SKProductsRequest(productIdentifiers: productSet)
            request.delegate = self
            request.start()
            paymentQueue.add(self)
        }
    }
    
    
    func favoriteNote(id: String) {
        api.putFavoriteNote(withId: id) { (finished, response) in

        }
    }
    
    func transactionFinish(transaction: SKPaymentTransaction) {
        validateRecieptData(transaction) { (finished, response, transaction: SKPaymentTransaction) in
            return
        }

    }
    
    private func postApiPurchaseNote(parameter: [ String : Any]) {
        api.postPurchaseNote(parameter: parameter) { (finished, response) in
            if response!["status"] as! Int == 200 {
                self.purchaseCallback(true, false)
            } else {
                self.purchaseCallback(false, true)
            }
        }
    }
    
    var getId: String {
        return note.id
    }
    
    var getRowWhenNoteLoaded: Int {
        return (note != nil) ? 1 : 0
    }
    
    var getRowWhenUserOwnThisNote: Int {
        return (note != nil && note.isMyNote) ? 1 : 0
    }
    
    var numberOfComments: Int {
        return (note == nil) ? 0 : note.comments?.count ?? 0
    }
    
    func getOwnedComment() -> Comment? {
        return note.myComment
    }
    
    func getComment(atIndexPath indexPath: IndexPath) -> Comment {
        return note.comments![indexPath.row]
    }
}

extension NoteDetailViewModel: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        if products.count == 0 {
            DispatchQueue.main.async {
                self.purchaseCallback(false,false)
            }
        }
        else{
            for product in products {
                let payment = SKPayment(product: product)
                SKPaymentQueue.default().add(payment)
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("purchasing")
                break
            case .deferred :
                print("deferred")
                break
            case .purchased:
                print("purchased")
                self.paymentTransaction = transaction
                transactionFinish(transaction: transaction)
                break
            case .failed:
                self.paymentTransaction = transaction
                failedTransaction(transaction)
                break
            default:
                print("Case Unknown")
                break
            }
        }
    }
    
    func failedTransaction(_ transaction: SKPaymentTransaction) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotiCenter.purchaseComplete), object: nil)
        SKPaymentQueue.default().finishTransaction(transaction)
        self.paymentQueue.remove(self)
        self.purchaseCallback(false, true)
    }
    
    func validateRecieptData(_ transaction: SKPaymentTransaction,_ complete: @escaping completeTransation) {
        let receiptUrl = Bundle.main.appStoreReceiptURL
        guard let receipt = try? Data(contentsOf: receiptUrl!) else {
            complete(false, ["message" : "No reciept"], transaction)
            SKPaymentQueue.default().finishTransaction(transaction)
            self.paymentQueue.remove(self)
            purchaseCallback(false, true)
            return
        }

        let transactionID = transaction.transactionIdentifier ?? ""

        let parameter: [String : Any] = [ "noteId" : note.id,
        "channel" : PurchaseType.inapp.rawValue,
        "transaction" : transactionID,
        "receipt" : receipt.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) ]

        if transaction.payment.productIdentifier.split(separator: ".").contains("note") {
            SKPaymentQueue.default().finishTransaction(transaction)
            self.paymentQueue.remove(self)
            postApiPurchaseNote(parameter: parameter)
        }else{
            SKPaymentQueue.default().finishTransaction(transaction)
            paymentQueue.remove(self)
        }
    }
    
}
