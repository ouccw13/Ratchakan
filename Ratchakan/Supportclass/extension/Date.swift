//
//  Date.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 9/9/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import Foundation

extension Date {
    
    func dateFormatter(timeStamp: Int, format: String = "dMMMyy, HH:mm") -> String {
        let dateFormatter = DateFormatter()
        
        let date = Date(timeIntervalSince1970: TimeInterval(integerLiteral: Int64(timeStamp)))
        
        dateFormatter.locale = Locale(identifier: "th")
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        
        return dateFormatter.string(from: date)
    }
    
}
