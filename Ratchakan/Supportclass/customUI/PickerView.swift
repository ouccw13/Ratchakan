//
//  PickerView.swift
//  ratchakan
//
//  Created by JJsobtid on 9/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

enum typePicker {
	case date
	case gender
	case other
}

@objc protocol PickerDateDelegate {
	func setBirthDay(_ birthday: String)
	@objc optional func setGender(_ gender: String)
	func cancel()
}

class PickerView: UIView {

	var dateFormatter: DateFormatter!
	
	var pickerShow: Bool = false
	var pickerView: UIPickerView?
	var datePicker: UIDatePicker?
	var doneButton: UIButton!
	var cancelButton: UIButton!
	
	var superViewController: UIViewController?
	
	var date: String?
    var gender: String?
	var defaultDate: Date? {
		didSet {
			if datePicker != nil {
				setDefaultDate()
			}
		}
	}

	var genderData = ["male", "female", "unknown"]

	var delegate: PickerDateDelegate?
	
	var type: typePicker? {
		didSet {
			fillUI()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .darkgraybg
		
		doneButton = UIButton()
		doneButton.setTitle(string.th_ok, for: .normal)
		doneButton.setTitleColor(.bluesystem, for: .normal)
		doneButton.addTarget(self, action: #selector(doneClick), for: .touchUpInside)
		doneButton.titleLabel?.textAlignment = .right
		
		cancelButton = UIButton()
		cancelButton.setTitle(string.th_cancel, for: .normal)
		cancelButton.setTitleColor(.bluesystem, for: .normal)
		cancelButton.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
		cancelButton.titleLabel?.textAlignment = .left
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	fileprivate func setDefaultDate() {
        if let defaultdate = defaultDate {
            datePicker!.date = defaultdate
        }
	}
	
	func fillUI() {
		
		guard let type = type else {
			return
		}
		
		addSubview(doneButton)
		doneButton.snp.makeConstraints { (make) in
			make.width.equalTo(80)
			make.height.equalTo(44)
			make.top.equalTo(0)
			make.trailing.equalTo(self.snp.trailing)
		}
		addSubview(cancelButton)
		cancelButton.snp.makeConstraints { (make) in
			make.width.equalTo(80)
			make.height.equalTo(44)
			make.top.equalTo(0)
			make.leading.equalTo(self.snp.leading)
		}
		
		if type == .date {
			dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "YYYY-MM-dd"
			
			datePicker = UIDatePicker()
			datePicker?.datePickerMode = .date
			datePicker?.frame = CGRect(x: 0, y: 44, width: frame.width, height: frame.height - 44)
			datePicker?.locale = Locale(identifier: "th_TH")
            if #available(iOS 13.0, *) {
                datePicker?.overrideUserInterfaceStyle = .light
            }
			datePicker?.backgroundColor = .white
			datePicker!.maximumDate = Date.init()
            date = dateFormatter.string(from: defaultDate ?? Date())
			
			datePicker!.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)

			addSubview(datePicker!)
		} else if type == .gender {
			pickerView = UIPickerView(frame: CGRect(x: 0, y: 44, width: frame.width, height: frame.height - 44))
			pickerView?.delegate = superViewController as? UIPickerViewDelegate
			pickerView?.dataSource = superViewController as? UIPickerViewDataSource
            if #available(iOS 13.0, *) {
                pickerView?.overrideUserInterfaceStyle = .light
            }
			pickerView?.backgroundColor = .white
			
			addSubview(pickerView!)
		}
		
	}
	
	@objc func datePickerValueChanged(_ sender: UIDatePicker){
		date = dateFormatter.string(from: sender.date)
	}
	
	@objc func doneClick() {
		if type == .date {
			delegate?.setBirthDay(date ?? "")
		} else if type == .gender {
			delegate?.setGender!("")
		}
		hidePicker()
	}
	
	@objc func cancelClick() {
		delegate?.cancel()
		hidePicker()
	}
	
	func hidePicker() {
		pickerShow = false
		removeFromSuperview()
	}
}
