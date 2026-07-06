//
//  SignInViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 12/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import AuthenticationServices

enum textFieldType: Int {
	case email
	case pass
	case name
}

class SignInViewController: UIViewController, UITextFieldDelegate {
	
	var loginViewModel: SignInViewModel!
	
	var disableColor = UIColor(red: 250/255, green: 207/255, blue: 215/255, alpha: 1.0)
	
	var logoImage: UIImageView!
	
	var idView: UIView!
	var emailImage: UIImageView!
	var emailField: UITextField!
	var emailLine: UIView!
	
	var orLabel: UILabel!
	var linearLine: UIView!
	
	var passView: UIView!
	var passImage: UIImageView!
	var passField: UITextField!
    var showPassButton: UIButton!
	var passLine: UIView!
	var forgotPassButton: UIButton!
	
	var nameView: UIView!
	var nameField: UITextField!
	var conditionButton: UIButton!
	
	var signInButton: UIButton!

	var reNewPassButton: UIButton!
	var cancelButton: UIButton!
	
	var loginAppleButton: UIButton!
	
	var skipButton, conditionDetailButton,privacyDetailButton: UIButton!
	
	var loginFacebookButton: UIButton!

	var bottomView: UIView!
    
    var registerLabel: UILabel!
    
    var registerButton: UIButton!
    
    var registerStack: UIStackView!
    
