//
//  tempAPI.swift
//  ratchakan
//
//  Created by JJsobtid on 14/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation

enum function {
	case logIn
	case myAccount
	case subjectGroup
	case contactUs
	case helpUs
	case historyPurchase
	case pretest
	case reportExam
	case calendarGroup
	case otp
	case other
}

let TIME_OUT = 5.0

class tempAPI {
	
	static func makeRequest(_ complete: @escaping complete, function: function, success: Bool) {
		DispatchQueue.main.asyncAfter(deadline: .now() + TIME_OUT, execute: {
			if function == .logIn {
				complete(success, logIn)
			} else if function == .myAccount {
				complete(success, myAccount)
			} else if function == .subjectGroup {
				complete(success, subjectGroup)
			} else if function == .contactUs {
				complete(success, contactUs)
			} else if function == .reportExam {
				complete(success, reportExamType)
			} else if function == .calendarGroup {
				complete(success, calendarGroup)
			} else if function == .otp {
				complete(success, otp)
			}
			else {
				complete(false, funcNotFound)
			}
			return
		})
	}
    
	static let funcNotFound: [String:Any] = [
		"status" : 400,
		"message" : "NO CONTENT",
		"result" : []
	]
	
	static let logIn: [String:Any] = [
		"status" : 200,
		"message" : "OK",
		"result" : [
			"uuid" : "03d031cdf0cb4c4dafc187d64870ab14",
			"token" : "7a630894a60338d549c1c066ae54d40a",
			"member_id": "xTL8Ywj3H1Wek7yGcHf63WNpsk5DPV",
			"session_id": "5jE8pb98cWT5NGq00c29AGUlYNVSHy",
		]
	]
    
	static let myAccount: [String: Any] = [:]
	static let otp: dictStringAny = ["status" : 200,
									 "message" : "OK",
									 "result" : [
										"email" : false,
										"otp" : 1234,
										"otp_expired": "30 minutes later",
										"phoneNumber": false,
									]]
    
	static let subjectGroup: [String: Any] = [
		"status": "completed",
		"message": "",
		"result": [ "subject_group": [ ["group_id": 3,
										"group_name": "9 วิชาสามัญ",
										"image": "https://api.sobtid.me/image/subject/ff733313-e2c5-48a1-9172-1da31f043896.png",
										"description": "ข้อสอบกลางที่จัดสอบโดย สทศ. เพื่อใช้ในการรับตรงเข้ามหาวิทยาลัย ",
										"random_view": 0,
										"color_rgb": [  "r": "240",
														"g": "140",
														"b": "0"],
										"color_html": "#F08C00",
										"order": 1 ],
									   ["group_id": 0,
										"group_name": "O-NET",
										"image": "https://api.sobtid.me/image/subject/6932ad16-b1f3-451b-902d-541156858b78.png",
										"description": "การทดสอบทางการศึกษาระดับชาติขั้นพื้นฐาน ครอบคลุม 5 กลุ่มสาระการเรียนรู้ ",
										"random_view": 1,
										"color_rgb": [  "r": "0",
														"g": "100",
														"b": "255"],
										"color_html": "#0064FF",
										"order": 2 ],
									   ["group_id": 2,
										"group_name": "GAT",
										"image": "https://api.sobtid.me/image/subject/d1560d07-fb9d-425a-9d06-4d0571ac046c.png",
										"description": "การวัดศักยภาพในการเรียนในมหาวิทยาลัยให้ประสบความสำเร็จ",
										"random_view": 0,
										"color_rgb": [  "r": "15",
														"g": "180",
														"b": "140"],
										"color_html": "#0FB48C",
										"order": 3 ],
									   ["group_id": 1,
										"group_name": "PAT",
										"image": "https://api.sobtid.me/image/subject/c3b917d4-b4be-4190-a70a-6d33147cd201.png",
										"description": "การวัดความรู้ที่เป็นพื้นฐาน กับศักยภาพที่จะเรียนในวิชาชีพนั้น ๆ ให้ประสบความสำเร็จ",
										"random_view": 0,
										"color_rgb": [	"r": "255",
														"g": "0",
														"b": "0"],
										"color_html": "#FF0000",
										"order": 4 ],
									   ["group_id": 0,
										"group_name": "O-NET",
										"image": "https://api.sobtid.me/image/subject/6932ad16-b1f3-451b-902d-541156858b78.png",
										"description": "การทดสอบทางการศึกษาระดับชาติขั้นพื้นฐาน ครอบคลุม 5 กลุ่มสาระการเรียนรู้ ",
										"random_view": 1,
										"color_rgb": [  "r": "0",
														"g": "100",
														"b": "255"],
										"color_html": "#0064FF",
										"order": 2 ],
									   ["group_id": 2,
										"group_name": "GAT",
										"image": "https://api.sobtid.me/image/subject/d1560d07-fb9d-425a-9d06-4d0571ac046c.png",
										"description": "การวัดศักยภาพในการเรียนในมหาวิทยาลัยให้ประสบความสำเร็จ",
										"random_view": 0,
										"color_rgb": [  "r": "15",
														"g": "180",
														"b": "140"],
										"color_html": "#0FB48C",
										"order": 3 ],
									   ["group_id": 1,
										"group_name": "PAT",
										"image": "https://api.sobtid.me/image/subject/c3b917d4-b4be-4190-a70a-6d33147cd201.png",
										"description": "การวัดความรู้ที่เป็นพื้นฐาน กับศักยภาพที่จะเรียนในวิชาชีพนั้น ๆ ให้ประสบความสำเร็จ",
										"random_view": 0,
										"color_rgb": [	"r": "255",
														  "g": "0",
														  "b": "0"],
										"color_html": "#FF0000",
										"order": 4 ] ]
				]
	]
	
