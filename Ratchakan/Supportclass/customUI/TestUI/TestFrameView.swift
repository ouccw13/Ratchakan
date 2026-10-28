//
//  TestFrameView.swift
//  ratchakan
//
//  Created by JJsobtid on 10/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

enum axisTestFrame {
	case vertical
	case horizontal
}

class TestFrameView: UIView {

	var boundFrame: UIView!
	var centerVerticalLine: UIView!
	var centerHorizontalLine: UIView!
	
	init() {
		super.init(frame: CGRect())
		
		boundFrame = UIView()
		boundFrame.backgroundColor = .clear
		boundFrame.layer.borderWidth = 0.5
		boundFrame.layer.borderColor = UIColor.gray.cgColor
		
		addSubview(boundFrame)
		boundFrame.snp.makeConstraints { (make) in
			make.edges.equalTo(snp.edges)
		}
		
		centerVerticalLine = UIView()
		centerVerticalLine.backgroundColor = .gray
		
		boundFrame.addSubview(centerVerticalLine)
		centerVerticalLine.snp.makeConstraints { (make) in
			make.center.equalTo(boundFrame.snp.center)
			make.width.equalTo(0.5)
			make.height.equalTo(boundFrame.snp.height)
			
		}
		
		centerHorizontalLine = UIView()
		centerHorizontalLine.backgroundColor = .gray
		
		boundFrame.addSubview(centerHorizontalLine)
		centerHorizontalLine.snp.makeConstraints { (make) in
			make.center.equalTo(boundFrame.snp.center)
			make.height.equalTo(0.5)
			make.width.equalTo(boundFrame.snp.width)
		}
		
		isUserInteractionEnabled = false
		boundFrame.isUserInteractionEnabled = false
		centerVerticalLine.isUserInteractionEnabled = false
		centerHorizontalLine.isUserInteractionEnabled = false
		
//		isOpaque = true
//		boundFrame.isOpaque = true
//		centerVerticalLine.isOpaque = true
//		centerHorizontalLine.isOpaque = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func addAndMakeConstraints(withSuperview view: UIView) {
		view.addSubview(self)
		self.snp.makeConstraints { (make) in
			make.edges.equalTo(view.snp.edges)
		}
	}
	/*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
