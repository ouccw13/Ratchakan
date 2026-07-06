//
//  PretestModel.swift
//  ratchakan
//
//  Created by JJsobtid on 17/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import Firebase
import CryptoSwift

struct Price {
	var inapp = 0
	var counterservice = 0
	var mol = 0
	var inappID = ""
	var inappDc = 0
	var counterserviceDc = 0
	var discountExp = 0
	var isPromotion = false
	
	init(priceData: [String: Any], discountData: [String: Any]) {
		inappID = Validation.anyIsString(Validation.anyIsDictionary(priceData, with: "INAPP"), with: "id")
		inapp = Validation.anyIsNumber(Validation.anyIsDictionary(priceData, with: "INAPP"), with: "value")
		counterservice = Validation.anyIsNumber(priceData, with: "THB")
		mol = Validation.anyIsNumber(priceData, with: "MOL")
		inappDc = Validation.anyIsNumber(Validation.anyIsDictionary(discountData, with: "INAPP"), with: "value")
		counterserviceDc = Validation.anyIsNumber(discountData, with: "THB")
		discountExp = Validation.anyIsNumber(discountData, with: "expireDate")
		if Double(discountExp) > Date().timeIntervalSince1970 {
			isPromotion = true
		}
	}
}

struct roundSelected {
	var round: Int = 0
	var pretestDate: Int = 0
	var pretestEndDate: Int = 0
	var date: Int = 0
	var action: Int = 0
	
	mutating func set(round: Int, from: Int, toDate: Int, dateIndex: Int, action: Int) {
		self.round = round
		self.pretestDate = from
		self.pretestEndDate = toDate
		self.date = dateIndex
		self.action = action
	}
}

class PretestModel: NSObject {
	
	var pretestDictionary: Dynamic<dictStringAny>!
	
	var pretestName: String
	var sponsorName: String
	var teacherName: String
	var teacherProfile: String
	var timeLimit: Int
	var totalScore: Float
	var vipPrice: Price
	var regularPrice: Price
	var banner: [String: Any]
	var colorHEX: String
	var dateGroup: [[String: Any]]
	var details: [dictStringAny]
    // MARK: detailsFilterNotZero
    var detailsFilterNotZero: [DetailsInPretestModel] = []
    var category: [Categories] = []
    
	var pretestUpdate: Dynamic<Int>
	var earlyBirdDate: Int
	var limitNumRegis: Int
	var pretestDate: Int
	var pretestID: String
	var questionID: [String]
	var questionNum: Int
	var question: String
	var round: Dynamic<[[String: Any]]>
	var startRegisDate: Int
	var endRegisDate: Int
	var selectedRound: roundSelected
	var originalRound: roundSelected
	var roundFirst: Bool
	
	var api = API()
	var member: member
	var ownerPretest: Dynamic<Bool>
	var roundPretest: Int?
	var summitPretest: Dynamic<Bool>
	
	var listenerPretest: ListenerRegistration?
	
