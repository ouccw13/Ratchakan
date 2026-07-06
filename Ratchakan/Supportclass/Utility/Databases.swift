//
//  Database.swift
//  ratchakan
//
//  Created by JJsobtid on 13/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit
import SQLite3
import Realm
import RealmSwift
import Foundation
enum queryType {
	case add
	case delete
    case delete_appleData
	case update_member
	case update_theme
	case query_member
    case query_appleData
	case query_theme
	case update_package
}

class Databases: NSObject {

	var documentsDirectory: String = ""
	var databaseFilename: String = ""
	var arrResults: [AnyObject] = []
	var arrColumnNames: [AnyObject] = []
	var affectedRows: uint = 0
	var lastInsertedRowID: uint = 0
    

	init(databaseFilename: String) {
		super.init()
		self.databaseFilename = databaseFilename
		self.documentsDirectory = Filemanager.databaseDirectory()
		self.copyDatabaseIntoDocumentsDirectory()
		
//		let member1 = member(value: ["member_id": "guest",
//									 "token":"token",
//									 "name":"hello",
//									 "surname":"world",
//									 "email":"test@test.me",
//									 "birthday":"",
//									 "gender":"",
//									 "date_reg":"",
//									 "profile_picture":"",
//									 "date_changepassword":"",
//									 "plan_expire":"",
//									 "first_of_date":""])
		
//		runRealm(type: .delete, element: member.self)
//
//		runRealm(query: member1, type: .add)
//
//		runRealm(query: member1, type: .query_member, element: member.self)
		
		migrateSchema()
	}
	
	func copyDatabaseIntoDocumentsDirectory() {
		let destinationPath = self.documentsDirectory.stringByAppendingPathComponent1(path: self.databaseFilename)
		if !FileManager.default.fileExists(atPath: destinationPath) {
			let sourcePath = Bundle.main.resourcePath?.stringByAppendingPathComponent1(path: self.databaseFilename)
			
			do {
				try FileManager.default.copyItem(atPath: sourcePath!, toPath: destinationPath)
			} catch _ as NSError {
				
			}
		}
	}
	
