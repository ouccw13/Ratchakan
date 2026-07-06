//
//  Utility.swift
//  ratchakan
//
//  Created by JJsobtid on 7/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation
import UIKit
import FCUUID
import MapKit
import EventKit

func not(_ bool: Bool) -> Bool { return !bool }

class Utility {
	
	static func getDeviceModel() -> String {
		return UIDevice.current.model
	}
	
	static func getDeviceOS() -> String {
		return "iOS \(UIDevice.current.systemVersion)"
	}
	
	static func getDeviceOSModel() -> String {
		return "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
	}
	
	static func getDeviceUUID() -> String {
		return FCUUID.uuidForDevice()
//		return UUID().uuidString
	}
	
	static func getAppVersion() -> String {
		return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
	}
	
	static func open(url: String) {
		if let url = URL(string: url.trimSpace()) {
            UIApplication.shared.open(url, options: [:], completionHandler: { success in
                if success {
                    print("เปิดลิงก์สำเร็จ")
                }else{
                    print("ไม่สามารถเปิดลิงก์ได้")
                }
            })
		} else {
			UIPasteboard.general.string = url
			dropdownAlert.title("Copy to Clipboard.", message: "Please past and open on web browser.", backgroundColor: .errorRed, textColor: .white)
		}
	}
	static func openiTunesURL() {
		open(url: Path.iTunesURL)
	}
	
	static func openMapOffice() {
		let latitude: CLLocationDegrees = 13.776936845634777
		let longitude: CLLocationDegrees = 100.53244201453596
		
		let regionDistance:CLLocationDistance = 100
		let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
		let options = [
			MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
			MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
		]
		let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
		let mapItem = MKMapItem(placemark: placemark)
		mapItem.name = string.th_company
		mapItem.openInMaps(launchOptions: options)
	}
	
	static func delayFunc(_ function: ()) {
		let delay = Int(4.5 * Double(1000))
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay), execute: {
			function
		})
		
	}
	
	static func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_11() -> Bool {
		if #available(iOS 11.0, *) {
			return true
		}
		return false
	}

	static func randomNum(_ num: UInt32) -> UInt32 {
		return arc4random() % num
	}
	
	// MARK: - ViewController
	static func getCurrentViewController() -> UIViewController {
		let getWindow : UIWindow = UIApplication.shared.keyWindow!
		let topController = getWindow.visibleViewController()
		return topController!
	}
	
	static func backToRootView(_ completion: (()-> Void)? = nil) {
		UIApplication.shared.delegate?.window!?.rootViewController?.dismiss(animated: true, completion: completion)
	}
	
	static func statusBar(color: UIColor) {
		UINavigationBar.appearance().clipsToBounds = true
		
        if #available(iOS 13.0, *) {

        } else {
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            statusBar.backgroundColor = color
        }
        
	}
	
	static func checkLogIn(member: [String:Any]) -> Bool {
		guard let member_id = member["memberId"] as? String else {
			showLogInView()
			return false
		}
		if member_id == "" {
			showLogInView()
			return false
		} else {
			let api = API()
			api.checkProfile({ (_, _) in
				return
			})
			return true
		}
	}
	
	static func showLogInView() {
		let signinView = SignInViewController()
        signinView.modalPresentationStyle = .fullScreen
		Utility.getCurrentViewController().present(signinView, animated: true, completion: nil)
	}
	
	static func show(_ views: [UIView], hides: [UIView]) {
		for view in views {
			view.show()
		}
		for view in hides {
			view.snp.removeConstraints()
			view.hide()
		}
	}
	
	// MARK: - String
	static func jsonLog(_ dictionary: [String:Any]) -> String {
		var jsonString = ""
		let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        jsonString = String.init(data: jsonData, encoding: .utf8) ?? ""
		return jsonString
	}
	
	static func randomSMSCode(num: Int) -> String {
		var code = ""
		for _ in 0..<num {
			code = "\(code)\(arc4random() % 10)"
		}
		return code
	}
	
	static func setStringAttributes(_ text: String, textColor: UIColor? = nil, bgColor: UIColor? = nil, font: UIFont? = nil, underline: Bool, underlineColor: UIColor? = nil) -> NSAttributedString {
        var strAttributes: [NSAttributedString.Key : Any] = [:]
		if underline && underlineColor != nil {
            strAttributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
			strAttributes[.underlineColor] = underlineColor!
		}
		if textColor != nil {
			strAttributes[.foregroundColor] = textColor
		}
		if bgColor != nil {
			strAttributes[.backgroundColor] = bgColor
		}
		if font != nil {
			strAttributes[.font] = font
		}
		return NSAttributedString(string: text, attributes: strAttributes)
	}
	
	static func empty(str: String?, ph: String) -> String {
		if str == nil || str?.trimSpace() == "" {
			return ph
		} else {
			return str!
		}
	}
	
	// MARK: - Path Cache Image
	static func largeProfileCacheImagePath(_ url: String) -> String {
		let filename = url.lastPathComponent()
		let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
		let path = paths[0].stringByAppendingPathComponent(path: "largeProfileimage")
		let filepath = "\(path)/\(filename)"
		return filepath
	}
	
	// MARK: - Image
	static func convertUIImageView(_ view: UIImageView, toColor color: UIColor) {
		view.image = view.image!.withRenderingMode(.alwaysTemplate)
		view.tintColor = color
	}
	
