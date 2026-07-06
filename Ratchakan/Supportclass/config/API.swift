//
//  API.swift
//  ratchakan
//
//  Created by JJsobtid on 13/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import FirebaseMessaging
//import FirebaseFirestore
typealias complete = (_ complete: Bool, _ response: [String:Any]?) -> Void
typealias completeWithListener = (_ complete: Bool, _ response: [String:Any]?, _ listenerPath: ListenerRegistration) -> Void

let tokenKey = "STGOVTOKEN"
let pretests = "pretests"//_test"
let promotions = "pretest_promotions"//_test"
let testpretest = false

func print(str: Any) {
    #if DEBUG
	print(str)
    #endif
}

class API: NSObject {
	var db: Databases?
    let userDefaultData = UserDefaultData.storeObserverSharedInstance
    let memberDefaultData = MemberDefaultData.storeObserverSharedInstance
	var param: [String:AnyObject]?
	var member_id, token, email, date, key, member_exam_session, member_exam_id, listener_path_random, plan_exp: String?
	var packages: [String:Int] = [:]
	var question_number: Int?
	var defaultFirestore: Firestore! = Firestore.firestore()
	
	// MARK: - INIT
	fileprivate func initDB() {
		db = Databases(databaseFilename: "database")
		member_id = ""
		token = ""
		plan_exp = "0"
		email = ""
        let member = db?.getMember()
		if member!["memberId"] != nil {
			member_id = member?["memberId"] as? String
		}
		if member!["token"] != nil {
			token = member?["token"] as? String
		}
		if member!["plan_expire"] != nil {
			plan_exp = member?["plan_expire"] as? String
		}
		if member!["email"] != nil {
			email = member?["email"] as? String
		}
		if let package = member!["packages"] {
			packages = package as! [String:Int]
		}
	}
	
	override init() {
		super.init()
		param = [:]
		initDB()
	}
	
	init(withoutdb db: Bool) {
		super.init()
		param = [:]
		self.db = Databases(databaseFilename: "database")
		member_id = ""
		token = ""
		plan_exp = "0"
	}
	
	func getDatabase() -> Databases {
		return db!
	}
	func getMember() -> member {
		return db!.getMembermodel().first!
	}
	
	// MARK: - REQUEST
	fileprivate func logAPI(_ url: String, _ typeRequest: String, _ parameter: [String : Any]) {
		//log API
		if url != Path.getiTunes {
            print("Test Logger API: ", "[\(typeRequest)]\nURL : \(url)\nParameter : \(Utility.jsonLog(parameter))")
		}
	}
	