	init(withDictionary data: [String: Any]) {
		
		pretestDictionary = Dynamic(data)
		
		roundFirst = true
		ownerPretest = Dynamic(false)
		summitPretest = Dynamic(false)
		member = api.getMember()
		
		pretestID = Validation.anyIsString(data, with: "pretestId")
		pretestName = Validation.anyIsString(data, with: "name")
		sponsorName = Validation.anyIsString(data, with: "sponsorName")
		teacherName = Validation.anyIsString(data, with: "teacherName")
		teacherProfile = Validation.anyIsString(Validation.anyIsDictionary(data, with: "creator"), with: "profileImage")
		timeLimit = Validation.anyIsNumber(data, with: "duration")
		totalScore = Validation.anyIsFloat(data, with: "totalScore")
		banner = Validation.anyIsDictionary(data, with: "banner")
		colorHEX = Validation.anyIsString(data, with: "color")
		dateGroup = Validation.anyIsArrayAny(data, with: "dateGroup")
		var index = 0
		for date in dateGroup {
			let groupTime = Validation.anyIsArrayAny(date, with: "group").filter { (time) -> Bool in
				if Validation.anyIsNumber(time, with: "pretestEndDate") <= Datetime.getCurrentTimestamp() {
					return false
				}
				return true
			}
			dateGroup[index]["group"] = groupTime
			index += 1
		}
		dateGroup = dateGroup.filter { (date) -> Bool in
			if Validation.anyIsArrayAny(date, with: "group").count == 0 {
				return false
			}
			return true
		}
		details = Validation.anyIsArrayAny(data, with: "detail")
		pretestUpdate = Dynamic(Validation.anyIsNumber(data, with: "updatedAt"))
		earlyBirdDate = Validation.anyIsNumber(data, with: "earlyBirdDate")
		limitNumRegis = Validation.anyIsNumber(data, with: "capacity")
		pretestDate = Validation.anyIsNumber(data, with: "pretestDate")
		questionID = Validation.anyIsArrayString(data, with: "questionId")
		questionNum = Validation.anyIsNumber(data, with: "questionQty")
		question = Validation.anyIsString(data, with: "questions")
		round = Dynamic(Validation.anyIsArrayAny(data, with: "round"))
		startRegisDate = Validation.anyIsNumber(data, with: "startRegisterDate")
		endRegisDate = Validation.anyIsNumber(data, with: "endRegisterDate")
		selectedRound = roundSelected()
		originalRound = roundSelected()
		vipPrice = Price(priceData: Validation.anyIsDictionary(Validation.anyIsDictionary(data, with: "price"), with: "vip"), discountData: Validation.anyIsDictionary(Validation.anyIsDictionary(data, with: "price"), with: "vip"))
		regularPrice = Price(priceData: Validation.anyIsDictionary(Validation.anyIsDictionary(data, with: "price"), with: "regular"), discountData: Validation.anyIsDictionary(Validation.anyIsDictionary(data, with: "price"), with: "regular"))
        
        // MARK: Filter map details for not equal zero
        category.removeAll()
        detailsFilterNotZero.removeAll()
        for item in details {
            if item["qty"] as! Int > 0 {
                let categories =  item["categories"] as? [Categories] ?? []
                if categories.count  > 0 {
                    for categorie in categories  {
                        category.append(Categories(id: categorie.id, name: categorie.name))
                    }
                    detailsFilterNotZero.append(DetailsInPretestModel(subjectId: item["subjectId"] as! String, content: item["content"] as! String, categories: self.category, qty: item["qty"] as! Int))
                }else{
                    detailsFilterNotZero.append(DetailsInPretestModel(subjectId: item["subjectId"] as! String, content: item["content"] as! String, categories: [], qty: item["qty"] as! Int))
                }
            }
        }
		super.init()
		
		checkOwner()
		NotificationCenter.default.addObserver(self, selector: #selector(recheckOwner), name: NSNotification.Name(rawValue: NotiCenter.checkLogIn), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(recheckOwner), name: NSNotification.Name(rawValue: NotiCenter.logOut), object: nil)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	func loadPretestData() {
		if listenerPretest == nil {
			let db = Firestore.firestore()
			listenerPretest = db.collection(pretests).document(pretestID).addSnapshotListener({ (snapshot, error) in
				guard let document = snapshot else {
					return
				}
				if document.exists {
					self.updatePretest(withDictionary: document.data()!)
				}
			})
		}
	}
	
	func checkOwner() {
		for eachRound in round.value {
			if Validation.anyIsNumber(eachRound, with: "pretestEndDate") >= Datetime.getCurrentTimestamp() {
				selectedRound.set(round: Validation.anyIsNumber(eachRound, with: "round"), from: Validation.anyIsNumber(eachRound, with: "pretestDate"), toDate: Validation.anyIsNumber(eachRound, with: "pretestEndDate"), dateIndex: 0, action: Validation.anyIsNumber(eachRound, with: "action"))
				originalRound.set(round: Validation.anyIsNumber(eachRound, with: "round"), from: Validation.anyIsNumber(eachRound, with: "pretestDate"), toDate: Validation.anyIsNumber(eachRound, with: "pretestEndDate"), dateIndex: 0, action: Validation.anyIsNumber(eachRound, with: "action"))
				break
			}
		}
		if member.member_id != "" {
			for eachRound in round.value {
				
				if let regisMember = eachRound["registerMember"] as? [String] {
					print(str: Utility.jsonLog(eachRound))
					if regisMember.contains(member.member_id) {
						DispatchQueue.main.async {
							LoadPretest.writePretest(self.pretestID, question: self.question)
						}
						ownerPretest.value = true
						roundPretest = Validation.anyIsNumber(eachRound, with: "round")
						summitPretest.value = false
						var index = 0, dateIndex = 0
						for group in dateGroup {
							for date in Validation.anyIsArrayAny(group, with: "group") {
								if Validation.anyIsNumber(date, with: "round") == roundPretest! {
									dateIndex = index
									break
								}
							}
							index = index + 1
						}
						selectedRound.set(round: roundPretest!, from: Validation.anyIsNumber(eachRound, with: "pretestDate"), toDate: Validation.anyIsNumber(eachRound, with: "pretestEndDate"), dateIndex: dateIndex, action: Validation.anyIsNumber(eachRound, with: "action"))
						originalRound.set(round: roundPretest!, from: Validation.anyIsNumber(eachRound, with: "pretestDate"), toDate: Validation.anyIsNumber(eachRound, with: "pretestEndDate"), dateIndex: dateIndex, action: Validation.anyIsNumber(eachRound, with: "action"))
						if (eachRound["submitMember"] as! [String]).contains(member.member_id) {
							summitPretest.value = true
						}
						break
					}
				} else {
					ownerPretest.value = false
					summitPretest.value = false
				}
			}
		} else {
			ownerPretest.value = false
			summitPretest.value = false
		}
	}
	
	@objc func recheckOwner() {
		api = API()
		member = api.getMember()
		ownerPretest.value = false
		summitPretest.value = false
		checkOwner()
	}
	
	func updatePretest(withDictionary data: [String: Any]) {
		
		pretestName = Validation.anyIsString(data, with: "name")
		sponsorName = Validation.anyIsString(data, with: "sponsorName")
		teacherName = Validation.anyIsString(data, with: "teacherName")
		teacherProfile = Validation.anyIsString(Validation.anyIsDictionary(data, with: "creator"), with: "profileImage")
		timeLimit = Validation.anyIsNumber(data, with: "duration")
		totalScore = Validation.anyIsFloat(data, with: "totalScore")
		banner = Validation.anyIsDictionary(data, with: "banner")
		colorHEX = Validation.anyIsString(data, with: "color")
		dateGroup = Validation.anyIsArrayAny(data, with: "dateGroup")
		var index = 0
		for date in dateGroup {
			let groupTime = Validation.anyIsArrayAny(date, with: "group").filter { (time) -> Bool in
				if Validation.anyIsNumber(time, with: "pretestEndDate") <= Datetime.getCurrentTimestamp() {
					return false
				}
				return true
			}
			dateGroup[index]["group"] = groupTime
			index += 1
		}
		dateGroup = dateGroup.filter { (date) -> Bool in
			if Validation.anyIsArrayAny(date, with: "group").count == 0 {
				return false
			}
			return true
		}
		pretestUpdate.value = Validation.anyIsNumber(data, with: "updatedAt")
		earlyBirdDate = Validation.anyIsNumber(data, with: "earlyBirdDate")
		limitNumRegis = Validation.anyIsNumber(data, with: "capacity")
		pretestDate = Validation.anyIsNumber(data, with: "pretestDate")
		questionID = Validation.anyIsArrayString(data, with: "questionId")
		questionNum = Validation.anyIsNumber(data, with: "questionQty")
		question = Validation.anyIsString(data, with: "questions")
		round = Dynamic(Validation.anyIsArrayAny(data, with: "round"))
		startRegisDate = Validation.anyIsNumber(data, with: "startRegisterDate")
		endRegisDate = Validation.anyIsNumber(data, with: "endRegisterDate")
		vipPrice = Price(priceData: Validation.anyIsDictionary(Validation.anyIsDictionary(data, with: "price"), with: "vip"), discountData: Validation.anyIsDictionary(Validation.anyIsDictionary(data, with: "price"), with: "vip"))
		regularPrice = Price(priceData: Validation.anyIsDictionary(Validation.anyIsDictionary(data, with: "price"), with: "regular"), discountData: Validation.anyIsDictionary(Validation.anyIsDictionary(data, with: "price"), with: "regular"))
		
		checkOwner()
		pretestDictionary.value = data
	}
	
	func removeListener() {
		listenerPretest?.remove()
		listenerPretest = nil
	}
	func connectListener() {
		loadPretestData()
	}
	
	func changeRound(_ complete: @escaping complete) {
		api.changeRoundPretest(pretestID, oldRound: originalRound.round, newRound: selectedRound.round) { (finished, response) in
			if finished {
				self.originalRound = self.selectedRound
			}
			complete(finished, response)
			return
		}
	}
}

class PromotionPretestModel: NSObject {
	var promotionID: String
	var promotionName: String
	var vipPrice: Price
	var regularPrice: Price
	var banner: [String: Any]
	var colorHEX: String
	var promotionUpdate: Int
	var earlyBirdDate: Int
	var endRegisDate: Int
	var startRegisDate: Int
	var pretestList: [String]
	var pretestListData: [PretestModel]
	var pretestLoaded: Dynamic<Bool>
	
