//
//  ExamGroups.swift
//  ratchakan
//
//  Created by Chatchawarn  Udomchutipath on 8/9/2565 BE.
//  Copyright © 2565 BE JJsobtid. All rights reserved.
//

import ObjectMapper

class ExamGroups: Mappable {
    var status:Int?
    var message:String?
    var result:ResultData?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        result <- map["result"]
    }
}

class ResultData:Mappable {
    var alert:AlertData?
    var subjects:[Subjects]?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        alert <- map["alert"]
        subjects <- map["subjects"]
    }
}

class AlertData:Mappable {
    var title:String?
    var message:String?
    var btn1:String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        message <- map["message"]
        btn1 <- map["btn1"]
    }
}

class Subjects:Mappable {
    var subjectId:String?
    var shortName:String?
    var name:String?
    var free:Bool?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        subjectId <- map["subjectId"]
        shortName <- map["shortName"]
        name <- map["name"]
        free <- map["free"]
    }
}



