//
//  MenuTableViewCell.swift
//  ratchakan
//
//  Created by JJsobtid on 4/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

@objc protocol UserEditDelegate {
	@objc optional func setData(_ value: String, key: UserData.RawValue)
}

class MenuTableViewCell: UITableViewCell, UITextFieldDelegate {

	var typeCell: MenuCellType?
	
	let imgIcon = UIImageView()
	let profileImage = UIImageView()
	let titleLabel = UILabel()
	let detailLabel = LoadingLabel()
	let detailTextField = UITextField()
	let notiSwitch = UISwitch()
	var accessoryImage = UIImageView()
	let lineSeparateView = UIView()
	
	let purchaseCodeLabel = UILabel()
	let dateLabel = UILabel()
	let detailStatusLabel = UILabel()
	let dateExpLabel = UILabel()
	
	var timer: Timer!
	var url: String!
	
	var editUserDelegate: UserEditDelegate?
	
	var cellModel: MenuCellViewModelFromCell? {
		didSet {
			fillUI()
		}
	}
	var cellContactModel: (key: ContactList, data: Dictionary<String, Any>)? {
		didSet {
			fillContract()
		}
	}
	var cellEditUserModel: (key: UserData, data: dictStringAny)? {
		didSet {
			fillUserInfo()
		}
	}
	var cellEditUserDetailModel: (key: UserData, data: dictStringAny)? {
		didSet {
			fillUserDetailInfo()
		}
	}
	var cellPurchaseHistoryModel: dictStringAny? {
		didSet {
			fillPurchaseHistory()
		}
	}
	
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
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		backgroundColor = .brandcolor3
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
	}
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesCancelled(touches, with: event)
		backgroundColor = .white
	}

	func createUI() {
        backgroundColor = .white
		selectionStyle = .none
		titleLabel.textColor = .Celllabel
		detailLabel.textColor = .guestcolor
		detailTextField.textColor = .guestcolor
		accessoryImage.image = UIImage(named: "chevronIcon")
		accessoryImage.contentMode = .scaleAspectFit
		profileImage.cornerView(radius: 40.0)
		profileImage.contentMode = .scaleAspectFit
		lineSeparateView.backgroundColor = .Collectionbg
		
		contentView.addsubviews([profileImage, imgIcon, titleLabel, detailLabel, detailTextField, accessoryImage, notiSwitch, lineSeparateView, purchaseCodeLabel, dateLabel, detailStatusLabel, dateExpLabel])
		tintColor = .brandcolor3
		
	}
	
	// MARK: - MENU CELL
	func fillUI() {
		guard let cellModel = cellModel else {
			return
		}
		
		setCellData(cellModel)
		setLayout()
	
	}
	
	func setCellData(_ cellModel: MenuCellViewModelFromCell) {
		typeCell = cellModel.type
        titleLabel.setParameter(font: .kanitReg16, color: .Celllabel)
		titleLabel.text = cellModel.title
        titleLabel.adjustsFontSizeToFitWidth = true
		imgIcon.image = UIImage(named: cellModel.imageName)
		imgIcon.contentMode = .scaleAspectFit
		
		Utility.show([imgIcon], hides: [detailLabel, notiSwitch, profileImage, lineSeparateView, accessoryImage, detailTextField, purchaseCodeLabel, dateLabel, dateExpLabel])
		accessoryType = .none
		titleLabel.font = .kanitReg16
		detailLabel.setParameter(font: .kanitReg14, color: .guestcolor)
		
		if typeCell == .profile {
			titleLabel.font = .kanitReg18
			detailLabel.text = cellModel.detail!
			detailLabel.textAlignment = .left
			detailLabel.textColor = .brandcolor1
			profileImage.image = UIImage(named: "unknown")
			let api = API()
			let member = api.getMember()
			if member.gender != "" {
				profileImage.image = UIImage(named: member.gender)
			} else {
				if member.member_id != "" {
					profileImage.image = UIImage(named: "unknown")
				}
			}
			if member.member_id != "" {
				titleLabel.text = "\(member.name) \(member.surname)"
				detailLabel.textColor = .guestcolor
				var numPackage = 0
				for package in member.packages {
					if package.endDate >= Datetime.getCurrentTimestamp() {
						numPackage += 1
					}
				}
				if numPackage != 0 {
					detailLabel.text = "คุณมี \(numPackage) แพ็กเกจ"
				} else {
					detailLabel.text = "ยังไม่ได้สมัคร​แพ็กเกจ"
				}
			}
			Utility.show([detailLabel, profileImage], hides: [accessoryImage, imgIcon])
		} else if typeCell == .version {
			detailLabel.textAlignment = .right
			detailLabel.text = cellModel.detail!
			Utility.show([detailLabel], hides: [])
		} else if typeCell == .noti {
			Utility.show([notiSwitch], hides: [])
			notiSwitch.isOn = true
			notiSwitch.thumbTintColor = .brandcolor1
			notiSwitch.onTintColor = .brandcolor3
		} else if typeCell == .logout {
			
		} else {
			accessoryImage.show()
		}
		
		if !DataConfig.lastCellSectionMenu.contains(typeCell!) {
			lineSeparateView.show()
		}
		
	}
	
	func setLayout() {
		if typeCell == .profile {
			profileImage.snp.remakeConstraints({ (make) in
				make.height.equalTo(80)
				make.width.equalTo(80)
				make.centerY.equalTo(self.contentView.snp.centerY)
				make.leading.equalTo(self.contentView.snp.leading).offset(26)
			})
			titleLabel.snp.remakeConstraints({ (make) in
				make.height.equalTo(27)
				make.leading.equalTo(self.profileImage.snp.trailing).offset(26)
				make.trailing.equalTo(self.contentView.snp.trailing).offset(-26)
				make.top.equalTo(34)
			})
			imgIcon.snp.remakeConstraints({ (make) in
				make.leading.equalTo(self.titleLabel.snp.leading)
				make.top.equalTo(self.titleLabel.snp.bottom).offset(13)
				make.height.equalTo(23)
				make.width.equalTo(20)
			})
			detailLabel.snp.remakeConstraints({ (make) in
				make.height.equalTo(21)
				make.centerY.equalTo(self.imgIcon.snp.centerY)
				make.leading.equalTo(self.titleLabel.snp.leading)
				make.trailing.equalTo(self.contentView.snp.trailing).offset(-26)
			})
			accessoryImage.snp.remakeConstraints { (make) in
				make.width.equalTo(6.6)
				make.height.equalTo(11)
				make.centerY.equalTo(contentView.snp.centerY)
				make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
			}
		} else {
			imgIcon.snp.remakeConstraints({ (make) in
				make.centerX.equalTo(self.contentView.snp.leading).offset(26)
				make.centerY.equalTo(self.contentView.snp.centerY)
				make.height.equalTo(25)
				make.width.equalTo(25)
			})
			titleLabel.snp.remakeConstraints({ (make) in
				make.leading.equalTo(self.imgIcon.snp.trailing).offset(MARGIN)
				make.trailing.equalTo(self.contentView.snp.trailing).offset(-(2*MARGIN + 40))
				make.height.equalTo(24)
				make.centerY.equalTo(self.imgIcon.snp.centerY)
			})
			lineSeparateView.snp.remakeConstraints({ (make) in
				make.leading.equalTo(self.titleLabel.snp.leading)
				make.trailing.equalTo(self.contentView.snp.trailing)
				make.bottom.equalTo(self.contentView.snp.bottom)
				make.height.equalTo(SEPARATE_LINE_WIDHT)
			})
			if typeCell == .version {
				detailLabel.snp.remakeConstraints({ (make) in
					make.height.equalTo(21)
					make.width.equalTo(80)
					make.centerY.equalTo(self.contentView.snp.centerY)
					make.trailing.equalTo(self.contentView.snp.trailing).offset(-MARGIN)
				})
			} else if typeCell == .noti {
				notiSwitch.snp.remakeConstraints({ (make) in
					make.centerY.equalTo(self.contentView.snp.centerY)
					make.trailing.equalTo(self.contentView.snp.trailing).offset(-MARGIN)
				})
			} else if typeCell == .logout {
				
			} else {
				accessoryImage.snp.remakeConstraints { (make) in
					make.width.equalTo(6.6)
					make.height.equalTo(11)
					make.centerY.equalTo(contentView.snp.centerY)
					make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
				}
			}
		}
	}
	
	// MARK: - MENU CONTACT CELL
	func fillContract() {
		guard let cellData = cellContactModel else {
			return
		}
		
		Utility.show([titleLabel, detailLabel, accessoryImage, lineSeparateView], hides: [imgIcon, profileImage, notiSwitch, detailTextField, purchaseCodeLabel, dateLabel, dateExpLabel, detailStatusLabel])
		
        titleLabel.setParameter(font: .kanitLight14, color: .Celllabel)
		detailLabel.setParameter(font: .kanitReg12, color: .guestcolor, alignment: .left)
		detailLabel.lineBreakMode = .byWordWrapping
		detailLabel.numberOfLines = 0
		accessoryImage.hide()
		if cellData.key == .company {
			titleLabel.text = cellData.data["company"] as? String ?? string.th_company
            detailLabel.setText(cellData.data["address"] as? String)
		} else {
			titleLabel.text = cellData.key.rawValue
			let type = ContactList.hash(type: cellData.key)
			let key = DataConfig.contactInfo[type]
			detailLabel.setText(cellData.data[key!.key] as? String)
		}
		
		accessoryImage.snp.remakeConstraints { (make) in
			make.width.equalTo(6.6)
			make.height.equalTo(11)
			make.centerY.equalTo(contentView.snp.centerY)
			make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
		}
		titleLabel.snp.remakeConstraints({ (make) in
			make.leading.equalTo(self.contentView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(self.accessoryImage.snp.leading).offset(-MARGIN)
			make.height.equalTo(24)
			make.top.equalTo(6)
		})
		detailLabel.snp.remakeConstraints({ (make) in
			make.top.equalTo(self.titleLabel.snp.bottom)
			make.bottom.equalTo(self.contentView.snp.bottom).offset(-6)
			make.leading.equalTo(self.titleLabel.snp.leading)
			make.trailing.equalTo(self.titleLabel.snp.trailing)
		})
		lineSeparateView.snp.remakeConstraints({ (make) in
			make.leading.equalTo(self.titleLabel.snp.leading)
			make.trailing.equalTo(self.contentView.snp.trailing)
			make.bottom.equalTo(self.contentView.snp.bottom)
			make.height.equalTo(SEPARATE_LINE_WIDHT)
		})
	}

	// MARK: - USER INFO
	func fillUserInfo() {
		guard let cellData = cellEditUserModel else {
			return
		}
		
		Utility.show([titleLabel, detailLabel, accessoryImage, lineSeparateView], hides: [imgIcon, profileImage, notiSwitch, detailTextField, purchaseCodeLabel, dateLabel, dateExpLabel, detailStatusLabel])
		
		detailLabel.setParameter(font: .kanitReg14, color: .guestcolor, alignment: .right)
        let api = API()
        let member = api.getDatabase().getMember()
        let memberEmail = member["email"] as! String
        let memberPhoneNumber = member["phoneNumber"] as! String
        if cellData.key.rawValue == "อีเมล" {
            if Validation.email(memberEmail) {
                titleLabel.setParameter(font: .kanitReg16, color: .successgreen)
            }else{
                titleLabel.setParameter(font: .kanitReg16, color: .Celllabel)
            }
        }else if cellData.key.rawValue == "เบอร์โทรศัพท์" {
            if Validation.tel(memberPhoneNumber) {
                titleLabel.setParameter(font: .kanitReg16, color: .successgreen)
            }else{
                titleLabel.setParameter(font: .kanitReg16, color: .Celllabel)
            }
        }else{
            titleLabel.setParameter(font: .kanitReg16, color: .Celllabel)
        }
		titleLabel.text = cellData.key.rawValue
		let type = UserData.hash(type: cellData.key)
		let key = DataConfig.editUser[type]
		
		switch cellData.key.hashValue {
			case UserData.name.hashValue:
            detailLabel.text = cellData.data["displayName"] as? String ?? "ชื่อ สกุล"
			case UserData.email.hashValue:
				detailLabel.text = Utility.empty(str: cellData.data[key!.key] as? String, ph: string.th_not_confirm_phone)
				if detailLabel.text == string.th_not_confirm_phone {
					detailLabel.textColor = .brandconfirm
				}
			case UserData.phone.hashValue:
            if Validation.anyIsBool(Validation.anyIsDictionary(cellData.data, with: "verify"), with: "phoneNumber") || Validation.anyIsDictionary(cellData.data, with: "phoneNumber").isEmpty != false  {
					detailLabel.text = cellData.data[key!.key] as? String
				} else {
					detailLabel.text = string.th_not_confirm_phone
					detailLabel.textColor = .brandconfirm
				}
			case UserData.password.hashValue:
				detailLabel.text = key!.key
			case UserData.birthday.hashValue:
            detailLabel.text = Utility.empty(str: cellData.data[key!.key] as? String, ph: string.th_unknown)
			case UserData.gender.hashValue:
				detailLabel.text = Validation.anyIsString(cellData.data, with: key!.key).genderThai()
			default:
				detailLabel.text = "test"
		}
		accessoryImage.snp.remakeConstraints { (make) in
			make.width.equalTo(6.6)
			make.height.equalTo(11)
			make.centerY.equalTo(contentView.snp.centerY)
			make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
		}
		titleLabel.snp.remakeConstraints({ (make) in
			make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
			make.width.equalTo(100)
			make.height.equalTo(21)
			make.top.equalTo(contentView.snp.top).offset(MARGIN)
			make.bottom.equalTo(contentView.snp.bottom).offset(-MARGIN)
		})
		detailLabel.snp.remakeConstraints({ (make) in
			make.height.equalTo(21)
			make.centerY.equalTo(titleLabel.snp.centerY)
			make.leading.equalTo(titleLabel.snp.trailing).offset(SMALLINSET)
			make.trailing.equalTo(accessoryImage.snp.leading).offset(-SMALLINSET)
		})
		lineSeparateView.snp.remakeConstraints({ (make) in
			make.leading.equalTo(self.titleLabel.snp.leading)
			make.trailing.equalTo(self.contentView.snp.trailing)
			make.bottom.equalTo(self.contentView.snp.bottom)
			make.height.equalTo(SEPARATE_LINE_WIDHT)
		})
	}
	
	// MARK: - USER DETAIL INFO
	func fillUserDetailInfo() {
		guard let cellData = cellEditUserDetailModel else {
			return
		}
		
		Utility.show([titleLabel, detailTextField, lineSeparateView], hides: [imgIcon, accessoryImage, profileImage, notiSwitch, detailLabel, purchaseCodeLabel, dateLabel, dateExpLabel, detailStatusLabel])
		
		titleLabel.font = .kanitLight14
		titleLabel.textColor = .guestcolor
        detailTextField.font = .kanitReg14
        detailTextField.textAlignment = .right
        detailTextField.textColor = .Celllabel
		
		titleLabel.text = cellData.key.rawValue
		detailTextField.removeTarget(self, action: nil, for: .valueChanged)
		detailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		detailTextField.delegate = self
		detailTextField.keyboardType = .default
		detailTextField.isSecureTextEntry = false
		detailTextField.accessibilityIdentifier = cellData.key.rawValue
		detailTextField.placeholder = ""
	
		if cellData.key == .firstname {
			detailTextField.placeholder = cellData.data["name"] as? String ?? string.th_name
			detailTextField.tag = UserData.firstname.hashValue
		} else if cellData.key == .surname {
			detailTextField.placeholder = cellData.data["surname"] as? String ?? string.th_surname
			detailTextField.tag = UserData.surname.hashValue
		} else if cellData.key == .oldpassword || cellData.key == .newpassword || cellData.key == .confirmpass {
			detailTextField.placeholder = "อย่างน้อย 8 ตัวอักษร"
			detailTextField.isSecureTextEntry = true
		} else {
			detailTextField.placeholder = cellData.data["email"] as? String ?? string.th_unknown
			detailTextField.keyboardType = .emailAddress
		}
        if #available(iOS 13.0, *) {
            detailTextField.attributedPlaceholder = NSAttributedString(string: detailTextField.placeholder ?? "", attributes: [.foregroundColor: UIColor.placeholdercolor])
        }
        
        titleLabel.snp.remakeConstraints({ (make) in
			make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
			make.width.equalTo(100)
			make.height.equalTo(21)
			make.top.equalTo(contentView.snp.top).offset(MARGIN)
			make.bottom.equalTo(contentView.snp.bottom).offset(-MARGIN)
		})
		detailTextField.snp.remakeConstraints({ (make) in
			make.height.equalTo(21)
			make.centerY.equalTo(contentView.snp.centerY)
			make.leading.equalTo(titleLabel.snp.trailing).offset(SMALLINSET)
			make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
		})
		lineSeparateView.snp.remakeConstraints({ (make) in
			make.leading.equalTo(self.titleLabel.snp.leading)
			make.trailing.equalTo(self.contentView.snp.trailing)
			make.bottom.equalTo(self.contentView.snp.bottom)
			make.height.equalTo(SEPARATE_LINE_WIDHT)
		})
	}
	
	@objc func textFieldDidChange(_ textField: UITextField) {
		if let cellData = cellEditUserDetailModel {
			if cellData.key == .firstname || cellData.key == .surname {
				if let lastCha = textField.text?.last {
					if (lastCha.unicodeScalarCodePoint() < 3585 || lastCha.unicodeScalarCodePoint() > 3673) && lastCha.unicodeScalarCodePoint() != 32 && lastCha.unicodeScalarCodePoint() != 46 {
						textField.text?.remove(at: (textField.text?.index(before: (textField.text?.endIndex)!))!)
					}
				}
			}
			editUserDelegate!.setData!(textField.text!, key: cellData.key.rawValue)
		}
	}
	
	// MARK: - PURCHASE HISTORY
	func fillPurchaseHistory() {
		guard let cellData = cellPurchaseHistoryModel else {
			return
		}
		titleLabel.flexibleLine()
        titleLabel.setParameter(font: .kanitReg16, color: .Celllabel)
		detailLabel.setParameter(font: .kanitLight14, color: .Celllabel)
		purchaseCodeLabel.setParameter(font: .kanitLight14, color: .Celllabel)
		dateLabel.setParameter(font: .kanitLight14, color: .Celllabel)
		detailStatusLabel.setParameter(font: .kanitLight14, color: .greenpurchase)

		Utility.show([titleLabel, accessoryImage, detailLabel, lineSeparateView, purchaseCodeLabel, dateLabel, detailStatusLabel, dateExpLabel], hides: [profileImage, imgIcon, detailTextField, notiSwitch])
		titleLabel.text = "\(Validation.anyIsString(cellData, with: "name")) (\(Validation.anyIsString(cellData, with: "type")))"//"SOBTID MEMBER 1 YEAR"
		purchaseCodeLabel.text = "\(Validation.anyIsString(cellData, with: "paymentCode")) (\(Validation.intDictionary(DataConfig.typePayment, withInt: Validation.anyIsNumber(cellData, with: "channel"))))"
		dateLabel.text = "\(string.th_operation_date) : \(Datetime().showDate(Validation.anyIsNumber(cellData, with: "transactionDate"), short: true, showTime: true))"
		detailLabel.text = "\(string.th_status) : "
		detailStatusLabel.text = string.th_confirm_purchase
		
		if not(Validation.anyIsBool(cellData, with: "isPaid")) {
			detailStatusLabel.text = string.th_confirm_not_purchase
			detailStatusLabel.textColor = .redPurchase
		}
		if Validation.dictionary(cellData, with: "url") {
			url = Validation.anyIsString(cellData, with: "url")
		} else if Validation.dictionary(cellData, with: "urlPayment") {
			if UIApplication.shared.canOpenURL(URL(string: "line://")!) {
				url = Validation.anyIsString(Validation.anyIsDictionary(cellData, with: "urlPayment"), with: "app")
			} else {
				url = Validation.anyIsString(Validation.anyIsDictionary(cellData, with: "urlPayment"), with: "web")
			}
		} else {
			url = nil
			accessoryImage.hide()
		}
		accessoryImage.snp.remakeConstraints { (make) in
			make.width.equalTo(6.6)
			make.height.equalTo(11)
			make.centerY.equalTo(contentView.snp.centerY)
			make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
		}
		titleLabel.snp.remakeConstraints({ (make) in
			make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(accessoryImage.snp.leading).offset(-SMALLINSET)
			make.top.equalTo(contentView.snp.top).offset(MARGIN)
			make.bottom.equalTo(purchaseCodeLabel.snp.top).offset(-1)
		})
		purchaseCodeLabel.snp.remakeConstraints { (make) in
			make.leading.equalTo(titleLabel.snp.leading)
			make.trailing.equalTo(titleLabel.snp.trailing)
			make.height.equalTo(24)
			make.top.equalTo(titleLabel.snp.bottom).offset(1)
			make.bottom.equalTo(dateLabel.snp.top)
		}
		dateLabel.snp.remakeConstraints { (make) in
			make.leading.equalTo(titleLabel.snp.leading)
			make.trailing.equalTo(titleLabel.snp.trailing)
			make.height.equalTo(24)
			make.top.equalTo(purchaseCodeLabel.snp.bottom)
			make.bottom.equalTo(detailLabel.snp.top)
		}
		detailLabel.snp.remakeConstraints { (make) in
			make.leading.equalTo(titleLabel.snp.leading)
			make.width.equalTo(50)
			make.height.equalTo(24)
			make.top.equalTo(dateLabel.snp.bottom)
			make.bottom.equalTo(contentView.snp.bottom).offset(-MARGIN)
		}
		detailStatusLabel.snp.remakeConstraints { (make) in
			make.leading.equalTo(detailLabel.snp.trailing)
			make.trailing.equalTo(titleLabel.snp.trailing)
			make.height.equalTo(24)
			make.centerY.equalTo(detailLabel.snp.centerY)
		}

		lineSeparateView.snp.remakeConstraints({ (make) in
			make.leading.equalTo(self.titleLabel.snp.leading)
			make.trailing.equalTo(self.contentView.snp.trailing)
			make.bottom.equalTo(self.contentView.snp.bottom)
			make.height.equalTo(SEPARATE_LINE_WIDHT)
		})
	}
}
