//
//  ResultOTPModel.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 27/2/2566 BE.
//  Copyright © 2566 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import ObjectMapper

class ResultOTPModel: Mappable {
    var message:String?
    var status:Int?
    var result:ResultMessage?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        status <- map["status"]
        result <- map["result"]
    }
}

class ResultMessage: Mappable {
    var massage:String?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
       massage <- map["massage"]
    }
}

class ResultVerifyOTPModel: Mappable {
    var message:String?
    var status:Int?
    var result:ResultMessage?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        status <- map["status"]
        result <- map["result"]
    }
}

class ErrorVerifyOTPModel: Mappable {
    var status:Int?
    var error:ErrorMessage?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        error <- map["error"]
    }
}

class ErrorMessage: Mappable {
    var message:String?
    var description:String?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        message <- map["message"]
       description <- map["description"]
    }
}
