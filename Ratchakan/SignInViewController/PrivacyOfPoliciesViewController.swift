//
//  PrivacyOfPoliciesViewController.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 4/10/2565 BE.
//  Copyright © 2565 BE Chatcha.sobtid. All rights reserved.
//

import UIKit

class PrivacyOfPoliciesViewController: CustomViewControllerPresentNavAndNoTabbar, CustomNavDelegate, CustomButtonClick {
    
//    var topView: CustomNav!
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
    var confirmButton: CustomBottomButton!
    var privacyTextView: CustomTextView!
    var loadingView: LoadingView!
    
//    let nav: Nav = Nav(title: string.th_privacy, isBack: true, isRight: false, color: UIColor.brandcolor1)
    let customButton: BottomButton = BottomButton(title: string.th_ok, color: .brandcolor1)
    
    lazy var api = API()
    var isMenu:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brandcolor_bg
        
//        topView = CustomNav(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TOP_VIEW))
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
        navTitleLabel.set(text: string.th_privacy)
        topView.addSubview(navTitleLabel)
        
        confirmButton = CustomBottomButton(frame: CGRect(x:0, y:0, width: SCREEN_WIDTH, height: BOTTOM_BAR))
        privacyTextView = CustomTextView()
        privacyTextView.backgroundColor = .clear
        privacyTextView.textContainerInset = UIEdgeInsets(top: MARGIN, left: MARGIN, bottom: MARGIN, right: MARGIN)
        
        privacyTextView.font = .thSarabun22
        privacyTextView.textColor = .Celllabel
        
        
        
//        let navModel = CustomViewModelFromNav(withNav: nav)
//        topView.viewModel = navModel
//        topView.delegate = self
        
        let confirmModel = CustomBottomButtonFromModel(withButton: customButton)
        confirmButton.viewModel = confirmModel
        confirmButton.delegate = self
        
        view.addSubview(topView);
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
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6  || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
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
        