    override var shouldAutorotate: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .all // Allow all orientations for iPad
        } else {
            return .portrait // Restrict to portrait for iPhone
        }
    }
	
	var login: LogInModel = LogInModel(email: "", password: "")
    var emailApple: String = ""
    var firstNameApple: String = ""
    var lastNameApple: String = ""
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.hideKeyboardWhenTappedAround()
        self.moveViewWhenKeyboradAppear()
		view.backgroundColor = .white
		
		logoImage = UIImageView(frame: CGRect())
		logoImage.image = #imageLiteral(resourceName: "logo")
		
		idView = UIView()
		idView.backgroundColor = .white
		idView.borderView(color: .darkgraybg, width: 1.0)
		idView.cornerView(radius: HEIGHT_ROUND_BUTTON/2)
		emailField = UITextField()
		emailField.regisType(placeholder: string.th_id, tag: textFieldType.email.rawValue, target: self, selector: #selector(textFieldDidChange(_:)))
        emailField.autocapitalizationType = .none
        emailField.spellCheckingType = .no
		emailField.keyboardType = .emailAddress
		emailField.returnKeyType = .done

		passView = UIView()
		passView.backgroundColor = .white
		passView.borderView(color: .darkgraybg, width: 1.0)
		passView.cornerView(radius: HEIGHT_ROUND_BUTTON/2)
		passField = UITextField()
		passField.regisType(placeholder: string.th_password, isSecure: true, tag: textFieldType.pass.rawValue, target: self, selector: #selector(textFieldDidChange(_:)))
		passField.returnKeyType = .done
		forgotPassButton = UIButton()
		forgotPassButton.setParameter(string.th_forgot_password, textColor: .brandcolor3_dark, font: .kanitLight12, backgroundColor: .clear)
		forgotPassButton.addTarget(self, action: #selector(forgotPassAction(_:)), for: .touchUpInside)
        
        // - button show/hide Password
        showPassButton = UIButton()
        showPassButton.setImage(UIImage(named: "iconEyeClose"), for: .normal)
        showPassButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        
        
		if #available(iOS 10.0, *) {
            emailField.textContentType = .emailAddress
		} else {
            emailField.textContentType = .username
            passField.textContentType = .password
        }
	
		nameView = UIView()
		nameView.backgroundColor = .white
		nameView.borderView(color: .darkgraybg, width: 1.0)
		nameView.cornerView(radius: HEIGHT_ROUND_BUTTON/2)
		nameField = UITextField()
		nameField.returnKeyType = .go
		nameField.regisType(placeholder: "ชื่อ นามสกุล (ภาษาไทย)", isSecure: false, tag: textFieldType.name.rawValue, target: self, selector: #selector(textFieldDidChange(_:)))
		nameView.alpha = 0
		nameView.isHidden = true
		
		signInButton = UIButton(frame: CGRect(x:0 ,y:0, width:100, height:HEIGHT_ROUND_BUTTON))
		signInButton.setParameter(string.th_login, textColor: .white, font: .kanitReg16, backgroundColor: disableColor)
		signInButton.addTarget(self, action: #selector(signInAction(_:)), for: .touchUpInside)
		signInButton.roundButton()
		signInButton.disableButton(canTouch: true, withColor: disableColor)
		
		orLabel = UILabel()
		orLabel.setParameter(font: .kanitLight16, color: .darkgraybg, alignment: .center)
		orLabel.text = "หรือ"
		orLabel.backgroundColor = view.backgroundColor
		linearLine = UIView()
		linearLine.backgroundColor = .darkgraybg
		
		skipButton = UIButton(frame: CGRect())
		skipButton.setTitle(string.th_skip_login, for: .normal)
		skipButton.titleLabel?.font = UIFont.kanitReg14
		skipButton.setTitleColor(.brandcolor3_dark, for: .normal)
		skipButton.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
        skipButton.isUserInteractionEnabled = false
		
		conditionDetailButton = UIButton(frame: CGRect())
		conditionDetailButton.setParameter(string.th_condition, textColor: .Celllabel, font: .kanitLight12, backgroundColor: .clearCanTouch)
		conditionDetailButton.alpha = 0
		conditionDetailButton.isHidden = true
		conditionDetailButton.addTarget(self, action: #selector(showCondition), for: .touchUpInside)
        
        privacyDetailButton = UIButton(frame: CGRect())
        privacyDetailButton.setParameter(string.th_privacy, textColor: .Celllabel, font: .kanitLight12, backgroundColor: .clearCanTouch)
        privacyDetailButton.alpha = 0
        privacyDetailButton.isHidden = true
        privacyDetailButton.addTarget(self, action: #selector(showPrivacy), for: .touchUpInside)
		
		loginFacebookButton = UIButton(frame: CGRect())
		loginFacebookButton.cornerView(radius: 54/2)
		loginFacebookButton.backgroundColor = .facebook
		loginFacebookButton.setImage(UIImage(named: "signWithFacebook"), for: .normal)
		loginFacebookButton.addTarget(self, action: #selector(facebookAction(_:)), for: .touchUpInside)
        loginFacebookButton.adjustsImageWhenHighlighted = false
		
		cancelButton = UIButton(frame: CGRect(x:0 ,y:0, width:100, height: HEIGHT_ROUND_BUTTON))
		cancelButton.setTitle(string.th_cancel, for: .normal)
		cancelButton.setTitleColor(.white, for: .normal)
		cancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
		cancelButton.roundButton()
		cancelButton.backgroundColor = .darkgraybg
		cancelButton.alpha = 0
		cancelButton.isHidden = true
		
		reNewPassButton = UIButton(frame: CGRect(x:0 ,y:0, width:100, height: HEIGHT_ROUND_BUTTON))
		reNewPassButton.setTitle(string.th_renew_pass, for: .normal)
		reNewPassButton.setTitleColor(.white, for: .normal)
		reNewPassButton.addTarget(self, action: #selector(newPassAction(_:)), for: .touchUpInside)
		reNewPassButton.roundButton()
		reNewPassButton.backgroundColor = .brandcolor1
		reNewPassButton.alpha = 0
		reNewPassButton.isHidden = true
		
		loginAppleButton = UIButton()
        loginAppleButton.backgroundColor = .black
        loginAppleButton.setImage(UIImage(named: "signWithApple"), for: .normal)
        loginAppleButton.adjustsImageWhenHighlighted = false
		loginAppleButton.cornerView(radius: 54/2)
        if #available(iOS 13.0, *) {
            loginAppleButton.addTarget(self, action: #selector(appleAction(_:)), for: .touchUpInside)
        }

        loginAppleButton.isHidden = true
        if #available(iOS 13.0, *) {
            loginAppleButton.isHidden = false
        }
        
        registerLabel = UILabel()
        registerLabel.text = "ยังไม่ได้เป็นสมาชิก?"
        registerLabel.font = .kanitReg14
        registerLabel.textColor = .Celllabel
        
        registerButton = UIButton()
        registerButton.setParameter("สมัครสมาชิก", textColor: .brandcolor1, font: .kanitReg14, backgroundColor: .clear)
        
		registerStack = UIStackView()
        registerStack.addArrangedSubview(registerLabel)
        registerStack.addArrangedSubview(registerButton)
        registerStack.axis = .horizontal
        registerStack.alignment = .center
        registerStack.spacing = 9
        
        registerButton.addTarget(self, action: #selector(regisAction(_:)), for: .touchUpInside)
        
		fillUI()
    }
    
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		Utility.statusBar(color: .clear)
		setLandscapeForiPad()
	}
    
    func setLandscapeForiPad() {
        guard UIDevice.current.userInterfaceIdiom == .pad else { return }
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] (context) in
            guard let self = self else { return }
            if UIDevice.current.orientation.isLandscape {
                print("Landscape")
                self.logoImage.snp.remakeConstraints { (make) in
                    make.width.equalTo(42)
                    make.height.equalTo(76)
                    make.centerX.equalTo(self.view.snp.centerX)
                    make.bottom.equalTo(self.view.snp.top).offset(SCREEN_HEIGHT/5)
                }
            }else{
                print("Portrait")
                self.logoImage.snp.remakeConstraints { (make) in
                    make.width.equalTo(42)
                    make.height.equalTo(76)
                    make.centerX.equalTo(self.view.snp.centerX)
                    make.bottom.equalTo(self.view.snp.top).offset(SCREEN_HEIGHT/5)
                }
            }
        }, completion: nil)
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func showPassword(_ sender: UIButton) {
        passField.isSecureTextEntry = !passField.isSecureTextEntry
        if passField.isSecureTextEntry {
            showPassButton.setImage(UIImage(named: "iconEyeClose"), for: .normal)
        } else {
            showPassButton.setImage(UIImage(named: "iconEyeOpen")?.withTintColor(.brandcolor1, renderingMode: .alwaysOriginal), for: .normal)
        }
    }
	
	@objc func skipAction(_ sender: Any) {
		if loginViewModel.state.value == .register {
			passField.isSecureTextEntry = true
			passField.returnKeyType = .go
			loginViewModel.stateChange(.login)
			passField.placeholder = string.th_password
			signInButton.setTitle(string.th_login, for: .normal)
            skipButton.isUserInteractionEnabled = false
			skipButton.setTitle(string.th_skip_login, for: .normal)
			forgotPassButton.setTitle(string.th_forgot_password, for: .normal)
            forgotPassButton.isHidden = false
            showPassButton.isHidden = false
			orLabel.isHidden = false
			linearLine.isHidden = false
			loginFacebookButton.isHidden = false
            if #available(iOS 13.0, *) {
                loginAppleButton.isHidden = false
            }
            registerStack.isHidden = false
            passView.snp.remakeConstraints { (make) in
                make.height.equalTo(idView.snp.height)
                make.leading.equalTo(idView.snp.leading)
                make.trailing.equalTo(idView.snp.trailing)
                make.top.equalTo(idView.snp.bottom).offset(MARGIN)
            }

			signInButton.snp.remakeConstraints ({ (make) in
                make.top.equalTo(forgotPassButton.snp.bottom).offset(MARGIN)
				make.height.equalTo(HEIGHT_ROUND_BUTTON)
				make.leading.equalTo(idView.snp.leading)
				make.trailing.equalTo(idView.snp.trailing)
			})
            forgotPassButton.snp.remakeConstraints { (make) in
				make.height.equalTo(21)
				make.width.equalTo(70)
                make.top.equalTo(passView.snp.bottom).offset(MARGIN)
				make.trailing.equalTo(passView.snp.trailing)
			}
            showPassButton.snp.remakeConstraints { (make) in
                make.height.equalTo(31)
                make.width.equalTo(70)
                make.centerY.equalTo(passView.snp.centerY)
                make.trailing.equalTo(passView.snp.trailing)
            }
            
			UIView.animate(withDuration: 0.2, animations: {
				self.nameView.alpha = 0
				self.conditionDetailButton.alpha = 0
                self.privacyDetailButton.alpha = 0
				self.orLabel.alpha = 1
				self.linearLine.alpha = 1
				self.loginFacebookButton.alpha = 1
                if #available(iOS 13.0, *) {
                    self.loginAppleButton.alpha = 1
                }
                self.registerStack.alpha = 1
				self.view.layoutIfNeeded()
			}) { (true) in
				self.nameView.isHidden = true
				self.conditionDetailButton.isHidden = true
                self.privacyDetailButton.isHidden = true
			}
			
		} else {
			loginViewModel.skipLogIn()
			Utility.backToRootView()
		}
	}
	
	@objc func regisAction(_ sender: Any) {
		loginViewModel.stateChange(.register)
		signInButton.setTitle(string.th_regis, for: .normal)
		passField.placeholder = "รหัสผ่านอย่างน้อย 8 ตัวอักษร"
		passField.returnKeyType = .done
        skipButton.isUserInteractionEnabled = true
		skipButton.setTitle("ย้อนกลับ", for: .normal)
		forgotPassButton.setTitle("แสดง", for: .normal)
        showPassButton.isHidden = true
		conditionDetailButton.isHidden = false
        privacyDetailButton.isHidden = false
        
		nameView.isHidden = false
		signInButton.snp.remakeConstraints({ (make) in
			make.top.equalTo(nameView.snp.bottom).offset(MARGIN)
			make.height.equalTo(HEIGHT_ROUND_BUTTON)
			make.leading.equalTo(idView.snp.leading)
			make.trailing.equalTo(idView.snp.trailing)
		})
		forgotPassButton.snp.remakeConstraints { (make) in
			make.height.equalTo(21)
			make.width.equalTo(35)
			make.centerY.equalTo(passView.snp.centerY)
			make.trailing.equalTo(passView.snp.trailing).offset(-MARGIN)
		}
		UIView.animate(withDuration: 0.2, animations: {
			self.nameView.alpha = 1
			self.conditionDetailButton.alpha = 1
            self.privacyDetailButton.alpha = 1
			self.orLabel.alpha = 0
			self.linearLine.alpha = 0
			self.loginFacebookButton.alpha = 0
            if #available(iOS 13.0, *) {
                self.loginAppleButton.alpha = 0
            }
            self.registerStack.alpha = 0
			self.view.layoutIfNeeded()
		}) { (true) in
			self.orLabel.isHidden = true
			self.linearLine.isHidden = true
			self.loginFacebookButton.isHidden = true
            if #available(iOS 13.0, *) {
                self.loginAppleButton.isHidden = true
            }
            self.registerStack.isHidden = true
		}
	}
	
	@objc func showCondition() {
		let termViewController = TermOfServiceViewController()
        termViewController.isMenu = false
        termViewController.modalTransitionStyle = .crossDissolve
        termViewController.modalPresentationStyle = .fullScreen
		present(termViewController, animated: true, completion: nil)
	}
    
    @objc func showPrivacy() {
        let privacyViewController = PrivacyOfPoliciesViewController()
        privacyViewController.isMenu = false
        privacyViewController.modalTransitionStyle = .crossDissolve
        privacyViewController.modalPresentationStyle = .fullScreen
        present(privacyViewController, animated: true, completion: nil)
    }
	
	@objc func signInAction(_ sender: Any) {
		loginViewModel.logIn()
	}
    
    @available(iOS 13.0, *)
    @objc func appleAction(_ sender: Any) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

	@objc func facebookAction(_ sender: Any) {
		let loading = LoadingLogViewController()
        loading.modalPresentationStyle = .fullScreen
		Utility.getCurrentViewController().present(loading, animated: true, completion: {
			loading.loadingAnimation.play()
		})
		let loginManager = LoginManager()
		loginManager.logOut()
		loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (loginResult, err) in
			if err != nil {
				loading.result = false
				return
			} else if (loginResult?.isCancelled)! {
				loading.result = false
				return
			} else {
				self.loginViewModel.logInWithFB(token: loginResult!.token!.tokenString, loading: loading)
			}
		}
	}
	
	@objc func forgotPassAction(_ sender: Any) {
		if loginViewModel.state.value == .login {
			self.reNewPassButton.isHidden = false
			self.cancelButton.isHidden = false
			UIView.animate(withDuration: 0.2, animations: {
				self.reNewPassButton.alpha = 1
				self.cancelButton.alpha = 1
				self.signInButton.alpha = 0
				self.passView.alpha = 0
                if #available(iOS 13.0, *) {
                    self.loginAppleButton.alpha = 0
                }
				self.loginFacebookButton.alpha = 0
				self.orLabel.alpha = 0
				self.linearLine.alpha = 0
                self.registerStack.alpha = 0
			}) { (true) in
				self.signInButton.isHidden = true
                self.forgotPassButton.isHidden = true
				self.passView.isHidden = true
				if #available(iOS 13.0, *) {
                    self.loginAppleButton.isHidden = true
                }
				self.loginFacebookButton.isHidden = true
				self.orLabel.isHidden = true
				self.linearLine.isHidden = true
                self.registerStack.isHidden = true
			}
		} else if loginViewModel.state.value == .register {
            self.forgotPassButton.isHidden = false
			passField.isSecureTextEntry = not(passField.isSecureTextEntry)
			var forgotText = "ซ่อน"
			if passField.isSecureTextEntry {
				forgotText = "แสดง"
			}
			forgotPassButton.setTitle(forgotText, for: .normal)
		}
	}
	
	@objc func cancelAction(_ sender: Any) {
		self.signInButton.isHidden = false
        self.forgotPassButton.isHidden = false
		self.passView.isHidden = false
		if #available(iOS 13.0, *) {
            self.loginAppleButton.isHidden = false
        }
		self.loginFacebookButton.isHidden = false
		self.orLabel.isHidden = false
		self.linearLine.isHidden = false
        self.registerStack.isHidden = false
		UIView.animate(withDuration: 0.2, animations: {
			self.reNewPassButton.alpha = 0
			self.cancelButton.alpha = 0
			self.signInButton.alpha = 1
			self.passView.alpha = 1
            self.forgotPassButton.alpha = 1
            if #available(iOS 13.0, *) {
                self.loginAppleButton.alpha = 1
            }
			self.loginFacebookButton.alpha = 1
			self.orLabel.alpha = 1
			self.linearLine.alpha = 1
            self.registerStack.alpha = 1
		}) { (true) in
			self.reNewPassButton.isHidden = true
			self.cancelButton.isHidden = true
		}
	}
	
	@objc func newPassAction(_ sender: Any) {
        if Validation.email(emailField.text ?? "") == true || Validation.tel(emailField.text ?? "") == true {
            loginViewModel.resetPassword()
        }else{
            Utility.showAlert(title: "เกิดข้อผิดพลาด", detail: "กรุณากรอก อีเมล หรือ เบอร์โทรศัพท์")
        }
	}
    
	
	@objc fileprivate func moveTopView() {
		if not(IS_IPAD) {
			let space = HAVE_NOTCH ? 2*MARGIN : MARGIN
			self.logoImage.snp.remakeConstraints { (make) in
				make.width.equalTo(42)
				make.height.equalTo(76)
				make.centerX.equalTo(self.view.snp.centerX)
				make.top.equalTo(self.view.snp.top).offset(MARGIN)
			}
			self.idView.snp.remakeConstraints { (make) in
				make.height.equalTo(HEIGHT_ROUND_BUTTON)
				if IS_IPHONE && !IS_IPHONE_6P {
					make.width.equalTo(SCREEN_WIDTH - (34*2))
				} else {
					make.width.equalTo(346)
				}
				make.centerX.equalTo(self.view.snp.centerX)
				make.top.equalTo(self.logoImage.snp.bottom).offset(space)
			}
			UIView.animate(withDuration: 0.25) {
				self.view.layoutIfNeeded()
			}
		}
	}
	
	@objc fileprivate func setDefaultTopView() {
		let height = SCREEN_HEIGHT/5
		let spaceTop = height - (144/2) - (2*MARGIN)
		
		self.logoImage.snp.remakeConstraints { (make) in
			make.width.equalTo(42)
			make.height.equalTo(76)
			make.centerX.equalTo(self.view.snp.centerX)
			make.bottom.equalTo(self.view.snp.top).offset(height)
		}
		self.idView.snp.remakeConstraints { (make) in
			make.height.equalTo(HEIGHT_ROUND_BUTTON)
			if IS_IPHONE && !IS_IPHONE_6P {
				make.width.equalTo(SCREEN_WIDTH - (34*2))
			} else {
				make.width.equalTo(346)
			}
			make.centerX.equalTo(self.view.snp.centerX)
			make.top.equalTo(self.logoImage.snp.bottom).offset(spaceTop)
		}
		UIView.animate(withDuration: 0.25) {
			self.view.layoutIfNeeded()
		}
	}
	
	fileprivate func fillUI() {
		if !isViewLoaded {
			return
		}
		
		view.addsubviews([linearLine, orLabel])
		self.view.addSubview(idView)
		
		self.view.addSubview(logoImage)
		setDefaultTopView()

		idView.addSubview(emailField)
		emailField.snp.makeConstraints { (make) in
			make.height.equalTo(24)
			make.centerY.equalTo(idView.snp.centerY)
			make.leading.equalTo(idView.snp.leading).offset(2*MARGIN)
			make.trailing.equalTo(idView.snp.trailing).offset(-2*MARGIN)
		}
		
		view.addSubview(passView)
		passView.snp.makeConstraints { (make) in
			make.height.equalTo(idView.snp.height)
			make.leading.equalTo(idView.snp.leading)
			make.trailing.equalTo(idView.snp.trailing)
			make.top.equalTo(idView.snp.bottom).offset(MARGIN)
		}

		passView.addSubview(passField)
		passField.snp.makeConstraints { (make) in
			make.height.equalTo(24)
			make.centerY.equalTo(passView.snp.centerY)
			make.leading.equalTo(emailField.snp.leading)
			make.trailing.equalTo(emailField.snp.trailing)
		}

		passView.addSubview(showPassButton)
        showPassButton.snp.remakeConstraints { (make) in
            make.height.equalTo(31)
            make.width.equalTo(70)
            make.centerY.equalTo(passView.snp.centerY)
            make.trailing.equalTo(passView.snp.trailing)
        }
		view.addSubview(nameView)
		nameView.snp.makeConstraints { (make) in
			make.height.equalTo(idView.snp.height)
			make.leading.equalTo(idView.snp.leading)
			make.trailing.equalTo(idView.snp.trailing)
			make.top.equalTo(passView.snp.bottom).offset(MARGIN)
		}
		
		nameView.addSubview(nameField)
		nameField.snp.makeConstraints { (make) in
			make.height.equalTo(24)
			make.centerY.equalTo(nameView.snp.centerY)
			make.leading.equalTo(emailField.snp.leading)
			make.trailing.equalTo(emailField.snp.trailing)
		}
        view.addSubview(forgotPassButton)
		view.addSubview(signInButton)
        forgotPassButton.snp.makeConstraints { (make) in
            make.height.equalTo(21)
            make.width.equalTo(70)
            make.top.equalTo(passView.snp.bottom).offset(13)
            make.trailing.equalTo(passView.snp.trailing)
        }
		signInButton.snp.makeConstraints { (make) in
			make.height.equalTo(HEIGHT_ROUND_BUTTON)
			make.leading.equalTo(idView.snp.leading)
			make.trailing.equalTo(idView.snp.trailing)
            make.top.equalTo(forgotPassButton.snp.bottom).offset(MARGIN)
		}
		
		linearLine.snp.makeConstraints { (make) in
			make.top.equalTo(signInButton.snp.bottom).offset(36)
			make.leading.equalTo(signInButton.snp.leading)
			make.height.equalTo(1.5)
			make.trailing.equalTo(signInButton.snp.trailing)
		}
		orLabel.snp.makeConstraints { (make) in
			make.center.equalTo(linearLine.snp.center)
			make.width.equalTo(84)
			make.height.equalTo(24)
		}

        self.view.addSubview(loginAppleButton)
        loginAppleButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(signInButton.snp.centerX).offset(-SMALLINSET)
            make.size.equalTo(54)
            make.top.equalTo(linearLine.snp.bottom).offset(36)
        }
        
        
        self.view.addSubview(loginFacebookButton)
        loginFacebookButton.snp.makeConstraints { (make) in
            if #available(iOS 13.0, *) {
                make.leading.equalTo(signInButton.snp.centerX).offset(SMALLINSET)
            } else {
                make.centerX.equalTo(signInButton.snp.centerX)
            }
            make.size.equalTo(54)
            make.top.equalTo(linearLine.snp.bottom).offset(36)
        }
        
		
		self.view.addSubview(skipButton)
		skipButton.snp.makeConstraints { (make) in
			make.height.equalTo(21)
			make.width.equalTo(85)
			if IS_IPHONE_4_OR_LESS {
				make.bottom.equalTo(view.snp.bottom).offset(-BOTTOM_INSET-SMALLINSET)
			} else {
				make.bottom.equalTo(view.snp.bottom).offset(-BOTTOM_INSET-2*MARGIN)
			}
			make.centerX.equalTo(self.view.snp.centerX)
		}
        
        self.view.addSubview(registerStack)
        registerStack.snp.makeConstraints { (make) in
            make.bottom.equalTo(skipButton.snp.top).offset(-12)
            make.centerX.equalTo(view.snp.centerX)
        }
		
        self.view.addSubview(conditionDetailButton)
		conditionDetailButton.snp.makeConstraints { (make) in
			make.height.equalTo(18)
			make.leading.equalTo(view.snp.leading).offset(MARGIN)
			make.bottom.equalTo(skipButton.snp.top).offset(-46)
			make.trailing.equalTo(view.snp.trailing).offset(-MARGIN)
		}
        
        self.view.addSubview(privacyDetailButton)
        privacyDetailButton.snp.makeConstraints { (make) in
            make.height.equalTo(18)
            make.top.equalTo(conditionDetailButton.snp.bottom).offset(10)
            make.leading.equalTo(view.snp.leading).offset(MARGIN)
            make.bottom.equalTo(skipButton.snp.top).offset(-10)
            make.trailing.equalTo(view.snp.trailing).offset(-MARGIN)
        }
		
		self.view.addSubview(cancelButton)
		cancelButton.snp.makeConstraints { (make) in
			make.height.equalTo(54)
			make.leading.equalTo(idView.snp.leading)
			make.trailing.equalTo(idView.snp.centerX).offset(-SMALLINSET)
			make.top.equalTo(idView.snp.bottom).offset(1.5*MARGIN)
		}
		self.view.addSubview(reNewPassButton)
		reNewPassButton.snp.makeConstraints { (make) in
			make.height.equalTo(54)
			make.leading.equalTo(idView.snp.centerX).offset(SMALLINSET)
			make.trailing.equalTo(idView.snp.trailing)
			make.centerY.equalTo(cancelButton.snp.centerY)
		}
		view.layoutIfNeeded()
		
		loginViewModel = LogInRegisViewModelFromModel(login: login)
		loginViewModel.canNext.bindAndFire { [unowned self] in
			if $0 {
				self.signInButton.enableButton(color: .brandcolor1)
			} else {
				self.signInButton.disableButton(canTouch: false, withColor: self.disableColor)
			}
			self.signInButton.dropShadow(color: .brandcoloralpha, radius: HEIGHT_ROUND_BUTTON/4)
		}
		
        loginFacebookButton.dropShadow(color: .blackAlpha(alpha: 0.16), radius: HEIGHT_ROUND_BUTTON/4)
        loginAppleButton.dropShadow(color: .blackAlpha(alpha: 0.16), radius: HEIGHT_ROUND_BUTTON/4)
		
	}
	
	// MARK: TextField Delegate
	@objc func textFieldDidChange(_ textField: UITextField) {
        DispatchQueue.main.async {
            if textField.tag == textFieldType.name.rawValue {
                if let lastCha = textField.text?.last {
                    if (lastCha.unicodeScalarCodePoint() < 3585 || lastCha.unicodeScalarCodePoint() > 3673) && lastCha.unicodeScalarCodePoint() != 32 && lastCha.unicodeScalarCodePoint() != 46 {
                        textField.text?.remove(at: (textField.text?.index(before: (textField.text?.endIndex)!))!)
                    }
                }
                
            }
            self.setMailPass(textField, data: textField.text ?? "")
        }
	}
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		// return NO to disallow editing.
		return true
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		// became first responder
	}
	
	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
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
		setMailPass(textField, data: textField.text!)
		if textField.tag == textFieldType.email.rawValue {
			passField.becomeFirstResponder()
		} else if textField.tag == textFieldType.pass.rawValue {
			if loginViewModel.state.value == .register {
				nameField.becomeFirstResponder()
			} else if loginViewModel.canNext.value {
				loginViewModel.logIn()
            }else{
                self.dismissKeyboard()
            }
		} else if textField.tag == textFieldType.name.rawValue && loginViewModel.state.value == .register && loginViewModel.canNext.value {
			loginViewModel.logIn()
		}
		// may be useful: textField.resignFirstResponder()
		return true
	}
	func setMailPass(_ textField: UITextField, data: String) {
		if textField.tag == textFieldType.email.rawValue {
			loginViewModel.setEmail(data)
		} else if textField.tag == textFieldType.pass.rawValue {
			loginViewModel.setPassword(data)
		} else {
			loginViewModel.setName(data)
		}
	}
}

