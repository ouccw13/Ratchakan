//
//  LogInRegisModel.swift
//  ratchakan
//
//  Created by JJsobtid on 18/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation
import UIKit

enum GENDER: String {
	case male = "male"
	case female = "female"
	case unknown = ""
}

enum FieldType: Int {
	case email
	case password
	case name
	case surname
	case gender
	case birthday
	case unknow
	
	static func from(_ hashValue: Int) -> FieldType {
		switch hashValue {
		case 0:
			return .email
		case 1:
			return .password
		case 2:
			return .name
		case 3:
			return .surname
		case 4:
			return .gender
		case 5:
			return .birthday
		default:
			return .unknow
		}
	}
}

enum logInState {
	case login
	case forgotpass
	case register
}

class LogInModel: NSObject {
	
	var api: API = API(withoutdb: true)
	
	var state: logInState
	var email, password, name: String
	var facebookToken: String = ""
	var canNext: Bool = false
	
	init(email: String, password: String) {
		self.email = email
		self.password = password
		name = ""
		state = .login
	}
	
	func logIn() {
		let loading = LoadingLogViewController()
        loading.modalPresentationStyle = .fullScreen
		Utility.getCurrentViewController().present(loading, animated: true, completion: {
			loading.loadingAnimation.play()
		})
		if state == .login {
			api.logIn({ (finished, responsed) in
				if finished {
                    guard let result = responsed?["result"] as? [String:Any] else {
                        return
                    }
                    let memberDefaultData = MemberDefaultData.storeObserverSharedInstance
                    memberDefaultData.set(type: .displayName, data: result["displayName"] as? String ?? "")
                    memberDefaultData.set(type: .memberId, data: result["memberId"] as? String ?? "")
                    memberDefaultData.set(type: .sessionId, data: result["sessionId"] as? String ?? "")
                    memberDefaultData.set(type: .token, data: result["token"] as? String ?? "")
					loading.resultText = "เข้าสู่ระบบสำเร็จ"
				} else {
					let message = Validation.anyIsString(Validation.anyIsDictionary(responsed!, with: "error"), with: "description")
					if message == "Username or password incorrectly" {
						loading.resultText = "\(string.th_id) หรือ รหัสผ่าน ไม่ถูกต้อง"
					} else {
						loading.resultText = string.th_try_again
					}
				}
				loading.result = finished
			}, parameter: ["email" : self.email.lowercased().trimSpace(),
						   "password" : self.password.genPassword()])
		} else if state == .register {
			api.registerMember({ (finished, responsed) in
				loading.resultText = ""
				if finished {
					loading.resultText = "สมัครสมาชิกสำเร็จ"
					if Validation.tel(self.email.trimSpace()) {
						loading.phoneNum = self.email.trimSpace()
					}
				} else {
					let message = Validation.anyIsString(Validation.anyIsDictionary(responsed!, with: "error"), with: "description")
					if message == "Username or password incorrectly" {
						loading.resultText = "\(string.th_id) หรือ รหัสผ่าน ไม่ถูกต้อง"
					} else if message == "The email address is already in use by another account." || message == "The user with the provided phone number already exists." {
						loading.resultText = "มี \(string.th_id) อยู่ในระบบแล้ว"
					} else if message == "surname is required" {
						loading.resultText = "กรุณากรอกนามสกุล"
					} else {
						loading.resultText = string.th_try_again
					}
				}
				loading.result = finished
			}, parameter: ["username" : email.lowercased().trimSpace(),
						   "password" : password.genPassword(),
						   "name" : name.trimSpace()])
		}
	}
    func loginWithApple(appleId: String, firstName: String, lastName: String, email: String, loading: LoadingLogViewController) {
        api.logIn({ (finished, responsed) in
            if finished {
                loading.resultText = "เข้าสู่ระบบสำเร็จ"
            } else {
                loading.resultText = Validation.anyIsString(Validation.anyIsDictionary(responsed!, with: "error"), with: "message")
            }
            loading.result = finished
        }, parameter: [ "email" : email,
                        "password" : "",
                        "appleId" : appleId ,
                        "firstName" : firstName,
                        "lastName" : lastName ], isApple: true)
    }
	func logInWithFB(token: String, loading: LoadingLogViewController) {
		api.logIn({ (finished, responsed) in
			if finished {
				loading.resultText = "เข้าสู่ระบบสำเร็จ"
			} else {
				loading.resultText = Validation.anyIsString(Validation.anyIsDictionary(responsed!, with: "error"), with: "message")
			}
			loading.result = finished
		}, parameter: ["email" : "",
					   "password" : "",
					   "accessToken" : token], isFacebook: true)
	}
	func resetPassword() {
		api.resetPassword({ (finished, response) in
			if finished {
				Utility.showAlert(title: "ทำรายการสำเร็จ", detail: "รหัสผ่านใหม่ถูกส่งไปที่ \(string.th_id) แล้ว")
			} else {
				Utility.showAlert(title: Validation.anyIsString(Validation.anyIsDictionary(response!, with: "error"), with: "message"), detail: "กรุณากรอกข้อมูลให้ถูกต้องและลองใหม่อีกครั้ง")
			}
		}, username: email.trimSpace())
	}
	func skipLogIn() {
		api.db?.memberLoginAsGuest()
	}
	
