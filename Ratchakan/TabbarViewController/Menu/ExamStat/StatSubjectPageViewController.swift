//
//  SubjectPageViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 19/3/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import TabPageViewController

class StatSubjectPageViewController: CustomViewControllerPushNavAndNoTabbar, CustomNavDelegate {

//	var topView: CustomNav!
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
	var nav: Nav!
	
	var tabPageViewController: TabPageViewController!
	
	var statData: [SubjectModel]!
	var nowIndex: Int!
	
	convenience init(parameter: [SubjectModel], index: Int, title: String) {
		
		self.init(nibName: nil, bundle: nil)
		statData = parameter
		nowIndex = index
		nav = Nav(title: title, isBack: true, isRight: false)

	}
	
	override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = .brandcolor_bg
		
//		topView = CustomNav(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TOP_VIEW))
        topView = UIView()
        topView.backgroundColor = .navbrandcolor
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
        navTitleLabel.set(text: nav.title)
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
		
		tabPageViewController = TabPageViewController()
		
		var tabPageOption = TabPageOption()
		tabPageOption.tabHeight = PAGEBAR_HEIGHT
		tabPageOption.currentColor = .brandcolor1
		tabPageOption.defaultColor = .guestcolor
		tabPageOption.pageBackgoundColor = .brandcolor_bg
        tabPageOption.fontSize = 12
//		if IS_IPAD && statData.count <= 6 {
//			tabPageOption.tabWidth = self.view.frame.width / CGFloat(statData.count)
//		} else if IS_IPHONE_6P && statData.count <= 4 {
//			tabPageOption.tabWidth = self.view.frame.width / CGFloat(statData.count)
//		} else {
//			if statData.count <= 3 {
//				tabPageOption.tabWidth = self.view.frame.width / CGFloat(statData.count)
//			}
//		}
        if IS_IPHONE_14_Pro_MAX || IS_IPHONE_14_Plus {
            tabPageOption.tabWidth = self.view.frame.width / 1.5
        }else{
//            tabPageOption.tabWidth = IS_IPHONE_6 || IS_IPHONE_14_Pro || IS_IPHONE_14  ? self.view.frame.width / 1.2  : self.view.frame.width / 2
            tabPageOption.tabWidth = IS_IPAD ? self.view.frame.width / 2  : self.view.frame.width / 1.2
        }
		
		tabPageViewController.option = tabPageOption
		
		for page in statData {
			let subjectName = page.name
			
			let statSubjectView = StatSubjectViewController(parameter: statData[statData.index(of: page)!])
			statSubjectView.view.backgroundColor = .brandcolor_bg
			
			tabPageViewController.tabItems.append((statSubjectView, subjectName))
		}
		
		self.insertChildController(tabPageViewController, intoParentView: self.view, below: self.topView, withFrame: CGRect())
		tabPageViewController.view.snp.makeConstraints { (make) in
			make.top.equalTo(self.topView.snp.bottom)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			make.bottom.equalTo(self.view.snp.bottom)
		}
		
        // Do any additional setup after loading the view.
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		tabPageViewController.displayControllerWithIndex(nowIndex, direction: .forward, animated: false)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	func back() {
		navigationController?.popViewController(animated: true)
	}

}