	func runRealm(query: Object? = nil, type: queryType, element: Object.Type? = nil) -> Any {
		let databasePath = documentsDirectory.stringByAppendingPathComponent1(path: databaseFilename)
		
		arrResults = []
		arrColumnNames = []
		
        migrateSchema()
//		let realm = try! Realm(fileURL: URL(fileURLWithPath: databasePath))
        var config = Realm.Configuration(schemaVersion: 3, migrationBlock: {
            migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
            }
        })
        if let url = config.fileURL {
            config.fileURL = url.deletingLastPathComponent().appendingPathComponent("defaultDB.realm")
        }
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
        do {
            let realm = try Realm()
            if type == .add {
                try! realm.write {
                    realm.add(query!)
                }
                guard realm.objects(element!).first != nil else {
                    return []
                }
            } else if type == .delete {
                let memberAll = realm.objects(element!)
                let packageAll = realm.objects(Packages.self)
                try! realm.write {
                    realm.delete(memberAll)
                    realm.delete(packageAll)
                }
            }else if type == .delete_appleData {
                let appleData = realm.objects(element!)
                try! realm.write {
                    realm.delete(appleData)
                }
            }
            else if type == .update_member {
                guard let memberData = realm.objects(element!).first else {
                    return []
                }
                let mem = memberData as! member
                try! realm.write {
                    mem.updateFrom(member: query as! member)
                }
            } else if type == .query_member {
                guard let memberData = realm.objects(element!).first else {
                    return []
                }
                let packageAll = realm.objects(Packages.self)
                let mem = memberData as! member
                for package in packageAll {
                    try! realm.write {
                        if not(mem.packages.contains(package)) {
                            mem.packages.append(package)
                        } else {
                            mem.packages.replace(index: mem.packages.index(of: package)!, object: package)
                        }
                    }
                }
                arrResults.append(memberData)
            } else if type == .query_theme {
                let themes = realm.objects(element!)
                for themeData in themes {
                    arrResults.append(themeData)
                }
            } else if type == .update_theme {
                guard let themes = realm.objects(element!).first else {
                    return []
                }
                let themeData = themes as! Theme
                let themeUpdate = query as! Theme
                try! realm.write {
                    themeData.theme = themeUpdate.theme
                }
            } else if type == .update_package {
                let packageAll = realm.object(ofType: Packages.self, forPrimaryKey: (query as! Packages).examId)
                try! realm.write {
                    if let package = packageAll {
                        package.endDate = (query as! Packages).endDate
                    } else {
                        realm.add(query!)
                    }
                }
            }else if type == .query_appleData {
                let appleData = realm.objects(element!)
                for apple in appleData {
                    arrResults.append(apple)
                }
            }
        } catch let error as NSError {
            debugPrint(error)
        }
		return []
	}
	
	func runQuery(query: String, isQueryExecutable: Bool) {
		let databasePath = documentsDirectory.stringByAppendingPathComponent1(path: databaseFilename)
		
		arrResults = []
		arrColumnNames = []
		
		var sqlite3Database: OpaquePointer?
		if sqlite3_open(databasePath, &sqlite3Database) == SQLITE_OK {
			var compiledStatement: OpaquePointer?

			if sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, nil) == SQLITE_OK {
				if !isQueryExecutable {
					var arrDataRow: [String] = []
					while sqlite3_step(compiledStatement) == SQLITE_ROW {
						arrDataRow = []
						
						let totalColumns = sqlite3_column_count(compiledStatement)
						
						for i in 0..<totalColumns {
							let dbDataAsChars = sqlite3_column_text(compiledStatement, i)
							
							if dbDataAsChars != nil {
								arrDataRow.append(String(cString: dbDataAsChars!))
							}
							
							if arrColumnNames.count != totalColumns {
								let dbDataAsChar = sqlite3_column_name(compiledStatement, i)
								arrColumnNames.append(String(cString: dbDataAsChar!) as AnyObject)
							}
						}
						
						if arrDataRow.count > 0 {
							arrResults.append(arrDataRow as AnyObject)
						}
					}
				} else {
					if sqlite3_step(compiledStatement) == SQLITE_DONE {
						affectedRows = uint(sqlite3_changes(sqlite3Database))
						lastInsertedRowID = uint(sqlite3_last_insert_rowid(sqlite3Database))
					} else {
						
					}
				}
			} else {

			}
			
			sqlite3_finalize(compiledStatement)
		}
		
		sqlite3_close(sqlite3Database)
	}

	func loadDataFromDB(query: String) -> [AnyObject] {
		self.runQuery(query: query, isQueryExecutable: false)
		
		return self.arrResults
	}
	
	func executeQuery(query: String) {
		self.runQuery(query: query, isQueryExecutable: true)
	}
	
	// MARK: member
    func memberLogin(response: [String:String]/*,fieldLogIn: String = ""*/) {
		let member1 = member(value: ["member_id": response["memberId"],
										 "token": response["token"],
										 "email": response["email"],
                                         "name": response["name"],
									     "surname": response["surname"]
									])
		_ = runRealm(type: .delete, element: member.self)
		_ = runRealm(query: member1, type: .add, element: member.self)
		
		self.setTheme(theme: 0)
	}
    
    func memberLogInApple(clientSecret: String,appleToken: String,authorizationcode: String,userIdentifier_appleId: String) {
        let appleRes = AppleSignInResponse(value: ["clientSecret": clientSecret,
                                                   "appleToken": appleToken,
                                                   "authorizationcode": authorizationcode,
                                                   "userIdentifier_appleid": userIdentifier_appleId
                                                  ])
        _ = runRealm(type: .delete, element: AppleSignInResponse.self)
        _ = runRealm(query: appleRes, type: .add, element: AppleSignInResponse.self)
    }
	
	func memberLoginAsGuest() {
		let username = "SOBTID GUEST"
		let guest = member()
		guest.updateFrom(dictionary:  [ "name": username as AnyObject,
										"surname" : "" as AnyObject,
										"member_id" : "" as AnyObject,
										"email" : "ยังไม่เข้าสู่ระบบ" as AnyObject,
                                        "packages" : [:] as AnyObject])
		_ = runRealm(type: .delete, element: member.self)
        _ = runRealm(type: .delete_appleData, element: AppleSignInResponse.self)
		_ = runRealm(query: guest, type: .add, element: member.self)
		for package in guest.packages {
			_ = runRealm(query: package, type: .update_package, element: Packages.self)
		}
		self.setTheme(theme: 0)
	}
	
	func memberSignout() {
		memberLoginAsGuest()
		NotificationCenter.default.post(name: Notification.Name(rawValue: NotiCenter.logOut), object: nil)
	}
    
    func memberIsDelete() {
        let username = "SOBTID GUEST"
        let guest = member()
        guest.updateFrom(dictionary:  [ "name": username as AnyObject,
                                        "surname" : "" as AnyObject,
                                        "member_id" : "" as AnyObject,
                                        "email" : "ยังไม่เข้าสู่ระบบ" as AnyObject,
                                        "packages" : [:] as AnyObject])
        _ = runRealm(type: .delete, element: member.self)
        _ = runRealm(type: .delete_appleData, element: AppleSignInResponse.self)
        _ = runRealm(query: guest, type: .add, element: member.self)
        for package in guest.packages {
            _ = runRealm(query: package, type: .update_package, element: Packages.self)
        }
    }
	
	func memberProfileFirst(response: [String:AnyObject]) {
		if (response["birthday"] != nil || response["profile_picture"] != nil) {
			var plans = response["plans"] as! [[String:AnyObject]]
			var plan_exp = 0
			if plans.count > 0 {
				plans = plans.sorted(by: { (a, b) -> Bool in
					return (a["plan_expire"] as? Int)! > (b["plan_expire"] as? Int)!
				})
				plan_exp = plans[0]["plan_expire"] as! Int
			}
			let memberData = member()
			memberData.updateFrom(dictionary: response)
			memberData.plan_expire = "\(plan_exp)"
			
			_ = runRealm(query: memberData, type: .update_member, element: member.self)
		}
	}
	
	func updateMyAccount(response: [String:AnyObject]) {
		var plan_exp = 0
		if Validation.dictionary(response, with: "plans") {
			var plans = response["plans"] as! [[String:AnyObject]]
			if plans.count > 0 {
				plans = plans.sorted(by: { (a, b) -> Bool in
					return (a["plan_expire"] as? Int)! > (b["plan_expire"] as? Int)!
				})
				plan_exp = plans[0]["plan_expire"] as! Int
			}
		}
		
		let memberData = member()
		memberData.updateFrom(dictionary: response)
		memberData.plan_expire = "\(plan_exp)"
		for package in memberData.packages {
			_ = runRealm(query: package, type: .update_package, element: Packages.self)
		}
		_ = runRealm(query: memberData, type: .update_member, element: member.self)
	}
	
	func tellUsMore(response: [String:AnyObject]) {
		let reason = response["reason"] as! Int
		let school_id = response["school_id"] as! Int
		let study_program_id = response["study_program_id"] as! Int
		
		_ = self.loadDataFromDB(query: "UPDATE member SET birthday='\(String(describing: response["birthday"]))', education_year='\(String(describing: response["education_year"]))', reason='\(reason)', schoool_id='\(school_id)', study_program_id='\(study_program_id)' WHERE member_id='\(String(describing: response["member_id"]))' LIMIT 1")
	}
	
	func getMembermodel() -> [member] {
		_ = runRealm(type: .query_member, element: member.self)
		
		guard let userdata = arrResults.first else {
			return [member(value: ["name": "SOBTID GUEST"])]
		}
		return arrResults as! [member]
	}
	func getMember() -> [String: AnyObject] {
		_ = runRealm(type: .query_member, element: member.self)
		
		guard let userdata = arrResults.first else {
			return [:]
		}
		return (userdata as! member).returnJSON() as [String : AnyObject]
	}
    
    func getAppleResponse() -> [String:AnyObject] {
        _ = runRealm(type: .query_appleData,element: AppleSignInResponse.self)
        guard let appledata = arrResults.first else {
            return [:]
        }
        return (appledata as! AppleSignInResponse).returnJSON() as [String: AnyObject]
    }
	
	func getToken() -> [String: AnyObject]{
		return getMember()
	}
	
	func setTheme(theme: Int) {
		_ = runRealm(type: .query_theme, element: Theme.self)
		let themes = Theme(value: ["theme" : theme])
		if arrResults.count == 1 {
			_ = runRealm(query: themes, type: .update_theme, element: Theme.self)
		} else if arrResults.count > 1 {
			_ = runRealm(type: .delete, element: Theme.self)
		} else {
			_ = runRealm(query: themes, type: .add, element: Theme.self)
		}
	}
	
	func getTheme() -> Int {
		let theme = 0
		_ = runRealm(type: .query_theme)
		guard let themes = arrResults.first else {
			return theme
		}
		return (themes as! Theme).theme
	}
	
	// MARK: noti
	func updateTime(response: [String:AnyObject]) {
		let time = response["time_noti"]
		
		let databasePath = documentsDirectory.stringByAppendingPathComponent1(path: databaseFilename)
		
		let realm = try! Realm(fileURL: URL(fileURLWithPath: databasePath))
		
		try! realm.write {
			let updateMember = realm.objects(member.self).first
			updateMember!.time_noti = time as! String
		}
	}
	
	// MARK: migrateSchema
	func migrateSchema() {
		let config = Realm.Configuration(
			// Set the new schema version. This must be greater than the previously used
			// version (if you've never set a schema version before, the version is 0).
			schemaVersion: 13,
			
			// Set the block which will be called automatically when opening a Realm with
			// a schema version lower than the one set above
			migrationBlock: { (migration, oldSchemaVersion) in
				// We haven’t migrated anything yet, so oldSchemaVersion == 0
				if (oldSchemaVersion < 13) {
					migration.enumerateObjects(ofType: "member") { oldObject, newObject in
						// No-op.
						// dynamic properties are defaulting the new column to true
						// but the migration block is still needed
					}
					migration.enumerateObjects(ofType: "theme") { oldObject, newObject in
						// No-op.
						// dynamic properties are defaulting the new column to true
						// but the migration block is still needed
					}
					migration.enumerateObjects(ofType: "screen_capture") { oldObject, newObject in
						// No-op.
						// dynamic properties are defaulting the new column to true
						// but the migration block is still needed
					}
				}
		})
		
		// Tell Realm to use this new configuration object for the default Realm
		Realm.Configuration.defaultConfiguration = config
		
		// Now that we've told Realm how to handle the schema change, opening the file
		// will automatically perform the migration
		do {
			_ = try Realm()
		} catch _ as NSError {
            print(str: "error")
		}
	}
	
	// MARK: firstofdate
	func updateFirst(date: String) {
		let databasePath = documentsDirectory.stringByAppendingPathComponent1(path: databaseFilename)

		let realm = try! Realm(fileURL: URL(fileURLWithPath: databasePath))
		
		try! realm.write {
			let updateMember = realm.objects(member.self).first
			updateMember!.first_of_date = date
		}
	}
}