	func setEmail(_ email: String) {
		self.email = email
		checkData()
	}
	
	func setPassword(_ password: String) {
		self.password = password
		checkData()
	}
	
	func setName(_ name: String) {
		self.name = name
		checkData()
	}
	
	func stateChange(_ state: logInState) {
		self.state = state
		checkData()
	}
	
	fileprivate func checkData() {
		if (Validation.email(email.trimSpace()) || Validation.tel(email.trimSpace())) && Validation.password(password) {
			if state == .login {
				canNext = true
			} else if state == .register && name != "" {
				canNext = true
			} else {
				canNext = false
			}
		} else {
			canNext = false
		}
	}
}

class RegisModel: NSObject {
	var api: API = API()
	
	var email: String
	var password: String
	var name: String?
	var surname: String?
	var gender: GENDER?
	var birthday: String?
	
	var canRegis: Bool = false
	var validateEmail: Bool = false
	
	init(email: String, password: String) {
		self.email = email
		self.password = password
		self.name = ""
		self.surname = ""
		self.gender = .male
		self.birthday = ""
	}
	
	func regis() {
		let loading = LoadingLogViewController()
        loading.modalPresentationStyle = .fullScreen
		Utility.getCurrentViewController().present(loading, animated: true, completion: {
			loading.loadingAnimation.play()
		})
		api.registerMember({ (finished, response) in
			loading.result = finished
			if finished {
				if Validation.tel(self.email.trimSpace()) {
					loading.phoneNum = self.email.trimSpace()
				}
			} else {

			}
		}, parameter: ["username" : email.lowercased().trimSpace(),
					   "password" : password.genPassword(),
					   "name" : name!,
					   "surname" : surname!,
					   "gender" : gender!.rawValue,
					   "birthdate" : birthday!])
	}
	
	func checkDuplicateUser(_ textField: UITextField, inView view: UIView, indicator: UIActivityIndicatorView) {
		if not(Validation.email(email.lowercased().trimSpace())) && not(Validation.tel(email.lowercased().trimSpace())) {
			textField.underline(in: view, error: true, color: .greenendexam)
		} else {
			indicator.show()
			indicator.startAnimating()
			api.checkDuplicateUsername({ (finished, _) in
				indicator.stopAnimating()
				self.validateEmail = finished
				textField.underline(in: view, error: not(finished), color: .greenendexam)
				if not(finished) {
					dropdownAlert.title(string.th_error, message: "มีผู้ใช้งานนี้อยู่ในระบบ", backgroundColor: .errorRed, textColor: .white)
				}
			}, username: email.lowercased().trimSpace())
		}
	}
	
	func setData(_ data: Any, fieldType: FieldType) {
		if fieldType == .email {
			email = data as! String
		} else if fieldType == .password {
			password = data as! String
		} else if fieldType == .name {
			name = data as? String
		} else if fieldType == .surname {
			surname = data as? String
		} else if fieldType == .gender {
			if data as! String == "male" {
				gender = .male
			} else if data as! String == "female" {
				gender = .female
			} else {
				gender = .unknown
			}
		} else if fieldType == .birthday {
			birthday = data as? String
		}
		checkData()
	}
	
	func checkData() {
		if email != "" && validateEmail && Validation.password(password) && name != "" && surname != "" {
			canRegis = true
		} else {
			canRegis = false
		}
	}
}
