//
//  PretestViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 7/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit
import TabPageViewController

class PretestViewController: CustomUIViewControllerWithNav, PretestDelegate {

//	var topView: CustomNav!
    var topView: UIView!
    var navTitleLabel: UILabel!
	var tabPageViewController: TabPageViewController!
	var nowPage: TypePretest!
	
	let nav: Nav = Nav(title: string.th_pretest, isBack: false, isRight: false, color: UIColor.navbrandcolor)
	var first = true
	
    override func viewDidLoad() {
        super.viewDidLoad()
//		topView = CustomNav(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TOP_VIEW)
        topView = UIView()
        topView.backgroundColor = .navbrandcolor
		self.view.backgroundColor = .brandcolor_bg
		
		fillUI()
        // Do any additional setup after loading the view.
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if first && !Utility.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_11() {
			tabPageViewController.displayControllerWithIndex(0, direction: .forward, animated: false)
			first = false
		}
	}
	
	fileprivate func fillUI() {
		if !isViewLoaded {
			return
		}
		
//		let navModel = CustomViewModelFromNav(withNav: self.nav)
//		topView.viewModel = navModel
//        topView.backgroundColor = .navbrandcolor
//        if #available(iOS 16.0, *) {
//            topView.leftButton.isHidden = true
//        } else {
//            // Fallback on earlier versions
//        }
		
		view.addSubview(topView)
		topView.snp.makeConstraints { (make) in
			make.top.equalTo(0)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			make.height.equalTo(TOP_VIEW)
		}
        
        navTitleLabel = UILabel()
        navTitleLabel.setParameter(font: .navTitleFont, color: .cellWhiteLabel)
        navTitleLabel.set(text: string.th_pretest)
        topView.addSubview(navTitleLabel)
        if IS_IPAD {
            navTitleLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(8)
                make.centerX.equalTo(topView.snp.centerX)
            }
        }else{
            navTitleLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.centerX.equalTo(topView.snp.centerX)
            }
        }
		
		tabPageViewController = TabPageViewController()
		let allPretest = PretestCollectionViewController()
		allPretest.delegate = self
		allPretest.view.backgroundColor = .brandcolor_bg
		let pastPretest = PretestCollectionViewController()
		pastPretest.view.backgroundColor = .brandcolor_bg
		let myPretest = PretestCollectionViewController()
		myPretest.view.backgroundColor = .brandcolor_bg
		
		allPretest.type = .allevent
		pastPretest.type = .pastevent
		myPretest.type = .myevent
	
		tabPageViewController.tabItems = [(allPretest, "Exams"), (myPretest, "My Exams")]
		
		var tabPageOption = TabPageOption()
		tabPageOption.tabHeight = PAGEBAR_HEIGHT
		tabPageOption.currentColor = .brandcolor1
		tabPageOption.defaultColor = .guestcolor
		tabPageOption.pageBackgoundColor = .brandcolor_bg
		tabPageOption.tabWidth = view.frame.width / 2
		
		tabPageViewController.option = tabPageOption
		
		insertChildController(tabPageViewController, intoParentView: view, below: topView, withFrame: CGRect())
		tabPageViewController.view.snp.makeConstraints { (make) in
			make.top.equalTo(topView.snp.bottom)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
			make.bottom.equalTo(view.snp.bottom)
		}
		
		tabPageViewController.displayControllerWithIndex(0, direction: .forward, animated: false)
	}

	// MARK: - All Pretest Delegate
	func AllPretestLoaded(havePretest: Bool) {
//		if !havePretest && nowPage == .allevent {
//			tabPageViewController.displayControllerWithIndex(1, direction: .forward, animated: true)
//		}
	}
	func nowPage(type: TypePretest) {
		nowPage = type
	}
}
