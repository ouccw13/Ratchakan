//
//  MenuViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 7/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import ObjectMapper
import SwiftJWT
class MenuViewController: CustomUIViewControllerNoNav, UISplitViewControllerDelegate, selectMenuDelegate, MenuDetailDelegate {

    lazy var globalParameter = GlobalParameter.storeObserverSharedInstance
    
    var splitMenuView: UISplitViewController!
    var menuView: MenuMasterView!
    var menuDetailView: MenuDetailView!
    var api: API!
    var listenerAccount: ListenerRegistration!
    var member: dictStringAny!
    let userDefaultData = UserDefaultData.storeObserverSharedInstance
    
    fileprivate func setTabelDataFromVersion() {
        menuView.tableData = DataConfig.tableUserMenuTell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .brandcolor_bg
        
        splitMenuView = UISplitViewController()
        splitMenuView.delegate = self

        api = API()
        listenNotiLogInOut(#selector(receiveNoti(_:)))
        
        menuView = MenuMasterView()
        menuView.delegate = self

        let master = UINavigationController()
        master.viewControllers = [menuView]
        splitMenuView.viewControllers = [master]
        
        if api.getMember().member_id != "" {
            setTabelDataFromVersion()
        }
        if IS_IPAD {
          if #available(iOS 18.0, *) {
                print("✅ Running on iPadOS 18.0 or later")
            } else {
                print("⬇️ Running on older iOS version")
                menuDetailView = MenuDetailView()
                menuDetailView.delegate = self
                if api.getMember().member_id == "" {
                    menuDetailView.typeDetailMenu = .tel
                    menuDetailView?.nav = Nav(title: string.th_contactUs, isBack: false, isRight: false, color: UIColor.navbrandcolor)
                    loadDetailData(.tel, title: string.th_contactUs)
                }
                else {
                    menuDetailView.typeDetailMenu = .profile
                    menuDetailView?.nav = Nav(title: string.th_edit_user, isBack: false, isRight: false, color: UIColor.navbrandcolor)
                    loadDetailData(.profile, title: string.th_edit_user)
                }
                let detail = UINavigationController()
                
                detail.viewControllers = [menuDetailView]
                
                splitMenuView.preferredDisplayMode = .allVisible
                splitMenuView.viewControllers = [master, detail]
            }
        }
        
        insertChildController(splitMenuView, intoParentView: view)
        
        fillUI()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func fillUI() {
        if !isViewLoaded {
            return
        }
        
    }
    
    @objc func logOut() {
        api.logOut({ (finished, responsed) in
            if finished {
                let userData = UserDefaultData.storeObserverSharedInstance
                userData.logout()
                self.menuView.tableData = DataConfig.tableGuestMenuTell
                if IS_IPAD {
                    self.loadDetailData(.tel, title: string.th_contactUs)
                }
            }
        })
    }
    @objc func logIn() {
        setTabelDataFromVersion()
        if IS_IPAD {
            loadDetailData(.profile, title: string.th_edit_user)
        }
    }
    
    func select(key: MenuCellType, withTitle title: String) {
        if !DataConfig.nonUserInteraction.contains(key) {
            let db = api.getDatabase()
            if key == .logout {
                let confirmAlert = UIAlertController(title: "ต้องการออกจากระบบ?", message: nil, preferredStyle: UIAlertController.Style.alert)
                confirmAlert.addAction(UIAlertAction(title: string.th_cancel, style: .cancel, handler: nil))
                confirmAlert.addAction(UIAlertAction(title: string.th_confirm, style: .default, handler: { action in
                    self.logOut()
                }))
                present(confirmAlert, animated: true, completion: nil)
            } else if key == .profile || key == .editUserData || key == .login {
                if Utility.checkLogIn(member: db.getMember()) {
                    loadDetailData(.profile, title: string.th_edit_user)
                }
            } else if key == .deleteAccount {
                let appleData = api.getDatabase().getAppleResponse()
                let appleToken = appleData["appleToken"] as? String ?? ""
                if appleToken != "" {
                    Utility.dialogConfirmRevoked(title: string.th_deleteAccountHeader, isShowButton: true,isShowTextField: true,isNotAppleId: false) {
                        self.deleteAccountandRevokedAppleId()
                    }
                }else{
                    Utility.dialogConfirmRevoked(title: string.th_deleteAccountHeader, isShowButton: true,isShowTextField: false,isNotAppleId: true) {
                        self.member = self.api.getDatabase().getMember()
                        let email = self.member["email"] as? String ?? ""
                        let phoneNumber = self.member["phoneNumber"] as? String ?? ""
                        let memberID = self.api.member_id ?? ""
                        if email != "" || phoneNumber != "" {
                            self.requestOTPforAccountDelete(memberID: memberID)
                        }else{
                            Utility.dialogConfirmAccountDeleteMemberforNoPhoneORNoNoEmail(title: "กรุณากรอก อีเมล หรือ เบอร์โทรศัพท์ ที่ต้องการให้ส่ง OTP") { (emailOrPhoneNumber) in
                                self.requestOTPforAccountDelete(memberID: memberID, emailOrPhoneNumber: emailOrPhoneNumber)
                            }
                        }
                    }
                }
            }
            else {
                loadDetailData(key, title: title)
            }
        }
    }
    
    fileprivate func createMenuDetailView(_ title: String, withKey key: MenuCellType) {
        if IS_IPAD {
            if key != .profile && key != .editUserData {
                menuDetailView.pickerHide(.phone)
                if listenerAccount != nil {
                    listenerAccount.remove()
                    listenerAccount = nil
                }
            }
            menuDetailView.delegate = self
            menuDetailView.typeDetailMenu = key
            menuDetailView!.nav = Nav(title: title, isBack: false, isRight: false, color: UIColor.navbrandcolor)
            menuDetailView?.tableData = [:]
        }
        else {
            menuDetailView = MenuDetailView()
            menuDetailView.delegate = self
            menuDetailView.typeDetailMenu = key
            menuDetailView!.nav = Nav(title: title, isBack: true, isRight: false, color: UIColor.navbrandcolor)
            navigationController?.pushViewController(self.menuDetailView!, animated: true)
            
            tabBarController?.tabBar.isHidden = true
        }
    }
    
    func loadDetailData(_ key: MenuCellType,title: String) {
        if key == .historyTest {
            let examHistoryView = ExamHistoryViewController()
            navigationController?.pushViewController(examHistoryView, animated: true)
        } else if key == .statTest {
            let examStatView = StatSubjectGroupViewController()
            navigationController?.pushViewController(examStatView, animated: true)
        } else if key == .vip {
            let packageView = PagePackageViewController()
            navigationController?.pushViewController(packageView, animated: true)
        } else if key == .termOfCondition {
            let termVC = TermOfServiceViewController()
            termVC.isMenu = true
            navigationController?.pushViewController(termVC, animated: true)
        } else if key == .privacy {
            let privacyVC = PrivacyOfPoliciesViewController()
            privacyVC.isMenu = true
            navigationController?.pushViewController(privacyVC, animated: true)
        } else if key == .deleteAccount {
            let deleteAccountAppleViewController = DeleteAccountAppleViewController()
            navigationController?.pushViewController(deleteAccountAppleViewController, animated: true)
        }else if key == .profile || key == .editUserData {
            if #available(iOS 18.0, *) {
                print("✅ Running on iPadOS 18.0 or later")
                let contactUsViewController = EditProfileViewController()
                contactUsViewController.titleNav = string.th_edit_user
                 navigationController?.pushViewController(contactUsViewController, animated: true)
            } else {
                print("⬇️ Running on older iOS version")
                createMenuDetailView(title, withKey: key)
                if key == .profile || key == .editUserData {
                    if listenerAccount != nil {
                        listenerAccount.remove()
                    }
                    menuDetailView.tableData = api.getDatabase().getMember()
                    let db = Firestore.firestore()
                    listenerAccount = db.collection("members").document(api.member_id!).addSnapshotListener({ (documentSnapshot, error) in
                        guard let document = documentSnapshot else {
                            print("Error fetching snapshots: \(error!)")
                            return
                        }
                        if document.exists {
                            self.api.getDatabase().updateMyAccount(response: document.data()! as [String : AnyObject])
                            if self.menuView.tableView != nil {
                                self.menuView.tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
                            }
                            if self.menuDetailView.typeDetailMenu == .profile || self.menuDetailView.typeDetailMenu == .editUserData{
                                self.menuDetailView.tableData = document.data()!
                            }
                        } else {

                        }
                    })
                } else if key == .historyPurchase {
                    api.getPaymentHistory({ (finished, response) in
                        if finished {
                            if self.menuDetailView.typeDetailMenu == .historyPurchase {
                                let tableData = ["payments" : Utility.sortArrayOfDictionary(Validation.anyIsArrayAny(Validation.anyIsDictionary(response!, with: "result"), with: "payments") , withInt: "createdAt", ascending: false)]
                                self.menuDetailView.tableData = tableData
                            }
                        }
                        return
                    })
                } else if key == .tel {
                    api.getContactUs({ (finished, response) in
                        if finished {
                            if self.menuDetailView.typeDetailMenu == .tel {
                                self.menuDetailView?.tableData = response!["result"] as! [String : Any]
                            }
                        }
                        return
                    })
                }
                else {
                    api.getHelpUs({ (finished, response) in
                        if finished {
                            if self.menuDetailView.typeDetailMenu == .help {
                                self.menuDetailView?.tableData = (response!["result"] as! [[String : Any]]).first!
                            }
                        }
                        return
                    })
                }
            }
        }
        else if key == .historyPurchase {
            if #available(iOS 18.0, *) {
                print("✅ Running on iPadOS 18.0 or later")
                let contactUsViewController = HistoryPurchaseViewController()
                contactUsViewController.titleNav = string.th_purchase_history
                 navigationController?.pushViewController(contactUsViewController, animated: true)
            } else {
                print("⬇️ Running on older iOS version")
                createMenuDetailView(title, withKey: key)
                if key == .profile || key == .editUserData {
                    if listenerAccount != nil {
                        listenerAccount.remove()
                    }
                    menuDetailView.tableData = api.getDatabase().getMember()
                    let db = Firestore.firestore()
                    listenerAccount = db.collection("members").document(api.member_id!).addSnapshotListener({ (documentSnapshot, error) in
                        guard let document = documentSnapshot else {
                            print("Error fetching snapshots: \(error!)")
                            return
                        }
                        if document.exists {
                            self.api.getDatabase().updateMyAccount(response: document.data()! as [String : AnyObject])
                            if self.menuView.tableView != nil {
                                self.menuView.tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
                            }
                            if self.menuDetailView.typeDetailMenu == .profile || self.menuDetailView.typeDetailMenu == .editUserData{
                                self.menuDetailView.tableData = document.data()!
                            }
                        } else {

                        }
                    })
                } else if key == .historyPurchase {
                    api.getPaymentHistory({ (finished, response) in
                        if finished {
                            if self.menuDetailView.typeDetailMenu == .historyPurchase {
                                let tableData = ["payments" : Utility.sortArrayOfDictionary(Validation.anyIsArrayAny(Validation.anyIsDictionary(response!, with: "result"), with: "payments") , withInt: "createdAt", ascending: false)]
                                self.menuDetailView.tableData = tableData
                            }
                        }
                        return
                    })
                } else if key == .tel {
                    api.getContactUs({ (finished, response) in
                        if finished {
                            if self.menuDetailView.typeDetailMenu == .tel {
                                self.menuDetailView?.tableData = response!["result"] as! [String : Any]
                            }
                        }
                        return
                    })
                }
                else {
                    api.getHelpUs({ (finished, response) in
                        if finished {
                            if self.menuDetailView.typeDetailMenu == .help {
                                self.menuDetailView?.tableData = (response!["result"] as! [[String : Any]]).first!
                            }
                        }
                        return
                    })
                }
            }
        }else if key == .tel {
            if #available(iOS 18.0, *) {
                print("✅ Running on iPadOS 18.0 or later")
                let contactUsViewController = ContactUsViewController()
                contactUsViewController.titleNav = string.th_contactUs
                 navigationController?.pushViewController(contactUsViewController, animated: true)
            } else {
                print("⬇️ Running on older iOS version")
                createMenuDetailView(title, withKey: key)
                if key == .profile || key == .editUserData {
                    if listenerAccount != nil {
                        listenerAccount.remove()
                    }
                    menuDetailView.tableData = api.getDatabase().getMember()
                    let db = Firestore.firestore()
                    listenerAccount = db.collection("members").document(api.member_id!).addSnapshotListener({ (documentSnapshot, error) in
                        guard let document = documentSnapshot else {
                            print("Error fetching snapshots: \(error!)")
                            return
                        }
                        if document.exists {
                            self.api.getDatabase().updateMyAccount(response: document.data()! as [String : AnyObject])
                            if self.menuView.tableView != nil {
                                self.menuView.tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
                            }
                            if self.menuDetailView.typeDetailMenu == .profile || self.menuDetailView.typeDetailMenu == .editUserData{
                                self.menuDetailView.tableData = document.data()!
                            }
                        } else {

                        }
                    })
                } else if key == .historyPurchase {
                    api.getPaymentHistory({ (finished, response) in
                        if finished {
                            if self.menuDetailView.typeDetailMenu == .historyPurchase {
                                let tableData = ["payments" : Utility.sortArrayOfDictionary(Validation.anyIsArrayAny(Validation.anyIsDictionary(response!, with: "result"), with: "payments") , withInt: "createdAt", ascending: false)]
                                self.menuDetailView.tableData = tableData
                            }
                        }
                        return
                    })
                } else if key == .tel {
                    api.getContactUs({ (finished, response) in
                        if finished {
                            if self.menuDetailView.typeDetailMenu == .tel {
                                self.menuDetailView?.tableData = response!["result"] as! [String : Any]
                            }
                        }
                        return
                    })
                }
                else {
                    api.getHelpUs({ (finished, response) in
                        if finished {
                            if self.menuDetailView.typeDetailMenu == .help {
                                self.menuDetailView?.tableData = (response!["result"] as! [[String : Any]]).first!
                            }
                        }
                        return
                    })
                }
            }
        }
        else {
            createMenuDetailView(title, withKey: key)
            if key == .profile || key == .editUserData {
                if listenerAccount != nil {
                    listenerAccount.remove()
                }
                menuDetailView.tableData = api.getDatabase().getMember()
                let db = Firestore.firestore()
                listenerAccount = db.collection("members").document(api.member_id!).addSnapshotListener({ (documentSnapshot, error) in
                    guard let document = documentSnapshot else {
                        print("Error fetching snapshots: \(error!)")
                        return
                    }
                    if document.exists {
                        self.api.getDatabase().updateMyAccount(response: document.data()! as [String : AnyObject])
                        if self.menuView.tableView != nil {
                            self.menuView.tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
                        }
                        if self.menuDetailView.typeDetailMenu == .profile || self.menuDetailView.typeDetailMenu == .editUserData{
                            self.menuDetailView.tableData = document.data()!
                        }
                    } else {

                    }
                })
            } else if key == .historyPurchase {
                api.getPaymentHistory({ (finished, response) in
                    if finished {
                        if self.menuDetailView.typeDetailMenu == .historyPurchase {
                            let tableData = ["payments" : Utility.sortArrayOfDictionary(Validation.anyIsArrayAny(Validation.anyIsDictionary(response!, with: "result"), with: "payments") , withInt: "createdAt", ascending: false)]
                            self.menuDetailView.tableData = tableData
                        }
                    }
                    return
                })
            } else if key == .tel {
                api.getContactUs({ (finished, response) in
                    if finished {
                        if self.menuDetailView.typeDetailMenu == .tel {
                            self.menuDetailView?.tableData = response!["result"] as! [String : Any]
                        }
                    }
                    return
                })
            }
            else {
                api.getHelpUs({ (finished, response) in
                    if finished {
                        if self.menuDetailView.typeDetailMenu == .help {
                            self.menuDetailView?.tableData = (response!["result"] as! [[String : Any]]).first!
                        }
                    }
                    return
                })
            }
        }
    }
    
    @objc fileprivate func receiveNoti(_ sender: NSNotification) {
        api = API()
        if Utility.checkLogIn(member: api.getDatabase().getMember()) {
            setTabelDataFromVersion()
            if IS_IPAD {
                loadDetailData(.profile, title: string.th_edit_user)
            }
        }
    }
    
    func closeDetail(type: MenuCellType) {
        if type == .profile || type == .editUserData {
            listenerAccount.remove()
            listenerAccount = nil
        }
    }
    
    // MARK: get OTP AccountDelete member Email Or Phone
    func requestOTPforAccountDelete(memberID: String) {
        let parameters: Parameters = [:]
        api.requestOTPforAccountDelete(memberId: memberID, parameter: parameters) { (finished,response) in
            if finished {
                let result = Mapper<ResultOTPModel>().map(JSON: response ?? [:])
                let message = result?.result?.massage ?? ""
                Utility.dialogConfirmAccountDeleteMember(title: message, emailOrPhone: "") { (otpCode) in
                    self.verifyOtpAccountDelete(otpCode: otpCode,memberId: memberID)
                }
            }else{
                let confirmAlert = UIAlertController(title: "เกิดข้อผิดพลาด", message: "ไม่สามารถเชื่อมต่อ API ได้", preferredStyle: UIAlertController.Style.alert)
                confirmAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: { action in
                }))
                self.present(confirmAlert, animated: true, completion: nil)
            }
        }
    }

    func requestOTPforAccountDelete(memberID: String,emailOrPhoneNumber:String) {
        var parameter: Parameters = [:]
        if Validation.email(emailOrPhoneNumber) {
            parameter = [
                "email": emailOrPhoneNumber
            ]
        }else if Validation.tel(emailOrPhoneNumber){
            parameter = [
                "phoneNumber": emailOrPhoneNumber
            ]
        }
        api.requestOTPforAccountDelete(memberId: memberID, parameter: parameter) { (finished,response) in
            if finished {
                let result = Mapper<ResultOTPModel>().map(JSON: response ?? [:])
                let message = result?.result?.massage ?? ""
                Utility.dialogConfirmAccountDeleteMember(title: message, emailOrPhone: emailOrPhoneNumber) { (otpCode) in
                    self.verifyOtpAccountDelete(otpCode: otpCode,memberId: memberID)
                }
            }else{
                let confirmAlert = UIAlertController(title: "เกิดข้อผิดพลาด", message: "ไม่สามารถเชื่อมต่อ API ได้", preferredStyle: UIAlertController.Style.alert)
                confirmAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: { action in
                }))
                self.present(confirmAlert, animated: true, completion: nil)
            }
        }
    }
    
    func verifyOtpAccountDelete(otpCode: String,memberId:String) {
        let parameters: Parameters = [
            "otpCode": otpCode
        ]
        api.verifyOtpAccountDelete(memberId: memberId, parameter: parameters) {
            (finished,response) in
            if finished {
                let result = Mapper<ResultOTPModel>().map(JSON: response ?? [:])
                let message = result?.result?.massage ?? ""
                if message == "ตรวจสอบ OTP สำเร็จ" || result?.status == 200 {
                    self.deleteAccountEmailOrPhone(memberId: memberId)
                }else{
                    let confirmAlert = UIAlertController(title: message, message: "", preferredStyle: UIAlertController.Style.alert)
                    confirmAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: { action in
                    }))
                    self.present(confirmAlert, animated: true, completion: nil)
                }
            }else{
                let result = Mapper<ErrorVerifyOTPModel>().map(JSON: response ?? [:])
                let message = result?.error?.message ?? ""
                let confirmAlert = UIAlertController(title: message, message: "", preferredStyle: UIAlertController.Style.alert)
                confirmAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: { action in
                }))
                self.present(confirmAlert, animated: true, completion: nil)
            }
        }
    }
    
    func deleteAccountEmailOrPhone(memberId:String) {
        if memberId != "" {
            api.deleteAccount(memberId: memberId) { (finished,response) in
                if finished {
                    let confirmAlert = UIAlertController(title: "ระบบทำการลบบัญชีผู้ใช้เรียบร้อยแล้ว", message: nil, preferredStyle: UIAlertController.Style.alert)
                    confirmAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: { action in
                        self.userDefaultData.logout()
                        self.api.getDatabase().memberIsDelete()
                        Utility.showLogInView()
                    }))
                    Utility.getCurrentViewController().present(confirmAlert, animated: true, completion: nil)
                }else{

                }
            }
        }else{
            let confirmAlert = UIAlertController(title: "ไม่สามารถลบบัญชีผู้ใช้ได้", message: nil, preferredStyle: UIAlertController.Style.alert)
            confirmAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: { action in
            }))
            Utility.getCurrentViewController().present(confirmAlert, animated: true, completion: nil)
        }
    }
    
    func deleteAccountandRevokedAppleId(){
        // MARK: Create JWT type ES256
        // MARK: Assign developer information and token expiration setting
        let myHeader = Header(kid: "key_id")
        let payload = ClaimsES256(iss: "team_id", iat: Date().timeIntervalSince1970, exp: (Date().timeIntervalSince1970 + TimeInterval(15552000)), aud: "https://appleid.apple.com", sub: "bundle_id")
        var myJwt = JWT(header: myHeader,claims: payload)
        let privateKeyPath = Bundle.main.url(forResource: "name_p8_file", withExtension: "p8")
        let privateKey: Data = try! Data(contentsOf: privateKeyPath!,options: .alwaysMapped)
        let jwtSigner = JWTSigner.es256(privateKey: privateKey)
        let signJWT = try! myJwt.sign(using: jwtSigner)
        // MARK: เอา authorizationCode base64String ที่ได้จาก signinWithapple ไปทำการ decoded ก่อน แล้วถึงนำไปใช้เรียก
        let appleData = api.getDatabase().getAppleResponse()
        let authorizationcode = appleData["authorizationcode"] as! String
        let decodedAuthCode = authorizationcode.base64Decoded()
        // MARK: Call Request api https://appleid.apple.com/auth/token (Generate and validate tokens JWT)
        let paramString: Parameters = [
            "client_id" : Bundle.main.bundleIdentifier!,
            "client_secret": signJWT,
            "code": decodedAuthCode ?? "",
            "grant_type": "authorization_code"
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Content-Length": "0",
            "Host": "appleid.apple.com"
        ]
        AF.request("https://appleid.apple.com/auth/token",method: .post, parameters: paramString,encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            switch(response.result) {
            case .success(let value):
                if let data = value as? [String: AnyObject] {
                    if response.response?.statusCode == 200 {
                        if let access_token = data["access_token"]  {
                            self.revokedToken(signJWT: signJWT, accessToken: access_token as! String)
                        }
                    }else{
                        let confirmAlert = UIAlertController(title: "\(response.response?.statusCode ?? 0)", message: "\(response.error?.localizedDescription ?? "ไม่สามารถเชื่อมต่อระบบได้")", preferredStyle: UIAlertController.Style.alert)
                        confirmAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: { action in
                        }))
                        self.present(confirmAlert, animated: true, completion: nil)
                    }
                }
            case .failure(_):
                let confirmAlert = UIAlertController(title: "เกิดข้อผิดพลาด", message: "ไม่สามารถเชื่อมต่อระบบได้", preferredStyle: UIAlertController.Style.alert)
                confirmAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: { action in
                }))
                self.present(confirmAlert, animated: true, completion: nil)
            }
        }
    }
    func revokedToken(signJWT:String,accessToken:String) {
        // MARK: Call Request api https://appleid.apple.com/auth/revoke (revoked appleId and delete account)
        let paramString: Parameters = [
            "client_id" : Bundle.main.bundleIdentifier!,
            "client_secret": signJWT,
            "token": accessToken,
            "token_type_hint": "access_token"
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Content-Length": "0",
            "Host": "appleid.apple.com"
        ]
        AF.request("https://appleid.apple.com/auth/revoke",method: .post, parameters: paramString,encoding: URLEncoding.httpBody, headers: headers).responseString { (response) in
            switch(response.result) {
            case .success(_):
                if response.response?.statusCode == 200 {
                    let confirmAlert = UIAlertController(title: "บัญชีที่ผูก apple id ถูกลบเรียบร้อยแล้ว", message: nil, preferredStyle: UIAlertController.Style.alert)
                    confirmAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: { action in
                        self.userDefaultData.logout()
                        self.api.getDatabase().memberSignout()
                    }))
                    Utility.getCurrentViewController().present(confirmAlert, animated: true, completion: nil)
                }
            case .failure(_):
                let confirmAlert = UIAlertController(title: "เกิดข้อผิดพลาด", message: "ไม่สามารถเชื่อมต่อระบบได้", preferredStyle: UIAlertController.Style.alert)
                confirmAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: { action in
                }))
                self.present(confirmAlert, animated: true, completion: nil)
            }
        }
    }
}
