//
//  PretestCollectionModel.swift
//  ratchakan
//
//  Created by JJsobtid on 17/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class PretestCollectionModel: NSObject {
	var pretestCollectionData: [Any]
	var type: TypePretest
	var api: API
	var loaded: Bool
	
	init(_ data: [PretestModel], type: TypePretest) {
		pretestCollectionData = data
		api = API()
		self.type = type
		loaded = true
		
		super.init()
	}
	
    func loadPretestList(_ result: @escaping () -> ()) {
        var arrPretestData: [[String:Any]] = []
        api = API()
        pretestCollectionData = []
        loaded = false
        if type == .allevent {
            self.api.getPretestEvents({ (finished, responseObject) in
                if finished {
                    arrPretestData += Utility.sortArrayOfDictionary(responseObject!["result"] as! [[String:Any]], withInt: "createdAt", ascending: false)
                } else {
                    
                }
                for eachPretest in arrPretestData {
                    if Validation.dictionary(eachPretest, with: "pretestId") {
                        self.pretestCollectionData.append(PretestModel(withDictionary: eachPretest))
                    } else {
                        self.pretestCollectionData.append(PromotionPretestModel(withDictionary: eachPretest))
                    }
                }
                self.loaded = true
                result()
                return
            })
        } else if type == .pastevent {
            api.getPastPretestEvents({ (finished, response) in
                if finished {
                    arrPretestData = Utility.sortArrayOfDictionary(response!["result"] as! [[String:Any]], withInt: "startRegisterDate", ascending: false)
                } else {
                    
                }
                for eachPretest in arrPretestData {
                    self.pretestCollectionData.append(PretestModel(withDictionary: eachPretest))
                }
                self.loaded = true
                result()
                return
            })
        } else if type == .myevent {
            api.getMyPretestEvents({ (finished, response) in
                if finished {
                    arrPretestData = response!["result"] as! [[String:Any]]
                } else {
                    
                }
                for eachPretest in arrPretestData {
                    self.pretestCollectionData.append(PretestModel(withDictionary: eachPretest))
                }
                self.loaded = true
                result()
                return
            })
        }
        return
    }
}
