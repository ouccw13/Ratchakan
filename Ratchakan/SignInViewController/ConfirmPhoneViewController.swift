//
//  ConfirmPhoneViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 9/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class ConfirmPhoneViewController: CustomViewControllerPresentNavAndNoTabbar, CustomNavDelegate, UITextFieldDelegate {

//	var topView: CustomNav!
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
	var titleLabel, phoneLabel, otpLabel: UILabel!
	var phoneTextField, otpTextField: UITextField!
	var conditionDetailButton: UIButton!
	var lineView: UIView!
	var loadingIndicator: UIActivityIndicatorView!
	
	var phoneNumber: String = ""
	
	var beforeView: String!
	
	lazy var api = API()
	
//	let nav: Nav = Nav(title: string.th_confirm_phone, isBack: true, isRight: false, color: UIColor.brandcolor1)
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		if UIColor.dark(color: .navbrandcolor) {
			return .lightContent
		} else {
			return .default
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		self.view.backgroundColor = .brandcolor_bg
		self.moveViewWhenKeyboradAppear()
		self.hideKeyboardWhenTappedAround()
		
//		topView = CustomNav(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TOP_VIEW))
        topView = UIView()
        topView.backgroundColor = .navbrandcolor
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.setAnimatedTouch()
        backButton.adjustsImageWhenHighlighted = false
        backButton.adjustsImageWhenDisabled = false
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        topView.addSubview(backButton)
        
        navTitleLabel = UILabel()
        navTitleLabel.setParameter(font: .navTitleFont, color: .cellWhiteLabel)
        navTitleLabel.numberOfLines = 2
        navTitleLabel.lineBreakMode = .byWordWrapping
        navTitleLabel.set(text: string.th_confirm_phone)
        topView.addSubview(navTitleLabel)
		
		phoneLabel = UILabel()
		phoneLabel.setParameter(font: .kanitLight14, color: .Celllabel)
		phoneLabel.text = string.th_phone_number
		otpLabel = UILabel()
		otpLabel.setParameter(font: .kanitLight14, color: .Celllabel)
		otpLabel.text = "รหัส OTP"
		
		let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: MARGIN, height: 44))
		phoneTextField = UITextField()
		phoneTextField.keyboardType = .phonePad
		phoneTextField.placeholder = " กรุณากรอกเบอร์โทรศัพท์"
		phoneTextField.text = phoneNumber
		phoneTextField.font = .kanitReg14
		phoneTextField.textColor = .Celllabel
		phoneTextField.textAlignment = .right
		phoneTextField.rightView = paddingView
		phoneTextField.rightViewMode = .always
		phoneTextField.backgroundColor = .white
		phoneTextField.delegate = self
		
		let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: MARGIN, height: 44))
		otpTextField = UITextField()
		otpTextField.keyboardType = .numberPad
		otpTextField.placeholder = " กรอก OTP ภายใน 30 นาที"
		otpTextField.font = .kanitReg14
		otpTextField.textColor = .Celllabel
		otpTextField.textAlignment = .right
		otpTextField.rightView = paddingView2
		otpTextField.rightViewMode = .always
		otpTextField.backgroundColor = .white
		otpTextField.delegate = self
		
		lineView = UIView()
		lineView.lineView(withColor: .separateLine)
		
		conditionDetailButton = UIButton(frame: CGRect())
		conditionDetailButton.cornerView(radius: 25)
		conditionDetailButton.setParameter(string.th_send_sms, textColor: .white, font: .kanitReg14, backgroundColor: .brandcolor1)
		conditionDetailButton.addTarget(self, action: #selector(sendOTP), for: .touchUpInside)
		conditionDetailButton.setAnimatedTouch()
		
        loadingIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
		
		fillUI()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.isNavigationBarHidden = true
		Utility.statusBar(color: .clear)
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		viewDisappear()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	fileprivate func fillUI() {
		if !isViewLoaded {
			return
		}
		
//		let navModel = CustomViewModelFromNav(withNav: self.nav)
//		topView.viewModel = navModel
//		topView.delegate = self
		
		view.addSubview(topView);
		topView.snp.makeConstraints { (make) in
			make.top.equalTo(0)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			make.height.equalTo(TOP_VIEW)
		}
        
        if IS_IPAD {
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY)/*.offset(INSET)*/
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
//                make.leading.equalTo(backButton.snp.trailing).offset(10)
                make.centerY.equalTo(topView.snp.centerY)/*.offset(INSET)*/
                make.centerX.equalTo(topView.snp.centerX)
//                make.trailing.equalTo(topView.snp.trailing).offset(-10)
            }
        }else{
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
//                make.leading.equalTo(backButton.snp.trailing).offset(10)
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.centerX.equalTo(topView.snp.centerX)
//                make.trailing.equalTo(topView.snp.trailing).offset(-10)
            }
        }
		
		view.addSubview(phoneTextField)
		phoneTextField.snp.makeConstraints { (make) in
			make.height.equalTo(44)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
			make.top.equalTo(topView.snp.bottom).offset(MARGIN)
		}
		phoneTextField.addSubview(phoneLabel)
		phoneLabel.snp.makeConstraints { (make) in
			make.centerY.equalTo(phoneTextField.snp.centerY)
			make.leading.equalTo(phoneTextField.snp.leading).offset(MARGIN)
			make.height.equalTo(21)
			make.width.equalTo(80)
		}
		
		view.addSubview(otpTextField)
		otpTextField.snp.makeConstraints { (make) in
			make.height.equalTo(44)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
			make.top.equalTo(phoneTextField.snp.bottom).offset(SEPARATE_LINE_WIDHT)
		}
		otpTextField.addSubview(otpLabel)
		otpLabel.snp.makeConstraints { (make) in
			make.centerY.equalTo(otpTextField.snp.centerY)
			make.leading.equalTo(otpTextField.snp.leading).offset(MARGIN)
			make.height.equalTo(21)
			make.width.equalTo(80)
		}
		
		view.insertSubview(lineView, aboveSubview: otpTextField)
		lineView.snp.makeConstraints { (make) in
			make.height.equalTo(SEPARATE_LINE_WIDHT)
			make.top.equalTo(phoneTextField.snp.bottom)
			make.leading.equalTo(otpTextField.snp.leading)
			make.trailing.equalTo(otpTextField.snp.trailing)
		}
		otpTextField.hide()
		lineView.hide()
		
		view.addSubview(conditionDetailButton)
		conditionDetailButton.snp.makeConstraints { (make) in
			make.height.equalTo(50)
			make.width.equalTo(120)
			make.top.equalTo(phoneTextField.snp.bottom).offset(MARGIN)
			make.centerX.equalTo(view.snp.centerX)
		}
		
		view.addSubview(loadingIndicator)
		loadingIndicator.snp.makeConstraints { (make) in
			make.center.equalTo(view.snp.center)
		}
	}
	
	func back() {
		dismiss(animated: true, completion: nil)
	}
	func next() {
		
	}
	
	@objc func sendOTP() {
		if Validation.tel(phoneTextField.text ?? "") {
			conditionDetailButton.isEnabled = false
			loadingIndicator.startAnimating()
			phoneNumber = phoneTextField.text!
			phoneTextField.isEnabled = false
			api.sendOtp(phoneNum: phoneTextField.text!, { (finished, response) in
				if finished {
					self.showOTPTextField()
				} else {
                    if Validation.anyIsString(Validation.anyIsDictionary(response!, with: "error"), with: "message")  != "" {
                        dropdownAlert.title(string.th_noti, message: Validation.anyIsString(Validation.anyIsDictionary(response!, with: "error"), with: "message"), backgroundColor: .errorRed, textColor: .white)
                    }else{
                        dropdownAlert.errorNTryAgain()
                    }
					self.phoneTextField.isEnabled = true
				}
				self.loadingIndicator.stopAnimating()
				self.conditionDetailButton.isEnabled = true
			})
		} else {
            dropdownAlert.title(string.th_error, message: string.th_requiredPhone, backgroundColor: .errorRed, textColor: .white)
		}
	}
	@objc func confirmOTP() {
		conditionDetailButton.isEnabled = false
		loadingIndicator.startAnimating()
		api.confirmOtp(otpTextField.text ?? "") { (finished, response) in
			self.loadingIndicator.stopAnimating()
			if finished {
				if Validation.anyIsBool(Validation.anyIsDictionary(Validation.anyIsDictionary(response!, with: "result"), with: "verify"), with: "phoneNumber") {
					self.updatePhoneNumber()
				} else {
					dropdownAlert.title(string.th_error, message: "OTP ไม่ถูกต้อง หรือ หมดเวลาทำรายการ", backgroundColor: .errorRed, textColor: .white)
					self.conditionDetailButton.isEnabled = true
				}
			} else {
				dropdownAlert.title(string.th_error, message: string.th_try_again, backgroundColor: .errorRed, textColor: .white)
				self.conditionDetailButton.isEnabled = true
			}
		}
	}
	func updatePhoneNumber() {
		self.loadingIndicator.startAnimating()
		self.api.updateAccount({ (finished, response) in
			self.loadingIndicator.stopAnimating()
			if finished {
				if self.beforeView == "signUp" {
					Utility.backToRootView()
				} else if self.beforeView == "menu" {
					self.back()
                    let confirmAlert = UIAlertController(title: "คุณยืนยันเบอร์โทรศัพท์นี้เรียบร้อย", message: nil, preferredStyle: UIAlertController.Style.alert)
					confirmAlert.addAction(UIAlertAction(title: string.th_ok, style: .default, handler: { (action) in
						self.back()
					}))
					Utility.getCurrentViewController().present(confirmAlert, animated: true, completion: nil)
				}
				return
			} else {
				self.updatePhoneNumber()
				return
			}
		}, value: ["phoneNumber": self.phoneNumber.phoneNumber()])
	}
	func showOTPTextField() {
		if otpTextField.isHidden {
			otpTextField.placeholder = " กรอก OTP ภายใน 30 นาที (\(Datetime().showTime( Datetime.getCurrentTimestamp() + UInt(30*60) )))"
			conditionDetailButton.setTitle("ยืนยันเบอร์", for: .normal)
			conditionDetailButton.removeTarget(self, action: nil, for: .allEvents)
			conditionDetailButton.addTarget(self, action: #selector(confirmOTP), for: .touchUpInside)
			UIView.animate(withDuration: 0.5, animations: {
				self.otpTextField.show()
				self.lineView.show()
				self.conditionDetailButton.snp.remakeConstraints { (make) in
					make.height.equalTo(50)
					make.width.equalTo(120)
					make.top.equalTo(self.otpTextField.snp.bottom).offset(MARGIN)
					make.centerX.equalTo(self.view.snp.centerX)
				}
			})
		}
	}
	// MARK: TextField Delegate
	@objc func textFieldDidChange(_ textField: UITextField) {
		
	}
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		// return NO to disallow editing.
		return true
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		// became first responder
	}
	
	func textFieldShouldEndEditing(_ textField: UITextField) -> (Bool) {
		// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
		return true
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
	}
	
	@available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
		// if implemented, called in place of textFieldDidEndEditing:
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		// return NO to not change text
		return true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		// called when 'return' key pressed. return NO to ignore.
		dismissKeyboard()
		return true
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
