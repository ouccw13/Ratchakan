//
//  MenuDetailView.swift
//  ratchakan
//
//  Created by JJsobtid on 29/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit

protocol MenuDetailDelegate {
	func closeDetail(type: MenuCellType)
}

class MenuDetailView: UIViewController, CustomNavDelegate, UITableViewDelegate, UITableViewDataSource, PickerDateDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UserEditDelegate {
	
	var topView: CustomNav!
    var topViewIphone: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
	var tableView: UITableView!
	var typeDetailMenu: MenuCellType?
	
	var nodataView: NoDataView!
    var loadingView: LoadingView!
	var typeUserEdit: UserData?
	var datePicker: PickerView!
	var genderPicker: PickerView!
	let genderData = DataConfig.genderData
	var nowGender: String!
    var dateFormatter: DateFormatter!
	var name: String?
	var surname: String?
	var oldPassword: String?
	var newPassword: String?
	var confirmPass: String?
	var email: String?
	
	var delegate: MenuDetailDelegate?
    var refreshHeader: HeaderRefreshControl!
	var api: API!
	
	var nav: Nav? = nil {
		didSet {
			fillUI()
		}
	}
	var tableData:[String: Any] = [:] {
		didSet {
			if isViewLoaded {
				tableView.reloadData()
			}
		}
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		if UIColor.dark(color: .navbrandcolor) {
			return .lightContent
		} else {
			return .default
		}
	}
	
	override var prefersStatusBarHidden: Bool {
		if IS_IPHONE {
			return false
		}
		return true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		moveViewWhenKeyboradAppear()
		hideKeyboardWhenTappedAround()
		
		view.backgroundColor = .brandcolor_bg
		
		automaticallyAdjustsScrollViewInsets = false
        if IS_IPAD {
            topView = CustomNav(frame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: TOP_VIEW))
            view.addSubview(topView)
        }else{
            topViewIphone = UIView()
            topViewIphone.backgroundColor = .navbrandcolor
            view.addSubview(topViewIphone)
        }
		
