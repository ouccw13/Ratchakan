//
//  MemberDataModel.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 12/11/2568 BE.
//  Copyright © 2568 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import ObjectMapper

class MemberDataModel: Mappable {
    
    var phoneNumber: String?
    var token: String?
    var displayName: String?
    var profileImage: String?
    var first_of_daye: String?
    var surname: String?
    var memberId: String?
    var plan_empire: Int?
    var createdAt: Int?
    var packages: [String: AnyObject]?
    var time_noti: String?
    var name: String?
    var birthday: String?
    var email: String?
    var date_changepassword: Int?
    var gender: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        phoneNumber <- map["phoneNumber"]
        token <- map["token"]
        displayName <- map["displayName"]
        profileImage <- map["profileImage"]
        first_of_daye <- map["first_of_daye"]
        surname <- map["surname"]
        memberId <- map["memberId"]
        plan_empire <- map["plan_empire"]
        createdAt <- map["createdAt"]
        packages <- map["packages"]
        time_noti <- map["time_noti"]
        name <- map["name"]
        birthday <- map["birthday"]
        email <- map["email"]
        date_changepassword <- map["date_changepassword"]
        gender <- map["gender"]
    }
}
