//
//  CustomNav.swift
//  ratchakan
//
//  Created by JJsobtid on 6/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit

@objc protocol CustomNavDelegate {
	@objc optional func back()
	@objc optional func next()
	@objc optional func search(_ text: String)
	@objc optional func cancelSearch(_ text: String)
}

class CustomNav: UIView, UITextFieldDelegate {
    
	@IBOutlet var titleNavLabel: UILabel!
	@IBOutlet var leftButton: UIBarButtonItem!
	@IBOutlet var rightButton: UIBarButtonItem!
	@IBOutlet weak var toolBar: UIToolbar!
	
	@IBOutlet weak var titleTrailConstraint: NSLayoutConstraint!
	
	var bgSearchView: UIView!
	var searchField: UITextField!
	var barView: UIView!
	
	var delegate: CustomNavDelegate?
	
	fileprivate weak var customNavNibView: UIView!
	
	var viewModel: CustomViewModelFromNav? {
		didSet {
			fillUI()
		}
	}
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		let customNav: UIView = UINib.loadCustomNav(self)
		addSubview(customNav)
		
		customNavNibView = customNav
		dropShadow(color: .brandcoloralpha)
		
		titleNavLabel.text = "FirstView"
		titleNavLabel.font = .navTitleFont
		titleNavLabel.textColor = .brandcolor1
		leftButton.title = ""
		leftButton.image = #imageLiteral(resourceName: "backIcon")
		rightButton.title = ""
		
		barView = UIView()
		
		toolBar.backgroundColor = .clear
		titleNavLabel.backgroundColor = .clear
		customNavNibView.backgroundColor = .clear
		
	}
	
	fileprivate func createSearchField() {
		bgSearchView = UIView()
		bgSearchView.alpha = 0
		
		let viewSearchAlpha = UIView()
		viewSearchAlpha.backgroundColor = .darksearchbg
		viewSearchAlpha.cornerView(radius: 5)
		
		searchField = UITextField()
		searchField.returnKeyType = .search
		searchField.textAlignment = .center
		searchField.font = .kanitReg16
		searchField.textColor = .white
		
		let searchImage = UIImageView(image: #imageLiteral(resourceName: "searchIcon"))
		searchImage.contentMode = .scaleAspectFit
		let clearImage = UIButton()
		clearImage.setImage(#imageLiteral(resourceName: "clearIcon"), for: .normal)
		clearImage.imageView?.contentMode = .scaleAspectFit
		clearImage.addTarget(self, action: #selector(cancelSearch), for: .touchUpInside)
		bgSearchView.addSubview(viewSearchAlpha)
		viewSearchAlpha.snp.remakeConstraints({ (make) in
			make.height.equalTo(28)
			make.leading.equalTo(bgSearchView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(bgSearchView.snp.trailing).offset(-MARGIN)
			make.bottom.equalTo(bgSearchView.snp.bottom).offset(-9)
		})
		viewSearchAlpha.addsubviews([searchImage, searchField, clearImage])
		searchImage.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize(width: 16, height: 16))
			make.centerY.equalTo(viewSearchAlpha.snp.centerY)
			make.leading.equalTo(viewSearchAlpha.snp.leading).offset(MARGIN)
		}
		clearImage.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize(width: 16, height: 16))
			make.centerY.equalTo(viewSearchAlpha.snp.centerY)
			make.trailing.equalTo(viewSearchAlpha.snp.trailing).offset(-SMALLINSET)
		}
		searchField.snp.makeConstraints { (make) in
			make.height.equalTo(viewSearchAlpha.snp.height)
			make.centerY.equalTo(viewSearchAlpha.snp.centerY)
			make.leading.equalTo(searchImage.snp.trailing).offset(4)
			make.trailing.equalTo(clearImage.snp.leading).offset(-4)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
		super.init(coder: aDecoder)
		
		let customNav: UIView = UINib.loadCustomNav(self)
		self.addSubview(customNav)
		self.customNavNibView = customNav
		
		titleNavLabel.text = "FirstView"
		titleNavLabel.font = .navTitleFont
		titleNavLabel.textColor = .brandcolor1
		leftButton.title = "Back"
		rightButton.title = "Next"
		
//		self.backgroundColor = UIColor.clear
		self.toolBar.backgroundColor = .clear
		self.titleNavLabel.backgroundColor = .clear
		self.customNavNibView.backgroundColor = .clear
		
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
//		customNavNibView.frame = self.bounds
		customNavNibView.dropShadow(color: .brandcoloralpha)
		
		guard let viewModel = viewModel else {
			return
		}
		let color = viewModel.color.withAlphaComponent(0.25)
		customNavNibView.dropShadow(color: color)
	}
	
	@IBAction func leftButtonPress(_ sender: Any) {
		self.delegate?.back!()
	}

	@IBAction func rightButtonPress(_ sender: Any) {
		if viewModel?.imageRight == "searchIcon" {
			UIView.animate(withDuration: 0.1, animations: {
				self.bgSearchView.alpha = 1
			})
			searchField.becomeFirstResponder()
		} else {
			self.delegate?.next!()
		}
	}
	
	fileprivate func fillUI() {
		guard let viewModel = viewModel else {
			return
		}
		
		self.titleNavLabel.text = viewModel.titleName

		if UIColor.dark(color: viewModel.color) {
			self.titleNavLabel.textColor = .white
		} else {
			self.titleNavLabel.textColor = .black
		}
		
		customNavNibView.snp.makeConstraints { (make) in
			make.height.equalTo(NAV_HEIGHT)
			make.width.equalTo(self.snp.width)
//			make.top.equalTo(STATUSBAR)
			make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
		}
		if !viewModel.left {
			self.leftButton.isEnabled = false
			self.leftButton.tintColor = .clear
		} else {
			if UIColor.dark(color: viewModel.color) {
				self.leftButton.tintColor = .white
			} else {
				self.leftButton.tintColor = .black
			}
		}
        
		if !viewModel.right {
			rightButton.isEnabled = false
			rightButton.tintColor = .clear
//			titleTrailConstraint.constant = -MARGIN
		} else {
			self.rightButton.image = UIImage(named: viewModel.imageRight!)
			if UIColor.dark(color: viewModel.color) {
				self.rightButton.tintColor = .white
			} else {
				self.rightButton.tintColor = .black
			}
			if viewModel.imageRight == "searchIcon" {
				createSearchField()
				searchField.delegate = self
			}
			
		}
		
		addSubview(barView)
		
		if viewModel.imageRight == "searchIcon" {
			addSubview(bgSearchView)
			bgSearchView.backgroundColor = viewModel.color
			bgSearchView.snp.remakeConstraints({ (make) in
				make.edges.equalTo(self.snp.edges)
			})
		}
		
		self.backgroundColor = viewModel.color
		toolBar.barTintColor = viewModel.color
		barView.backgroundColor = viewModel.color
		
		barView.snp.makeConstraints { (make) in
			make.top.equalTo(0)
			make.leading.equalTo(self.snp.leading)
			make.trailing.equalTo(self.snp.trailing)
			make.bottom.equalTo(customNavNibView.snp.top)
		}
		
	}
	
	@objc fileprivate func cancelSearch() {
		delegate?.cancelSearch!(searchField.text ?? "")
		searchField.text = nil
		searchField.endEditing(true)
		UIView.animate(withDuration: 0.1, animations: {
			self.bgSearchView.alpha = 0
		})
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		// called when 'return' key pressed. return NO to ignore.
		searchField.endEditing(true)
		if textField.text != nil && textField.text?.trimSpace() != "" {
			delegate?.search!(textField.text!)
		}
		return true
	}
}
