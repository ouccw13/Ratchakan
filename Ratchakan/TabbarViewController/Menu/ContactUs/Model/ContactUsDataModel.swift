//
//  ContactUsDataModel.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 11/11/2568 BE.
//  Copyright © 2568 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import ObjectMapper

class ContactUsDataModel: Mappable {
    
    var message: String?
    var resultContactUS: ResultContactUS?
    var statusCode: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        resultContactUS <- map["result"]
        statusCode <- map["status"]
    }
}

class ResultContactUS: Mappable {
    
    var address: String?
    var facebookId: String?
    var twitter: String?
    var twitterId: String?
    var company: String?
    var facebook: String?
    var email: String?
    var tel: String?
    var line: String?
    var instagram: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        address <- map["address"]
        facebookId <- map["facebookId"]
        twitter <- map["twitter"]
        twitterId <- map["twitterId"]
        company <- map["company"]
        facebook <- map["facebook"]
        email <- map["email"]
        tel <- map["tel"]
        line <- map["line"]
        instagram <- map["instagram"]
    }
}
