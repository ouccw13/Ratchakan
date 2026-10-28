//
//  KeyChainHelper.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 3/7/2567 BE.
//  Copyright © 2567 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import Security

class KeyChainHelper {
    
    static func save(_ key: String, value: String) {
        let data = Data(value.utf8)
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary
        
        SecItemDelete(query) // Delete any existing item
        SecItemAdd(query, nil) // Add the new item
    }
    
    static func get(_ key: String) -> String? {
           let query = [
               kSecClass: kSecClassGenericPassword,
               kSecAttrAccount: key,
               kSecReturnData: kCFBooleanTrue!,
               kSecMatchLimit: kSecMatchLimitOne
           ] as CFDictionary

           var dataTypeRef: AnyObject?
           let status = SecItemCopyMatching(query, &dataTypeRef)
           
           if status == errSecSuccess {
               if let data = dataTypeRef as? Data,
                  let result = String(data: data, encoding: .utf8) {
                   return result
               }
           }
           return nil
       }
}
