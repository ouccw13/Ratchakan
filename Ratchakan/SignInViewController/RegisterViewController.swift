//
//  RegisterViewController.swift
//  ratchakan
//
//  Created by FelisDJ on 12/13/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, CustomNavDelegate, CustomButtonClick, UITextFieldDelegate, PickerDateDelegate, GenderSelectDelegate {

	var regisViewModel: RegisterViewModel!
	
	var topView: CustomNav!
	var regisButton: CustomBottomButton!
	var formView: [UIView?] = []
	var textFields: [UITextField?] = []
	var conditionDetailButton: UIButton!
	var genderButton: [IconNLabelButton]!
	var indicatorUser: UIActivityIndicatorView!
	
	var datePicker: PickerView?
	var datePickerShow: Bool = false
	
	var nowTextField, genderTextField: UITextField?
	
	let formData = DataConfig.formRegis
	
	let nav: Nav = Nav(title: string.th_regis, isBack: true, isRight: false, color: UIColor.brandcolor1)
	let customButton: BottomButton = BottomButton(title: string.th_regis, color: .brandcolor1)
	let regis: RegisModel = RegisModel(email: "", password: "")
	
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
		
		topView = CustomNav(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TOP_VIEW))
		regisButton = CustomBottomButton(frame: CGRect(x:0, y:0, width: SCREEN_WIDTH, height: BOTTOM_BAR))

		genderButton = [IconNLabelButton(frame: CGRect()), IconNLabelButton(frame: CGRect())]
		genderButton[0].circleNText(string.th_male, withID: "male")
		genderButton[0].delegate = self
		genderButton[1].circleNText(string.th_female, withID: "female")
		genderButton[1].delegate = self
		
		createForm()
		conditionDetailButton = UIButton(frame: CGRect())
		conditionDetailButton.setTitle(string.th_condition, for: .normal)
		conditionDetailButton.setTitleColor(.guestcolor, for: .normal)
		conditionDetailButton.titleLabel?.font = .kanitReg12
		conditionDetailButton.titleLabel?.textAlignment = .right
		
		let conditionString = NSMutableAttributedString(string: string.th_condition)
		let textRange = NSMakeRange(0, 17)
        conditionString.addAttributes([.underlineStyle : NSUnderlineStyle.single.rawValue,
								 .underlineColor : UIColor.darkgraybg
								 ], range: textRange)
		
		conditionDetailButton.setAttributedTitle(conditionString, for: .normal)
		conditionDetailButton.addTarget(self, action: #selector(showCondition), for: .touchUpInside)
		
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
	fileprivate func createForm() {
		for row in formData {
			let key = row["key"] as! FieldType
			var placeholder = row["placeholder"] as! String
			if key != .gender && key != .birthday {
				placeholder = "\(placeholder)*"
			}
			let formview = UIView(frame: CGRect())
			formview.tag = key.rawValue
			
			let lineBottom = UIView()
			lineBottom.lineView()
			let iconImage = UIImageView(image: row["iconImage"] as? UIImage)
			iconImage.contentMode = .scaleAspectFit
			let textField = UITextField()
			textField.tag = key.rawValue
			textField.regisType(placeholder: placeholder, tag: key.rawValue , target: self, selector: #selector(textFieldDidChange(_:)))
			
			formview.addSubview(iconImage)
			formview.addSubview(textField)
			formview.addSubview(lineBottom)
			if key == .email {
				indicatorUser = UIActivityIndicatorView()
				indicatorUser.hidesWhenStopped = true
                indicatorUser.style = UIActivityIndicatorView.Style.medium
				indicatorUser.hide()
				formview.addSubview(indicatorUser)
				
				indicatorUser.snp.makeConstraints({ (make) in
					make.size.equalTo(CGSize(width: 20, height: 20))
					make.centerY.equalTo(formview.snp.centerY)
					make.trailing.equalTo(formview.snp.trailing).offset(-4)
				})
			}
			iconImage.snp.makeConstraints({ (make) in
				make.centerY.equalTo(formview.snp.centerY)
				make.height.equalTo(20)
				make.width.equalTo(20)
				make.leading.equalTo(formview.snp.leading).offset(4)
			})
			textField.snp.makeConstraints({ (make) in
				make.centerY.equalTo(formview.snp.centerY)
				make.height.equalTo(24)
				make.leading.equalTo(iconImage.snp.trailing).offset(20)
				make.trailing.equalTo(formview.snp.trailing).offset(-4)
			})
			lineBottom.snp.makeConstraints({ (make) in
				make.bottom.equalTo(formview.snp.bottom)
				make.height.equalTo(UNDERLINE_WIDHT)
				make.leading.equalTo(textField.snp.leading)
				make.trailing.equalTo(textField.snp.trailing)
			})
			
			if key == .email {
				textField.keyboardType = .emailAddress
			} else if key == .password {
				textField.regisType(placeholder: placeholder, isSecure: true, tag: key.rawValue, target: self, selector: #selector(textFieldDidChange(_:)))
			} else if key == .name {
                
			} else if key == .surname {
                
			} else if key == .gender {
				genderTextField = textField
				for button in genderButton {
					formview.addSubview(button)
					if button.identifier == "male" {
						button.snp.makeConstraints({ (make) in
							make.height.equalTo(24)
							make.width.equalTo(60)
							make.centerY.equalTo(formview.snp.centerY)
							make.trailing.equalTo(lineBottom.snp.trailing)
						})
					} else {
						button.snp.makeConstraints({ (make) in
							make.height.equalTo(24)
							make.width.equalTo(60)
							make.centerY.equalTo(formview.snp.centerY)
							make.trailing.equalTo(lineBottom.snp.trailing).offset(-80)
						})
					}
				}
			} else if key == .birthday {

			}
			textFields.append(textField)
			formView.append(formview)
		}
	}
	fileprivate func fillUI() {
		if !isViewLoaded {
			return
		}
		
		let navModel = CustomViewModelFromNav(withNav: self.nav)
		topView.viewModel = navModel
		topView.delegate = self
		
		let regisModel = CustomBottomButtonFromModel(withButton: customButton)
		regisButton.viewModel = regisModel
		regisButton.delegate = self
		regisButton.setColorButton(.darkgraybg, canTouch: true)
		
		self.view.addSubview(topView);
		topView.snp.makeConstraints { (make) in
			make.top.equalTo(0)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			make.height.equalTo(TOP_VIEW)
		}
		
		self.view.addSubview(regisButton)
		regisButton.snp.makeConstraints { (make) in
			make.bottom.equalTo(self.view.snp.bottom)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			make.height.equalTo(BOTTOM_BAR)
		}
		
		var beforeField: UIView!
		
		for fieldView in formView {
			view.addSubview(fieldView!)
			if formView.first! == fieldView {
				fieldView!.snp.makeConstraints { (make) in
					make.height.equalTo(42)
					if IS_IPHONE && !IS_IPHONE_6P {
						make.width.equalTo(SCREEN_WIDTH - (34*2))
					} else {
						make.width.equalTo(346)
					}
					make.centerX.equalTo(self.view.snp.centerX)
					make.top.equalTo(topView.snp.bottom).offset(MARGIN)
				}
			} else {
				fieldView!.snp.makeConstraints({ (make) in
					make.height.equalTo(42)
					make.leading.equalTo(beforeField.snp.leading)
					make.trailing.equalTo(beforeField.snp.trailing)
					make.top.equalTo(beforeField.snp.bottom).offset(MARGIN)
				})
			}
			beforeField = fieldView!
		}
		
		self.view.addSubview(conditionDetailButton)
		conditionDetailButton.snp.makeConstraints { (make) in
			make.height.equalTo(18)
			make.width.equalTo(120)
			if IS_IPHONE_4_OR_LESS {
				make.bottom.equalTo(regisButton.snp.top).offset(0.5)
			} else {
				make.top.equalTo(beforeField.snp.bottom).offset(-10)
			}
			make.trailing.equalTo(beforeField.snp.trailing).offset(6)
		}
		
		regisViewModel = LogInRegisViewModelFromModel(regis: regis)
		regisViewModel.canNext.bindAndFire { (canRegis) in
			if canRegis {
				self.regisButton.setColorButton(.brandcolor1, canTouch: true)
			} else {
				self.regisButton.setColorButton(.darkgraybg, canTouch: true)
			}
		}
	}
	
	func back() {
		dismiss(animated: true, completion: nil)
	}
	func next(tag: Int) {
		regisViewModel.regis()
	}
	
	@objc func showCondition() {
		let termViewController = TermOfServiceViewController()
        termViewController.modalTransitionStyle = .crossDissolve
        termViewController.modalPresentationStyle = .fullScreen
		present(termViewController, animated: true, completion: nil)
	}
	
	// MARK: TextField Delegate
	@objc func textFieldDidChange(_ textField: UITextField) {
		setInfo(textField, data: textField.text!)
	}
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		if datePickerShow && FieldType.from(textField.tag) != .birthday {
			datePicker?.removeFromSuperview()
			datePickerShow = !datePickerShow
			moveViewDown()
		}

		if FieldType.from(textField.tag) == .birthday {
			view.endEditing(true)
			nowTextField = textField
			
			if datePicker == nil {
				datePicker = PickerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: PICKER_HEIGHT))
				datePicker!.delegate = self
				datePicker!.type = .date
			}
			if !datePickerShow {
				datePickerShow = true
				let overlab = textField.overlabKeyboard(view, targetY: SCREEN_HEIGHT-PICKER_HEIGHT)
				checkOverlab(overlab)
				
				view.addSubview(datePicker!)
				datePicker!.snp.remakeConstraints({ (make) in
					make.leading.equalTo(view.snp.leading)
					make.trailing.equalTo(view.snp.trailing)
					make.bottom.equalTo(view.snp.bottom)
					make.height.equalTo(PICKER_HEIGHT)
				})
				view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height + overlab.1)
			}
			
			return false
		} else if FieldType.from(textField.tag) == .gender {
			view.endEditing(true)
			return false
		}
		
		let overlab = textField.overlabKeyboard(view)
		checkOverlab(overlab)
		return true
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		// became first responder
	}
	
	func textFieldShouldEndEditing(_ textField: UITextField) -> (Bool) {
		// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
		
		let view = formView[textField.tag]
		textField.underline(in: view!)
		if FieldType.from(textField.tag) == .email {
			regisViewModel.checkUsername(textField, inView: view!, indicator: indicatorUser)
		}
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
		setInfo(textField, data: textField.text!)
		if textField.tag == FieldType.surname.rawValue {
			dismissKeyboard()
		} else {
			textFields[textField.tag + 1]?.becomeFirstResponder()
		}
		// may be useful: textField.resignFirstResponder()
		return true
	}
	func setInfo(_ textField: UITextField, data: String) {
		regisViewModel.setData(data, fieldType: FieldType.from(textField.tag))
	}
	
	func setBirthDay(_ birthday: String) {
		datePickerShow = false
		moveViewDown()
		nowTextField?.text = Datetime().birthDate(birthday)
		regisViewModel.setData(birthday, fieldType: .birthday)
	}
	
	func cancel() {
		datePickerShow = false
		moveViewDown()
	}
	
	func select(gender: String) {
		regisViewModel.setData(gender, fieldType: .gender)
		genderTextField!.text = string.th_gender
		view.endEditing(true)
		for button in genderButton {
			if button.identifier != gender {
				button.didUnselectedGender()
			}
		}
	}
	
	func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		return datePicker!
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
