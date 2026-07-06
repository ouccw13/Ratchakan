//
//  DialogSendOTPforDeleteAccountView.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 27/2/2566 BE.
//  Copyright © 2566 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class DialogSendOTPforDeleteAccountView: BasedView,PopupViewDelegate,UITextFieldDelegate {
    var backgroundView: UIView = UIView()
    
    var didAcceptButtonTapped: ((_ OtpCode:String)->Void) = {_ in }
    
    var didCloseButtonTapped: (()->Void) = {}
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var acceptButtonTitle: String = "ยืนยัน" {
        didSet {
            acceptButtonTitleLabel.text = acceptButtonTitle
        }
    }
    
    var closeButtonTitle: String = "ยกเลิก" {
        didSet {
            closeButtonTitleLabel.text = closeButtonTitle
        }
    }
    
    var isHiddenCloseButton: Bool = false {
        didSet {
            closeButtonView.isHidden = isHiddenCloseButton
        }
    }
    
    var count:Int = 60
    var getTimer:Timer?
    var otpCode:String = ""
    var emailOrPhone:String?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet{
            titleLabel.font = UIFont.kanitReg18
            titleLabel.textColor = UIColor.Celllabel
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = .byWordWrapping
        }
    }
    
    
    @IBOutlet weak var closeButtonView: UIView!{
        didSet{
            closeButtonView.borderView(color: .brandcolor1, width: 1.0)
            closeButtonView.cornerView(radius: 25.0, clip: true)
        }
    }
    @IBOutlet weak var closeButtonTitleLabel: UILabel! {
        didSet {
            closeButtonTitleLabel.font = UIFont.kanitReg16
            closeButtonTitleLabel.textColor = UIColor.brandcolor1
        }
    }
    
    @IBOutlet var otpTextField: UITextField! {
        didSet{
            otpTextField.font = UIFont.kanitReg14
        }
    }
    
    @IBAction func setOTPTextField(_ sender: UITextField) {
        let otpText = sender.text
        self.otpCode = otpText ?? ""
        if self.otpCode != "" {
            self.acceptButtonView.backgroundColor = .brandcolor1
            acceptButtonView.borderView(color: .brandcolor1, width: 1.0)
        }else{
            self.acceptButtonView.backgroundColor = .lightgraybg
            self.acceptButtonView.borderView(color: .lightgraybg, width: 1.0)
        }
    }
    
    @IBOutlet weak var resendOtpButton: UIButton! {
        didSet{
            resendOtpButton.titleLabel?.font = UIFont.kanitLight14
            resendOtpButton.titleLabel?.numberOfLines = 0
            resendOtpButton.titleLabel?.text = "ยังไม่ได้รหัสยืนยัน? ขอรหัสใหม่อีกครั้ง"
            resendOtpButton.titleLabel?.lineBreakMode = .byWordWrapping
        }
    }
    
    @IBOutlet weak var acceptButtonView: UIView! {
        didSet{
            acceptButtonView.borderView(color: .lightgraybg, width: 1.0)
            acceptButtonView.backgroundColor = .lightgraybg
            acceptButtonView.cornerView(radius: 25.0, clip: true)
        }
    }
    @IBOutlet weak var acceptButtonTitleLabel: UILabel! {
        didSet {
            acceptButtonTitleLabel.font = UIFont.kanitReg16
            acceptButtonTitleLabel.textColor = UIColor.cellWhiteLabel
        }
    }
    
    @IBAction func didClickCloseButton() {
        didCloseButtonTapped()
    }
    
    @IBAction func didClickAcceptButton() {
        if self.otpCode != "" {
            didAcceptButtonTapped(self.otpCode)
        }
    }
    
    @IBAction func resendOtpAction() {
        resendOtpDeleteAccount()
        count = 60
        getTimer = Timer.scheduledTimer(timeInterval: 1, target: self,selector: #selector(executeResendAgain), userInfo: nil, repeats: true)
        RunLoop.main.add(getTimer!, forMode: RunLoop.Mode.common)
    }
    
    func resendOtpDeleteAccount() {
        let api = API()
        var parameters: Parameters = [:]
        let memberId = api.member_id ?? ""
        if emailOrPhone == "" {
            parameters = [:]
        }else{
            if Validation.email(emailOrPhone ?? "") {
                parameters = [
                    "email": emailOrPhone ?? ""
                ]
            }else if Validation.tel(emailOrPhone ?? "") {
                parameters = [
                    "phoneNumber": emailOrPhone ?? ""
                ]
            }
        }
        api.requestOTPforAccountDelete(memberId: memberId, parameter: parameters) {(finished,response) in
            if finished {
                print("Test reSend OTPforAccountDelete success: ",Utility.jsonLog(response ?? [:]))
            }else{
                print("Test reSend OTPforAccountDelete error: ",Utility.jsonLog(response ?? [:]))
                let confirmAlert = UIAlertController(title: "เกิดข้อผิดพลาด", message: "ไม่สามารถเชื่อมต่อ API ได้", preferredStyle: UIAlertController.Style.alert)
                confirmAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: { action in
                }))
                Utility.getCurrentViewController().present(confirmAlert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func executeResendAgain() {
        if count > 0 {
            count -= 1
        }else{
            getTimer?.invalidate()
        }
        
        if count > 0 {
            resendOtpButton.isEnabled = false
            resendOtpButton.titleLabel?.text = "รออีก \(count) วินาที"
        }else{
            resendOtpButton.isEnabled = true
            resendOtpButton.titleLabel?.text =  "ยังไม่ได้รหัสยืนยัน? ขอรหัสใหม่อีกครั้ง"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViewWithNib()
        hideKeyboardWhenTappedAround()
    }
    
    override func setupViewWithCode() {
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.33
        addSubview(backgroundView)
        super.setupViewWithCode()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func setupViewWithNib() {
        
    }
}
