//
//  ExamsInTab.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 22/11/2565 BE.
//  Copyright © 2565 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import ObjectMapper

class ExamsInTab:Mappable {
    var status:Int?
    var message:String?
    var result:ResultInTab?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        result <- map["result"]
    }
}
class ResultInTab:Mappable {
    var exams:[Exams]?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        exams <- map["exams"]
    }
}
class Exams:Mappable {
    var _id:String?
    var examId:String?
    var name:String?
    var examGroupId:String?
    var questionQty:Int?
    var examScore:Int?
    var coverImage:String?
    var status:Bool?
    var color:String?
    var createdAt:TimeInterval?
    var updatedAt:TimeInterval?
    var subjectGroup:String?
    var examGroup:String?
    var approverId:String?
    var description:String?
    var tags:[String]?
    var free:Bool?
    var subjects:[SubjectList]?
    var alert:String?
    var score:Score?
    var isDone:Bool?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id <- map["_id"]
        examId <- map["examId"]
        name <- map["name"]
        examGroupId <- map["examGroupId"]
        questionQty <- map["questionQty"]
        examScore <- map["examScore"]
        coverImage <- map["coverImage"]
        status <- map["status"]
        color <- map["color"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
        subjectGroup <- map["subjectGroup"]
        examGroup <- map["examGroup"]
        approverId <- map["approverId"]
        description <- map["description"]
        tags <- map["tags"]
        free <- map["free"]
        subjects <- map["subjects"]
        alert <- map["alert"]
        score <- map["score"]
        isDone <- map["isDone"]
    }
}

class SubjectList:Mappable {
    var subjectName:String?
    var questionQty:Int?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        subjectName <- map["subjectName"]
        questionQty <- map["questionQty"]
    }
}

class Score:Mappable {
    var memberScore:Int?
    var examScore:Int?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        memberScore <- map["memberScore"]
        examScore <- map["examScore"]
    }
}
