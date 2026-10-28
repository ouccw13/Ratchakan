//
//  PagePackageViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 19/4/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import TabPageViewController

class PagePackageViewController: CustomViewControllerPushNavAndNoTabbar, CustomNavDelegate, PackagePurchaseDelegate {

//	var topView: CustomNav!
//	let nav: Nav = Nav(title: string.th_vip, isBack: true, isRight: true, imageRight: "tutorialIcon")
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
    var privilageButton: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()

//		topView = CustomNav(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TOP_VIEW))
        topView = UIView()
        topView.backgroundColor = .navbrandcolor
		view.backgroundColor = .brandcolor_bg
		
//		let navModel = CustomViewModelFromNav(withNav: nav)
//		topView.viewModel = navModel
//		topView.delegate = self
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
        navTitleLabel.set(text: string.th_vip)
        topView.addSubview(navTitleLabel)
        
        privilageButton = UIButton()
        privilageButton.setImage(UIImage(named: "tutorialIcon"), for: .normal)
        privilageButton.setAnimatedTouch()
        privilageButton.adjustsImageWhenHighlighted = false
        privilageButton.adjustsImageWhenDisabled = false
        privilageButton.addTarget(self, action: #selector(gotoBenefitVC), for: .touchUpInside)
        topView.addSubview(privilageButton)
        
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
            privilageButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY)/*.offset(INSET)*/
                make.trailing.equalTo(topView.snp.trailing).offset(-5)
                make.height.equalTo(50)
                make.width.equalTo(50)
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
            privilageButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.trailing.equalTo(topView.snp.trailing).offset(-5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
        }
		
		let tabPageViewController = TabPageViewController()
		
		var tabPageOption = TabPageOption()
		tabPageOption.tabHeight = PAGEBAR_HEIGHT
		tabPageOption.currentColor = .brandcolor1
		tabPageOption.defaultColor = .guestcolor
		tabPageOption.pageBackgoundColor = .brandcolor_bg
		tabPageOption.tabWidth = self.view.frame.width / 2
		
		tabPageViewController.option = tabPageOption
	
		let allPackageVC = PackagePurchaseViewController()
		allPackageVC.delegate = self
		let myPackageVC = MyPackageViewController()
		tabPageViewController.tabItems = [(allPackageVC, "แพ็กเกจทั้งหมด"), (myPackageVC, "แพ็กเกจที่ซื้อแล้ว")]
		
		self.insertChildController(tabPageViewController, intoParentView: self.view, below: self.topView, withFrame: CGRect())
		tabPageViewController.view.snp.makeConstraints { (make) in
			make.top.equalTo(self.topView.snp.bottom)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			make.bottom.equalTo(self.view.snp.bottom)
		}
	}

	@objc func back() {
		navigationController?.popViewController(animated: true)
	}
	@objc func gotoBenefitVC() {
		let packageBenefitVC = PackageBenefitViewController()
		navigationController?.pushViewController(packageBenefitVC, animated: true)
	}
	
	func nowPurchase(_ purchase: Bool) {
		view.isUserInteractionEnabled = !purchase
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
