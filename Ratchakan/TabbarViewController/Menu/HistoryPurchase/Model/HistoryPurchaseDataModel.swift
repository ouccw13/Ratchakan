//
//  HistoryPurchaseDataModel.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 11/11/2568 BE.
//  Copyright © 2568 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import ObjectMapper

class HistoryPurchaseDataModel: Mappable {
    
    var message: String?
    var statusCode: Int?
    var resultHistoryPurchase: ResultHistoryPurchase?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        statusCode <- map["status"]
        resultHistoryPurchase <- map["result"]
    }
}

class ResultHistoryPurchase: Mappable {
    
    var memberId: String?
    var paymentHistory: [PaymentHistory]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        memberId <- map["memberId"]
        paymentHistory <- map["payments"]
    }
}

class PaymentHistory: Mappable {
    
    var paymentCode: String?
    var updateAt: Int?
    var paymentId: String?
    var channel: Int?
    var paycode: String?
    var transaction: String?
    var isPaid: Bool?
    var url: String?
    var expiredDate: Int?
    var amount: Int?
    var type: String?
    var memberId: String?
    var transactionDate: Int?
    var createdAt: Int?
    var status: Bool?
    var name: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        paymentCode <- map["paymentCode"]
        updateAt <- map["updateAt"]
        paymentId <- map["paymentId"]
        channel <- map["channel"]
        paycode <- map["paycode"]
        transaction <- map["transaction"]
        isPaid <- map["isPaid"]
        url <- map["url"]
        expiredDate <- map["expiredDate"]
        amount <- map["amount"]
        type <- map["type"]
        memberId <- map["memberId"]
        transactionDate <- map["transactionDate"]
        createdAt <- map["createdAt"]
        status <- map["status"]
        name <- map["name"]
    }
}
