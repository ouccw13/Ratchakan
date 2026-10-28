//
//  ClaimsES256.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 22/2/2566 BE.
//  Copyright © 2566 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import SwiftJWT
struct ClaimsES256 : Claims {
    var iss:String
    var iat:TimeInterval
    var exp:TimeInterval
    var aud: String
    var sub:String
}
