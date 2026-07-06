//
//  CustomDialogRevokeAppleView.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 22/2/2566 BE.
//  Copyright © 2566 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import UIKit
class CustomDialogRevokeAppleView: BasedView,PopupViewDelegate {
    var backgroundView: UIView = UIView()
    
    var didAcceptButtonTapped: (()->Void) = {}
    
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
    var isEnabledConfirm:Bool = false
    var isNotAppleId:Bool = false {
        didSet{
            if isNotAppleId == true {
                acceptButtonView.borderView(color: .brandcolor1, width: 1.0)
                acceptButtonView.backgroundColor = .brandcolor1
                acceptButtonView.cornerView(radius: 25.0, clip: true)
                acceptButtonTitleLabel.font = UIFont.kanitReg16
                acceptButtonTitleLabel.textColor = UIColor.cellWhiteLabel
                acceptButton.isEnabled = true
            }else{
                acceptButtonView.borderView(color: .lightgraybg, width: 1.0)
                acceptButtonView.backgroundColor = .lightgraybg
                acceptButtonView.cornerView(radius: 25.0, clip: true)
                acceptButtonTitleLabel.font = UIFont.kanitReg16
                acceptButtonTitleLabel.textColor = UIColor.brownGrey
                acceptButton.isEnabled = false
            }
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet{
            titleLabel.font = UIFont.kanitMed18
            titleLabel.textColor = UIColor.Celllabel
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = .byWordWrapping
        }
    }
    
    @IBOutlet weak var aboutAccountLabel: UILabel! {
        didSet {
            aboutAccountLabel.font = UIFont.kanitMed14
            aboutAccountLabel.textColor = UIColor.Celllabel
            aboutAccountLabel.numberOfLines = 0
            aboutAccountLabel.lineBreakMode = .byWordWrapping
            aboutAccountLabel.text = "เกี่ยวกับบัญชีผู้ใช้"
        }
    }
    
    @IBOutlet weak var descriptionAccounttextView: UITextView! {
        didSet {
            descriptionAccounttextView.font = UIFont.kanitLight14
            descriptionAccounttextView.backgroundColor = .clear
            descriptionAccounttextView.textColor = .Celllabel
            descriptionAccounttextView.text = "ขอแจ้งให้ทราบว่า การลบบัญชีผู้ใช้ จะทำการลบข้อมูลส่วนตัว รวมถึงข้อมูลสถิติต่างๆในการทำข้อสอบของผู้ใช้ทั้งหมด"
            descriptionAccounttextView.isEditable = false
        }
    }

    @IBOutlet var confirmDeleteAccountTextField: UITextField! {
        didSet{
            confirmDeleteAccountTextField.font = UIFont.kanitReg12
        }
    }
    
    @IBOutlet weak var titleConfirmDeleteAccountLabel: UILabel! {
        didSet {
            titleConfirmDeleteAccountLabel.font = UIFont.kanitReg14
            titleConfirmDeleteAccountLabel.textColor = UIColor.Celllabel
            titleConfirmDeleteAccountLabel.numberOfLines = 0
            titleConfirmDeleteAccountLabel.lineBreakMode = .byWordWrapping
            titleConfirmDeleteAccountLabel.text = "กรุณาพิมพ์ \(#""ยืนยันการลบบัญชี""#) เพื่อยืนยัน"
            titleConfirmDeleteAccountLabel.changeFont(ofText: #""ยืนยันการลบบัญชี""#, with: .kanitMed14)
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
            acceptButtonTitleLabel.textColor = UIColor.brownGrey
        }
    }
    
    @IBOutlet weak var acceptButton: UIButton! {
        didSet {
            acceptButton.isEnabled = false
        }
    }
    
    @IBAction func didClickCloseButton() {
        didCloseButtonTapped()
    }
    
    @IBAction func didClickAcceptButton() {
        didAcceptButtonTapped()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupViewWithNib()
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    // MARK: - Keyboard Notification
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
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
    
}

extension  CustomDialogRevokeAppleView : UITextViewDelegate,UITextFieldDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        descriptionAccounttextView.text = "ขอแจ้งให้ทราบว่า การลบบัญชีผู้ใช้ จะทำการลบข้อมูลส่วนตัว รวมถึงข้อมูลสถิติต่างๆในการทำข้อสอบของผู้ใช้ทั้งหมด"
    }
    
    @IBAction func editingTestField(_ sender: UITextField) {
        let resultText = sender.text
        if resultText == "ยืนยันการลบบัญชี" {
            isEnabledConfirm = true
            acceptButtonView.borderView(color: .brandcolor1, width: 1.0)
            acceptButtonView.cornerView(radius: 25.0, clip: true)
            acceptButtonView.backgroundColor = .brandcolor1
            acceptButtonTitleLabel.textColor = UIColor.cellWhiteLabel
            acceptButton.isEnabled = true
        }else{
            isEnabledConfirm = false
            acceptButtonView.borderView(color: .lightgraybg, width: 1.0)
            acceptButtonView.cornerView(radius: 25.0, clip: true)
            acceptButtonView.backgroundColor = .lightgraybg
            acceptButtonTitleLabel.textColor = UIColor.brownGrey
            acceptButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