//	static func loadCacheImage
	
	// MARK: - DICTIONARY
	static func sortArrayOfDictionary(_ array: [[String: Any]], withInt key: String, ascending: Bool) -> [[String: Any]] {
		let sortedArray = array.sorted { (firstDict, secondDict) -> Bool in
			if ascending {
				return (firstDict[key] as? Int ?? 0) < (secondDict[key] as? Int ?? 0)
			} else {
				return (firstDict[key] as? Int ?? 0) > (secondDict[key] as? Int ?? 0)
			}
		}
		
		return sortedArray
	}
	static func sortArrayOfDictionary(_ array: [[String: Any]], withString key: String, ascending: Bool) -> [[String: Any]] {
		let sortedArray = array.sorted { (firstDict, secondDict) -> Bool in
			if ascending {
				return (firstDict[key] as? String ?? "") < (secondDict[key] as? String ?? "")
			} else {
				return (firstDict[key] as? String ?? "") > (secondDict[key] as? String ?? "")
			}
		}
		
		return sortedArray
	}
	
	static func compareIntLess(_ firstDict: dictStringAny, _ secondDict: dictStringAny, _ key: String) -> Bool {
		return (firstDict[key] as! Int) < (secondDict[key] as! Int)
	}
	
	static func sortIntArrayOfDictionary(_ array: [dictStringAny], withFirstKey key: String, secondKey: String, ascending: Bool = true) -> [dictStringAny] {
		let sortedArray = array.sorted { (firstDict, secondDict) -> Bool in
			if ascending {
				if (firstDict[key] as? Int ?? 0) == (secondDict[key] as? Int ?? 0) {
					return compareIntLess(firstDict, secondDict, secondKey)
				}
				return compareIntLess(firstDict, secondDict, key)
			} else {
				if (firstDict[key] as? Int ?? 0) == (secondDict[key] as? Int ?? 0) {
					return not(compareIntLess(firstDict, secondDict, secondKey))
				}
				return not(compareIntLess(firstDict, secondDict, key))
			}
		}
		return sortedArray
	}
	static func sortPriorityDateArrayOfDictionary(_ array: [dictStringAny], priorityValue: String, withFirstKey key: String, secondKey: String, ascending: Bool = true) -> [dictStringAny] {
		let sortedArray = array.sorted { (firstDict, secondDict) -> Bool in
			if ascending {
				if Datetime().showDate(firstDict[key] as! Int, short: true, showTime: false) == priorityValue && Datetime().showDate(secondDict[key] as! Int, short: true, showTime: false) == priorityValue {
					return compareIntLess(firstDict, secondDict, secondKey)
				} else if Datetime().showDate(firstDict[key] as! Int, short: true, showTime: false) == priorityValue && Datetime().showDate(secondDict[key] as! Int, short: true, showTime: false) != priorityValue {
					return true
				} else if Datetime().showDate(firstDict[key] as! Int, short: true, showTime: false) != priorityValue && Datetime().showDate(secondDict[key] as! Int, short: true, showTime: false) == priorityValue {
					return false
				} else if Datetime().showDate(firstDict[secondKey] as! Int, short: true, showTime: false) == priorityValue && Datetime().showDate(secondDict[secondKey] as! Int, short: true, showTime: false) == priorityValue {
					return compareIntLess(firstDict, secondDict, key)
				} else if Datetime().showDate(firstDict[secondKey] as! Int, short: true, showTime: false) == priorityValue && Datetime().showDate(secondDict[secondKey] as! Int, short: true, showTime: false) != priorityValue {
					return true
				} else if Datetime().showDate(firstDict[secondKey] as! Int, short: true, showTime: false) != priorityValue && Datetime().showDate(secondDict[secondKey] as! Int, short: true, showTime: false) == priorityValue {
					return false
				} else {
					if (firstDict[secondKey] as! Int) == (secondDict[secondKey] as! Int) {
						return compareIntLess(firstDict, secondDict, key)
					}
					return compareIntLess(firstDict, secondDict, secondKey)
				}
			} else {
				if Datetime().showDate(firstDict[key] as! Int, short: true, showTime: false) == priorityValue && Datetime().showDate(secondDict[key] as! Int, short: true, showTime: false) == priorityValue {
					return not(compareIntLess(firstDict, secondDict, secondKey))
				} else {
					if (firstDict[key] as! Int) == (secondDict[key] as! Int) {
						return not(compareIntLess(firstDict, secondDict, secondKey))
					}
					return not(compareIntLess(firstDict, secondDict, key))
				}
			}
		}
		return sortedArray
	}
	
	static func valueForKeyPath(_ key: String, arrayOfDict: [dictStringAny]) -> [Any] {
		let arrayForKey = arrayOfDict.map { (dict) -> Any in
			return dict[key] as Any
		}
		return arrayForKey
	}
	
	// MARK: - CALENDAR REMINDER
	static func addEvent(title: String, startDate: UInt, endDate: UInt, note: String?, type: String, url: String) {
		
		let eventStore : EKEventStore = EKEventStore()
		// 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
		
		eventStore.requestAccess(to: .event) { (granted, error) in
			
			if (granted) && (error == nil) {
				let event : EKEvent = EKEvent(eventStore: eventStore)
				let dateFrom = startDate
				let dateTo = endDate
				
				event.title = title
				event.startDate = Datetime().dateWith(timeinterval: dateFrom)
				event.endDate = Datetime().dateWith(timeinterval: (dateFrom == dateTo ? dateTo : dateTo))
				if let note = note {
					event.notes = note
				}
				for time in (type == "calendar" ? DataConfig.timeReminderCalendar : DataConfig.timeReminderPretest) {
					let alarm: EKAlarm = EKAlarm(relativeOffset: TimeInterval(-time))
					event.addAlarm(alarm)
				}

				event.isAllDay = true
				event.url = URL(string: url)
				event.calendar = eventStore.defaultCalendarForNewEvents
				do {
					try eventStore.save(event, span: .thisEvent)
                } catch _ as NSError {
					Utility.showAlert(title: string.th_error, detail: string.th_try_again)
				}
				
				Utility.showAlert(title: "เพิ่ม\(string.th_calendar)\(string.th_complete)", detail: "เพิ่ม Event ไปยัง Calendar เรียบร้อย")
			}
			else{
				Utility.showAlert(title: string.th_error, detail: string.th_try_again)
			}
		}
	}
	
	// MARK: - ALERT VIEW
	static func showAlert(title: String, detail: String) {
        let confirmAlert = UIAlertController(title: title, message: detail, preferredStyle: UIAlertController.Style.alert)
		confirmAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: nil))
		Utility.getCurrentViewController().present(confirmAlert, animated: true, completion: nil)
	}
	
	// MARK: - NUMBER
	static func checkFloat(_ num: Float) -> String {
		var numString = "0"
		if Int(num * 1000) % 1000 == 0 {
			numString = "\(Int(num))"
		} else {
			let t = Int(num * 1000)
			var numFormat = "%.3f"
			if t % 10 == 0 && t % 100 == 0 {
				numFormat = "%.1f"
			} else if t % 10 == 0 && t % 100 != 0 {
				numFormat = "%.2f"
			}
			numString = String(format: numFormat, num)
		}
		return numString
	}
	
	static func commaNumber(_ num: Int) -> String {
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = NumberFormatter.Style.decimal
		return numberFormatter.string(from: NSNumber(value: num))!
	}
	
	// MARK: - COUPON
	@objc static func sendCoupon(_ api: API, path: String, redeemCode: String, deletePath: @escaping (String) -> ()) {
		api.redeemCode(redeemCode) { (finished, response) in
			if finished {
				let couponSuccessAlert = PackageAlertView(withView: Utility.getCurrentViewController().tabBarController!.view, title: "ใช้คูปองสำเร็จแล้ว", detail: Validation.anyIsString(Validation.anyIsDictionary(response!, with: "result"), with: "alert"), button: string.th_ok, success: finished)
				couponSuccessAlert.showLayout()
				deletePath(path)
			} else if response != nil {
				if Validation.anyIsString(Validation.anyIsDictionary(response!, with: "error"), with: "description") == "Invalid redeem code." || Validation.anyIsString(Validation.anyIsDictionary(response!, with: "error"), with: "description") == "Redeem code was used." {
                    let usedCouponAlert = UIAlertController(title: "ใช้คูปองไม่สำเร็จ", message: Validation.anyIsString(Validation.anyIsDictionary(response!, with: "error"), with: "message"), preferredStyle: UIAlertController.Style.alert)
					usedCouponAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: nil))
					Utility.getCurrentViewController().present(usedCouponAlert, animated: true, completion: nil)
					deletePath(path)
				} else {
					let errAlert = PackageAlertView(withView: Utility.getCurrentViewController().tabBarController!.view, title: "ใช้คูปองไม่สำเร็จ", detail: Validation.anyIsString(Validation.anyIsDictionary(response!, with: "error"), with: "message"), button: string.th_try_again, success: finished)
					errAlert.showLayout()
				}
			} else {
				
			}
		}
	}
    
    static func dialogConfirmRevoked(title: String,isShowButton: Bool = false,isShowTextField:Bool = false,isNotAppleId:Bool = false, completion: @escaping () -> Void) {
        let popupAlertView = CustomDialogRevokeAppleView(frame: UIScreen.main.bounds)
        popupAlertView.title = title
//        popupAlertView.aboutSubscriptionforIosLabel.isHidden = true
//        popupAlertView.descriptionSubscriptionforIostextView.isHidden = true
//        popupAlertView.linkAccountSubscription.isHidden = true
        popupAlertView.titleConfirmDeleteAccountLabel.isHidden = isShowTextField == true ? false : true
        popupAlertView.confirmDeleteAccountTextField.isHidden = isShowTextField == true ? false : true
        popupAlertView.isNotAppleId = isNotAppleId
        popupAlertView.closeButtonTitle = "ยกเลิก"
        popupAlertView.acceptButtonTitle = "ยืนยัน"
        popupAlertView.didAcceptButtonTapped = { () -> Void in
            popupAlertView.dismiss(for: popupAlertView, completion: nil)
            completion()
        }
        popupAlertView.didCloseButtonTapped = { () -> Void in
            popupAlertView.dismiss(for: popupAlertView, completion: nil)
        }
        popupAlertView.show(for: popupAlertView.containerView, animation: .fade)
    }
    
    static func dialogConfirmAccountDeleteMemberforNoPhoneORNoNoEmail(title: String, completion: @escaping (String) -> Void) {
        let popupAlertView = DialogSendOTPNoPhoneORNoEmailView(frame: UIScreen.main.bounds)
        popupAlertView.title = title
        popupAlertView.closeButtonTitle = "ยกเลิก"
        popupAlertView.acceptButtonTitle = "ยืนยัน"
        popupAlertView.didAcceptButtonTapped = { (otpCode:String) -> Void in
            popupAlertView.dismiss(for: popupAlertView, completion: nil)
            completion(otpCode)
        }
        popupAlertView.didCloseButtonTapped = { () -> Void in
            popupAlertView.dismiss(for: popupAlertView, completion: nil)
        }
        popupAlertView.show(for: popupAlertView.containerView, animation: .fade)
    }
    
    static func  dialogConfirmAccountDeleteMember(title: String,emailOrPhone:String, completion: @escaping (String) -> Void) {
        let popupAlertView = DialogSendOTPforDeleteAccountView(frame: UIScreen.main.bounds)
        popupAlertView.title = title
        popupAlertView.emailOrPhone = emailOrPhone
        popupAlertView.closeButtonTitle = "ยกเลิก"
        popupAlertView.acceptButtonTitle = "ยืนยัน"
        popupAlertView.didAcceptButtonTapped = { (otpCode:String) -> Void in
            popupAlertView.dismiss(for: popupAlertView, completion: nil)
            completion(otpCode)
        }
        popupAlertView.didCloseButtonTapped = { () -> Void in
            popupAlertView.dismiss(for: popupAlertView, completion: nil)
        }
        popupAlertView.show(for: popupAlertView.containerView, animation: .fade)
    }
	
	// MARK: - USER DEFAULT
}

class CheckArray<T> {
	
	static func check(_ arr: [T], index: Int) -> T? {
		if index < arr.count {
			return arr[index]
		}
		return nil
	}
}
