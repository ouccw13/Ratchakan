//
//  TabBarViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 7/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit
import Firebase
import FirebaseRemoteConfig
enum typeTab: Int {
	case EXAM
    case NOTE
	case PRETEST
	case CALENDAR
	case MENU
}

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

	var remoteConfig: RemoteConfig!
	var selectTab: Bool = false
	
	var exam: ExamViewController?
	var pretest: PretestViewController?
    var note: NoteDashboardViewController?
	var calendar: CalendarViewController?
	var menu: MenuViewController?
//    var menu: MenuVC?
	
	var nav_exam: UINavigationController?
	var nav_pretest: UINavigationController?
    var nav_note: UINavigationController?
	var nav_calendar: UINavigationController?
	var nav_menu: UINavigationController?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.isNavigationBarHidden = true

		remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
//		remoteConfig.configSettings = RemoteConfigSettings(developerModeEnabled: true)
		remoteConfig.setDefaults(["tab_index": NSNumber(integerLiteral: 0)])
		
		exam = ExamViewController()
		nav_exam = UINavigationController(rootViewController: exam!)
		nav_exam?.tabBarItem.image = UIImage(named: "ExamIcon")
		nav_exam?.tabBarItem.title = string.th_exam
        nav_exam?.tabBarItem.setTitleTextAttributes([.font: UIFont.kanitMed10], for: .normal)
        nav_exam?.tabBarItem.setTitleTextAttributes([.font: UIFont.kanitMed10], for: .selected)
        
        nav_note = UINavigationController()
        nav_note?.tabBarItem.image = UIImage(named: "NoteIcon")
        nav_note?.tabBarItem.title = string.th_note
        nav_note?.tabBarItem.setTitleTextAttributes([.font: UIFont.kanitMed10], for: .normal)
        nav_note?.tabBarItem.setTitleTextAttributes([.font: UIFont.kanitMed10], for: .selected)
		
		nav_pretest = UINavigationController()
		nav_pretest?.tabBarItem.image = UIImage(named: "PretestIcon")
		nav_pretest?.tabBarItem.title = string.th_pretest
        nav_pretest?.tabBarItem.setTitleTextAttributes([.font: UIFont.kanitMed10], for: .normal)
        nav_pretest?.tabBarItem.setTitleTextAttributes([.font: UIFont.kanitMed10], for: .selected)
		
		nav_calendar = UINavigationController()
		nav_calendar?.tabBarItem.image = UIImage(named: "CalendarIcon")
		nav_calendar?.tabBarItem.title = string.th_calendar
        nav_calendar?.tabBarItem.setTitleTextAttributes([.font: UIFont.kanitMed10], for: .normal)
        nav_calendar?.tabBarItem.setTitleTextAttributes([.font: UIFont.kanitMed10], for: .selected)
		
		nav_menu = UINavigationController()
		nav_menu?.tabBarItem.image = UIImage(named: "MenuIcon")
		nav_menu?.tabBarItem.title = string.th_menu
        nav_menu?.tabBarItem.setTitleTextAttributes([.font: UIFont.kanitMed10], for: .normal)
        nav_menu?.tabBarItem.setTitleTextAttributes([.font: UIFont.kanitMed10], for: .selected)
		
		setViewControllers([nav_exam!,nav_note!, nav_pretest!, nav_calendar!, nav_menu!], animated: true)
		
		delegate = self
		
		tabBar.tintColor = .brandcolor1
        tabBar.backgroundColor =  .brandcolor_bg
        if #available(iOS 18.0, *) {
            traitOverrides.horizontalSizeClass = .compact
        } else {
            // Fallback on earlier versions
        }
		if #available(iOS 10.0, *) {
			tabBar.unselectedItemTintColor = UIColor.brandcolor3_dark
            
		} else {
			// Fallback on earlier versions
		}
		
		remoteConfig.fetch(withExpirationDuration: 0) { [weak self] (remoteStatus, error) in
			if let _ = error {
				return
			}
			guard let weakSelf = self else {
				return
			}
            weakSelf.remoteConfig.fetchAndActivate()
            let configIndex = weakSelf.remoteConfig["tab_index"].numberValue.intValue
            let intConfigIndex = (configIndex)
			if intConfigIndex != weakSelf.selectedIndex && !weakSelf.selectTab {
				if intConfigIndex == typeTab.PRETEST.rawValue {
					weakSelf.pretest = PretestViewController()
					weakSelf.nav_pretest = UINavigationController(rootViewController: weakSelf.pretest!)
					weakSelf.nav_pretest?.tabBarItem.image = UIImage(named: "Pretest")
					weakSelf.nav_pretest?.tabBarItem.title = string.th_pretest
				}
                weakSelf.setViewControllers([weakSelf.nav_exam!, weakSelf.nav_note!, weakSelf.nav_pretest!, weakSelf.nav_calendar!, weakSelf.nav_menu!], animated: true)
                weakSelf.selectedIndex = intConfigIndex
			}
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		selectTab = true
		let selectIndex = tabBarController.viewControllers?.index(of: viewController)
		if selectedIndex == typeTab.EXAM.rawValue && exam == nil {
			exam = ExamViewController()
			nav_exam = UINavigationController(rootViewController: exam!)
			nav_exam?.tabBarItem.image = UIImage(named: "ExamIcon")
			nav_exam?.tabBarItem.title = string.th_exam
            nav_exam?.tabBarItem.setTitleTextAttributes([.font: UIFont.kanitMed10], for: .normal)
            nav_exam?.tabBarItem.setTitleTextAttributes([.font: UIFont.kanitMed10], for: .selected)
			
			var allviews = tabBarController.viewControllers
			allviews?.remove(at: selectIndex!)
			allviews?.insert(nav_exam!, at: selectIndex!)
			
			tabBarController.setViewControllers(allviews, animated: false)
			tabBarController.selectedIndex = selectIndex!
			
			return false
		} else if selectIndex == typeTab.NOTE.rawValue && note == nil {
            note = NoteDashboardViewController()
            nav_note = UINavigationController(rootViewController: note!)
            nav_note?.tabBarItem.image = UIImage(named: "NoteIcon")
            nav_note?.tabBarItem.title = string.th_note
            nav_note?.tabBarItem.setTitleTextAttributes([.font: UIFont.kanitMed10], for: .normal)
            nav_note?.tabBarItem.setTitleTextAttributes([.font: UIFont.kanitMed10], for: .selected)
            
            var allviews = tabBarController.viewControllers
            allviews?.remove(at: selectIndex!)
            allviews?.insert(nav_note!, at: selectIndex!)
            
            tabBarController.setViewControllers(allviews, animated: false)
            tabBarController.selectedIndex = selectIndex!
            
            return false
        } else if selectIndex == typeTab.PRETEST.rawValue && pretest == nil {
			pretest = PretestViewController()
			nav_pretest = UINavigationController(rootViewController: pretest!)
			nav_pretest?.tabBarItem.image = UIImage(named: "PretestIcon")
			nav_pretest?.tabBarItem.title = string.th_pretest
            nav_pretest?.tabBarItem.setTitleTextAttributes([.font: UIFont.kanitMed10], for: .normal)
            nav_pretest?.tabBarItem.setTitleTextAttributes([.font: UIFont.kanitMed10], for: .selected)
            
			var allviews = tabBarController.viewControllers
			allviews?.remove(at: selectIndex!)
			allviews?.insert(nav_pretest!, at: selectIndex!)
			
			tabBarController.setViewControllers(allviews, animated: false)
			tabBarController.selectedIndex = selectIndex!
			
			return false
		} else if selectIndex == typeTab.CALENDAR.rawValue && calendar == nil {
			calendar = CalendarViewController()
			nav_calendar = UINavigationController(rootViewController: calendar!)
			nav_calendar?.tabBarItem.image = UIImage(named: "CalendarIcon")
			nav_calendar?.tabBarItem.title = string.th_calendar
            nav_calendar?.tabBarItem.setTitleTextAttributes([.font: UIFont.kanitMed10], for: .normal)
            nav_calendar?.tabBarItem.setTitleTextAttributes([.font: UIFont.kanitMed10], for: .selected)
            
			var allviews = tabBarController.viewControllers
			allviews?.remove(at: selectIndex!)
			allviews?.insert(nav_calendar!, at: selectIndex!)
			
			tabBarController.setViewControllers(allviews, animated: false)
			tabBarController.selectedIndex = selectIndex!
			
			return false
		} else if selectIndex == typeTab.MENU.rawValue && menu == nil {
			menu = MenuViewController()
//            menu = MenuVC()
			nav_menu = UINavigationController(rootViewController: menu!)
			nav_menu?.tabBarItem.image = UIImage(named: "MenuIcon")
			nav_menu?.tabBarItem.title = string.th_menu
            nav_menu?.tabBarItem.setTitleTextAttributes([.font: UIFont.kanitMed10], for: .normal)
            nav_menu?.tabBarItem.setTitleTextAttributes([.font: UIFont.kanitMed10], for: .selected)
            
			var allviews = tabBarController.viewControllers
			allviews?.remove(at: selectIndex!)
			allviews?.insert(nav_menu!, at: selectIndex!)
			
			tabBarController.setViewControllers(allviews, animated: false)
			tabBarController.selectedIndex = selectIndex!
			
			return false
		}
		return true
	}
}