		tableView = UITableView(frame: CGRect(), style: .grouped)
		tableView.sectionFooterHeight = MARGIN
		tableView.sectionHeaderHeight = 0
		tableView.backgroundColor = .clear
		tableView.separatorColor = .clear
		tableView.setDynamicHeight(53)
		tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "reusecell")
        
        if typeDetailMenu == .historyPurchase {
            refreshHeader = HeaderRefreshControl(withColor: .brandcolor1, titleAttribute: Utility.setStringAttributes(string.en_pull_refresh, textColor: .brandcolor1, font: .kanitReg14, underline: false), target: (self ,#selector(reloadData)))
            if #available(iOS 10.0, *) {
                tableView.refreshControl = refreshHeader
            } else {
                tableView.insertSubview(refreshHeader, at: 0)
            }
        }
        if IS_IPAD {
            view.insertSubview(tableView, belowSubview: topView)
        }else{
            view.insertSubview(tableView, belowSubview: topViewIphone)
        }
		
		nodataView = NoDataView(view.frame)
        if IS_IPAD {
            view.insertSubview(nodataView, belowSubview: topView)
        }else{
            view.insertSubview(nodataView, belowSubview: topViewIphone)
        }
		nodataView.snp.makeConstraints {
			$0.edges.equalTo(view.snp.edges)
		}
		nodataView.hide()
        loadingView = LoadingView(withSuperview: view)
		
		fillUI()
		// Do any additional setup after loading the view.
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.isNavigationBarHidden = true
		navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
		if IS_IPHONE {
			tabBarController?.tabBar.isHidden = true
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    @objc func reloadData() {
        loadingView.startLoading()
        if refreshHeader != nil {
            refreshHeader.setTitleBeginRefreshing()
        }
        nodataView.hide()
        tableView.reloadData()
        loadingView.stopLoading()
        refreshHeader.endRefreshing()
    }
	
	fileprivate func fillUI() {
		if !isViewLoaded {
			return
		}
		
		guard let nav = nav else {
			return
		}
        if IS_IPAD {
            let navModel = CustomViewModelFromNav(withNav: nav)
            topView.viewModel = navModel
            topView.delegate = self
        }else{
            backButton = UIButton()
            backButton.setImage(UIImage(named: "backIcon"), for: .normal)
            backButton.setAnimatedTouch()
            backButton.adjustsImageWhenHighlighted = false
            backButton.adjustsImageWhenDisabled = false
            backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
            topViewIphone.addSubview(backButton)
            
            navTitleLabel = UILabel()
            navTitleLabel.setParameter(font: .navTitleFont, color: .cellWhiteLabel)
            navTitleLabel.numberOfLines = 2
            navTitleLabel.lineBreakMode = .byWordWrapping
            navTitleLabel.set(text: nav.title)
            topViewIphone.addSubview(navTitleLabel)
        }
        
        if IS_IPAD {
            topView.snp.remakeConstraints { (make) in
                make.top.equalTo(0)
                make.leading.equalTo(self.view.snp.leading)
                make.trailing.equalTo(self.view.snp.trailing)
                make.height.equalTo(TOP_VIEW)
            }
            tableView.snp.remakeConstraints { (make) in
                    make.top.equalTo(topView.snp.bottom)
                    make.leading.equalTo(view.snp.leading)
                    make.trailing.equalTo(view.snp.trailing)
                    if IS_IPAD {
                        make.bottom.equalTo(view.snp.bottom).offset(-TABBAR_HEIGHT)
                    } else {
                        make.bottom.equalTo(view.snp.bottom)
                    }
            }
        }else{
            topViewIphone.snp.remakeConstraints { (make) in
                make.top.equalTo(0)
                make.leading.equalTo(self.view.snp.leading)
                make.trailing.equalTo(self.view.snp.trailing)
                make.height.equalTo(TOP_VIEW)
            }
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topViewIphone.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.leading.equalTo(topViewIphone.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(topViewIphone.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.centerX.equalTo(topViewIphone.snp.centerX)
            }
            tableView.snp.remakeConstraints { (make) in
                make.top.equalTo(topViewIphone.snp.bottom)
                make.leading.equalTo(view.snp.leading)
                make.trailing.equalTo(view.snp.trailing)
                if IS_IPAD {
                    make.bottom.equalTo(view.snp.bottom).offset(-TABBAR_HEIGHT)
                } else {
                    make.bottom.equalTo(view.snp.bottom)
                }
            }
        }
        
		tableView.delegate = self as UITableViewDelegate
		tableView.dataSource = self as UITableViewDataSource
        view.layoutIfNeeded()
		
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		nodataView.hide()
		if typeDetailMenu == .tel {
			return DataConfig.contactInfo.count
		} else if typeDetailMenu == .profile {
			return DataConfig.editUser.count
		} else if typeUserEdit == .name {
			return DataConfig.editNameUser.count
		} else if typeUserEdit == .password {
			return DataConfig.editPassUser.count
		} else if typeUserEdit == .email {
			return DataConfig.editEmailUser.count
		} else if typeDetailMenu == .historyPurchase {
			if Validation.anyIsArrayAny(tableData, with: "payments").count == 0 {
				nodataView.show()
			}
			return Validation.anyIsArrayAny(tableData, with: "payments").count
        }
		return 0
	}
	
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reusecell", for: indexPath) as! MenuTableViewCell
            cell.editUserDelegate = nil
            if typeDetailMenu == .tel {
                if let contactCellData = DataConfig.contactInfo[indexPath.item]?.type {
                    cell.cellContactModel = (contactCellData, tableData)
                }
            } else if typeDetailMenu == .profile {
                if let editUserCellData = DataConfig.editUser[indexPath.item]?.type {
                    cell.cellEditUserModel = (editUserCellData, tableData)
                }
                nowGender = tableData["gender"] as? String ?? "male"
            } else if typeDetailMenu == .vip {
                
            } else if typeDetailMenu == .statTest {
                
            } else if typeDetailMenu == .historyTest {
                
            } else if typeDetailMenu == .historyPurchase {
                cell.cellPurchaseHistoryModel = Validation.anyIsArrayAny(tableData, with: "payments")[indexPath.item]
            } else if typeDetailMenu == .help {
                
            } else if typeUserEdit == .name {
                if let editNameUserCellData = DataConfig.editNameUser[indexPath.item]?.type {
                    cell.cellEditUserDetailModel = (editNameUserCellData, tableData)
                }
                cell.editUserDelegate = self
            } else if typeUserEdit == .password {
                if let editPassUserCellData = DataConfig.editPassUser[indexPath.item]?.type {
                    cell.cellEditUserDetailModel = (editPassUserCellData, tableData)
                }
                cell.editUserDelegate = self
            } else if typeUserEdit == .email {
                if let editEmailUserCellData = DataConfig.editEmailUser[indexPath.item]?.type {
                    cell.cellEditUserDetailModel = (editEmailUserCellData, tableData)
                }
                cell.editUserDelegate = self
            }
            return cell
    }
	
	func pickerHide(_ key: UserData) {
		if key != .birthday && datePicker != nil {
			datePicker.hidePicker()
		}
		if key != .gender && genderPicker != nil {
			genderPicker.hidePicker()
		}
	}
	
	fileprivate func clickCellEffect(_ cell: MenuTableViewCell) {
		UIView.animate(withDuration: 0.25) {
			cell.backgroundColor = .white
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
		
		if typeDetailMenu == .tel && cell.cellContactModel?.data.count != 0 {
			clickCellEffect(cell)
			if let key = cell.cellContactModel?.key, let data = cell.cellContactModel?.data {
				var parameter = ""
			
				if key == .tel {
					parameter =  "02-060-2889"
					let strUrl = "tel::\(parameter)"
					let url = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
					Utility.open(url: url!)
				} else if key == .email {
					parameter = data["email"] as! String
					let strUrl = "mailto:\(parameter)?subject=Customer Feedback"
					let url = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
					Utility.open(url: url!)
				} else if key == .line {
					parameter = data["line"] as! String
					let strUrl = "http://line.me/ti/p/~\(parameter)"
					let url = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
					if UIApplication.shared.canOpenURL(URL(string: url!)!) {
						Utility.open(url: url!)
					}
				} else if key == .instagram {
					parameter = data["instagram"] as! String
                    let strUrl = "https://www.instagram.com/sobtidgov/?hl=en"
					let url = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
					if UIApplication.shared.canOpenURL(URL(string: url!)!) {
						Utility.open(url: url!)
					}
				} else if key == .facebook {
					parameter = data["facebookId"] as! String
					let strUrl = "https://www.facebook.com/SobtidGO/"
					let url = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
					if UIApplication.shared.canOpenURL(URL(string: url!)!) {
						Utility.open(url: url!)
					}
				} else if key == .twitter {
					parameter = data["twitterId"] as! String
                    let strUrl = "https://twitter.com/sobtidme"
					let url = strUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
					if UIApplication.shared.canOpenURL(URL(string: url!)!) {
						Utility.open(url: url!)
					}
				} else if key == .company {
					Utility.openMapOffice()
				}
			}
		} else if typeDetailMenu == .profile {
			clickCellEffect(cell)
			if let key = cell.cellEditUserModel?.key, let data = cell.cellEditUserModel?.data {
				pickerHide(key)
				let bottomIfIpad: CGFloat = (IS_IPAD ? TABBAR_HEIGHT : 0)
				
				if key == .birthday {
					if datePicker == nil {
						datePicker = PickerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: PICKER_HEIGHT))
						datePicker.delegate = self
						datePicker.type = .date
					}
					if datePicker.pickerShow == false {
						if let birthday = data["birthday"] as? String, birthday != "" {
							datePicker.defaultDate = Datetime().fromThaiDate(birthday)
                            let datexxx = Datetime().fromThaiDate(birthday)
                            dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "YYYY-MM-dd"
                            datePicker.date = dateFormatter.string(from: datexxx)
						}
						datePicker.pickerShow = true
						view.addSubview(datePicker)
						datePicker.snp.remakeConstraints({ (make) in
							make.leading.equalTo(view.snp.leading)
							make.trailing.equalTo(view.snp.trailing)
							make.bottom.equalTo(view.snp.bottom).offset(-bottomIfIpad)
							make.height.equalTo(PICKER_HEIGHT)
						})
					}
				} else if key == .gender {
					if genderPicker == nil {
						genderPicker = PickerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: PICKER_HEIGHT*2/3))
						genderPicker.superViewController = self
						genderPicker.delegate = self
						genderPicker.type = .gender
					}
					if not(genderPicker.pickerShow) {
						genderPicker.pickerShow = true
						view.addSubview(genderPicker)
						genderPicker.snp.remakeConstraints({ (make) in
							make.leading.equalTo(view.snp.leading)
							make.trailing.equalTo(view.snp.trailing)
							make.bottom.equalTo(view.snp.bottom).offset(-bottomIfIpad)
							make.height.equalTo(PICKER_HEIGHT*2/3)
						})
					}
				} else if key == .phone {
					let confirmPhoneVC = ConfirmPhoneViewController()
					confirmPhoneVC.beforeView = "menu"
                    confirmPhoneVC.modalTransitionStyle = .crossDissolve
                    confirmPhoneVC.modalPresentationStyle = .fullScreen
					Utility.getCurrentViewController().present(confirmPhoneVC, animated: true, completion: nil)
				} else {
					let menuDetailView = MenuDetailView()
					menuDetailView.typeUserEdit = key
					menuDetailView.nav = Nav(title: key.rawValue, isBack: true, isRight: true, imageRight: "checkIcon", color: .navbrandcolor)
					navigationController?.pushViewController(menuDetailView, animated: true)
					menuDetailView.tableData = tableData
					
					if IS_IPHONE {
						tabBarController?.tabBar.isHidden = true
					}
				}
			}
		} else if typeDetailMenu == .historyPurchase {
			clickCellEffect(cell)
			if cell.url != nil {
				Utility.open(url: cell.url)
			}
		} else if typeUserEdit != nil {
            clickCellEffect(cell)
			cell.detailTextField.becomeFirstResponder()
        }
	}
	
	func setBirthDay(_ birthday: String) {
		updateAccount(["birthday" : Datetime().birthDate(birthday)])
	}
	@objc func setGender(_ gender: String) {
		updateAccount(["gender" : gender])
	}
	
	func cancel() {

	}
	@objc func setData(_ value: String, key: String) {
		if key == UserData.firstname.rawValue {
			name = value
		} else if key == UserData.surname.rawValue {
			surname = value
		} else if key == UserData.oldpassword.rawValue {
			oldPassword = value
		} else if key == UserData.newpassword.rawValue {
			newPassword = value
		} else if key == UserData.confirmpass.rawValue {
			confirmPass = value
		} else if key == UserData.email.rawValue {
			email = value.lowercased().trimSpace()
		}
	}
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		
	}
	
	func back() {
		if typeDetailMenu != nil {
			delegate?.closeDetail(type: typeDetailMenu!)
		}
		navigationController?.popViewController(animated: true)
	}
	
	fileprivate func dropAlertWith(_ title: String) {
		dropdownAlert.title(string.th_error, message: title, textColor: .white)
	}
	
	fileprivate func initAPI() {
		if self.api == nil {
			self.api = API()
		}
	}
	
	func next() {
		dismissKeyboard()
		var arrUpdate: dictStringAny = [:]
		if typeUserEdit == .name {
			if let name = self.name, let surname = self.surname, not(name.trimSpace().isEmpty), not(surname.trimSpace().isEmpty) {
				arrUpdate = ["name" : name,
							 "surname" : surname,
							 "displayName" : "\(name) \(surname)"]
			} else {
				dropAlertWith(string.th_fill_field)
				return
			}
		} else if typeUserEdit == .password {
			if let old = oldPassword, let new = newPassword, let confirm = confirmPass {
				if not(Validation.password(new)) {
					dropAlertWith("รหัสผ่านต้องมีความยาวอย่างน้อย 8 ตัวอักษร")
					return
				} else if new != confirm {
					dropAlertWith("รหัสผ่านใหม่ไม่ตรงกัน")
					return
				} else if old == new {
					dropAlertWith("รหัสผ่านใหม่เหมือนกับรหัสผ่านเดิม")
					return
				}
				arrUpdate = ["oldPassword": old.genPassword(),
							 "newPassword": new.genPassword()]
			} else {
				dropAlertWith(string.th_fill_field)
				return
			}
		} else if typeUserEdit == .email {
			if let email = self.email, Validation.email(email) {
				arrUpdate = ["email" : email ]
			} else {
				return
			}
		}
        let confirmAlert = UIAlertController(title: "Alert", message: "คุณยืนยันที่จะเปลี่ยน\(typeUserEdit!.rawValue)", preferredStyle: UIAlertController.Style.alert)
		confirmAlert.addAction(UIAlertAction(title: string.th_cancel, style: .cancel, handler: nil))
		confirmAlert.addAction(UIAlertAction(title: string.th_confirm, style: .default, handler: { action in
			if self.typeUserEdit == .name {
				self.updateAccount(arrUpdate)
			} else if self.typeUserEdit == .password {
				self.changePassword(arrUpdate)
			} else if self.typeUserEdit == .email {
				self.initAPI()
				self.api.duplicateEmail({ (finished, _) in
					if finished {
						self.changeEmail(arrUpdate)
					} else {
						dropdownAlert.title(string.th_error, message: "มีอีเมลนี้อยู่ในระบบ", backgroundColor: .errorRed, textColor: .white)
					}
				}, email: self.email!)
			}
		}))
		Utility.getCurrentViewController().present(confirmAlert, animated: true, completion: nil)
	}

	func changePassword(_ value: dictStringAny) {
		initAPI()
		api.changePassword({ (finished, response) in
			if finished {
				self.showSuccessAlert("เปลี่ยนรหัสผ่านเรียบร้อย")
			} else {
				let error = response!["error"] as! [String: String]
				if error["description"] == "Password not match" {
                    let errorAlert = UIAlertController(title: string.th_fail_process, message: string.th_old_pass_notcorrect, preferredStyle: UIAlertController.Style.alert)
					errorAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: nil))
					Utility.getCurrentViewController().present(errorAlert, animated: true, completion: nil)
				}
			}
		}, value: value)
	}
	fileprivate func showSuccessAlert(_ detail: String) {
        let successAlert = UIAlertController(title: string.th_purchase_success, message: detail, preferredStyle: UIAlertController.Style.alert)
		successAlert.addAction(UIAlertAction(title: string.th_ok, style: .default, handler: { action in self.back() }))
		Utility.getCurrentViewController().present(successAlert, animated: true, completion: nil)
	}
	
	func changeEmail(_ value: dictStringAny) {
		api.updateEmail({ (finished, response) in
			if finished {
				let detail = "เปลี่ยนอีเมลเรียบร้อย"
				self.showSuccessAlert(detail)
			} else {
				
			}
		}, value: value)
	}
	func updateAccount(_ value: dictStringAny) {
		initAPI()
		api.updateAccount({ (finished, response) in
			if finished {
				if self.typeDetailMenu == nil {
					self.back()
				}
			} else {
                let errorAlert = UIAlertController(title: string.th_fail_process, message: string.th_try_again, preferredStyle: UIAlertController.Style.alert)
				errorAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: nil))
				Utility.getCurrentViewController().present(errorAlert, animated: true, completion: nil)
			}
		}, value: value)
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return genderData.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return genderData[row].genderThai()
	}
	func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return 44
	}
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		nowGender = genderData[row]
	}
}
