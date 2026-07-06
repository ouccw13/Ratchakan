//
//  DetailsInPretestModel.swift
//  ratchakan
//
//  Created by Chatchawarn  Udomchutipath on 20/2/2566 BE.
//  Copyright © 2566 BE Chatcha.sobtid. All rights reserved.
//

import Foundation

struct DetailsInPretestModel {
    var subjectId:String
    var content:String
    var categories:[Categories]
    var qty:Int
}

struct Categories {
    var id:String
    var name:String
}