	init(withDictionary data: [String: Any]) {
		promotionID = Validation.anyIsString(data, with: "promotionId")
		promotionName = Validation.anyIsString(data, with: "name")
		banner = Validation.anyIsDictionary(data, with: "banner")
		colorHEX = "#ff3255"//Validation.anyIsString(data, with: "color")
		promotionUpdate = Validation.anyIsNumber(data, with: "updatedAt")
		earlyBirdDate = Validation.anyIsNumber(data, with: "early_bird_date")
		endRegisDate = Validation.anyIsNumber(data, with: "endRegisterDate")
		startRegisDate = Validation.anyIsNumber(data, with: "startRegisterDate")
		pretestList = Validation.anyIsArrayString(data, with: "pretests")
		pretestLoaded = Dynamic(false)
		pretestListData = []
		
		vipPrice = Price(priceData: Validation.anyIsDictionary(Validation.anyIsDictionary(data, with: "price"), with: "vip"), discountData: Validation.anyIsDictionary(Validation.anyIsDictionary(data, with: "price"), with: "vip"))
		regularPrice = Price(priceData: Validation.anyIsDictionary(Validation.anyIsDictionary(data, with: "price"), with: "regular"), discountData: Validation.anyIsDictionary(Validation.anyIsDictionary(data, with: "price"), with: "regular"))
		
		super.init()
		
		loadPretest()
	}
	
	func loadPretest() {
		for pretestId in pretestList {
			let db = Firestore.firestore()
			db.collection(pretests).document(pretestId).getDocument(completion: { (pretest, error) in
				if let err = error {
					print(str: err)
					return
				} else {
					if pretest!.exists {
						self.pretestListData.append(PretestModel(withDictionary: pretest!.data()!))
					} else {
						return
					}
				}
				if self.pretestListData.count == self.pretestList.count {
					self.pretestLoaded.value = true
				}
			})
		}
	}
}