    fileprivate func makeRequest(url: String, parameter: [String:Any] = [:], complete: @escaping complete) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        logAPI(url, "POST", parameter)
        
        
        let header : HTTPHeaders = ["Authorization": UserDefaults.standard.string(forKey: tokenKey) ?? token ?? ""]
        AF.request(url, method:  .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let value = try JSONSerialization.jsonObject(with: data, options: [])
                    if let json = value as? [String:AnyObject] {
                        guard let res = response.response else {
                            complete(true, json)
                            return
                        }
                        guard let error = json["error"] as? [String: AnyObject] else {
                            print("[SUCCESS] : \(json)")
                            complete(true, json)
                            return
                        }
                        if error.count > 0 {
                            if json["status"] as? Int == 401 {
                                self.userDefaultData.logout()
                                self.memberDefaultData.logout()
                                self.getDatabase().memberSignout()
                            }else{
                                complete(false, json)
                            }
                        }else{
                            print("OK 200 SUCCESS : \(res.statusCode)")
                            print("Response Success Data: \(Utility.jsonLog(json))")
                            complete(true, json)
                            return
                        }
                    }else if let jsonArray = value as? [[String: AnyObject]] {
                        complete(true, ["result": jsonArray])
                    }else{
                        complete(false, ["message": "Invalid JSON format"])
                    }
                }catch {
                    print("JSON parse error: \(error)")
                }
            case .failure(let error):
                print("Failed MAKE Request (POST) error data: \(response.result)")
                print("error calling MAKE (POST) on /todos/1")
                print(error)
                complete(false, ["message": error.localizedDescription])
                return
            }
        }
    }
    
    func postRequest(url: String, parameter: [String:Any] = [:], complete: @escaping complete) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        logAPI(url, "POST", parameter)
        
        let header : HTTPHeaders = ["Authorization": UserDefaults.standard.string(forKey: tokenKey) ?? token ?? ""]
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let value = try JSONSerialization.jsonObject(with: data, options: [])
                    if let json = value as? [String: AnyObject] {
                        guard let res = response.response else {
                            complete(true, json)
                            return
                        }
                        guard let error = json["error"] as? [String: AnyObject] else {
                            print("[SUCCESS] : \(json)")
                            complete(true, json)
                            return
                        }
                        if error.count > 0 {
                            if json["status"] as? Int == 401 {
                                self.userDefaultData.logout()
                                self.memberDefaultData.logout()
                                self.getDatabase().memberSignout()
                            }else{
                                complete(false, json)
                            }
                        }else{
                            print("OK 200 SUCCESS: \(res.statusCode)")
                            print("Response Success Data: \(Utility.jsonLog(json))")
                            complete(true, json)
                            return
                        }
                    }else if let jsonArray = value as? [[String:AnyObject]] {
                        complete(true, ["result": jsonArray])
                    }else{
                        complete(false, ["message": "Invalid JSON format"])
                    }
                }catch {
                    print("JSON parse error: \(error)")
                    complete(false, ["message": error.localizedDescription])
                }
            case .failure(let error):
                print("Failed POST Request error data: \(response.result)")
                print(error)
                complete(false, ["message": error.localizedDescription])
                return
            }
        }
    }

    fileprivate func deleteRequest(url:String,parameter:[String:Any] = [:], complete: @escaping complete) {
        logAPI(url, "DELETE", parameter)
        let header : HTTPHeaders = ["Authorization": UserDefaults.standard.string(forKey: tokenKey) ?? token ?? ""]
        AF.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: header).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let value = try JSONSerialization.jsonObject(with: data, options: [])
                    if let json = value as? [String: AnyObject] {
                        guard let res = response.response else {
                            complete(true, json)
                            return
                        }
                        guard let error = json["error"] as? [String: AnyObject] else {
                            print("[SUCCESS]: \(json)")
                            complete(true, json)
                            return
                        }
                        if error.count > 0 {
                            if json["status"] as? Int == 401 {
                                self.userDefaultData.logout()
                                self.memberDefaultData.logout()
                                self.getDatabase().memberSignout()
                            }else {
                                complete(false, json)
                            }
                        }else {
                            print("OK 200 SUCCESS: \(res.statusCode)")
                            print("Response Success Data: \(Utility.jsonLog(json))")
                            complete(true, json)
                            return
                        }
                    }else if let jsonArray = value as? [[String: AnyObject]] {
                        complete(true, ["result": jsonArray])
                    }else{
                        complete(false, ["message": "Invalid JSON format"])
                    }
                }catch {
                    print("JSON parse error: \(error)")
                    complete(false, ["message": error.localizedDescription])
                }
            case .failure(let error):
                print("Failed DELETE request error data: \(response.result)")
                print("error calling DELETE on /todos/1")
                print(error)
                complete(false, ["message": error.localizedDescription])
                return
            }
        }
    }
    fileprivate func putRequest(url: String, parameter: [String:Any] = [:], complete: @escaping complete) {
        
        logAPI(url, "PUT", parameter)
        
        let header : HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: tokenKey) ?? token ?? ""]
        AF.request(url, method: .put, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let value = try JSONSerialization.jsonObject(with: data, options: [])
                    if let json = value as? [String: AnyObject] {
                        guard let res = response.response else {
                            complete(true, json)
                            return
                        }
                        guard let error = json["error"] as? [String: AnyObject] else {
                            print("[SUCCESS]: \(json)")
                            complete(true, json)
                            return
                        }
                        if error.count > 0 {
                            if json["status"] as? Int == 401 {
                                self.userDefaultData.logout()
                                self.memberDefaultData.logout()
                                self.getDatabase().memberSignout()
                            }else{
                                complete(false, json)
                            }
                        }else{
                            print("OK 200 SUCCESS: \(res.statusCode)")
                            print("Response Success Data: \(Utility.jsonLog(json))")
                            complete(true, json)
                            return
                        }
                    }else if let jsonArray = value as? [[String: AnyObject]] {
                        complete(true, ["result": jsonArray])
                    }else{
                        complete(false, ["message": "Invalid JSON format"])
                    }
                }catch {
                    print("JSON parse error: \(error)")
                    complete(false, ["message": error.localizedDescription])
                }
            case.failure(let error):
                print("Failed PUT request error: \(error)")
                print("error calling PUT on /todos/1")
                print(error)
                complete(false, ["message": error.localizedDescription])
                return
            }
        }
    }
	
    fileprivate func getRequest(url: String, complete: @escaping complete) {
        
        logAPI(url, "GET", [:])
        let header : HTTPHeaders = ["Authorization": UserDefaults.standard.string(forKey: tokenKey) ?? token ?? ""]
        AF.request(url, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: url == Path.intro || url == Path.examGroup || url == Path.token ? nil : header).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let value = try JSONSerialization.jsonObject(with: data, options: [])
                    if let json = value as? [String: AnyObject] {
                        guard let res = response.response else {
                            complete(true, json)
                            return
                        }
                        guard let error = json["error"] as? [String: AnyObject] else {
                            print("[SUCCESS]: \(json)")
                            complete(true, json)
                            return
                        }
                        if error.count > 0 {
                            if json["status"] as? Int == 401 {
                                self.userDefaultData.logout()
                                self.memberDefaultData.logout()
                                self.getDatabase().memberSignout()
                            }else{
                                complete(false, error)
                            }
                        }else{
                            print("OK 200 SUCCESS: \(res.statusCode)")
                            print("Response Success data: \(Utility.jsonLog(json))")
                            complete(true, json)
                            return
                        }
                    }else if let jsonArray = value as? [[String: AnyObject]] {
                        complete(true, ["result": jsonArray])
                    }else{
                        complete(false, ["message": "Invalid JSON format"])
                    }
                }catch {
                    print("JSON parse error: \(error)")
                    complete(false, ["message": error.localizedDescription])
                }
            case .failure(let error):
                print("Failed GET request error: \(response.result)")
                print("error calling GET on /todos/1")
                print(error)
                complete(false, ["message": error.localizedDescription])
                return
            }
        }
    }
	
	fileprivate func resultFormat(_ result: [[String: Any]]) -> [String: Any] {
		return [ "status" : 1,
				 "message" : "",
				 "result": result ]
	}
	
	func getToken(_ complete: @escaping complete) {
		if self.member_id == "" {
			getRequest(url: Path.token) { (finished, response) in
				if finished {
						UserDefaults.standard.set(Validation.anyIsString(Validation.anyIsDictionary(response!, with: "result"), with: "token"), forKey: tokenKey)
						UserDefaults.standard.synchronize()
					complete(true, nil)
					return
				} else {
					self.getToken({ (_, _) in
					})
					complete(false, nil)
					return
				}
			}
		}
	}
	
	func serverLog(parameter: [String: Any], _ complete: @escaping complete) {
		var query = parameter
		query["memberId"] = member_id ?? ""
		makeRequest(url: Path.serverLog, parameter: query) { (_, _) in
		}
	}
	
	// MARK: - APP INFORMATION
	func getiTunesData(_ complete: @escaping complete) {
		makeRequest(url: Path.getiTunes) { (finished, responseObject) in
			if finished {
				complete(true, responseObject)
				return
			} else {
				complete(false, [:])
				return
			}
		}
	}
	func getTimeStamp(_ complete: @escaping complete) {
		getRequest(url: Path.timeStamp) { (finished, response) in
			complete(finished, response)
			return
		}
	}
	
	// MARK: - LOGIN & PROFILE & MENU
	func getIntro(_ complete: @escaping complete) {
		getRequest(url: Path.intro) { (finished, response) in
			complete(finished, response)
			return
		}
	}
	
	func getAuthToken(_ complete: @escaping complete) {
		getRequest(url: Path.authToken) { (finished, response) in
			complete(finished, response)
			return
		}
	}
	
	func registerMember(_ complete: @escaping complete, parameter: [String: Any]) {
		var param = parameter
		param["deviceType"] = Utility.getDeviceOS()
		param["deviceName"] = Utility.getDeviceModel()
		param["deviceToken"] = Messaging.messaging().fcmToken
		makeRequest(url: Path.register, parameter: param) { (finished, response) in
			if finished {
				let result = response!["result"] as! [String: Any]
				let arrName = (result["displayName"] as! String).split(separator: " ")
				var name = "", surname = ""
				for i in 0..<arrName.count {
					if i == 0 {
						name = String(arrName[i])
					} else {
						surname = surname + String(arrName[i])
					}
				}
				let parameters: [String: String] = [ "memberId" : result["memberId"] as! String,
													 "token" : result["token"] as! String,
													 "email": parameter["username"] as! String,
													 "name" : name,
													 "surname": surname.trimSpace() ]
				UserDefaults.standard.set(Validation.anyIsString(result, with: "token"), forKey: tokenKey)
				UserDefaults.standard.synchronize()
				self.member_id = (result["memberId"] as? String)
				self.token = result["token"] as? String
				self.email = parameter["username"] as? String
				self.db?.memberLogin(response: parameters)
				self.myAccount({ (finished, response) in
					NotificationCenter.default.post(name: Notification.Name(rawValue: NotiCenter.checkLogIn), object: nil)
					return
				})
			}
			complete(finished, response)
			return
		}
		
	}
	func sendOtp(phoneNum: String, _ complete: @escaping complete) {
		makeRequest(url: Path.phoneOTP(member_id ?? ""), parameter: ["phoneNumber" : phoneNum]) { (finished, response) in
			complete(finished, response)
			return
		}
	}
	func confirmOtp(_ otp: String, _ complete: @escaping complete) {
		putRequest(url: Path.phoneOTP(member_id ?? ""), parameter: ["otp" : otp]) { (finished, response) in
			complete(finished, response)
			return
		}
	}
	
    func logIn(_ complete: @escaping complete, parameter: [String:Any], isFacebook: Bool = false, isApple: Bool = false) {
		var param: dictStringAny = ["deviceType" : Utility.getDeviceOS(),
									"deviceName" : Utility.getDeviceModel(),
									"deviceToken" : Messaging.messaging().fcmToken as Any,
									"username" : parameter["email"] as! String,
									"password" : parameter["password"] as! String]
		if isFacebook {
			param["accessToken"] = parameter["accessToken"] as! String
		}
        if isApple {
            param["email"] = parameter["email"] as! String
            param["appleId"] = parameter["appleId"] as! String
            param["firstName"] = parameter["firstName"] as! String
            param["lastName"] = parameter["lastName"] as! String
        }
        let pathLogin = (isFacebook ? "\(Path.login)/fb" : (isApple ? "\(Path.login)/apple" : Path.login))
		self.makeRequest(url: pathLogin, parameter: param) { (finished, response) in
            if finished {
                let result = response?["result"] as? [String: Any] ?? [:]
                if result.count > 0 {
                    let arrName = (result["displayName"] as! String).split(separator: " ")
                    var name = "", surname = ""
                    for i in 0..<arrName.count {
                        if i == 0 {
                            name = String(arrName[i])
                        } else {
                            surname = surname + String(arrName[i])
                        }
                    }
                    let parameters: [String: String] = [ "memberId" : result["memberId"] as! String,
                                                         "token" : result["token"] as! String,
                                                         "email": parameter["email"] as! String,
                                                         "name" : name,
                                                         "surname": surname.trimSpace() ]
                    UserDefaults.standard.set(Validation.anyIsString(result, with: "token"), forKey: tokenKey)
                    UserDefaults.standard.synchronize()
                    self.member_id = (result["memberId"] as? String)
                    self.token = result["token"] as? String
                    self.email = parameter["email"] as? String
                    self.db?.memberLogin(response: parameters)
                    self.myAccount({ (finished, response) in
                        NotificationCenter.default.post(name: Notification.Name(rawValue: NotiCenter.checkLogIn), object: nil)
                        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                        if let pathArray = UserDefaults.standard.stringArray(forKey: string.redeemUserDefaultKey) {
                            for path in pathArray {
                                appDelegate?.handleURLSchemes(path)
                            }
                        }
                        return
                    })
                    self.getAuthToken { (finished, response) in
                        if finished {
                            let token = Validation.anyIsString(Validation.anyIsDictionary(response!, with: "result"), with: "token")
                            Auth.auth().signIn(withCustomToken: token, completion: nil)
                        }
                        return
                    }
                    
                }
			} else {
                
			}
			complete(finished, response)
			return
		}
	}
	func logOut(_ complete: @escaping complete) {
		if member_id != "" {
			let loadingView = LoadingView(withSuperview: Utility.getCurrentViewController().view)
			loadingView.backgroundColor = .clear
			loadingView.startLoading()
			let param: dictStringAny = ["memberId" : member_id ?? "",
										"deviceToken" : token!]
			
			makeRequest(url: Path.logout, parameter: param) { (finished, response) in
				loadingView.stopLoading()
				if finished {
					let user = Auth.auth().currentUser
					if user != nil {
						try? Auth.auth().signOut()
					}
					UserDefaults.standard.set("", forKey: eachDateKey)
					self.db?.memberSignout()
                    self.userDefaultData.logout()
                    self.memberDefaultData.logout()
                }else{
                }
				complete(finished, response)
				return
			}
		}
	}
	
	func myAccount(_ complete: @escaping complete) {
		if member_id != "" {
			defaultFirestore.collection("members").document(member_id ?? "").getDocument(completion: { (querySnapshot, error) in
				if let err = error {
					print(str: err)
					complete(false, [:])
					return
				} else {
					if (querySnapshot?.exists)! {
						let response = ["status" : 1,
                                        "result" : querySnapshot!.data() as Any] as [String : Any]
						self.email = querySnapshot!.data()!["email"] as? String ?? ""
						self.db?.updateMyAccount(response: querySnapshot!.data()! as [String : AnyObject])
						self.checkProfile({ (_, _) in return})
						complete(true, response)
					} else {
						complete(false, [:])
					}
					return
				}
			})
		} else {
			complete(false, ["result":"NO"])
			return
		}
	}
	func updateAccount(_ complete: @escaping complete, value: dictStringAny) {
		putRequest(url: Path.changeEmail(byMember: member_id!), parameter: value) { (finished, response) in
			if finished {
				
			}
			complete(finished, response)
			return
		}
	}
	func resetPassword(_ complete: @escaping complete, username: String) {
		putRequest(url: Path.resetPassword, parameter: ["username" : username]) { (finished, response) in
			complete(finished, response)
			return
		}
	}
	func updateEmail(_ complete: @escaping complete, value: dictStringAny) {
		putRequest(url: Path.changeEmail(byMember: member_id ?? ""), parameter: value) { (finished, response) in
			if finished {
				
			}
			complete(finished, response)
			return
		}
	}
	func changePassword(_ complete: @escaping complete, value: dictStringAny) {
		putRequest(url: Path.changePass(byMember: member_id ?? ""), parameter: value) { (finished, response) in
			complete(finished, response)
			return
		}
	}
	
	func checkSession(_ complete: @escaping complete) {
		if member_id != "" {
			defaultFirestore.collection("members").document(member_id ?? "").getDocument(completion: { (querySnapshot, error) in
				if let err = error {
					print(str: err)
					complete(false, nil)
					return
				} else {
					if (querySnapshot?.exists)! {
						let userdata = querySnapshot!.data()
						let sessions = userdata!["sessions"] as! [dictStringAny]
						var haveSession = false
						for session in sessions {
							if Validation.anyIsString(session, with: "deviceToken") == Messaging.messaging().fcmToken {
								haveSession = true
								break
							}
						}
						if haveSession {
							complete(true, nil)
							return
						} else {
							complete(false, nil)
							self.logOut({ (finished, response) in
								if finished {
                                    let confirmAlert = UIAlertController(title: "session หมดอายุ\nกรุณาเข้าสู่ระบบอีกครั้ง", message: nil, preferredStyle: UIAlertController.Style.alert)
									confirmAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: { action in
										Utility.showLogInView()
									}))
									Utility.getCurrentViewController().present(confirmAlert, animated: true, completion: nil)
								}
							})
						}
						return
					} else {
						complete(false, nil)
					}
					return
				}
			})
		} else {
			complete(false, ["result":"NO"])
			return
		}
	}
	
	func getMyPackage(_ complete: @escaping complete) {
		if member_id != "" {
			defaultFirestore.collection("members").document(member_id ?? "").getDocument(completion: { (querySnapshot, error) in
				if let err = error {
					print(str: err)
					complete(false, nil)
					return
				} else {
					if (querySnapshot?.exists)! {
						let userdata = querySnapshot!.data()
						var packageData : [String: Any] = [:]
						for (key, value) in Validation.anyIsDictionary(userdata!, with: "packages") {
							if Validation.anyIsNumber(value as! [String:Any], with: "endDate") >= Datetime.getCurrentTimestamp() {
								packageData[key] = value
							}
						}
						complete(true, ["result" : packageData])
						return
					} else {
						complete(false, nil)
					}
					return
				}
			})
		} else {
			complete(false, ["result":"NO"])
			return
		}
	}
	
	func checkProfile(_ complete: @escaping complete) {
		if member_id != "" {
			defaultFirestore.collection("members").document(member_id ?? "").getDocument(completion: { (querySnapshot, error) in
				if let err = error {
					print(str: err)
					complete(false, nil)
					return
				} else {
					if (querySnapshot?.exists)! {
                        if let userdata = querySnapshot!.data() {
							var haveSession = false
                            haveSession = true
							if haveSession {
								let response = ["status" : 1,
                                                "result" :  userdata] as [String : Any]
								self.email = querySnapshot!.data()!["email"] as? String ?? ""
								self.db?.updateMyAccount(response: querySnapshot!.data()! as [String : AnyObject])
								self.initDB()
								complete(true, response)
								return
							} else {
								complete(false, nil)
								self.logOut({ (finished, response) in
									if finished {
                                        let confirmAlert = UIAlertController(title: "session หมดอายุ\nกรุณาเข้าสู่ระบบอีกครั้ง", message: nil, preferredStyle: UIAlertController.Style.alert)
										confirmAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: nil))
										Utility.getCurrentViewController().present(confirmAlert, animated: true, completion: nil)
									}
								})
							}
						} else {
							complete(false, nil)
						}
						return
					} else {
						complete(false, nil)
					}
					return
				}
			})
		} else {
			complete(false, ["result":"NO"])
			return
		}
	}
	
	func duplicateEmail(_ complete: @escaping complete, email: String) {
		defaultFirestore.collection("members").whereField("email", isEqualTo: email).getDocuments { (querySnapshots, error) in
			if let _ = error {
				complete(false, [:])
			} else {
				if querySnapshots?.documents.count == 0 {
					complete(true, [:])
				} else {
					complete(false, [:])
				}
			}
			return
		}
	}
	
	func checkDuplicateUsername(_ complete: @escaping complete, username: String) {
		defaultFirestore.collection("members").whereField("email", isEqualTo: username).getDocuments { (querySnapshots, error) in
			if let _ = error {
				complete(false, [:])
			} else {
				if querySnapshots?.documents.count == 0 {
					if username.count == 0 {
						complete(false, [:])
						return
					}
					let tempPhoneIndex = username.index(after: username.startIndex)
					let phone = (username.prefix(1) == "0" ? "+66\(username[tempPhoneIndex...])" : username)
					self.defaultFirestore.collection("members").whereField("phoneNumber", isEqualTo: phone).getDocuments(completion: { (snapshots, err) in
						if let _ = err {
							complete(false, [:])
						} else {
							if snapshots?.documents.count == 0 {
								complete(true, [:])
							} else {
								complete(false, [:])
							}
						}
						return
					})
				} else {
					complete(false, [:])
				}
			}
			return
		}
	}
	
	// MARK: - EXAM
	func getExamFree(_ complete: @escaping complete) {
		getRequest(url: Path.examTest) { (finished, response) in
			complete(finished, response)
			return
		}
	}
    
	func getExamGroup(_ complete: @escaping complete) {
		getRequest(url: Path.examGroup) { (finished, response) in
			complete(finished, response ?? [:])
			return
		}
	}
    
	func getExamGroupTab(_ id: String, _ complete: @escaping complete) { 
		getRequest(url: Path.examInGroupTab(id)) { (finished, response) in
			complete(finished, response ?? [:])
			return
		}
	}
    
	func getExamInGroupTab(_ id: String, subjectId: String, _ complete: @escaping complete) {
		getRequest(url: Path.examInTab(id, subjectId: subjectId)) { (finished, response) in
			complete(finished, response ?? [:])
			return
		}
	}
    
	func getExamQuestion(_ id: String, _ complete: @escaping complete) {
		getRequest(url: Path.examQuestion(id)) { (finished, response) in
			complete(finished, response)
			return
		}
	}
	
	func getSolution(examId: String, _ complete: @escaping complete) {
		let parameter = ["memberId" : member_id ?? "",
						 "memberExamId" : examId,
						 "deviceType" : "iOS"]
		
        let header : HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: tokenKey) ?? ""]
		
		logAPI(Path.solution, "POST", parameter)
		
		let post = "memberId=\(member_id ?? "")&memberExamId=\(examId)&deviceType=iOS"

		let postData = post.data(using: String.Encoding.utf8, allowLossyConversion: true)
		let contentLength: String = "\(postData!.count)"
		
		var request = try! URLRequest(url: Path.solution, method: .post, headers: header)
		request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.httpBody = postData!
		request.addValue(contentLength, forHTTPHeaderField: "Content-Length")
		request.setValue("application/json", forHTTPHeaderField: "Accept")
		complete(true, ["result" : request])
	}
    
	func getSolutionV2(examId: String) -> URLRequest {
		let parameter = ["memberId" : member_id ?? "",
						 "memberExamId" : examId,
						 "deviceType" : "iOS"]
		
        let header : HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: tokenKey) ?? ""]
		
		logAPI(Path.solution, "POST", parameter)
		
		let post = "memberId=\(member_id ?? "")&memberExamId=\(examId)&deviceType=iOS"
		let postData = post.data(using: String.Encoding.utf8, allowLossyConversion: true)
		let contentLength: String = "\(postData!.count)"
		
		var request = try! URLRequest(url: Path.solution, method: .post, headers: header)
		request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.httpBody = postData!
		request.addValue(contentLength, forHTTPHeaderField: "Content-Length")
		request.setValue("application/json", forHTTPHeaderField: "Accept")
		return request
	}
	
	func sendExamAnswer(_ examData: ExamModel, time: Int, _ complete: @escaping complete) {
		let questionsAnswer = examData.questions
		var answers: [dictStringAny] = []
		for question in questionsAnswer {
			if question.questionType == .c4a1 || question.questionType == .c5a1 {
				let selectedChoice = question.answer as? Choice ?? Choice(choiceData: [:])
				answers.append(["questionId" : question.id, "time" : question.time, "choiceIds" : [selectedChoice.id]])
			} else if question.questionType == .c5a2 {
				let selectedChoice = question.answer as? [Choice] ?? []
				var answer: [String] = []
				for choice in selectedChoice {
					answer.append(choice.id)
				}
				answers.append(["questionId" : question.id, "time" : question.time, "choiceIds" : answer])
			}
		}
		let sendParameter: dictStringAny = ["memberId" : member_id ?? "",
											"totalTime": time,
											"answers" : answers]
		makeRequest(url: Path.sendAnswerExam(examData.id), parameter: sendParameter) {
            (finished, response) in
			complete(finished, response)
			return
		}
	}
	
	func reportedType(_ complete: @escaping complete) {
		getRequest(url: Path.reportType) { (finished, response) in
			complete(finished, response)
			return
		}
	}
	
	func reportedQuestion(_ questionId: String, type: String, message: String, isExam: Bool = true, pretestId: String = "", _ complete: @escaping complete) {
		makeRequest(url: Path.reportExam, parameter: ["reporter" : member_id ?? "",
													  "type" : type,
													  "message" : (message == defaultReportText ? "" : message),
													  "pretestId" : pretestId,
													  "targetId" : questionId,
													  "category" : isExam ? "exam" : "pretest"])
		{ (finished, response) in
			complete(finished, response)
			return
		}
	}
	
	func getAllExamHistory(_ complete: @escaping complete) {
		getRequest(url: Path.examHistory(member_id ?? "")) { (finished, response) in
			complete(finished, response)
			return
		}
	}
	
	func getGroupExamHistory(_ complete: @escaping complete, groupId: String) {
		getRequest(url: Path.examHistoryGroup(member_id ?? "", groupId: groupId)) { (finished, response) in
			complete(finished, response)
			return
		}
	}
	
	func getExamHistroy(_ complete: @escaping complete, memberExamId: String) {
		getRequest(url: Path.examHistoryAnswer(member_id ?? "", examId: memberExamId)) { (finished, response) in
			complete(finished, response)
			return
		}
	}
	
	// MARK: - PRETEST
	func getPretest(id: String, _ complete: @escaping complete) {
		defaultFirestore.collection(pretests).document(id).getDocument { (querySnapshot, error) in
			if let err = error {
				print(str: err)
				complete(false, nil)
				return
			} else {
				if let snapshot = querySnapshot {
					complete(true, ["result" : PretestModel(withDictionary: snapshot.data()!)])
				} else {
					complete(false, nil)
				}
				return
			}
		}
	}
    
	func getPretestAnswer(id: String, _ complete: @escaping complete) {
		getRequest(url: Path.pretestAnswer(id)) { (finished, response) in
			complete(finished, response)
			return
		}
	}
	
	func getPretestEvents(_ complete: @escaping complete) {
		if member_id != nil && member_id != "" {
			defaultFirestore.collection("members").document(member_id ?? "").getDocument(completion: { (querySnapshot, error) in
				var arrPretest: [[String: Any]] = []
				if let err = error {
					print(str: err)
					complete(false, self.resultFormat(arrPretest))
					return
				} else {
					if (querySnapshot!.exists) {
						let myPretests = Validation.anyIsArrayString(querySnapshot!.data()!, with: "pretests")
						let db = Firestore.firestore()
						db.collection(pretests).getDocuments { (snapshots, err) in
							if let err = err {
								print(str: err)
							} else {
								for snapshot in snapshots!.documents {
									if snapshot.exists && not(myPretests.contains(snapshot.documentID)) && Validation.anyIsBool(snapshot.data(), with: "status") && (Validation.anyIsNumber(Validation.anyIsDictionary(Validation.anyIsDictionary(snapshot.data(), with: "price"), with: "regular"), with: "THB") != 0 || (Validation.anyIsNumber(Validation.anyIsDictionary(Validation.anyIsDictionary(snapshot.data(), with: "price"), with: "regular"), with: "THB") == 0)) {
										arrPretest.append(snapshot.data())
									}
								}
							}
							complete(true, self.resultFormat(arrPretest))
							return
						}
					} else {
						complete(true, self.resultFormat(arrPretest))
						return
					}
				}
			})
		} else {
			defaultFirestore.collection(pretests).getDocuments { (querySnapshot, error) in
				if let err = error {
					print(str: err)
					complete(false, nil)
					return
				} else {
					var arrPretest: [[String: Any]] = []
					for snapshot in querySnapshot!.documents {
						if snapshot.exists {
							if Validation.anyIsBool(snapshot.data(), with: "status") && (Validation.anyIsNumber(Validation.anyIsDictionary(Validation.anyIsDictionary(snapshot.data(), with: "price"), with: "regular"), with: "THB") != 0 || (Validation.anyIsNumber(Validation.anyIsDictionary(Validation.anyIsDictionary(snapshot.data(), with: "price"), with: "regular"), with: "THB") == 0 )) {
								arrPretest.append(snapshot.data())
							}
						}
					}
					complete(true, self.resultFormat(arrPretest))
					return
				}
			}
		}
	}
    
	func getPromotionPretest(_ complete: @escaping complete) {
		let db = Firestore.firestore()
		db.collection(promotions).getDocuments { (querySnapshot, error) in
			if let err = error {
				print(str: err)
				complete(false, nil)
				return
			} else {
				var arrPromotion: [[String: Any]] = []
				for snapshot in querySnapshot!.documents {
					if snapshot.exists {
						arrPromotion.append(snapshot.data())
					}
				}
				complete(true, self.resultFormat(arrPromotion))
				return
			}
		}
	}
    
	func getPastPretestEvents(_ complete: @escaping complete) {
		if member_id != nil && member_id! != "" {
			defaultFirestore.collection("members").document(member_id ?? "").getDocument(completion: { (querySnapshot, error) in
				var arrPretest: [[String: Any]] = []
				if let err = error {
					print(str: err)
					complete(false, self.resultFormat(arrPretest))
					return
				} else {
					if (querySnapshot!.exists) {
						let myPretests = Validation.anyIsArrayString(querySnapshot!.data()!, with: "pretests")
						let db = Firestore.firestore()
						db.collection(pretests).getDocuments { (snapshots, err) in
							if let err = err {
								print(str: err)
							} else {
								for snapshot in snapshots!.documents {
									if snapshot.exists && not(myPretests.contains(snapshot.documentID)) && Validation.anyIsNumber(snapshot.data(), with: "endRegisterDate") < Datetime.getCurrentTimestamp() && Validation.anyIsBool(snapshot.data(), with: "status") && Validation.anyIsNumber(Validation.anyIsDictionary(Validation.anyIsDictionary(snapshot.data(), with: "price"), with: "regular"), with: "THB") != 0 {
										arrPretest.append(snapshot.data())
									}
								}
							}
							complete(true, self.resultFormat(arrPretest))
							return
						}
					} else {
						complete(true, self.resultFormat(arrPretest))
						return
					}
				}
			})
		} else {
			defaultFirestore.collection(pretests).getDocuments { (snapshots, error) in
				var arrPretest: [[String: Any]] = []
				if let err = error {
					print(str: err)
					complete(false, self.resultFormat(arrPretest))
					return
				} else {
					for snapshot in snapshots!.documents {
						if snapshot.exists && Validation.anyIsNumber(snapshot.data(), with: "endRegisterDate") < Datetime.getCurrentTimestamp() && Validation.anyIsBool(snapshot.data(), with: "status") && Validation.anyIsNumber(Validation.anyIsDictionary(Validation.anyIsDictionary(snapshot.data(), with: "price"), with: "regular"), with: "THB") != 0 {
							arrPretest.append(snapshot.data())
						}
					}
					complete(true, self.resultFormat(arrPretest))
					return
				}
			}
		}
	}
    
    func getMyPretestEvents(_ complete: @escaping complete) {
        var id = ""
        if member_id != nil && member_id != "" {
            id = member_id!
        } else {
            id = "test_no_member"
        }
        var pastPretest: [dictStringAny] = []
        var nowPretest: [dictStringAny] = []
        defaultFirestore.collection("members").document(id).getDocument(completion: { (querySnapshot, error) in
            var arrPretest: [[String: Any]] = []
            if let err = error {
                print(str: err)
                complete(false, self.resultFormat(arrPretest))
                return
            } else {
                if (querySnapshot!.exists) {
                    let myPretests = Validation.anyIsArrayString(querySnapshot!.data()!, with: "pretests")
                    let db = Firestore.firestore()
                    db.collection(pretests).getDocuments { (snapshots, err) in
                        if let err = err {
                            print(str: err)
                        } else {
                            for snapshot in snapshots!.documents {
                                if snapshot.exists && myPretests.contains(snapshot.documentID) {
                                    if  Validation.anyIsNumber(snapshot.data(), with: "endRegisterDate") <= Datetime.getCurrentTimestamp()  {
                                        pastPretest.append(snapshot.data())
                                    } else {
                                        nowPretest.append(snapshot.data())
                                    }
                                }
                            }
                            arrPretest += Utility.sortArrayOfDictionary(nowPretest, withInt: "endRegisterDate", ascending: true)
                            arrPretest += Utility.sortArrayOfDictionary(pastPretest, withInt: "endRegisterDate", ascending: false)
                        }
                        complete(true, self.resultFormat(arrPretest))
                        return
                    }
                } else {
                    complete(true, self.resultFormat(arrPretest))
                    return
                }
            }
        })
    }
	
	func changeRoundPretest(_ pretestId: String, oldRound: Int, newRound: Int,_ complete: @escaping complete) {
		makeRequest(url: Path.changeRound(pretestId), parameter: ["memberId" : member_id ?? "",
																  "oldRound" : oldRound,
																  "newRound" : newRound,
																  "test" : testpretest])
		{ (finished, response) in
			complete(finished, response)
			return
		}
	}
	
	func sendPretestAnswer(pretestData: PretestModel,_ answerData: [Question], totalTime: Int, _ complete: @escaping complete) {
		var answers: [dictStringAny] = []
		for question in answerData {
			if question.questionType == .c4a1 || question.questionType == .c5a1 {
				let selectedChoice = question.answer as? Choice ?? Choice(choiceData: [:])
				answers.append(["questionId" : question.id, "time" : question.time, "choiceIds" : [selectedChoice.id]])
			} else if question.questionType == .c5a2 {
				let selectedChoice = question.answer as? [Choice] ?? []
				var answer: [String] = []
				for choice in selectedChoice {
					answer.append(choice.id)
				}
				answers.append(["questionId" : question.id, "time" : question.time, "choiceIds" : answer])
			}
		}
		let sendParameter: dictStringAny = ["memberId" : member_id!,
											"type" : (Datetime.getCurrentTimestamp() <= pretestData.originalRound.pretestEndDate + (5 * 60) ? 1 : 0),
											"round" : pretestData.originalRound.round,
											"answers" : answers,
											"totalTime" : totalTime,
											"test" : testpretest]
		makeRequest(url: Path.sendAnswerPretest(pretestData.pretestID), parameter: sendParameter) { (finished, response) in
			var result = response ?? [:]
			result["type"] = sendParameter["type"]
			complete(finished, result)
			return
		}
	}
    
	func getPretestHistory(pretestId: String, _ complete: @escaping complete) {
		getRequest(url: Path.pretestHistory(pretestId)) { (finished, response) in
			complete(finished, response)
			return
		}
	}
    
	func getPretestSolution(answerId: String, _ complete: @escaping complete) {
		let parameter = ["memberId" : member_id!,
						 "answerId" : answerId,
						 "deviceType" : "iOS"]
		
        let header : HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: tokenKey) ?? ""]
		
		logAPI(Path.pretestSolution, "POST", parameter)
		
		let post = "memberId=\(member_id ?? "")&answerId=\(answerId)&deviceType=iOS"
		let postData = post.data(using: String.Encoding.utf8, allowLossyConversion: true)
		let contentLength: String = "\(postData!.count)"
		
		var request = try! URLRequest(url: Path.pretestSolution, method: .post, headers: header)
		request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.httpBody = postData!
		request.addValue(contentLength, forHTTPHeaderField: "Content-Length")
		request.setValue("application/json", forHTTPHeaderField: "Accept")
		complete(true, ["result" : request])
	}
    
	func getPretestSolutionV2(answerId: String) -> URLRequest { // ไม่ได้ใช้งาน
		let parameter = ["memberId" : member_id ?? "",
						 "answerId" : answerId,
						 "deviceType" : "iOS"]
		
        let header : HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: tokenKey) ?? ""]
		
		logAPI(Path.pretestSolution, "POST", parameter)
		
		let post = "memberId=\(member_id ?? "")&answerId=\(answerId)&deviceType=iOS"
		let postData = post.data(using: String.Encoding.utf8, allowLossyConversion: true)
		let contentLength: String = "\(postData!.count)"
		
		var request = try! URLRequest(url: Path.pretestSolution, method: .post, headers: header)
		request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.httpBody = postData!
		request.addValue(contentLength, forHTTPHeaderField: "Content-Length")
		request.setValue("application/json", forHTTPHeaderField: "Accept")
		return request
	}
	
	func checkMemberPretestOnline(action: PretestOnlineStatus, pretestId: String,_ complete: @escaping complete) {
		var ref: DatabaseReference!
		ref = Database.database().reference()
		ref.child("pretest").child(pretestId).child(member_id ?? "").observeSingleEvent(of: .value, with: { (snapshot) in
			if snapshot.exists() {
				if action == .delete {
					ref.child("pretest").child(pretestId).child(self.member_id ?? "").removeValue(completionBlock: { (err, dbRef) in
						
					})
				} else {
					let value = snapshot.value as? dictStringAny ?? [:]
					let uuid = value["uuid"] as? String ?? ""
					if uuid == Utility.getDeviceUUID() {
						complete(true, nil)
					} else {
						complete(false, ["message" : "บัญชีผู้ใช้ของคุณมีการเข้าทำข้อสอบจากอุปกรณ์อื่น โปรดลองใหม่อีกครั้งในภายหลัง"])
					}
				}
				return
			} else {
				let post = [ "deviceType" : "iOS",
							 "uuid" : Utility.getDeviceUUID() ]
				let childUpdates = ["/pretest/\(pretestId)/\(self.member_id ?? "")" : post]
				ref.updateChildValues(childUpdates)
				complete(true, nil)
				return
			}
		}) { (err) in
			print(str: err)
			complete(false, ["message" : err.localizedDescription])
			return
		}
	}
	
	// MARK: - CALENDAR
	func getTypeCalendar(_ complete: @escaping complete) {
		getRequest(url: Path.typeCalendar) { (finished, response) in
			if finished {
			}
			complete(finished, response)
			return
		}
	}
    
	func getCalendar(_ search: String? = nil, type: String? = nil, _ complete: @escaping complete) {
		var parameter: dictStringAny = [:]
		if let type = type {
			parameter["type"] = type
		}
		if let search = search {
			parameter["search"] = search
		}
		makeRequest(url: Path.allCalendar, parameter: parameter) { (finished, response) in
			complete(finished, response)
			return
		}
	}
    
	func getAllCalendar(_ complete: @escaping complete) {
		makeRequest(url: Path.calendar) { (finished, response) in
			complete(finished, response)
			return
		}
	}
	
	// MARK: - PAYMENT
	func purchasePretest(promotionId: String? = nil, receipt: String = "", round: [dictStringAny], channel: Int, transactionId: String? = nil, memberEmail: String, _ complete: @escaping complete) {
		var parameter: dictStringAny = ["memberId" : member_id ?? "",
										"channel" : channel,
										"email" : memberEmail,
										"pretests" : round,
										"transaction" : channel == PurchaseType.inapp.rawValue ? transactionId! : "",
										"receipt" : receipt,
										"test" : testpretest]
		if let promotion = promotionId {
			parameter["promotionId"] = promotion
		}
		print(str: parameter)
		makeRequest(url: Path.pretest(), parameter: parameter)
		{ (finished, response) in
			complete(finished, response)
			return														
		}
	}

	func purchasePretestPromotion(id: String, transactionId: String? = nil, parameter: dictStringAny,_ complete: @escaping complete) {
		makeRequest(url: Path.promotionPretest(id), parameter: ["memberId" : member_id ?? "",
																"pretests" : Validation.anyIsArrayAny(parameter, with: "pretests"),
																"channel" : Validation.anyIsNumber(parameter, with: "channel"),
																"card" : "",
																"transaction" : Validation.anyIsNumber(parameter, with: "channel") == PurchaseType.inapp.rawValue ? transactionId! : ""]) { (finished, response) in
			complete(finished, response)
			return
		}
	}
    
	func validateInApp(_ parameter: dictStringAny, _ complete: @escaping complete) {
		makeRequest(url: Path.validateInApp, parameter: parameter) { (finished, response) in
			complete(finished, response)
			return
		}
	}
	
	func inappComplete(transactionId: String, _ complete: @escaping complete) {
		makeRequest(url: Path.inAppComplete, parameter: ["transaction" : transactionId]) { (finished, response) in
			complete(finished, response)
			return
		}
	}
    
	func getPaymentHistory(_ complete: @escaping complete) {
		getRequest(url: Path.paymentHistory(memberId: member_id ?? "")) { (finished, response) in
			complete(finished, response)
			return
		}
	}
    
	func purchasePackages(receipt: String = "", ids: [String], channel: Int, member: String, transactionId: String? = nil, _ complete: @escaping complete) {
		makeRequest(url: Path.purchasePackages, parameter: ["packages" : ids,
															"memberId" : member,
															"channel" : channel,
															"transaction" : channel == PurchaseType.inapp.rawValue ? transactionId! : "",
															"receipt" : receipt])
		{ (finished, response) in
			complete(finished, response)
			return
		}
	}
    
	func redeemCode(_ rc: String,_ complete: @escaping complete) {
		makeRequest(url: Path.redeem, parameter: ["redeemCode" : rc]) { (finished, response) in
			if finished {
				self.checkProfile({ (_, _) in
					NotificationCenter.default.post(name: Notification.Name(rawValue: NotiCenter.checkLogIn), object: nil)
					return
				})
			}
			complete(finished, response)
			return
		}
	}
	
	// MARK: - MENU
	func getExamStat(_ complete: @escaping complete) {
		getRequest(url: Path.memberExamStat(member_id ?? "")) { (finished, response) in
			complete(finished, response)
			return
		}
	}
    
	func getPackages(_ complete: @escaping complete) {
		getRequest(url: Path.packages) { (finished, response) in
			complete(finished, response)
			return
		}
	}
    
	func getPackageDetail(_ complete: @escaping complete) {
		getRequest(url: Path.packagesDetail) { (finished, response) in
			complete(finished, response)
			return
		}
	}
    
	func getContactUs(_ complete: @escaping complete) {
		getRequest(url: Path.contactUs) { (finished, response) in
			complete(finished, response)
			return
		}
	}
    
	func getHelpUs(_ complete: @escaping complete) {
		getRequest(url: Path.helpUs) { (finished, response) in
			complete(finished, response)
			return
		}
	}
    
	func getTermOfService(_ complete: @escaping complete) {
		getRequest(url: Path.termService) { (finished, response) in
			complete(finished, response)
			return
		}
	}
    
    func getPrivacyOfPolicies(_ complete: @escaping complete) {
        getRequest(url: Path.privacy) { (finished, response) in
            complete(finished,response)
            return
        }
    }
    
    //MARK: - NOTE
    func getNote(searchParam: String? = nil, tagParam: String? = nil , _ complete: @escaping complete) {
        var path = Path.note
        if let text = searchParam { path += "?name=\(text)" }
        if let text = tagParam { path += text }
        getRequest(url: path) { (finished, response) in
            if finished {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: Validation.anyIsArrayAny(response!, with: "data"), options: [])
                    let noteList = try JSONDecoder().decode([Note].self, from: jsonData)
                    complete(finished, ["result" : noteList])
                } catch {
                    print(error)
                    complete(false, response)
                }
            }
            return
        }
    }
    
    func getNoteViaPath(path: String, _ complete: @escaping complete) {
        getRequest(url: path) { (finished, response) in
            if finished {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: Validation.anyIsArrayAny(response!, with: "data"), options: [])
                    let noteList = try JSONDecoder().decode([Note].self, from: jsonData)
                    complete(finished, ["result" : noteList])
                } catch {
                    complete(false, response)
                }
            }
            return
        }
    }
    
    func getNoteGrades(_ complete: @escaping complete) {
        getRequest(url: Path.getNoteGrades) { (finished, response) in
            if finished {
                do {
                    let data = Validation.anyIsDictionary(response!, with: "data")
                    let jsonData = try JSONSerialization.data(withJSONObject: Validation.anyIsArrayAny(data, with: "items"), options: [])
                    let gradeList = try JSONDecoder().decode([NoteGrade].self, from: jsonData)
                    complete(true, ["result" : gradeList])
                } catch {
                    print(error)
                    complete(false, response)
                }
            }
            return
        }
    }
    
    func getNoteDetail(withId id: String, _ complete: @escaping complete) {
        getRequest(url: Path.getNoteDetail(id: id)) { (finished, response) in
            if finished {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: Validation.anyIsDictionary(response!, with: "data"), options: [])
                    let noteData = try JSONDecoder().decode(Note.self, from: jsonData)
                    complete(finished, ["result" : noteData])
                } catch {
                    print(error)
                    complete(false, response)
                }
            }
        }
    }
    
    func putFavoriteNote(withId id: String, _ complete: @escaping complete) {
        putRequest(url: Path.favoriteThisNote(id: id)) { (finished, response) in
            complete(finished, response)
        }
    }
    
    func putCommentNote(withId id: String, parameter: [String : Any], _ complete: @escaping complete) {
        putRequest(url: Path.commentThisNote(id: id), parameter: parameter) { (finished, response) in
            complete(finished, response)
        }
    }
    
    func postPurchaseNote(parameter: [String : Any], _ complete: @escaping complete) {
        makeRequest(url: Path.purchaseNote, parameter: parameter) { (finished, response) in
            complete(finished, response)
        }
    }
    
    //MARK: request OTP Account Delete
    func requestOTPforAccountDelete(memberId:String,parameter: [String:Any], _ complete: @escaping complete) {
        makeRequest(url: Path.requestOtpDeleteAccount(memberId),parameter: parameter) { (finished, response) in
            complete(finished, response)
        }
    }
    
    //MARK: verify Otp AccountDelete
    func verifyOtpAccountDelete(memberId:String,parameter: [String:Any], _ complete: @escaping complete) {
        makeRequest(url: Path.verifyOtpDeleteAccount(memberId),parameter: parameter) { (finished, response) in
            complete(finished,response)
        }
    }
    
    //MARK: confrim delete AccountDelete
    func deleteAccount(memberId:String, _ complete: @escaping complete) {
        deleteRequest(url: Path.deleteAccount(memberId)) { (finished,response) in
            complete(finished,response)
        }
    }
}
