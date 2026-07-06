//
//  PretestPurchaseTableViewCell.swift
//  ratchakan
//
//  Created by JJsobtid on 5/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

enum PretestPurchaseCellType {
	case purchase
	case detailPretest
	case detailUser
}
protocol PretestFieldDelegate {
	func editField(_ textField: UITextField)
}
protocol PretestSelectPaymentDelegate {
	func selectPayment(_ type: String)
}

class PretestPurchaseTableViewCell: UITableViewCell, UITextFieldDelegate {

	static let cellIdentified: String = "PretestPurchaseTableViewCell"
	
	var titleLabel: UILabel!
	var detailLabel: UILabel!
	var textField: UITextField!
	var conditionLabel: UILabel!
	var separateLine: UIView!
	var inappButton: UIButton!
	var counterServiceButton: UIButton!
	var molButton: UIButton!
	
	var fieldDelegate: PretestFieldDelegate!
	var selectPaymentDelegate: PretestSelectPaymentDelegate!
	
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		createUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	func createUI() {
		selectionStyle = .none
		
		inappButton = UIButton()
		inappButton.tag = 0
		inappButton.addTarget(self, action: #selector(clickPurchaseType(_:)), for: .touchUpInside)
		setPurchaseButtonType(inappButton)
		
		counterServiceButton = UIButton()
		counterServiceButton.tag = 1
		counterServiceButton.addTarget(self, action: #selector(clickPurchaseType(_:)), for: .touchUpInside)
		setPurchaseButtonType(counterServiceButton)
		
		molButton = UIButton()
		molButton.tag = 2
		molButton.addTarget(self, action: #selector(clickPurchaseType(_:)), for: .touchUpInside)
		setPurchaseButtonType(molButton)
		
		titleLabel = UILabel()
		detailLabel = UILabel()
		detailLabel.setParameter(font: .kanitReg14, color: .guestcolor)
		
		textField = UITextField()
		textField.font = .kanitReg14
		textField.textColor = .guestcolor
		textField.textAlignment = .right
		textField.delegate = self
		
		conditionLabel = UILabel()
		conditionLabel.setParameter(font: .kanitLight12, color: .brandcolor1, alignment: .center)
		conditionLabel.text = string.th_condition_pretest
		
		separateLine = UIView()
		separateLine.lineView(withColor: .separateLine)
		
		contentView.addsubviews([inappButton, counterServiceButton, molButton, titleLabel, detailLabel, textField, conditionLabel, separateLine])
	}
	
	func fillUI(_ type: PretestPurchaseCellType, row: Int, data: dictStringAny) {
		if type == .purchase {
			Utility.show([inappButton], hides: [counterServiceButton, molButton, titleLabel, detailLabel, textField, conditionLabel, separateLine])
			inappButton.snp.remakeConstraints({ (make) in
				make.top.equalTo(contentView.snp.top).offset(MARGIN)
				make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
				make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
				make.height.equalTo(50)
			})
			inappButton.setTitle("IN-APP ราคา \(Validation.anyIsNumber(data, with: "inapp")) บาท", for: .normal)
			let globalParameter = GlobalParameter.storeObserverSharedInstance
			if !globalParameter.newMoreStore {
				Utility.show([counterServiceButton], hides: [])
				counterServiceButton.snp.remakeConstraints({ (make) in
					make.top.equalTo(inappButton.snp.bottom).offset(MARGIN)
					make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
					make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
					make.height.equalTo(50)
				})
				counterServiceButton.setTitle("Counter Service ราคา \(Validation.anyIsNumber(data, with: "counterService")) บาท", for: .normal)
			}
		} else if type == .detailPretest {
			Utility.show([titleLabel, detailLabel], hides: [inappButton, counterServiceButton, molButton, textField, conditionLabel, separateLine])
			
			titleLabel.setParameter(font: .kanitReg16, color: .Celllabel)
			titleLabel.text = Validation.anyIsString(data, with: "name")
			detailLabel.text = Datetime().showDate(Validation.anyIsNumber(data, with: "date"), short: false, showTime: true)
			
			titleLabel.snp.remakeConstraints({ (make) in
				make.top.equalTo(contentView.snp.top).offset(SMALLINSET)
				make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
				make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
				make.height.equalTo(24)
			})
			detailLabel.snp.remakeConstraints({ (make) in
				make.bottom.equalTo(contentView.snp.bottom).offset(-SMALLINSET)
				make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
				make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
				make.height.equalTo(21)
			})
		} else if type == .detailUser {
			Utility.show([titleLabel, textField, separateLine], hides: [inappButton, counterServiceButton, molButton, detailLabel, conditionLabel])
			
			titleLabel.setParameter(font: .kanitLight14, color: .Celllabel)
			titleLabel.text = DataConfig.formPretest[row]
			titleLabel.sizeToFit()
			textField.placeholder = titleLabel.text
			
			if DataConfig.formPretest[row] == string.th_email {
				textField.keyboardType = .emailAddress
				textField.placeholder = Validation.email(Validation.anyIsString(data, with: "email")) ? Validation.anyIsString(data, with: "email") : titleLabel.text
			} else if DataConfig.formPretest[row] == string.th_phone_number {
				textField.keyboardType = .phonePad
				textField.placeholder = Validation.tel(Validation.anyIsString(data, with: "email")) ? Validation.anyIsString(data, with: "email") : titleLabel.text
			} else {
				if DataConfig.formPretest[row] == string.th_name {
					textField.placeholder = Validation.anyIsString(data, with: "name")
				} else if DataConfig.formPretest[row] == string.th_surname {
					textField.placeholder = Validation.anyIsString(data, with: "surname")
				}
				textField.keyboardType = .default
			}
			textField.snp.remakeConstraints({ (make) in
				make.centerY.equalTo(titleLabel.snp.centerY)
				make.leading.equalTo(titleLabel.snp.trailing).offset(MARGIN)
				make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
				make.height.equalTo(21)
			})
			titleLabel.snp.remakeConstraints({ (make) in
				make.centerY.equalTo(contentView.snp.centerY)
				make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
				make.height.equalTo(21)
				make.width.equalTo(DataConfig.sizeFormPretest[row])
			})
			separateLine.snp.remakeConstraints({ (make) in
				make.height.equalTo(SEPARATE_LINE_WIDHT)
				make.bottom.equalTo(contentView.snp.bottom)
				make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
				make.trailing.equalTo(contentView.snp.trailing)
			})
		}
	}
	
	fileprivate func setPurchaseButtonType(_ button: UIButton) {
		button.setTitleColor(.guestcolor, for: .normal)
		button.titleLabel?.font = .kanitReg16
		button.backgroundColor = .white
		button.cornerView(radius: 25.0)
		button.borderView(color: .guestcolor, width: 1.0)
	}
	
	@objc fileprivate func clickPurchaseType(_ sender: UIButton) {
		for button in [inappButton, counterServiceButton, molButton] {
			setPurchaseButtonType(button ?? UIButton())
		}
		sender.setTitleColor(.white, for: .normal)
		sender.backgroundColor = .brandcolor1
		sender.layer.borderColor = UIColor.brandcolor1.cgColor
		if sender == inappButton {
			selectPaymentDelegate.selectPayment("inapp")
		} else if sender == counterServiceButton {
			selectPaymentDelegate.selectPayment("counterService")
		} else if sender == molButton {
			selectPaymentDelegate.selectPayment("mol")
		}
	}
	
	func setInappButton(enable: Bool) {
		if enable {
			inappButton.isEnabled = true
			inappButton.borderView(color: .guestcolor, width: 1.0)
		} else {
			inappButton.isEnabled = false
			inappButton.borderView(color: .Collectionbg, width: 1.0)
		}
	}
	
	@objc func textFieldDidChange(_ textField: UITextField) {
		setInfo(textField, data: textField.text!)
	}
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		fieldDelegate.editField(textField)
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
		setInfo(textField, data: textField.text!)
		// may be useful: textField.resignFirstResponder()
		return true
	}
	func setInfo(_ textField: UITextField, data: String) {
        
	}
}
