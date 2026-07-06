//
//  TermOfServiceViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 30/3/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class TermOfServiceViewController: CustomViewControllerPresentNavAndNoTabbar, CustomNavDelegate, CustomButtonClick {
	
//	var topView: CustomNav!
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
	var confirmButton: CustomBottomButton!
	var termTextView: CustomTextView!
	var loadingView: LoadingView!
    var isMenu:Bool?
	let nav: Nav = Nav(title: "ข้อตกลงและเงื่อนไขบริการ", isBack: true, isRight: false, color: UIColor.brandcolor1)
	let customButton: BottomButton = BottomButton(title: string.th_ok, color: .brandcolor1)
	
	lazy var api = API()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .brandcolor_bg
		
//		topView = CustomNav(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TOP_VIEW))
        topView = UIView()
        topView.backgroundColor = .navbrandcolor
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.setAnimatedTouch()
        backButton.adjustsImageWhenHighlighted = false
        backButton.adjustsImageWhenDisabled = false
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        topView.addSubview(backButton)
        
        navTitleLabel = UILabel()
        navTitleLabel.setParameter(font: .navTitleFont, color: .cellWhiteLabel)
        navTitleLabel.numberOfLines = 2
        navTitleLabel.lineBreakMode = .byWordWrapping
        navTitleLabel.set(text: "ข้อตกลงและเงื่อนไขบริการ")
        topView.addSubview(navTitleLabel)
        
		confirmButton = CustomBottomButton(frame: CGRect(x:0, y:0, width: SCREEN_WIDTH, height: BOTTOM_BAR))
		termTextView = CustomTextView()
        termTextView.backgroundColor = .clear
		termTextView.textContainerInset = UIEdgeInsets(top: MARGIN, left: MARGIN, bottom: MARGIN, right: MARGIN)
		
		termTextView.font = .thSarabun22
		termTextView.textColor = .Celllabel

//		let navModel = CustomViewModelFromNav(withNav: nav)
//		topView.viewModel = navModel
//		topView.delegate = self
		
		let confirmModel = CustomBottomButtonFromModel(withButton: customButton)
		confirmButton.viewModel = confirmModel
		confirmButton.delegate = self
		
		view.addSubview(topView)
		topView.snp.makeConstraints { (make) in
			make.top.equalTo(0)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			make.height.equalTo(TOP_VIEW)
		}
        
        if IS_IPAD {
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY)/*.offset(INSET)*/
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
//                make.leading.equalTo(backButton.snp.trailing).offset(10)
                make.centerY.equalTo(topView.snp.centerY)/*.offset(INSET)*/
                make.centerX.equalTo(topView.snp.centerX)