@available(iOS 13.0, *)
extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let userIdentifier = appleIdCredential.user
            
            if let emailApple = appleIdCredential.email {
                self.emailApple = emailApple
            }
            
            if let fullNameApple =  appleIdCredential.fullName {
                if let givenName = fullNameApple.givenName , let familyName = fullNameApple.familyName {
                    if givenName != "" && familyName != "" {
                        self.firstNameApple = givenName
                        self.lastNameApple = familyName
                    }
                }
            }
            
            let loading = LoadingLogViewController()
            loading.modalPresentationStyle = .fullScreen
            Utility.getCurrentViewController().present(loading, animated: true, completion: {
                loading.loadingAnimation.play()
            })

            let api = API()
            if self.emailApple != "" && self.firstNameApple != "" && self.lastNameApple != "" {
                KeyChainHelper.save("emailApple", value: self.emailApple)
                KeyChainHelper.save("firstNameApple", value: self.firstNameApple)
                KeyChainHelper.save("lastNameApple", value: self.lastNameApple)
                self.loginViewModel.loginWithApple(appleId: userIdentifier, firstName: self.firstNameApple, lastName: self.lastNameApple, email: self.emailApple, loading: loading)
            }else{
                if let emailApple = KeyChainHelper.get("emailApple"),let firstNameApple = KeyChainHelper.get("firstNameApple"),let lastNameApple = KeyChainHelper.get("lastNameApple") {
                    self.loginViewModel.loginWithApple(appleId: userIdentifier, firstName: firstNameApple, lastName: lastNameApple, email: emailApple, loading: loading)
                }else{
                    self.loginViewModel.loginWithApple(appleId: userIdentifier, firstName: firstNameApple, lastName: lastNameApple, email: emailApple, loading: loading)
                }
            }
            // MARK:  add appleId data to local
            api.db?.memberLogInApple(clientSecret: appleIdCredential.identityToken?.base64EncodedString() ?? "", appleToken: String(data: appleIdCredential.identityToken!, encoding: .utf8) ?? "", authorizationcode: appleIdCredential.authorizationCode?.base64EncodedString() ?? "", userIdentifier_appleId: appleIdCredential.user)
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userIdentifier) {  (credentialState, error) in
                switch credentialState {
                case .authorized:
                    print("apple id is valid")
                    // The Apple ID credential is valid.
                case .revoked:
                    print("apple id revoke")
                    // The Apple ID credential is revoked.
                    break
                case .notFound:
                    print("credential not found")
                    // No credential was found, so show the sign-in UI.
                    break
                default:
                    break
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
}


@available(iOS 13.0, *)
extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
