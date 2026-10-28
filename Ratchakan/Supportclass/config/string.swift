//
//  string.swift
//  ratchakan
//
//  Created by JJsobtid on 7/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation

class string {

	static let URLSchemes = "sobtidofficial://"
	static let redeemUserDefaultKey = "sobtidofficialredeem"
	
	// MARK: General
	static let th_ok = "ตกลง"
	static let th_confirm = "ยืนยัน"
	static let th_cancel = "ยกเลิก"
	static let th_error = "พบความผิดพลาด"
	static let th_complete = "สำเร็จ"
	static let th_condition = "ข้อตกลงและเงื่อนไขของบริการ"
    static let th_privacy = "นโยบายความเป็นส่วนตัว"
    static let th_deleteAccount = "ลบบัญชีผู้ใช้"
    static let th_deleteAccountHeader = "คุณต้องการลบบัญชีผู้ใช้ ใช่หรือไม่ ?"
	static let th_male = "ผู้ชาย"
	static let th_female = "ผู้หญิง"
	static let th_more_detail = "ดูรายละเอียดเพิ่มเติม"
	static let th_purchase = "ชำระเงิน"
	static let th_info_buyer = "ข้อมูลผู้ซื้อ"
	static let th_conc_purchase = "สรุปการสั่งซื้อ"
	static let th_identifier = "เลขประจำตัวประชาชน"
	static let th_phone_number = "เบอร์โทรศัพท์"
	static let th_email = "อีเมล"
	static let th_purchase_success = "ทำรายการสำเร็จ"
	static let th_test_result = "ผลสอบ"
	static let th_average = "เฉลี่ย"
	static let th_status = "สถานะ"
	static let th_exp_date = "หมดอายุ"
	static let th_operation_date = "วันที่ทำรายการ"
	static let en_iap = "In-app Purchase"
	static let en_mol = "MOL"
	static let en_CS = "Counter Service"
	static let th_confirm_purchase = "ชำระเรียบร้อย"
	static let th_confirm_not_purchase = "ยังไม่ชำระ"
	static let th_total = "ทั้งหมด"
	static let en_pull_refresh = "Pull down to refresh"
	static let en_loading = "Loading..."
	static let th_duplicate_phone = "มีเบอร์โทรนี้อยู่ในระบบแล้ว"
	static let th_order_code = "เลขที่สั่งซื้อ"
	static let th_order_complete = "การสั่งซื้อสำเร็จ"
	static let th_order_not_complete = "การสั่งซื้อไม่สำเร็จ"
	static let th_start = "เริ่มต้น"
	static let th_hour = "ชั่วโมง"
	static let th_minute = "นาที"
	
	// MARK:
	static let th_cantconnectitune = "ไม่สามารถเชื่อมต่อกับ iTunes Store ได้"
	static let th_sobtidhasnewer = "Sobtid มีเวอร์ชั่นที่ใหม่กว่า"
	static let th_plsupdateapp = "กรุณาอัพเดตแอพเพื่อให้ใช้งานได้มีประสิทธิภาพมากที่สุด"
	static let th_gotostore = "ไปที่สโตร์"
	static let th_closeads = "ต้องการปิดโฆษณา"
	static let th_data_not_found = "ไม่พบข้อมูล"
	static let th_try_again = "กรุณาลองใหม่อีกครั้ง"
	static let th_fail_process = "ทำรายการไม่สำเร็จ"
	static let th_condition_pretest = "กรุณาใช้ชื่อและนามสกุลจริงตามบัตรประชาชนเพื่อใช้ในการยืนยันตัวตนเพื่อรับสิทธิพิเศษ"
	static let th_company = "บริษัท สอบติดเอ็ดดูเทนเมนท์ จำกัด"
	static let th_unknown = "ไม่ระบุ"
	static let th_fill_field = "กรุณากรอกข้อมูลให้ครบ"
	static let th_old_pass_notcorrect = "รหัสผ่านเก่าไม่ถูกต้อง"
	