//                make.trailing.equalTo(topView.snp.trailing).offset(-10)
            }
        }else{
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
//                make.leading.equalTo(backButton.snp.trailing).offset(10)
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.centerX.equalTo(topView.snp.centerX)
//                make.trailing.equalTo(topView.snp.trailing).offset(-10)
            }
        }
		
		view.addSubview(confirmButton)
		confirmButton.snp.makeConstraints { (make) in
			make.bottom.equalTo(self.view.snp.bottom)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			make.height.equalTo(BOTTOM_BAR)
		}
		
		view.insertSubview(termTextView, belowSubview: topView)
		termTextView.snp.makeConstraints { (make) in
			make.top.equalTo(topView.snp.bottom)
			make.leading.equalTo(view.snp.leading)
			make.bottom.equalTo(confirmButton.snp.top)
			make.trailing.equalTo(view.snp.trailing)
		}
		
		loadingView = LoadingView(withSuperview: view)
		loadingView.startLoading()
		api.getTermOfService { (finished, response) in
			self.loadingView.stopLoading()
			if finished {
                let termAndCondition = "เงื่อนไขและข้อตกลงในการเข้าร่วมกับเว็บไซต์ sobtid.me\n  \nโปรดอ่านทำความเข้าใจตามเงื่อนไขและข้อตกลงก่อนทำการลงทะเบียนหลังจากที่การลงทะเบียนเสร็จสมบูรณ์แล้วจะถือว่าท่านยอมรับเงื่อนไขและถือเป็นข้อตกลงระหว่างสมาชิกและนักเขียน กับ บริษัท สอบติด เอ็ดดูเทนเมนต์ จำกัด สำหรับการใช้บริการเว็บไซต์ Sobtid.me สมาชิกจะต้องเห็นด้วยกับรูปแบบการบริการและเงื่อนไขงานของ Sobtid.me ถ้าผู้ใช้ไม่เห็นด้วยกับข้อตกลงนี้ กรุณาหยุดใช้บริการ Sobtid.me นี้โดยทันที\n\nการชำระเงิน\n1. การชำระเงินค่าบริการ หรือค่าสมาชิก เมื่อทำรายการสั่งซื่อสำเร็จแล้วไม่สามารถขอคืนหรือยกเลิกรายการได้\n\nสมาชิกทั่วไป\n1. การสมัครสมาชิกกับ Sobtid.me ไม่ต้องเสียค่าใช้จ่ายใดๆทั้งสิ้น\n\n2. ผู้ที่ต้องการสมัครสมาชิกต้องกรอกข้อมูลของตนเองที่เป็นจริงแก่ Sobtid.me ให้ครบทุกข้อเพื่อสิทธิประโยชน์ของท่านในการเข้าร่วมกิจกรรมของ Sobtid.me หาก Sobtid.me ตรวจสอบพบว่าท่านให้ข้อมูลเท็จ ทีมงานมีสิทธิ์ไม่ให้สิทธิ์การเป็นสมาชิกได้หรือยกเลิกการเป็นสมาชิกได้\n\n3. ผู้ใดแอบอ้าง หรือกระทำการใดๆอันเป็นการละเมิดสิทธิ์ส่วนบุคคลโดยใช้ข้อมูลของผู้อื่นมาแอบอ้างสมัครสมาชิกเพื่อให้ได้สิทธิ์การสมาชิกถือเป็นความผิดต้องรับโทษตามที่กฎหมายกำหนดไว้\n\n4. เพื่อความเป็นส่วนตัวและความปลอดภัยในข้อมูลของท่านเอง Sobtid.me ขอแจ้งให้ท่านทราบว่าเป็นหน้าที่ของท่านเองในการรักษา Password ของท่านให้ดีโดยไม่บอกให้ผู้อื่นทราบ\n\n5. สมาชิกสามารถเปลี่ยนแปลงรหัสผ่าน(Password) ด้วยตนเองได้ตลอดระยะเวลาการใช้งานโดยไม่ต้องแจ้งให้ Sobtid.me ทราบ ทั้งนี้สมาชิกตกลงให้รหัสผ่าน(Password) ที่เปลี่ยนแปลงไป ในแต่ละขณะดังกล่าวเป็นรหัสผ่านการใช้บริการของ Sobtid.me ที่มีผลผูกพันสมาชิกตามข้อกำหนดและเงื่อนไขการใช้บริการนี้ทุกประการ\n\n6. การกระทำการใดๆ โดยผ่านบริการไม่ว่ากรณีใดๆก็ตาม หากกระทำโดยใช้รหัสสมาชิกและรหัสผ่านของสมาชิกและ/หรือตรงตามวิธีการหรือเงื่อนไขที่บริษัทกำหนดไว้เกี่ยวกับการใช้บริการ Sobtid.me แล้วสมาชิกตกลงให้ถือว่าการกระทำนั้นมีผลสมบูรณ์โดยสมาชิกไม่ต้องลงลายมือชื่อเป็นหลักฐานในเอกสารใดๆ อีกและยินยอมรับผิดชอบในการกระทำดังกล่าวเสมือนหนึ่งว่าสมาชิกเป็นผู้กระทำด้วยตนเองทั้งนี้ไม่ว่าจะเกิดขึ้นด้วยความทุจริตของบุคคลภายนอกหรือไม่ก็ตาม สมาชิกจะไม่เรียกร้องให้บริษัทต้องรับผิดชอบแต่อย่างใด\n\n7. รหัสผ่าน(Password) ถือเป็นความลับเฉพาะตัวของสมาชิกที่ต้องเก็บรักษาและปกปิดมิให้ผู้อื่นล่วงรู้สมาชิกต้องเก็บรักษาไว้ด้วยตนเองหากมีการใช้บริการรายการใดๆโดยใช้รหัสผ่าน (Password) ของสมาชิกแล้วให้ถือว่าถูกต้องสมบูรณ์มีผลผูกพันกับสมาชิกเสมือนสมาชิกใช้บริการในครั้งนั้นๆ ด้วยตนเอง ทั้งนี้ บริษัทไม่สามารถล่วงรู้รหัสผ่าน(Password) ของสมาชิกได้ ดังนั้น บริษัทจึงไม่ต้องรับผิดชอบในความเสียหายใดๆที่เกิดขึ้นในการใช้บริการ Sobtid.me โดยรหัสผ่าน(Password) ของสมาชิก\n\n8. สมาชิกจำเป็นต้องตรวจสอบความถูกต้องในการทำรายการสั่งซื้อว่าถูกต้องหรือไม่ก่อนที่จะทำการตกลงชำระเงินซึ่งถ้าหากเกิดข้อผิดพลาดจากการทำรายการสั่งซื้อ อันเนื่องมาจากความไม่ถูกต้องของรายการเนื่องมาจากความผิดพลาดของสมาชิกเองทาง Sobtid.me จะไม่รับผิดชอบทั้งสิ้น\n\n9. ถ้า Sobtid.me พบว่าสมาชิกนำข้อมูลข้อสอบของ Sobtid.me นำไปทำซ้ำดัดแปลง แก้ไข เผยแพร่ หรือจัดจำหน่าย โดยไม่ได้รับอนุญาตจาก Sobtid.me ทีมงาน Sobtid.me มีสิทธิ์ที่จะยกเลิกความเป็นสมาชิกได้โดยทันที\n\n10. ข้อมูลข้อสอบที่สมาชิกเข้าใช้งาน ห้ามกระทำซ้ำหรือดัดแปลง, ห้ามให้เช่าต้นฉบับหรือสำเนางาน, ห้ามเผยแพร่งานต่อสาธารณชน หากผู้ใดกระทำการดังกล่าว ถือเป็นการละเมิดลิขสิทธิ์ ต้องรับโทษอาญาและจ่ายค่าเสียหายแก่เจ้าของลิขสิทธิ์ และ Sobtid.me ด้วย หากผู้ใดรู้อยู่แล้วหรือมีเหตุอันควรรู้ว่างานใดได้ทำขึ้นโดยละเมิดลิขสิทธิ์ของผู้อื่น กระทำการต่อไปนี้แก่งานนั้นเพื่อหากำไร ให้ถือว่าผู้นั้นกระทำละเมิดลิขสิทธิ์ด้วย ได้แก่\n\n\t10.1 ขาย มีไว้เพื่อขาย เสนอขาย ให้เช่า เสนอให้เช่า ให้เช่าซื้อ หรือเสนอให้เช่าซื้อ\n\n\t10.2 เผยแพร่ต่อสาธารณชน\n\n\t10.3 แจกจ่ายในลักษณะที่อาจก่อให้เกิดความเสียหายแก่เจ้าของลิขสิทธิ์\n\n11. สมาชิกจะต้องไม่โพสต์ข้อความที่มีเนื้อหาดังต่อไปนี้ที่ Sobtid.me\n\n\t11.1 ไม่โพสต์ข้อความซึ่งพาดพิงหรือลบหลู่ สถาบันพระมหากษัตริย์\n\n\t11.2 ไม่โพสต์ข้อมูลหยาบคาบหมิ่นประมาท หรือ สร้างความเสียหายต่อบุคคลหนึ่งบุคคลใด\n\n\t12. Sobtid.me จะไม่รับผิดชอบต่อความสูญเสียในด้านข้อมูลสมาชิก ข้อมูลการสั่งซื้อ และข้อมูลทุกๆอย่างภายในเว็บไซต์หากมีการสูญหาย จากการถูกจารกรรมความผิดพลาดจากระบบของเครื่องแม่ข่ายที่เก็บข้อมูลหรือความผิดพลาดที่เกิดจากระบบเว็บไซต์ท้ังสิ้น\n\n13. หากพบว่าสมาชิกกระทำการที่ผิดเงื่อนไขและข้อตกลงกับ Sobtid.me ทีมงาน Sobtid.me มีสิทธิ์ที่จะยกเลิกความเป็นสมาชิกได้โดยทันที\n\n14. สมาชิกสามารถทำข้อสอบพร้อมกันได้ 1 อุปกรณ์ต่อบัญชี\n\n15. สมาชิกสามารถเข้าสู่ระบบพร้อมกันได้ 5 อุปกรณ์ต่อบัญชี\n\nSobtid.me\n6 ม.ค. 2560"
                self.termTextView.text = termAndCondition 
			} else {
				self.termTextView.text = "เกิดข้อผิดพลาด\nกรุณาลองใหม่อีกครั้ง"
			}
			return
		}
		termTextView.isScrollEnabled = true
        // Do any additional setup after loading the view.
    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		termTextView.setContentOffset(CGPoint.zero, animated: false)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func next(tag: Int) {
		back()
	}
	func back() {
        if isMenu == true {
            navigationController?.popViewController(animated: true)
        }else{
            dismiss(animated: true, completion: nil)
        }
	}
	
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
