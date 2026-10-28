//
//  CalendarViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 7/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit
import TabPageViewController

class CalendarViewController: CustomUIViewControllerWithNav, CustomNavDelegate {

    var topView: UIView!
    var navTitleLabel: UILabel!
    var searchButton: UIButton!
    var bgSearchView: UIView!
    var searchField: UITextField!
	var tabPageViewController: TabPageViewController!
	
	lazy var api = API()
    var delegate: CustomNavDelegate?
	var first = true
	
	override func viewDidLoad() {
        super.viewDidLoad()
        topView = UIView()
        topView.backgroundColor = .navbrandcolor
		self.view.backgroundColor = .brandcolor_bg
		
        navTitleLabel = UILabel()
        navTitleLabel.setParameter(font: .navTitleFont, color: .cellWhiteLabel)
        navTitleLabel.numberOfLines = 2
        navTitleLabel.lineBreakMode = .byWordWrapping
        navTitleLabel.set(text: string.th_calendar)
        topView.addSubview(navTitleLabel)
        
        searchButton = UIButton()
        searchButton.setImage(UIImage(named: "searchIcon"), for: .normal)
        searchButton.setAnimatedTouch()
        searchButton.adjustsImageWhenHighlighted = false
        searchButton.adjustsImageWhenDisabled = false
        // Use a valid selector with sender parameter
        searchButton.addTarget(self, action: #selector(gotoSearchCalendar(_:)), for: .touchUpInside)
        topView.addSubview(searchButton)
        
        bgSearchView = UIView()
        bgSearchView.backgroundColor = .darksearchbg
        bgSearchView.cornerView(radius: 5)
        bgSearchView.hide()
        topView.addSubview(bgSearchView)
        
        searchField = UITextField()
        searchField.returnKeyType = .search
        searchField.textAlignment = .center
        searchField.font = .kanitReg16
        searchField.textColor = .white
        searchField.placeholder = "ค้นหา"
        searchField.delegate = self
        bgSearchView.addSubview(searchField)
        
        let searchImage = UIImageView(image: #imageLiteral(resourceName: "searchIcon"))
        searchImage.contentMode = .scaleAspectFit
        let clearImage = UIButton()
        clearImage.setImage(#imageLiteral(resourceName: "clearIcon"), for: .normal)
        clearImage.imageView?.contentMode = .scaleAspectFit
        clearImage.addTarget(self, action: #selector(cancelSearch), for: .touchUpInside)
        bgSearchView.addSubview(clearImage)
        
		view.addSubview(topView)
		topView.snp.makeConstraints { (make) in
			make.top.equalTo(0)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			make.height.equalTo(TOP_VIEW)
		}
        
        if IS_IPAD {
            searchButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY)
                make.trailing.equalTo(topView.snp.trailing).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY)
                make.centerX.equalTo(topView.snp.centerX)
            }
            bgSearchView.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY)
                make.leading.equalTo(topView.snp.leading).offset(10)
                make.trailing.equalTo(topView.snp.trailing).offset(-10)
                make.height.equalTo(50)
            }
        }else{
            searchButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.trailing.equalTo(topView.snp.trailing).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.centerX.equalTo(topView.snp.centerX)
            }
            bgSearchView.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6  || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.leading.equalTo(topView.snp.leading).offset(10)
                make.trailing.equalTo(topView.snp.trailing).offset(-10)
                make.height.equalTo(50)
            }
        }
        
        searchField.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgSearchView.snp.centerY)
            make.leading.equalTo(bgSearchView.snp.leading).offset(10)
            make.trailing.equalTo(bgSearchView.snp.trailing).offset(-10)
            make.height.equalTo(50)
        }
        
        clearImage.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 16, height: 16))
            make.centerY.equalTo(bgSearchView.snp.centerY)
            make.trailing.equalTo(bgSearchView.snp.trailing).offset(-SMALLINSET)
        }
            
		fillUI()
        // Do any additional setup after loading the view.
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if tabPageViewController == nil {
			loadCalendarType()
		}
	}
	
	fileprivate func fillUI() {
		if !isViewLoaded {
			return
		}
	}
	
	@objc fileprivate func loadCalendarType() {
		api.getTypeCalendar { (finished, response) in
			if finished && self.tabPageViewController == nil {
				guard var groups = (response!["result"] as? [dictStringAny]) else {
					return
				}
				groups.insert(["name": string.th_total], at: 0)
				
				self.tabPageViewController = TabPageViewController()
				
				var tabPageOption = TabPageOption()
				tabPageOption.tabHeight = PAGEBAR_HEIGHT
				tabPageOption.currentColor = .brandcolor1
				tabPageOption.defaultColor = .guestcolor
				tabPageOption.pageBackgoundColor = .brandcolor_bg
				
				self.tabPageViewController.option = tabPageOption
				
				for group in groups {
					let typeGroup = group["name"] as! String
					if typeGroup == string.th_total {
						let calendarAllView = AllCalendarViewController()
						calendarAllView.view.backgroundColor = .brandcolor_bg
						
						self.tabPageViewController.tabItems.append((calendarAllView, typeGroup))
					} else {
						let calendarView = CalendarGroupViewController()
						calendarView.type = typeGroup
						calendarView.view.backgroundColor = .brandcolor_bg
						
						self.tabPageViewController.tabItems.append((calendarView, typeGroup))
					}
				}
				
				self.insertChildController(self.tabPageViewController, intoParentView: self.view, below: self.topView, withFrame: CGRect())
				self.tabPageViewController.view.snp.makeConstraints { (make) in
					make.top.equalTo(self.topView.snp.bottom)
					make.leading.equalTo(self.view.snp.leading)
					make.trailing.equalTo(self.view.snp.trailing)
					make.bottom.equalTo(self.view.snp.bottom)
				}
			}
            else{
                self.perform(#selector(self.loadCalendarType), with: self, afterDelay: 2000)
                Utility.showAlert(title: "เกิดข้อผิดพลาด", detail:  response?["message"] as? String ?? "ระบบไม่สามารถโหลดข้อมูลได้")
            }
			return
		}
	}
    
    @objc func gotoSearchCalendar(_ sender: UIButton) {
        navTitleLabel.hide()
        bgSearchView.show()
        searchButton.hide()
    }
    
    @objc func cancelSearch() {
        navTitleLabel.show()
        searchButton.show()
        bgSearchView.hide()
        searchField.text = nil
        searchField.endEditing(true)
    }
}

extension CalendarViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        searchField.endEditing(true)
        if textField.text != nil && textField.text?.trimSpace() != "" {
            delegate?.search!(textField.text!)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            let searchCalendarView = CalendarSearchViewController()
            searchCalendarView.type = .main
            searchCalendarView.searchText = text
            searchCalendarView.nav = Nav(title: text, isBack: true, isRight: false)
            navigationController?.pushViewController(searchCalendarView, animated: true)
        }
    }
}