	// MARK: Login_Regis
	static let th_regis = "สมัครสมาชิก"
	static let th_skip_login = ""
	static let th_login = "เข้าสู่ระบบ"
	static let th_pls_login = "กรุณาเข้าสู่ระบบ"
	static let th_login_facebook = "เข้าสู่ระบบผ่าน Facebook"
	static let th_id = "อีเมล หรือ เบอร์โทรศัพท์"
	static let th_password = "รหัสผ่าน"
	static let th_forgot_password = "ลืมรหัสผ่าน"
	static let th_renew_pass = "ขอรหัสผ่านใหม่"
	static let th_name = "ชื่อ"
	static let th_surname = "นามสกุล"
	static let th_gender = "เพศ"
	static let th_birthday = "วันเกิด"
	static let th_confirm_phone = "ยืนยันเบอร์โทรศัพท์"
	static let th_send_sms = "ส่ง SMS"
    static let th_requiredPhone = "กรุณากรอกเบอร์ให้ถูกต้อง"
	
	// MARK: EXAM
	static let th_exam = "ข้อสอบ"
	static let th_finish_exam = "จบการสอบ"
	static let th_report_exam = "รายงานปัญหาข้อสอบ"
	static let th_list_exam = "รายการคำถาม"
	static let th_summary_exam = "สรุปคะแนน"
	static let th_analysis_summary_exam = "วิเคราะห์ผลสอบ"
	static let th_cong_exam = "ยินดีด้วย คุณสอบผ่าน"
	static let th_fail_exam = "เสียใจด้วย คุณสอบไม่ผ่าน"
	static let th_show_solutioin = "ดูเฉลย"
	static let th_read_article = "อ่านบทความ"
	static let en_read_article = "Read article"
	static let th_pactice_exam = "ฝึกซ้อม"
	static let th_start_exam = "เริ่มสอบ"
	static let th_start_exam_package = "เริ่มทำข้อสอบในหมวดที่ซื้อได้"
	
	// MARK: PRETEST
	static let th_pretest = "Pretest"
	static let th_change_round = "แก้ไขรอบ"
	static let th_regis_test = "สมัครสอบ"
	static let th_sponsor_by = "สนับสนุนโดย"
	static let th_choose_date = "เลือกวัน"
	static let th_choose_time = "เลือกเวลา"
	static let th_choose_purchase = "เลือกวิธีการชำระเงิน"
	static let th_detail_purchase = "รายละเอียดการสั่งซื้อ"
	static let th_detail_user = "รายละเอียดผู้สมัคร"
	static let th_pretest_history = "ประวัติการสอบ Pretest"
	static let th_buy_pretest = "ซื้อชุดข้อสอบ"
	static let th_score_analysis = "วิเคราะห์คะแนน"
	static let th_score_average = "ค่าเฉลี่ย"
	static let th_solution = "เฉลย"
	static let en_solution = "answer"
	static let th_detail_solution = "เฉลยละเอียด"
	static let th_start_pretest = "คุณสามารถดูข้อมูล Pretest ได้ที่ My Event"
	
    // MARK: NOTE
    static let th_note = "โน้ต"
    
	// MARK: CALENDAR
	static let th_calendar = "ปฏิทิน"
	static let th_detail = "รายละเอียด"
	static let th_today = "วันนี้"
	
	// MARK: MENU
	static let th_menu = "เมนู"
	static let th_contactUs = "ติดต่อ"
	static let th_helpUs = "ช่วยเหลือ"
	static let th_version = "เวอร์ชั่น"
	static let th_noti = "การแจ้งเตือน"
	static let th_regis_vip = "สมัครสอบติดแพ็กเกจ"
	static let th_vip = "สอบติดแพ็กเกจ"
	static let th_edit_user = "แก้ไขข้อมูลส่วนตัว"
	static let th_test_stats = "สถิติจากการทำข้อสอบ"
	static let th_test_history = "ประวัติการสอบ"
	static let th_purchase_history = "ประวัติการสั่งซื้อ"
    static let th_revoked_AppleID = "ยกเลิกการผูก AppleID"
	static let th_log_out = "ออกจากระบบ"
	static let th_change_password = "เปลี่ยนรหัสผ่าน"
	static let th_not_confirm_phone = "ยังไม่ยืนยัน"
}
