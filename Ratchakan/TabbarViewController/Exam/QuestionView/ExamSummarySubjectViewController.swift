//
//  ExamSummarySubjectViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 21/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class ExamSummarySubjectViewController: CustomViewControllerPushNavAndNoTabbar, CustomNavDelegate, UITableViewDelegate, UITableViewDataSource {

//	var topView: CustomNav!
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
	var summarySubjectTableView: UITableView!
	
	var categoriesData: [dictStringAny]!
	
	var nav: Nav!
	
	convenience init(parameter: [dictStringAny], navTitle: String) {
		
		self.init(nibName: nil, bundle: nil)
		categoriesData = parameter
		nav = Nav(title: navTitle, isBack: true, isRight: false)
		
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
		
//		topView = CustomNav(frame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: TOP_VIEW))
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
        navTitleLabel.setParameter(font: IS_IPHONE_6 || IS_IPHONE_5_OR_LESS ? .kanitReg16 : .navTitleFont, color: .cellWhiteLabel)
        navTitleLabel.numberOfLines = 2
        navTitleLabel.lineBreakMode = .byWordWrapping
        navTitleLabel.set(text: nav?.title)
        topView.addSubview(navTitleLabel)
		
		// Do any additional setup after loading the view.
//		let navModel = CustomViewModelFromNav(withNav: nav)
//		topView.viewModel = navModel
//		topView.delegate = self
		
		view.addSubview(topView)
		topView.snp.remakeConstraints { (make) in
			make.top.equalTo(0)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
            make.height.equalTo(IS_IPHONE_6P ? TOP_VIEW + MARGIN : TOP_VIEW)
		}
        
        if IS_IPAD {
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY)/*.offset(INSET)*/
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(backButton.snp.trailing).offset(10)
                make.centerY.equalTo(topView.snp.centerY)/*.offset(INSET)*/
//                make.centerX.equalTo(topView.snp.centerX)
                make.trailing.equalTo(topView.snp.trailing).offset(-10)
            }
        }else{
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(backButton.snp.trailing).offset(10)
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
//                make.centerX.equalTo(topView.snp.centerX)
                make.trailing.equalTo(topView.snp.trailing).offset(-10)
            }
        }
		
		fillUI()
        // Do any additional setup after loading the view.
    }

	fileprivate func fillUI() {
		if !isViewLoaded  {
			return
		}
		
		summarySubjectTableView = UITableView(frame: CGRect(), style: .plain)
		summarySubjectTableView.setParameter(target: self)
		summarySubjectTableView.contentInset = UIEdgeInsets(top: MARGIN, left: 0, bottom: MARGIN, right: 0)
		summarySubjectTableView.register(BarPercentTableViewCell.self, forCellReuseIdentifier: BarPercentTableViewCell.cellIdentifier)
		summarySubjectTableView.setDynamicHeight(71)
		
		view.insertSubview(summarySubjectTableView, belowSubview: topView)
		summarySubjectTableView.snp.makeConstraints { (make) in
			make.top.equalTo(topView.snp.bottom)
			make.leading.equalTo(topView.snp.leading)
			make.trailing.equalTo(topView.snp.trailing)
			make.bottom.equalTo(view.snp.bottom)
		}
		
	}
	
	func back() {
		navigationController?.popViewController(animated: true)
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categoriesData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: BarPercentTableViewCell.cellIdentifier, for: indexPath) as! BarPercentTableViewCell

		let subjectData = categoriesData[indexPath.item]
		let data = ["name" : Validation.anyIsString(subjectData, with: "categoryName"),
					"score" : Validation.anyIsFloat(subjectData, with: "score"),
					"totalScore" : Validation.anyIsFloat(subjectData, with: "categoryScore")] as dictStringAny
		cell.setExamSummaryData(data: data, type: .line, last: indexPath.item == categoriesData.count-1 ? true : false)
		cell.isUserInteractionEnabled = false
		
		return cell
	}
}
