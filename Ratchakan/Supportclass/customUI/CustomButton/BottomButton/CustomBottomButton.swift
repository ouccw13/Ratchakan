//
//  CustomBottomButton.swift
//  ratchakan
//
//  Created by FelisDJ on 12/13/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit

class CustomBottomButton: UIView {

	var delegate: CustomButtonClick?

	var button: UIButton!
	
	fileprivate weak var customBottomButton: UIView!
	fileprivate var bottomSafeView: UIView!
	
	var viewModel: CustomBottomButtonFromModel? {
		didSet {
			fillUI()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		let customButton: UIView = UIView(frame: frame)
		self.addSubview(customButton)
		self.customBottomButton = customButton
		
		bottomSafeView = UIView()
		button = UIButton()
		self.addSubview(button)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	
	@IBAction func onClickButton(_ sender: Any) {
		clickButton(sender)
	}
	
	@objc func clickButton(_ sender: Any) {
		self.delegate?.next(tag: tag)
	}
	
	fileprivate func fillUI() {
		guard let viewModel = viewModel else {
			return
		}

		button.setBottomParameter(title: viewModel.title.value, bgColor: viewModel.color)
		button.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
		
		customBottomButton.backgroundColor = viewModel.color
		button.snp.makeConstraints { (make) in
			make.height.equalTo(50)
			make.leading.equalTo(self.snp.leading)
			make.trailing.equalTo(self.snp.trailing)
			make.top.equalTo(self.snp.top)
		}
		
		customBottomButton.addSubview(bottomSafeView)
		bottomSafeView.backgroundColor = viewModel.color
		
		bottomSafeView.snp.makeConstraints { (make) in
			make.leading.equalTo(button.snp.leading)
			make.trailing.equalTo(button.snp.trailing)
			make.top.equalTo(button.snp.bottom)
			make.bottom.equalTo(SCREEN_HEIGHT)
		}
		let tapBottmView = UITapGestureRecognizer(target: self, action: #selector(clickButton(_:)))
		bottomSafeView.addGestureRecognizer(tapBottmView)
	}
	
	func setColorButton(_ color: UIColor, canTouch: Bool) {
		if color == .brandcolor1 {
			button.enableButton(color: color)
			isUserInteractionEnabled = true
		} else {
			button.disableButton(canTouch: canTouch, withColor: color)
			isUserInteractionEnabled = canTouch
		}
		UIView.animate(withDuration: TIME_ANIMATE_COLOR_C, animations: {
			self.bottomSafeView.layer.backgroundColor = color.cgColor
		})
	}
	
	func setTitle(_ title: String) {
		viewModel?.changeTitle(title)
		viewModel?.title.bindAndFire({ (title) in
			self.button.setTitle(title, for: .normal)
		})
	}
}
