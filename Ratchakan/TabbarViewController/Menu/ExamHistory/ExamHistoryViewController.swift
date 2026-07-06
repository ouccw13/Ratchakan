//
//  ExamHistoryViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 2/3/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import TabPageViewController

class ExamHistoryViewController: CustomViewControllerPushNavAndNoTabbar, CustomNavDelegate {

//	var topView: CustomNav!
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
	let api = API()
	
//	let nav: Nav = Nav(title: string.th_test_history, isBack: true, isRight: false, color: UIColor.navbrandcolor)
	
	override func viewDidLoad() {
		super.viewDidLoad()
//		topView = CustomNav(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TOP_VIEW))
        topView = UIView()
        topView.backgroundColor = .navbrandcolor
		self.view.backgroundColor = .brandcolor_bg
		
//		let navModel = CustomViewModelFromNav(withNav: self.nav)
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
        navTitleLabel.set(text: string.th_test_history)
        topView.addSubview(navTitleLabel)
        
		self.view.addSubview(topView);
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
		
		api.getAllExamHistory { (finished, response) in
			if finished {
				var types = Validation.anyIsArrayAny(Validation.anyIsDictionary(response!, with: "result"), with: "examGroups")
				types.insert(["examGroupName": string.th_total,
							  "examGroupId" : ""], at: 0)
				
				let tabPageViewController = TabPageViewController()
				
				var tabPageOption = TabPageOption()
				tabPageOption.tabHeight = PAGEBAR_HEIGHT
				tabPageOption.currentColor = .brandcolor1
				tabPageOption.defaultColor = .guestcolor
				tabPageOption.pageBackgoundColor = .brandcolor_bg
				if IS_IPAD && types.count <= 6 {
					tabPageOption.tabWidth = self.view.frame.width / CGFloat(types.count)
				} else if IS_IPHONE_6P && types.count <= 4 {
					tabPageOption.tabWidth = self.view.frame.width / CGFloat(types.count)
				} else {
					if types.count <= 3 {
						tabPageOption.tabWidth = self.view.frame.width / CGFloat(types.count)
					}
				}
				
				tabPageViewController.option = tabPageOption
				
				for type in types {
					let typeGroup = type["examGroupId"] as! String
					let typeName = type["examGroupName"] as! String
					
					let historyView = ExamHistoryGroupViewController()
					if typeName == string.th_total {
						historyView.collectionData = Utility.sortArrayOfDictionary(Validation.anyIsArrayAny(Validation.anyIsDictionary(response!, with: "result"), with: "memberExams"), withInt: "testDate", ascending: false)
					}
					historyView.type = typeGroup
					historyView.view.backgroundColor = .brandcolor_bg
					
					tabPageViewController.tabItems.append((historyView, typeName))
				}
				
				self.insertChildController(tabPageViewController, intoParentView: self.view, below: self.topView, withFrame: CGRect())
				tabPageViewController.view.snp.makeConstraints { (make) in
					make.top.equalTo(self.topView.snp.bottom)
					make.leading.equalTo(self.view.snp.leading)
					make.trailing.equalTo(self.view.snp.trailing)
					make.bottom.equalTo(self.view.snp.bottom)
				}
			}
		}

		fillUI()
		// Do any additional setup after loading the view.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
	}
	
	fileprivate func fillUI() {
		if !isViewLoaded {
			return
		}
	}
	
	func back() {
		navigationController?.popViewController(animated: true)
	}

}
