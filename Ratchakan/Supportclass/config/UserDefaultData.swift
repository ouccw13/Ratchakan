//
//  UserDefaultData.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 22/2/2566 BE.
//  Copyright © 2566 BE Chatcha.sobtid. All rights reserved.
//

import Foundation

enum UserDefaultKey:String {
    case clientSecret
    case appleToken
    case authorizationcode
    case userIdentifier_appleId
    case access_token
    case token_type
    case expires_in
    case refresh_token
    case id_token
    case email
    case firstName
    case lastName
}

class UserDefaultData: NSObject {
    var clientSecret: String = ""
    var appleToken: String = ""
    var authorizationcode: String = ""
    var access_token:String = ""
    var token_type:String = ""
    var expires_in:String = ""
    var refresh_token:String = ""
    var id_token:String = ""
    var userIdentifier_appleid: String = ""
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var defaultData: [String: Any]! {
        didSet {
            setValuable()
        }
    }
    
    class var storeObserverSharedInstance: UserDefaultData {
        struct Static {
            static let instance: UserDefaultData = UserDefaultData()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
//        if let data = UserDefaults.standard.dictionary(forKey: mainKey) {
//            defaultData = data
//        } else {
        defaultData = [UserDefaultKey.clientSecret.rawValue : "",
                       UserDefaultKey.appleToken.rawValue : "",
                       UserDefaultKey.authorizationcode.rawValue : "",
                       UserDefaultKey.userIdentifier_appleId.rawValue : "",
                       UserDefaultKey.access_token.rawValue : "",
                       UserDefaultKey.token_type.rawValue : "",
                       UserDefaultKey.expires_in.rawValue : "",
                       UserDefaultKey.refresh_token.rawValue : "",
                       UserDefaultKey.id_token.rawValue : "",
                       UserDefaultKey.email.rawValue : "",
                       UserDefaultKey.firstName.rawValue : "",
                       UserDefaultKey.lastName.rawValue : ""
        ]
//            UserDefaults.standard.set(defaultData, forKey: mainKey)
            DispatchQueue.main.async {
                UserDefaults.standard.synchronize()
            }
//        }
        setValuable()
    }
    
    func set(type: UserDefaultKey, data: String) {
//        if type == .jwtToken {
//            defaultData[type.rawValue] = "Bearer \(data)"
//        } else if type == .onboarding {
//            defaultData[type.rawValue] = data == "true"
//        } else {
        defaultData[type.rawValue] = data
//        }
//        UserDefaults.standard.set(defaultData, forKey: mainKey)
        DispatchQueue.main.async {
            UserDefaults.standard.synchronize()
        }
    }
    
    fileprivate func setValuable() {
        clientSecret = Validation.anyIsString(defaultData, with: UserDefaultKey.clientSecret.rawValue)
        appleToken = Validation.anyIsString(defaultData, with: UserDefaultKey.appleToken.rawValue)
        authorizationcode = Validation.anyIsString(defaultData, with: UserDefaultKey.authorizationcode.rawValue)
        userIdentifier_appleid = Validation.anyIsString(defaultData, with: UserDefaultKey.userIdentifier_appleId.rawValue)
        access_token = Validation.anyIsString(defaultData, with: UserDefaultKey.access_token.rawValue)
        token_type = Validation.anyIsString(defaultData, with: UserDefaultKey.token_type.rawValue)
        expires_in = Validation.anyIsString(defaultData, with: UserDefaultKey.expires_in.rawValue)
        refresh_token = Validation.anyIsString(defaultData, with: UserDefaultKey.refresh_token.rawValue)
        id_token = Validation.anyIsString(defaultData, with: UserDefaultKey.id_token.rawValue)
        email = Validation.anyIsString(defaultData, with: UserDefaultKey.email.rawValue)
        firstName = Validation.anyIsString(defaultData, with: UserDefaultKey.firstName.rawValue)
        lastName = Validation.anyIsString(defaultData, with: UserDefaultKey.lastName.rawValue)
    }
    
    func logout() {
        defaultData = [UserDefaultKey.clientSecret.rawValue : "",
                       UserDefaultKey.appleToken.rawValue : "",
                       UserDefaultKey.authorizationcode.rawValue : "",
                       UserDefaultKey.userIdentifier_appleId.rawValue : "",
                       UserDefaultKey.access_token.rawValue : "",
                       UserDefaultKey.token_type.rawValue : "",
                       UserDefaultKey.expires_in.rawValue : "",
                       UserDefaultKey.refresh_token.rawValue : "",
                       UserDefaultKey.id_token.rawValue : "",
                       UserDefaultKey.email.rawValue : email,
                       UserDefaultKey.firstName.rawValue : firstName,
                       UserDefaultKey.lastName.rawValue : lastName
        ]
        DispatchQueue.main.async {
            UserDefaults.standard.synchronize()
        }
    }
}
