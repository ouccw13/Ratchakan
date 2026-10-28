//
//  Double.swift
//  ratchakan
//
//  Created by Chatchawarn  Udomchutipath on 19/9/2565 BE.
//  Copyright © 2565 BE Chatcha.sobtid. All rights reserved.
//

import Foundation

extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}
