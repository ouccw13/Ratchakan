//
//  ExamPageGroupViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 26/4/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import TabPageViewController
import Firebase
import ObjectMapper
let eachDateKey = "eachDayPackageRatchkarn".md5()

class ExamPageGroupViewController: CustomUIViewControllerWithNav, CustomNavDelegate, ExamGroupViewControllerDelegate {

    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
	
	var nodataView: NoDataView!
	var loadingView: LoadingView!
	
	lazy var api: API! = API()
	var alertBool: [Bool] = []

    var alertData: AlertData!
	var groupId: String?
	var searchText: String?
	
	var nav: Nav! {
		didSet {
			fillUI()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
        topView = UIView()
        topView.backgroundColor = .navbrandcolor
        view.addSubview(topView)
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.setAnimatedTouch()
        backButton.adjustsImageWhenHighlighted = false
        backButton.adjustsImageWhenDisabled = false
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        topView.addSubview(backButton)
        
        navTitleLabel = UILabel()
        navTitleLabel.setParameter(font: .navTitleFont, color: .cellWhiteLabel)
        navTitleLabel.set(text: nav.title)
        topView.addSubview(navTitleLabel)
		view.backgroundColor = .brandcolor_bg
		
		loadingView = LoadingView(withSuperview: view)
		if groupId != nil {
			loadingView.startLoading()
			api.getExamGroupTab(groupId!) { (finished, response) in
				self.loadingView.stopLoading()
				if finished {
                    let examGroups =  Mapper<ExamGroups>().map(JSON: response!)
                    if examGroups?.result?.subjects?.count ?? 0 == 0 {
                        self.nodataView.show()
                        return
                    }
					
					let tabPageViewController = TabPageViewController()
					
					var tabPageOption = TabPageOption()
					tabPageOption.tabHeight = PAGEBAR_HEIGHT
					tabPageOption.currentColor = .brandcolor1
					tabPageOption.defaultColor = .guestcolor
					tabPageOption.pageBackgoundColor = .brandcolor_bg
	
					tabPageViewController.option = tabPageOption
                    var listResultData : [Subjects] = []
                    if let result = examGroups?.result?.subjects {
                        listResultData = result.filter{$0.name == "ข้อสอบฟรี"}
                        let sortTypeName = result.sorted(by: {$0.name ?? "" < $1.name ?? ""})
                        listResultData.append(contentsOf: sortTypeName)
                        let sortExamGroup = self.removeDuplicate(array: listResultData)
                        var index = 0
                        for type in sortExamGroup {
                            let subjectId = type.subjectId
                            let typeName = type.name
                            let examGroupView = ExamGroupViewController()
                            examGroupView.id = (self.groupId!, subjectId ?? "")
                            examGroupView.view.tag = index
                            examGroupView.delegate = self
                            tabPageViewController.tabItems.append((examGroupView,typeName ?? ""))
                            self.alertBool.append(type.free ?? false)
                            self.alertData = examGroups?.result?.alert
                            index += 1
                        }
                    }
					self.insertChildController(tabPageViewController, intoParentView: self.view, below: self.topView, withFrame: CGRect())
					tabPageViewController.view.snp.makeConstraints { (make) in
						make.top.equalTo(TOP_VIEW)
						make.leading.equalTo(self.view.snp.leading)
						make.trailing.equalTo(self.view.snp.trailing)
						make.bottom.equalTo(self.view.snp.bottom)
					}
                    if examGroups?.result?.subjects?.count ?? 0 == 0 {
						self.nodataView.show()
					} else {
						self.nodataView.hide()
					}
				} else {
					self.nodataView.show()
				}
			}
		}

		// Do any additional setup after loading the view.
		fillUI()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	fileprivate func fillUI() {
		if !isViewLoaded || nav == nil {
			return
		}
		
		nodataView = NoDataView(view.frame)
		
		view.addSubview(nodataView)
		view.addSubview(topView)
		
		topView.snp.makeConstraints { (make) in
			make.top.equalTo(0)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			make.height.equalTo(TOP_VIEW)
		}
        
        if IS_IPAD {
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY)
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY)
                make.centerX.equalTo(topView.snp.centerX)
            }
        }else{
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.centerX.equalTo(topView.snp.centerX)
            }
        }
		
		nodataView.snp.makeConstraints {
			$0.edges.equalTo(view.snp.edges)
		}
		nodataView.hide()
		
	}
	
	func back() {
		navigationController?.popViewController(animated: true)
	}
	func next() {
		Analytics.logEvent("ExamFilter", parameters: ["type" : "navButton"])
	}
	
	func search(_ text: String) {
		
	}
	
	func cancelSearch(_ text: String) {
		
	}

	// MARK: - ExamGroupDelegate
	func viewDidShow(index: Int) {
		if !alertBool[index] {
			let thisDate = Datetime().showDate(Datetime.getCurrentTimestamp(), short: true, showTime: false)
			if let date = UserDefaults.standard.string(forKey: eachDateKey) {
				if date != thisDate {
					showPackageAlert(date: thisDate, index: index)
				}
			} else {
				showPackageAlert(date: thisDate, index: index)
			}
		}
	}
	
	// MARK: - Package Alert
	func showPackageAlert(date: String, index: Int) {
		UserDefaults.standard.set(date, forKey: eachDateKey)
        if let data = alertData {
            let packageAlert = PackageAlertView(withView: Utility.getCurrentViewController().tabBarController!.view, title: data.title ?? "", detail: data.message ?? "", button: data.btn1 ?? "")
            packageAlert.acceptAddTarget(self, selector: #selector(showPackageBenefit(_:)))
            packageAlert.showLayout()
        }
	}
	
	@objc func showPackageBenefit(_ sender: UIGestureRecognizer) {
		let packagePurchaseView = PagePackageViewController()
		navigationController?.pushViewController(packagePurchaseView, animated: false)
	}
    
    func removeDuplicate(array: [Subjects]) -> [Subjects] {
        var unique = [Subjects]()
        for item in array {
            if !unique.contains(where: { $0.name == item.name }) {
                unique.append(item)
            }
        }
        return unique
    }

}
