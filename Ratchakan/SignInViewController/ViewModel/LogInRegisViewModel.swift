//
//  LogInRegisViewModel.swift
//  ratchakan
//
//  Created by JJsobtid on 18/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation
import UIKit

protocol SignInViewModel {
	var email : Dynamic<String> { get }
	var password : Dynamic<String> { get }
	var name: Dynamic<String> { get }
	var canNext : Dynamic<Bool> { get }
	var state : Dynamic<logInState> { get }
	
	func skipLogIn()
	func logIn()
    func loginWithApple(appleId: String, firstName: String, lastName: String, email: String, loading: LoadingLogViewController)
	func logInWithFB(token: String, loading: LoadingLogViewController)
	func resetPassword()
	func setEmail(_ email: String)
	func setPassword(_ pass: String)
	func setName(_ name: String)
	func stateChange(_ state: logInState)
}

protocol RegisterViewModel {
	var email : Dynamic<String> { get }
	var password : Dynamic<String> { get }
	var name : Dynamic<String> { get }
	var surname : Dynamic<String> { get }
	var gender : Dynamic<GENDER> { get }
	var birthday : Dynamic<String> { get }
	var canNext : Dynamic<Bool> { get }
	
	func regis()
	func setData(_ data: Any, fieldType: FieldType)
	func checkUsername(_ textField: UITextField, inView view: UIView, indicator: UIActivityIndicatorView)
}
