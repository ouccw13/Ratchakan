//
//  PNChartLabel.swift
//  PNChartSwift
//
//  Created by YiChen Zhou on 11/11/16.
//  Copyright © 2016 YiChen Zhou. All rights reserved.
//

import UIKit

class PNChartLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = .kanitLight10
        self.textColor = .cencelborder
        self.backgroundColor = UIColor.clear
        self.textAlignment = NSTextAlignment.center
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: NSCode) has not been implemented.")
    }

}
