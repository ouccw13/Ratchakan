//
//  PretestSummaryViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 12/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import TabPageViewController

class PretestSummaryViewController: CustomViewControllerPushNavAndNoTabbar, CustomNavDelegate, CustomButtonClick {

	var fromNoti: Bool = false
	
//	var topView: CustomNav!
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
	var solutionButton: CustomBottomButton!
	
//	let nav: Nav = Nav(title: string.th_test_result, isBack: true, isRight: false, color: UIColor.navbrandcolor)
	let customButton: BottomButton = BottomButton(title: string.th_show_solutioin, color: .brandcolor1)
	var pretestHistoryModel: PretestHistoryModel!
	
	convenience init(withPretest data: PretestHistoryModel) {
		self.init(nibName: nil, bundle: nil)
		pretestHistoryModel = data
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = .brandcolor_bg

//		topView = CustomNav(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TOP_VIEW))
        topView = UIView()
        topView.backgroundColor = .navbrandcolor
		solutionButton = CustomBottomButton(frame: CGRect(x:0, y:0, width: SCREEN_WIDTH, height: BOTTOM_BAR))
		
        // Do any additional setup after loading the view.
		fillUI()
    }    

	fileprivate func fillUI() {
		if !isViewLoaded {
			return
		}
		
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
        navTitleLabel.set(text: string.th_test_result)
        topView.addSubview(navTitleLabel)
		
		let solutionViewModel = CustomBottomButtonFromModel(withButton: customButton)
		solutionButton.viewModel = solutionViewModel
		solutionButton.delegate = self
		
		view.addsubviews([topView, solutionButton])
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
//                make.leading.equalTo(backButton.snp.trailing).offset(MARGIN)
                make.centerY.equalTo(topView.snp.centerY)/*.offset(INSET)*/
                make.centerX.equalTo(topView.snp.centerX)
//                make.trailing.equalTo(topView.snp.trailing).offset(-MARGIN)
            }
        }else{
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
//                make.leading.equalTo(backButton.snp.trailing).offset(MARGIN)
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.centerX.equalTo(topView.snp.centerX)
//                make.trailing.equalTo(topView.snp.trailing).offset(-MARGIN)
            }
        }
        
		solutionButton.snp.makeConstraints { (make) in
			make.bottom.equalTo(view.snp.bottom)
			make.leading.equalTo(view.snp.leading)
			make.height.equalTo(BOTTOM_BAR)
			make.trailing.equalTo(view.snp.trailing)
		}
		
		let summarySubject = SummarySubjectViewController(withData: pretestHistoryModel)
		summarySubject.view.backgroundColor = .brandcolor_bg
		if pretestHistoryModel.isPractice {
			insertChildController(summarySubject, intoParentView: view, below: topView, withFrame: CGRect())
			summarySubject.view.snp.makeConstraints { (make) in
				make.top.equalTo(topView.snp.bottom).offset(-PAGEBAR_HEIGHT)
				make.leading.equalTo(view.snp.leading)
                make.trailing.equalTo(view.snp.trailing)
				make.bottom.equalTo(solutionButton.snp.top)
			}
		} else {
			let tabPageViewController = TabPageViewController()
			let summaryAverage = SummaryAverageViewController(withData: pretestHistoryModel.memberStat)
			summaryAverage.view.backgroundColor = .brandcolor_bg
		
			tabPageViewController.tabItems = [(summarySubject, string.th_score_analysis), (summaryAverage, string.th_score_average)]//, (solutionView, string.th_solution)]
			
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
				make.bottom.equalTo(solutionButton.snp.top)
			}
			
			if !Utility.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_11() {
				tabPageViewController.displayControllerWithIndex(1, direction: .forward, animated: false)
			}
		}
		
	}
	
	// MARK: - Nav Delegate
	func back() {
        print("fromNoti: \(fromNoti)")
		if fromNoti {
			dismiss(animated: true, completion: nil)
		} else {
			navigationController?.popViewController(animated: true)
		}
	}
	
	// MARK: - Bottom Button Delegate
	func next(tag: Int) {
		showSolution()
	}
	
	func showSolution() {
		let solutionViewController = PretestSolutionViewController(withAnswerId: pretestHistoryModel.answerId, pretestId: pretestHistoryModel.pretestId)
		solutionViewController.nav = Nav(title: string.th_solution, isBack: true, isRight: false, imageRight: "closeWhiteIcon")
		navigationController?.pushViewController(solutionViewController, animated: true)
	}

}
