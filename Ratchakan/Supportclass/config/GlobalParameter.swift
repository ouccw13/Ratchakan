//
//  GlobalParameter.swift
//  ratchakan
//
//  Created by JJsobtid on 11/6/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class GlobalParameter: NSObject {

	lazy var api = API()
	var newMoreStore: Bool
	
	class var storeObserverSharedInstance: GlobalParameter {
		struct Static {
			static let instance: GlobalParameter = GlobalParameter()
		}
		return Static.instance
	}
	
	override init() {
		
		newMoreStore = true
		super.init()
		
//		var iTunesData: [String: Any] = [:]
//		api.getiTunesData { (finished, response) in
//			guard let result = response!["resultCount"] as? Int else {
//				return
//			}
//			if result > 0 {
//				let results = response!["results"] as! [Any]
//				iTunesData = results[0] as! [String : Any]
//				let cur_version = Utility.getAppVersion()
//				let store_version = iTunesData["version"] as! String
//
//				let arrCurrent = cur_version.split(separator: ".")
//				let arrStore = store_version.split(separator: ".")
//
//				if arrStore.count != arrCurrent.count {
////					self.newMoreStore = false
//				} else if arrCurrent[0] <= arrStore[0] && arrCurrent[1] <= arrStore[1] && arrCurrent[2] <= arrStore[2] {
////					self.newMoreStore = false
//				}
//			}
//		}
	}
	
}
