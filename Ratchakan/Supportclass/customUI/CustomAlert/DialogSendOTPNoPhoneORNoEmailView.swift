//
//  DialogSendOTPNoPhoneORNoEmailView.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 27/2/2566 BE.
//  Copyright © 2566 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class DialogSendOTPNoPhoneORNoEmailView: BasedView,PopupViewDelegate,UITextFieldDelegate {
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
    
    var otpCode:String = ""
    
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

    override func setupViewWithNib() {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