enum MemberDefaultKey: String {
    case displayName
    case memberId
    case sessionId
    case token
}

class MemberDefaultData: NSObject {
    
    var displayName: String = ""
    var memberId: String = ""
    var sessionId: String = ""
    var token: String = ""
    
    var defaultData: [String:Any]! {
        didSet {
            setValuable()
        }
    }
    
    class var storeObserverSharedInstance: MemberDefaultData {
        struct Static {
            static let instance: MemberDefaultData = MemberDefaultData()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        defaultData = [MemberDefaultKey.displayName.rawValue : "",
                       MemberDefaultKey.memberId.rawValue : "",
                       MemberDefaultKey.sessionId.rawValue : "",
                       MemberDefaultKey.token.rawValue : ""]
        DispatchQueue.main.async {
            UserDefaults.standard.synchronize()
        }
        setValuable()
    }
    
    fileprivate func setValuable() {
        displayName = Validation.anyIsString(defaultData, with: MemberDefaultKey.displayName.rawValue)
        memberId = Validation.anyIsString(defaultData, with: MemberDefaultKey.memberId.rawValue)
        sessionId = Validation.anyIsString(defaultData, with: MemberDefaultKey.sessionId.rawValue)
        token = Validation.anyIsString(defaultData, with: MemberDefaultKey.token.rawValue)
    }
    
    func set(type: MemberDefaultKey, data: String) {
        defaultData[type.rawValue] = data
        DispatchQueue.main.async {
            UserDefaults.standard.synchronize()
        }
    }
    
    func logout() {
        defaultData = [MemberDefaultKey.displayName.rawValue : "",
                       MemberDefaultKey.memberId.rawValue : "",
                       MemberDefaultKey.sessionId.rawValue : "",
                       MemberDefaultKey.token.rawValue : ""]
        DispatchQueue.main.async {
            UserDefaults.standard.synchronize()
        }
    }
}