	static let contactUs: [String: Any] = [ "status": "completed",
											"message": "",
											"result": [ "companyname": "บริษัท สอบติดเอ็ดดูเทนเมนท์ จำกัด",
														"address": "เลขที่ 3 อาคารพร้อมพันธ์ 3 ห้อง 603 ซอยลาดพร้าว 3 ถนนลาดพร้าว แขวงจอมพล เขตจตุจักร กทม 10900",
														"tel": "02-024-6668",
														"email": "support@sobtid.me",
														"line": "@sobtid",
														"instagram": "sobtid.me",
														"facebook": "https://www.facebook.com/sobtid.me/",
														"facebookID": "1668306550097973",
														"twitter": "Sobtid_me",
														"twitterID": "Sobtid_me" ] ]
	
	static let helpUs: [String: Any] = [ "status": "completed",
										 "message": "",
										 "result": [ "companyname": "บริษัท สอบติดเอ็ดดูเทนเมนท์ จำกัด",
													 "address": "เลขที่ 3 อาคารพร้อมพันธ์ 3 ห้อง 603 ซอยลาดพร้าว 3 ถนนลาดพร้าว แขวงจอมพล เขตจตุจักร กทม 10900",
													 "tel": "02-024-6668",
													 "email": "support@sobtid.me",
													 "line": "@sobtid",
													 "instagram": "sobtid.me",
													 "facebook": "https://www.facebook.com/sobtid.me/",
													 "facebookID": "1668306550097973",
													 "twitter": "Sobtid_me",
													 "twitterID": "Sobtid_me" ] ]
	
	static let pretest: [String: Any] = [ "status": "completed",
										  "message": "",
										  "result": [ "tutor_detail" : ["profile_image" : "", "tutor_name" : "hello"],
													  "pretest_name" : "test",
													  "price" : 80,
													  "banner": [] ] ]
	
	static let reportExamType: dictStringAny = [ "status": "completed",
												 "message": "",
												 "result": [ "typeExamReport": [["name" : "คำถาม", "id" : "0"],
																				["name" : "คำตอบ", "id" : "1"],
																				["name" : "บทความ", "id" : "2"],
																				["name" : "อื่น ๆ", "id" : "3"] ] ] ]
	
	static let calendarGroup: dictStringAny = [ "status": "completed",
												"message": "",
												"result": [ "calendarGroup": [["name" : "ทั้งหมด", "id" : "0"],
																			   ["name" : "เปิดรับสมัคร", "id" : "1"],
																			   ["name" : "ประกาศผล", "id" : "2"],
																			   ["name" : "สัมภาษณ์", "id" : "3"] ] ] ]
}
