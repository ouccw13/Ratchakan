//
//  Float.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 30/9/2565 BE.
//  Copyright © 2565 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
extension Float {
    var convertFloatZerotoInt: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
