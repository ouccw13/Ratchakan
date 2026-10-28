//
//  AppDelegate.swift
//  ratchakan
//
//  Created by JJsobtid on 6/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit
import FirebaseCrashlytics
import Firebase
import FirebaseAuth
import FirebaseMessaging
import FirebaseRemoteConfig
import SnapKit
import StoreKit
import UserNotifications
import FBSDKCoreKit
import AppTrackingTransparency
import AdSupport
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SKPaymentTransactionObserver, UNUserNotificationCenterDelegate, MessagingDelegate, CustomAlertDelegate {
    
	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
		
	}

	var window: UIWindow?
	var tabbar: TabBarViewController?
	var nowAlert: AlertView?
	
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		let manager = Filemanager()
		manager.initialSetup()
        
        FirebaseApp.configure()
//        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        
		self.tabbar = TabBarViewController()
		self.window = UIWindow(frame: UIScreen.main.bounds)
		self.window?.backgroundColor = .clear
		self.window?.rootViewController = self.tabbar
		self.window?.makeKeyAndVisible()
        SKPaymentQueue.default().add(Payment.storeObserverSharedInstance)
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        _ = GlobalParameter.storeObserverSharedInstance
        self.setUpNoti(application)
        CheckUpdate.shared.showUpdate(withConfirmation: false)
        
        self.requestDataPermission()
        let api = API()
        
        api.getToken { (_, _) in
            return
        }
        
        if let pathArray = UserDefaults.standard.stringArray(forKey: string.redeemUserDefaultKey) {
            for path in pathArray {
                handleURLSchemes(path)
            }
        }
		
		return true
	}
    
    func requestDataPermission() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if #available(iOS 14.0, *) {
                ATTrackingManager.requestTrackingAuthorization{ status in
                    switch status {
                    case .authorized:
                        // Tracking authorization dialog was shown
                        // and we are authorized
                        print("Test APP Authorize")
                        // Now that we are authorized we can get the IDFA
                        print(ASIdentifierManager.shared().advertisingIdentifier)
                    case .denied:
                        // Tracking authorization dialog was
                        // shown and permission is denied
                        print("Test APP1 Denied")
                    case .notDetermined:
                        // Tracking authorization dialog has not been shown
                        print("Test APP2 Not Determined")
                    case .restricted:
                        print("Test APP3 Restricted")
                    @unknown default:
                        print("Test APP4 Unknown")
                    }
                }
            }
        }
    }
    
    func setUpNoti(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { (granted, error) in
                
            })
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self
            
        } else {
            let allNotificationtypes: UIUserNotificationType = [.sound, .alert, .badge]
            let setting = UIUserNotificationSettings(types: allNotificationtypes, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            // Fallback on earlier versions
        }
        UIApplication.shared.registerForRemoteNotifications()
    }

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("Test applicationWillResignActive")
        NotificationCenter.default.post(name: .ApplicationResignActive, object: nil)
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("Test applicationDidEnterBackground")
        NotificationCenter.default.post(name: .ApplicationDidEnterBackground, object: nil)
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("Test applicationWillEnterForeground")
        NotificationCenter.default.post(name: .ApplicationWillEnterForeground, object: nil)
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("Test applicationDidBecomeActive")
        NotificationCenter.default.post(name: .ApplicationDidBecomeActive, object: nil)
        requestDataPermission()
        let api = API()
        api.getToken { (_, _) in
            return
        }
        DispatchQueue.main.async {
            // Update UI
            CheckUpdate.shared.showUpdate(withConfirmation: false)
        }
	}

	func applicationWillTerminate(_ application: UIApplication) {
        print("Test applicationWillTerminate")
//		NotificationCenter.default.post(name: NSNotification.Name("appterminate"), object: nil)
		postNoti("appterminate")
        NotificationCenter.default.post(name: .ApplicationWillTerminate, object: nil)
        SKPaymentQueue.default().remove(Payment.storeObserverSharedInstance)
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

	func postNoti(_ name: String) {
		NotificationCenter.default.post(name: NSNotification.Name(name), object: nil)
	}

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		
		print(str: url.absoluteString)
		if url.absoluteString.hasPrefix(string.URLSchemes) {
			let path = url.absoluteString.substring(from: string.URLSchemes.count)
			addSchemesPathToUserDefault(path)
			handleURLSchemes(path)
			return true
		} else {
            let handled = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String ?? "", annotation: options[UIApplication.OpenURLOptionsKey.annotation])
			return handled
		}
	}
	func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
		
		print(str: url)
		if url.absoluteString.hasPrefix(string.URLSchemes) {
			let path = url.absoluteString.substring(from: string.URLSchemes.count)
			if !path.isEmpty {
				addSchemesPathToUserDefault(path)
				handleURLSchemes(path)
			}
			return true
		} else {
			let handled = ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
		
			return handled
		}
	}
	
	fileprivate func addSchemesPathToUserDefault(_ path: String) {
		if var pathArray = UserDefaults.standard.stringArray(forKey: string.redeemUserDefaultKey) {
			if not(pathArray.contains(path)) {
				pathArray.append(path)
				UserDefaults.standard.set(pathArray, forKey: string.redeemUserDefaultKey)
			}
		} else {
			UserDefaults.standard.set([path], forKey: string.redeemUserDefaultKey)
		}
	}
	fileprivate func deleteSchemesPathToUserDefault(_ path: String) {
		if var pathArray = UserDefaults.standard.stringArray(forKey: string.redeemUserDefaultKey) {
			if pathArray.contains(path) {
				pathArray.remove(at: pathArray.lastIndex(where: { (p) -> Bool in
					return p == path
				})!)
				UserDefaults.standard.set(pathArray, forKey: string.redeemUserDefaultKey)
			}
		}
	}
	
	func handleURLSchemes(_ path: String) {
		if path.isEmpty {
			deleteSchemesPathToUserDefault("")
		}
		let api = API()
		let pathComponent = path.split(separator: "/").map { (substr) -> String in
			return String(substr)
		}
		if api.getMember().member_id != "" {
			if let firstPath = CheckArray.check(pathComponent, index: 0) {
				if firstPath == "payment" {
					if let secondPath = CheckArray.check(pathComponent, index: 1) {
						if secondPath == "redeem" {
							let redeemCode = CheckArray.check(pathComponent, index: 2) ?? ""
							Utility.sendCoupon(api, path: path, redeemCode: redeemCode) { (pathToDelete) in
								self.deleteSchemesPathToUserDefault(pathToDelete)
							}
						} else {
							
						}
					}
				} else {
				
				}
			} else {
			}
		} else {
            let plsLogInAlert = UIAlertController(title: "กรุณาเข้าสู่ระบบเพื่อใช้คูปอง", message: nil, preferredStyle: UIAlertController.Style.alert)
			plsLogInAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: nil))
			Utility.getCurrentViewController().present(plsLogInAlert, animated: true, completion: nil)
		}
	}
	
	// Handle remote notification registration.
	func application(_ application: UIApplication,
					 didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
		// Forward the token to your provider, using a custom method.
	
	}
	
	func application(_ application: UIApplication,
					 didFailToRegisterForRemoteNotificationsWithError error: Error) {
		// The token is not currently available.
		
	}
	
	// FROM CLICK
	@available(iOS 10.0, *)
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		
		let notification = response.notification
		let request = notification.request
		let content = request.content
		if let userInfo = content.userInfo as? dictStringAny {
			print(str: Utility.jsonLog(userInfo))
			let notiType = Validation.anyIsString(userInfo, with: "type")
			if notiType == NotificationType.pretestThirty.rawValue || notiType == NotificationType.pretestStart.rawValue || notiType == NotificationType.pretestCalFinished.rawValue {
				showPretest(id: Validation.anyIsString(userInfo, with: "pretestId"), type: notiType)
				let localNoti = LocalNotifications.sharedInstance
				localNoti.removeNoti(userInfo)
			} else if notiType == NotificationType.url.rawValue {
				let adsWebView = WebView(link: Validation.anyIsString(userInfo, with: "url"), title: Validation.anyIsString(userInfo, with: "title"))
				Utility.getCurrentViewController().present(adsWebView, animated: true, completion: nil)
			} else if notiType == NotificationType.image.rawValue {
				
			} else if notiType == NotificationType.imageText.rawValue {
				
			} else if notiType == NotificationType.package.rawValue {
				
			} else if notiType == NotificationType.pretest.rawValue {
				
			}
			
		}
		
	}
	
	// IN APP
	@available(iOS 10.0, *)
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		if let userInfo = notification.request.content.userInfo as? dictStringAny {
			print(str: Utility.jsonLog(userInfo))
			let notiType = Validation.anyIsString(userInfo, with: "type")
			
			if notiType == NotificationType.pretestThirty.rawValue {
				checkNowView(data: userInfo, title: Validation.anyIsString(userInfo, with: "title"), detail: "ถึงเวลาสอบ", time: (Int(Validation.anyIsString(userInfo, with: "pretestDate")) ?? Int(Datetime.getCurrentTimestamp())+1800) - Int(Datetime.getCurrentTimestamp()))
				let localNoti = LocalNotifications.sharedInstance
				localNoti.removeNoti(userInfo)
			} else if notiType == NotificationType.pretestStart.rawValue {
				checkNowView(data: userInfo, title: Validation.anyIsString(userInfo, with: "title"), detail: "การสอบเริ่มขึ้นแล้ว", time: nil)
			} else if notiType == NotificationType.pretestCalFinished.rawValue {
				checkNowView(data: userInfo, title: Validation.anyIsString(userInfo, with: "title"), detail: "ผลสอบของคุณออกแล้ว", time: nil)
			} else if notiType == NotificationType.url.rawValue {
				checkNowView(data: userInfo, title: Validation.anyIsString(userInfo, with: "title"), detail: Validation.anyIsString(userInfo, with: "body"), time: nil)
			} else if notiType == NotificationType.image.rawValue {
				
			} else if notiType == NotificationType.imageText.rawValue {
				
			} else if notiType == NotificationType.package.rawValue {
				
			} else if notiType == NotificationType.pretest.rawValue {
				
			}
		}
	}
	
	func checkNowView(data: dictStringAny, title: String, detail: String, time: Int?) {
		let currentView = Utility.getCurrentViewController()
		if currentView.isKind(of: ExamStartViewController.classForCoder()) {
			dropdownAlert.title(title, message: "\(detail)\(time == nil ? "" : "ใน 30 นาที")", backgroundColor: .brandcolor1, textColor: .Celllabel)
		} else {
			let alert = AlertView(frame: Utility.getCurrentViewController().view.frame)
			alert.data = data
			alert.delegate = self
			alert.setTitle(title, detail: detail, time: time, next: "ดูรายละเอียด", close: string.th_ok)
			if nowAlert != nil && nowAlert!.isShow {
				nowAlert?.animatedHide()
			}
			alert.animatedShow()
			nowAlert = alert
		}
	}
	
	func confirmAlert() {
		print(str: "confirm")
		if let data = nowAlert!.data {
			if let pretestId = data["pretestId"] as? String, let type = data["type"] as? String {
				showPretest(id: pretestId, type: type)
			}
			if let type = data["type"] as? String {
				if type == NotificationType.url.rawValue {
					let adsWebView = WebView(link: Validation.anyIsString(data, with: "url"), title: Validation.anyIsString(data, with: "title"))
					Utility.getCurrentViewController().present(adsWebView, animated: true, completion: nil)
				} else if type == NotificationType.image.rawValue {
					
				}
			}
		} else {
			
		}
	}
	
	func showPretest(id: String, type: String) {
		let nowVC = Utility.getCurrentViewController()
        let loading = UIActivityIndicatorView(style: .medium)
		nowVC.view.addSubview(loading)
		loading.center = nowVC.view.center
		let api = API()
		loading.startAnimating()
		if type == NotificationType.pretestCalFinished.rawValue {
			api.getPretestAnswer(id: id) { (finished, response) in
				if finished {
					let pretestSummaryView = PretestSummaryViewController(withPretest: PretestHistoryModel(withData: Validation.anyIsDictionary(response!, with: "result")))
					pretestSummaryView.fromNoti = true
					let navPretestVC = UINavigationController(rootViewController: pretestSummaryView)
					nowVC.present(navPretestVC, animated: true, completion: nil)
				} else {
					dropdownAlert.errorNTryAgain()
				}
				loading.stopAnimating()
				return
			}
		} else {
			api.getPretest(id: id) { (finished, response) in
				if finished {
					let pretestData = response!["result"] as! PretestModel
					let nav: Nav = Nav(title: pretestData.pretestName, isBack: true, isRight: false, color: UIColor.color(fromHexString: pretestData.colorHEX))
					let pretestDetailRoundViewController = PretestDetailRoundViewController()
					pretestDetailRoundViewController.nav = nav
					pretestDetailRoundViewController.setBanner((pretestData.banner["tablet"] as? dictStringAny ?? ["path":""])["path"] as! String)
					pretestDetailRoundViewController.pretestList = [pretestData]
					pretestDetailRoundViewController.fromNoti = true
					let navPretestVC = UINavigationController(rootViewController: pretestDetailRoundViewController)
					nowVC.present(navPretestVC, animated: true, completion: nil)
				} else {
					dropdownAlert.errorNTryAgain()
				}
				loading.stopAnimating()
				return
			}
		}
	}
	
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
		print(str: fcmToken)
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		
		print("NOTIFICATION2")
	}
    
}

extension NSNotification.Name  {
    static let ApplicationResignActive = NSNotification.Name("ApplicationResignActive")
    static let ApplicationDidBecomeActive = NSNotification.Name("ApplicationDidBecomeActive")
    static let ApplicationDidEnterBackground = NSNotification.Name("ApplicationDidEnterBackground")
    static let ApplicationWillTerminate = NSNotification.Name("WillTerminate")
    static let ApplicationWillEnterForeground = NSNotification.Name("ApplicationWillEnterForeground")
}

