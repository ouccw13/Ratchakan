//
//  LoadingView.swift
//  ratchakan
//
//  Created by JJsobtid on 22/3/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import Lottie

class LoadingView: UIView {

	var loadingAnimation: LottieAnimationView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	init(withSuperview view: UIView) {
		super.init(frame: CGRect())
		
		backgroundColor = .clear
		
		loadingAnimation = LottieAnimationView(name: "loading")
		loadingAnimation.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
		loadingAnimation.contentMode = .scaleAspectFit
		loadingAnimation.backgroundColor = .brandcoloralpha
		loadingAnimation.cornerView(radius: 50)
		loadingAnimation.center = self.center
//		addSubview(loadingAnimation)
		loadingAnimation.loopMode = .loop
//		loadingAnimation.play()
		
		view.addSubview(loadingAnimation)
		loadingAnimation.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize(width: 100, height: 100))
			make.center.equalTo(view.snp.center)
//			make.top.equalTo(view.snp.top).offset(-PAGEBAR_HEIGHT)
//			make.leading.equalTo(view.snp.leading)
//			make.trailing.equalTo(view.snp.trailing)
//			make.bottom.equalTo(view.snp.bottom).offset(-TABBAR_HEIGHT)
		}
		loadingAnimation.hide()
		hide()
	}
	
	func startLoading() {
		show()
		loadingAnimation.show()
		loadingAnimation.play()
	}
	
	func stopLoading() {
		hide()
		loadingAnimation.hide()
		loadingAnimation.stop()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
