//
//  LocalNotifications.swift
//  ratchakan
//
//  Created by JJsobtid on 15/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import Foundation

enum NotificationType: String {
	case calendar = "calendar"
	case url = "url"
	case image = "image"
	case imageText = "imageText"
	case package = "package"
	case pretest = "pretest"
	case pretestStart = "preteststart"
	case pretestThirty = "pretest30"
	case pretestCalFinished = "pretestcalfinish"
}

class LocalNotifications: NSObject {
	
	class var sharedInstance: LocalNotifications {
		struct Static {
			static let instance: LocalNotifications = LocalNotifications()
		}
		return Static.instance
	}
	
	var api: API!
	var member: dictStringAny!
	var defaultTime: String!
	var dateInterval: [UInt] = [10, 60, 60*2]
	override init() {
		
		api = API()
		member = api.getDatabase().getMember()
        defaultTime = (member["time_noti"] as! String)
		
	}
    func addNoti(_ data: dictStringAny, alert: UInt) {
        for time in dateInterval {
            let notification = UILocalNotification()
            notification.alertBody = "Alert \"\(data["title"])\" Is Coming In \(Datetime.timeFromSec(CLong(time), haveSpace: false))" // text that will be displayed in the notification
            notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
            notification.fireDate = Datetime().dateWith(timeinterval: alert + time) // todo item due date (when notification will be fired
            notification.category = "calendar"
            notification.soundName = UILocalNotificationDefaultSoundName // play default sound
            notification.userInfo = ["title": data["title"], "UUID": "\(alert)"] // assign a unique identifier to the notification so that we can retrieve it later
            
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
	
	func removeNoti(_ data: dictStringAny) {
		let scheduledNotifications: [UILocalNotification]? = UIApplication.shared.scheduledLocalNotifications
		guard scheduledNotifications != nil else {return} // Nothing to remove, so return
		
		for notification in scheduledNotifications! { // loop through notifications...
			if (notification.userInfo!["title"] as! String == data["title"] as! String) && notification.userInfo!["UUID"] as! String == data["UUID"] as! String { // ...and cancel the notification that corresponds to this TodoItem instance (matched by UUID)
				UIApplication.shared.cancelLocalNotification(notification) // there should be a maximum of one match on UUID
				break
			}
		}
	}
	
	func removeAllNoti() {
		let scheduledNotifications: [UILocalNotification]? = UIApplication.shared.scheduledLocalNotifications
		guard scheduledNotifications != nil else {return} // Nothing to remove, so return
		
		UIApplication.shared.cancelAllLocalNotifications()
	}
}