        view.insertSubview(privacyTextView, belowSubview: topView)
        privacyTextView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.bottom.equalTo(confirmButton.snp.top)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        loadingView = LoadingView(withSuperview: view)
        loadingView.startLoading()
        api.getPrivacyOfPolicies { (finished, response) in
            self.loadingView.stopLoading()
            if finished {
                let privacyAndPolicies = "เมื่อผู้ใช้บริการได้เข้าใช้บริการหรือออกจาก Sobtid.me รวมถึงการเข้าชมหน้าต่างๆของเว็บไซต์ Sobtid.me จะมีการจัดเก็บค่าIP Address รวมถึงชนิดเว็บเบราว์เซอร์ของสมาชิกทั้งนี้ก็เพื่อนำข้อมูลเหล่านั้นมาวิเคราะห์และนำไปพัฒนาบริการของ Sobtid.meเพื่อตอบสนองความต้องการของสมาชิกในอนาคต\n  \nการรวบรวมข้อมูล\n1.ในการสมัครสมาชิกกับ Sobtid.me ผู้ใช้บริการจะต้องกรอกข้อมูลชื่อ และ ที่อยู่ไปรษณีย์อิเล็กทรอนิกส์ให้ถูกต้องและครบถ้วนเพื่อสิทธิประโยชน์ของผู้ใช้บริการในอนาคต\n\n2.ข้อมูลส่วนบุคคลที่สมาชิกได้ให้หรือใช้ผ่านการประมวลผลของเครื่องคอมพิวเตอร์ที่ควบคุมการทำงานของ Sobtid.me ทั้งหมดนั้น สมาชิกยอมรับและตกลงว่าเป็นสิทธิและกรรมสิทธิ์ของบริษัท Sobtid.meจะรักษาข้อมูลเหล่านั้นไว้เป็นความลับตามเกณฑ์มาตรฐานสากลสำหรับการรักษาข้อมูลเป็นความลับและจะไม่อนุญาตให้ผู้อื่นเข้าถึงข้อมูลดังกล่าวได้นอกจากพนักงานผู้ที่ได้รับอนุญาตจาก Sobtid.me อย่างไรก็ตามเพื่อความปลอดภัยในข้อมูลส่วนบุคคลของสมาชิก สมาชิกควรปฏิบัติตามข้อกำหนดและเงื่อนไขการให้บริการของเว็บไซต์ของบริษัทแต่ละเว็บไซต์โดยเคร่งครัด\n\n3.ข้อมูลทางสถิติสมาชิก(demographic) เฉพาะ เพศ,อายุ,ระดับการศึกษา,อาชีพ,จังหวัดและประเทศที่อยู่อาศัย จะถูกเก็บข้อมูลทุกครั้งที่มีการดาวน์โหลดตัวอย่าง หนังสืออิเล็กทรอนิกส์(E-book)และการสั่งซื้อหนังสืออิเล็กทรอนิกส์(E-book):ซึ่งข้อมูลดังกล่าวจะถูกแจ้งให้กับสำนักพิมพ์ที่เป็นเจ้าของลิขสิทธิ์หนังสืออิเล็กทรอนิกส์(E-book)เพื่อใช้ในการวิเคราะห์ทางสถิติ โดยที่Sobtid.me จะไม่มีการเปิดเผยชื่อ-นามสกุล,อีเมลแอดเดรส,ชื่อโปรไฟล์ หรือ ข้อมูลอื่นที่ไม่ได้แจ้งไว้ ดังข้างต้นเป็นอันขาด \n\nการเปิดเผยข้อมูลแก่บุคคลที่สาม\n1. Sobtid.me อาจใช้ข้อมูลที่ได้รับจากสมาชิก เพื่อใช้ในการการส่งเสริมการตลาดหรือให้ข้อมูลแก่หน่วยงานที่ทำหน้าที่ด้านการตลาดโดย Sobtid.me เป็นผู้ว่าจ้างพันธมิตรทางธุรกิจหรือผู้ให้การสนับสนุนทางธุรกิจ ตามที่ Sobtid.meเห็นสมควร\n2. การเปิดเผยข้อมูลนั้นๆเป็นไปโดยถูกต้องตามกฎหมายหรือตามคำสั่งของหน่วยงานของรัฐที่เกี่ยวข้อง\n\nคุกกี้(COOKIE)\nคุกกี้คือไฟล์ขนาดเล็กที่มีสตริงอักขระซึ่งส่งไปยังคอมพิวเตอร์ของสมาชิก เมื่อสมาชิกเข้าชมเว็บไซต์นั้นอีกครั้งคุกกี้จะทำให้เว็บไซต์ดังกล่าวจดจำเบราว์เซอร์ของสมาชิก คุกกี้อาจเก็บการตั้งค่าของผู้ใช้หรือข้อมูลอื่นๆโดยสมาชิกสามารถตั้งค่าเบราว์เซอร์ของสมาชิกใหม่หรือให้ปฏิเสธคุกกี้ทั้งหมดหรือแสดงให้รู้เมื่อกำลังมีการส่งคุกกี้ อย่างไรก็ตามลักษณะหรือบริการบางอย่างของเว็บไซต์อาจทำงานได้ไม่สมบูรณ์เมื่อไม่มีคุกกี้\n\nความรับผิดชอบ\nSobtid.me ขอสงวนสิทธิ์ในการปฏิเสธความรับผิดทั้งหมดในกรณีที่ข้อมูลส่วนบุคคลของสมาชิกเสียหายหรือสูญหายเนื่องจากความผิดพลาดใดๆระหว่างส่งข้อมูลระหว่างเซิฟเวอร์กับผู้ใช้บริการโดยอาจจะมีเหตุสุดวิสัยใดๆจากการถูกจารกรรมข้อมูลคอมพิวเตอร์(Hack) และ/หรือการกระทำใดๆที่ขัดกฎหมายไม่ว่าการกระทำนั้นจะเกิดจากบุคคลใดๆก็ตาม ลิขสิทธิ์(Copyrights) ลิขสิทธิ์ตามกฎหมาย(Copyrights) ข้อความ ภาพ เสียง เนื้อหา ส่วนประกอบใดๆทั้งหมดของ Sobtid.me รวมถึงแต่ไม่จำกัดเฉพาะเครื่องหมายการค้า เครื่องหมายบริการ ชื่อทางการค้า ที่ปรากฏบน Sobtid.me เป็นงานอันได้รับความคุ้มครองตามกฎหมายทรัพย์สินทางปัญญาของไทยโดยชอบด้วยกฎหมายของ Sobtid.me แต่เพียงผู้เดียวหากบุคคลใดลอกเลียน ปลอมแปลงทำซ้ำ ดัดแปลง เผยแพร่ต่อสาธารณชนจำหน่าย มีไว้ให้เช่าหรือกระทำการใดๆในลักษณะที่เป็นการแสวงหาประโยชน์ทางการค้าหรือประโยชน์โดยมิชอบไม่ว่าโดยประการใดๆ จากทรัพย์สินทางปัญญาดังกล่าวข้างต้นโดยไม่ได้รับอนุญาตจากSobtid.me Sobtid.meจะดำเนินการตามกฎหมายกับผู้ละเมิดสิทธิดังกล่าวโดยทันที\n\nการเปลี่ยนแปลงนโยบายความเป็นส่วนตัว\nSobtid.me สามารถเปลียนแปลงนโยบายความเป็นส่วนตัวได้ตลอดเวลาเมื่อมีการเปลี่ยนแปลงหรือเพิ่มเติมบริการหรือเมื่อเราได้รับข้อเสนอแนะจากสมาชิก การเปลี่ยนแปลงใดๆในนโยบายจะมีการแจ้งถึงสมาชิกผ่านทางไปรษณีย์อิเล็กทรอนิกส์ หากสมาชิกมีคำถามที่เกี่ยวข้องกับนโยบายความเป็นส่วนตัวของเรา สมาชิกสามารถติดต่อผ่านที่อยู่ไปรษณีย์อิเล็กทรอนิกส์ support@sobtid.me หรือผ่านหน้า \"ติดต่อเรา\"\n\nSobtid.me\n6 ม.ค. 2560"
                self.privacyTextView.text = privacyAndPolicies
            } else {
                self.privacyTextView.text = "เกิดข้อผิดพลาด\nกรุณาลองใหม่อีกครั้ง"
            }
            return
        }
        privacyTextView.isScrollEnabled = true
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        privacyTextView.setContentOffset(CGPoint.zero, animated: false)
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
}

