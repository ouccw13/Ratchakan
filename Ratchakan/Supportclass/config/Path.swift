//
//  Path.swift
//  ratchakan
//
//  Created by JJsobtid on 13/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation

let API_DEV = "https://gateway.sobtid.me/official/v1/dev"
let API_ROOT = "https://gateway.sobtid.me/official/v1"
let USE_API = API_ROOT
let hash = "kWUd59GdbR-fAzA9uu1S3-YslKqeOSQC-jz4sC5ofFH-8ycopj23F1"

class Path {
	
	static let getiTunes = "http://itunes.apple.com/lookup?id=\(myAppID)"
	static let iTunesURL = "https://itunes.apple.com/app/id\(myAppID)?ls=1&mt=8"

	static let token = "\(USE_API)/members/guest/\(hash)"
	static let authToken = "\(USE_API)/members/token"
	static let timeStamp = "\(USE_API)/server/time"
	static let serverLog = "\(USE_API)/payments/log/errors"
	
	// MARK: - REGIN & ACCOUNT
	static let intro = "\(USE_API)/intros"
	static let register = "\(USE_API)/members/register"
	static let login = "\(USE_API)/members/login"
	static let logout = "\(USE_API)/members/logout"
	static func phoneOTP(_ memberId: String) -> String { return "\(USE_API)/members/\(memberId)/verify/otp" }
	static let resetPassword = "\(USE_API)/members/password/reset"
	
	static func changePass(byMember memberId: String) -> String { return "\(USE_API)/members/\(memberId)/password/update" }
	static func changeEmail(byMember memberId: String) -> String { return "\(USE_API)/members/\(memberId)" }
    static func getPayments(byMember memberId: String) -> String //ไม่ได้ใช้งาน
    {
        return "\(USE_API)/members/\(memberId)/payment"
    }

	// MARK: - EXAM
	static let examTest = "\(USE_API)/exams/free"
	static let examGroup = "\(USE_API)/exam_groups"
	static func examInGroup(_ groupId: String) -> String
    {
       return  "\(USE_API)/exam_groups/\(groupId)/exams/chapters"
        
    }
	static func examInGroupTab(_ groupId: String) -> String //ไม่ได้ใช้งาน
    { return "\(USE_API)/exam_groups/\(groupId)/subjects" }
	static func examInTab(_ groupId: String, subjectId: String) -> String { return /*"\(USE_API)/exam_groups/\(groupId)/subjects/\(subjectId)/exams"*/
        "\(USE_API)/exam_groups/new/\(groupId)/subjects/\(subjectId)/exams"
    }
	static func examQuestion(_ examId: String) -> String { return "\(USE_API)/exams/\(examId)/questions" }
	static func memberAnswerExam(member: String, exam: String) -> String //ไม่ได้ใช้งาน
    {
        return "\(USE_API)/exams/\(exam)/ans/\(member)"
        
    }
	static func sendAnswerExam(_ examId: String) -> String { return "\(USE_API)/exams/\(examId)/ans" }
	static let solution = "https://www.sobtid.me/exam/official/solution"
	static let reportType = "\(USE_API)/reports/types"
	static let reportExam = "\(USE_API)/reports"
	static func examHistory(_ member: String) -> String { return "\(USE_API)/members/\(member)/member_exams" }
	static func examHistoryAnswer(_ member: String, examId: String) -> String { return "\(USE_API)/members/\(member)/member_exams/\(examId)" }
	static func examHistoryGroup(_ member: String, groupId: String) -> String { return "\(USE_API)/members/\(member)/member_exams/exam_groups/\(groupId)" }
	
	// MARK: - PRETEST
	static func changeRound(_ id: String) -> String { return "\(USE_API)/pretests/\(id)/change/round" }
	static func sendAnswerPretest(_ id: String) -> String { return "https://us-central1-sobtid-goverment.cloudfunctions.net/official/v1/pretests/\(id)/ans" }
	static func pretestAnswer(_ id:String) -> String { return "\(USE_API)/pretests/\(id)/answers/actualResult" }
	static func pretestHistory(_ id: String) -> String { return "\(USE_API)/pretests/\(id)/history" }
	static let pretestSolution = "https://sobtid.me/pretest/rendersolution/official"
	
	// MARK: - CALENDAR
	static let typeCalendar = "\(USE_API)/calendars/types"
	static let allCalendar = "\(USE_API)/calendars"
	static let calendar = "\(USE_API)/calendars/schedules"
	
	// MARK: - PAYMENT
	static func promotionPretest(_ id: String) -> String { return "\(USE_API)/payments/purchase/promotions/\(id)" }
	static func pretest(_ id: String = "") -> String { return "\(USE_API)/payments/purchase/pretests" }
	static let validateInApp = "\(USE_API)/payments/validation/inapp/apple" //ไม่ได้ใช้งาน
	static func paymentHistory(memberId: String) -> String { return "\(USE_API)/members/\(memberId)/payment" }
	static let purchasePackages = "\(USE_API)/payments/purchase/packages"
    static let purchaseNote = "\(USE_API)/payments/purchase/note"
	static let inAppComplete = "\(USE_API)/payments/validation/inapp/apple/completed" //ไม่ได้ใช้งาน
	static let redeem = "\(USE_API)/payments/redeem/claim"
	
	// MARK: - MENU
	static func memberExamStat(_ memberId: String) -> String { return "\(USE_API)/members/\(memberId)/stat" }
	static let packages = "\(USE_API)/payments/packages/all"
	static let packagesDetail = "\(USE_API)/payments/packages/detail"
	static let contactUs = "\(USE_API)/members/contact"
	static let helpUs = "\(USE_API)/members/help" //ไม่ได้ใช้งาน
	static let privacy = "\(USE_API)/privacy"
	static let termService = "\(USE_API)/terms"
	
    // MARK: - NOTE
    static let note = "\(USE_API)/note"
    static let noteSuggestion = "\(USE_API)/note/suggestion"
    static let notePopular = "\(USE_API)/note/best-seller"
    static let noteFavorite = "\(USE_API)/note/myfavorite"
    static let getNoteGrades = "\(USE_API)/note/grades?includeNote=true"
    static let getMyNote = "\(USE_API)/note/mynote"
    static func getNoteDetail(id: String) -> String { return "\(USE_API)/note/\(id)/detail" }
    static func favoriteThisNote(id: String) -> String { return "\(USE_API)/note/\(id)/favorite" }
    static func commentThisNote(id: String) -> String { return "\(USE_API)/note/\(id)/comment" }
    
    // MARK: Delete Account
    static func requestOtpDeleteAccount(_ memberId:String) -> String {
        return "\(USE_API)/members/\(memberId)/accountDelete"
    }
    static func verifyOtpDeleteAccount(_ memberId:String) -> String {
        return "\(USE_API)/members/\(memberId)/accountDelete/verifyOtp"
    }
    static func deleteAccount(_ memberId:String) -> String {
        return "\(USE_API)/members/\(memberId)/accountDelete/confirmDelete"
    }
}
