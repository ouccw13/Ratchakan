//
//  MenuViewModel.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 11/11/2568 BE.
//  Copyright © 2568 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import ObjectMapper

class MenuViewModel: NSObject  {
    
    let api = API()
    var contactUsDataSource: ContactUsDataModel!
   
    override init() {
        super.init()
        self.getContactUsData()
    }
    
    func getContactUsData() {
        api.getContactUs({ (finished,response) in
            self.contactUsDataSource = Mapper<ContactUsDataModel>().map(JSON: response ?? [:])
        })
        return
    }
}
