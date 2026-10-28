//
//  LogInRegisViewModelFromModel.swift
//  ratchakan
//
//  Created by JJsobtid on 18/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit

class LogInRegisViewModelFromModel: NSObject, SignInViewModel, RegisterViewModel {
	
	fileprivate let login : LogInModel?
	fileprivate let register : RegisModel?
	
	var email: Dynamic<String>
	var password: Dynamic<String>
	var canNext: Dynamic<Bool>
	var state: Dynamic<logInState>
	
	var name: Dynamic<String>
	var surname: Dynamic<String>
	var gender: Dynamic<GENDER>
	var birthday: Dynamic<String>
	
	init(login: LogInModel) {
		self.login = login
		self.register = nil
		
		self.email = Dynamic(login.email)
		self.password = Dynamic(login.password)
		self.name = Dynamic(login.name)
		self.state = Dynamic(login.state)
		self.surname = Dynamic("")
		self.gender = Dynamic(.unknown)
		self.birthday = Dynamic("")
		self.canNext = Dynamic(login.canNext)
		
		super.init()
		self.subscribeToNotifications()
	}
	
	init(regis: RegisModel) {
		self.register = regis
		self.login = nil
		
		self.email = Dynamic(regis.email)
		self.password = Dynamic(regis.password)
		self.name = Dynamic(regis.name!)
		self.state = Dynamic(.register)
		self.surname = Dynamic(regis.surname!)
		self.gender = Dynamic(regis.gender!)
		self.birthday = Dynamic(regis.birthday!)
		self.canNext = Dynamic(regis.canRegis)
		
		super.init()
		self.subscribeToNotifications() 
	}
	
	deinit {
		unsubscribeFromNotifications()
	}
	
	fileprivate func subscribeToNotifications() {
//		NotificationCenter.default.addObserver(self,
//											   selector: #selector(gameScoreDidChangeNotification(_:)),
//											   name: NSNotification.Name(rawValue: GameNotifications.GameScoreDidChangeNotification),
//											   object: game)
	}
	
	fileprivate func unsubscribeFromNotifications() {
//		NotificationCenter.default.removeObserver(self)
	}

	fileprivate func setCanNext() {
		canNext.value = (login?.canNext)!
	}
	func setEmail(_ email: String = "") {
		login?.setEmail(email)
		setCanNext()
	}
	func setPassword(_ pass: String = "") {
		login?.setPassword(pass)
		setCanNext()
	}
	func setName(_ name: String) {
		login?.setName(name)
		setCanNext()
	}
	func stateChange(_ state: logInState) {
		login?.stateChange(state)
		self.state.value = login!.state
		setCanNext()
	}
	func logIn() {
		login?.logIn()
	}
    func loginWithApple(appleId: String, firstName: String, lastName: String, email: String, loading: LoadingLogViewController) {
        login?.loginWithApple(appleId: appleId, firstName: firstName, lastName: lastName, email: email, loading: loading)
    }
	func logInWithFB(token: String, loading: LoadingLogViewController) {
		login?.logInWithFB(token: token, loading: loading)
	}
	func resetPassword() {
		login?.resetPassword()
	}
	
	func skipLogIn() {
		login?.skipLogIn()
	}
	
	func checkUsername(_ textField: UITextField, inView view: UIView, indicator: UIActivityIndicatorView) {
		register?.checkDuplicateUser(textField, inView: view, indicator: indicator)
	}
	
	func regis() {
		if register?.email == "" {
			dropdownAlert.title(string.th_error, message: "กรุณากรอกอีเมลหรือเบอร์โทรศัพท์", backgroundColor: .brandcolor1, textColor: .white)
		} else if not(register!.validateEmail) {
			dropdownAlert.title(string.th_error, message: "อีเมลหรือเบอร์โทรศัพท์นี้มีในระบบแล้ว", backgroundColor: .brandcolor1, textColor: .white)
		} else if not(Validation.password((register?.password)!)) {
			dropdownAlert.title(string.th_error, message: "รหัสผ่านอย่างน้อย 8 ตัวอักษร", backgroundColor: .brandcolor1, textColor: .white)
		} else if register?.name == "" || register?.surname == "" {
			dropdownAlert.title(string.th_error, message: "กรุณากรอกชื่อหรือนามสกุลให้ครบถ้วน", backgroundColor: .brandcolor1, textColor: .white)
		} else {
			register?.regis()
		}
	}
	func setData(_ data: Any, fieldType: FieldType) {
		register?.setData(data, fieldType: fieldType)
		canNext.value = (register?.canRegis)!
	}

}
