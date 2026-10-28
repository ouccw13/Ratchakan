//
//  CustomMarkerView.swift
//  ratchakan
//
//  Created by Chatchawarn  Udomchutipath on 19/9/2565 BE.
//  Copyright © 2565 BE Chatcha.sobtid. All rights reserved.
//

import UIKit
import Charts
import DGCharts

class CustomMarkerView: MarkerView {
    @IBOutlet weak var contentView:UIView!
    @IBOutlet weak var markerBoard: UIView!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var markerStick: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    private func initUI() {
        Bundle.main.loadNibNamed("CustomMarkerView", owner: self, options: nil)
        addSubview(contentView)
        markerStick.backgroundColor = .brandcoloralpha
        markerBoard.backgroundColor = .brandcoloralpha
        markerBoard.layer.cornerRadius = 3.0
        markerStick.layer.cornerRadius = 3.0
        lbValue.textColor = .cencelborder
        
        self.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
              self.offset = CGPoint(x: -(self.frame.width/2), y: 0)
    }
}

