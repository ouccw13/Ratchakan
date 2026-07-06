//
//  ExamSummaryViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 30/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import Firebase

class ExamSummaryViewController: CustomViewControllerPresentNavAndNoTabbar, CustomNavDelegate, CustomButtonClick, UITableViewDelegate, UITableViewDataSource {

    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
	var solutionButton: CustomBottomButton!
	var summaryTableView: UITableView!
	
	var type, memberExamId: String!
	var summaryData: dictStringAny!
	var memberScore: dictStringAny!
	var subjectsData: [dictStringAny]!
	var totalTime: Int!
	var questionData: Question!
	
	var nav: Nav!
	let customButton: BottomButton = BottomButton(title: string.th_show_solutioin, color: .brandcolor1)
	
	convenience init(parameter: dictStringAny, time: Int, typeExam: String = "exam", isLeft: Bool = false) {
		self.init(nibName: nil, bundle: nil)
		type = typeExam
		summaryData = parameter
		nav = Nav(title: Validation.anyIsString(parameter, with: "examName"), isBack: false, isRight: true, imageRight: "closeIcon")
		if typeExam != "exam" {
			nav = Nav(title: string.th_test_result, isBack: false, isRight: true, imageRight: "closeIcon")
			Crashlytics.crashlytics().setCustomValue(Validation.anyIsString(summaryData, with: "pretestId"), forKey: "summary_pretest")
		} else {
			Crashlytics.crashlytics().setCustomValue(Validation.anyIsString(summaryData, with: "examId"), forKey: "summary_exam")
		}
		memberExamId = Validation.anyIsString(parameter, with: "memberExamId")
		memberScore = Validation.anyIsDictionary(parameter, with: "memberScore")
		subjectsData = memberScore["subjects"] as? [dictStringAny] ?? []
		totalTime = time
		
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
		
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
		view.backgroundColor = .brandcolor_bg
		
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
        if type == "pretest" {
            navTitleLabel.set(text:  Validation.anyIsString(summaryData, with: "name"))
        }else{
            navTitleLabel.set(text:  Validation.anyIsString(summaryData, with: "examName"))
        }
        topView.addSubview(navTitleLabel)
		
		solutionButton = CustomBottomButton(frame: CGRect(x:0, y:0, width: SCREEN_WIDTH, height: BOTTOM_BAR))
		
		// Do any additional setup after loading the view.
		view.addSubview(topView)
		topView.snp.remakeConstraints { (make) in
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
                make.leading.equalTo(backButton.snp.trailing).offset(10)
                make.centerY.equalTo(topView.snp.centerY)
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
                make.trailing.equalTo(topView.snp.trailing).offset(-10)
            }
        }
		
		fillUI()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func viewDidLayoutSubviews() {
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	fileprivate func fillUI() {
		if !isViewLoaded  {
			return
		}
		
		let solutionViewModel = CustomBottomButtonFromModel(withButton: customButton)
		solutionButton.viewModel = solutionViewModel
		solutionButton.delegate = self
		
		view.addSubview(solutionButton)
		solutionButton.snp.makeConstraints { (make) in
			make.bottom.equalTo(self.view.snp.bottom)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			make.height.equalTo(BOTTOM_BAR)
		}
		
		summaryTableView = UITableView(frame: CGRect(), style: .plain)
		summaryTableView.setParameter(target: self)
		summaryTableView.contentInset = UIEdgeInsets(top: 0.01, left: 0, bottom: MARGIN, right: 0)
		summaryTableView.register(BarPercentTableViewCell.self, forCellReuseIdentifier: BarPercentTableViewCell.cellIdentifier)
		summaryTableView.setDynamicHeight(71)
		
		view.insertSubview(summaryTableView, belowSubview: topView)
		summaryTableView.snp.makeConstraints { (make) in
			make.top.equalTo(topView.snp.bottom)
			make.leading.equalTo(topView.snp.leading)
			make.trailing.equalTo(topView.snp.trailing)
			make.bottom.equalTo(solutionButton.snp.top)
		}
	}
	
	func back() {
		Utility.backToRootView {
			if #available(iOS 10.3, *) {
				AppStoreReviewManager.requestReviewIfAppropriate()
			}
		}
	}
    
	func next() {
		back()
	}
	
	func next(tag: Int) {
		showSolution()
	}
	
	func showSolution() {
		if type == "pretest" {
			let solutionViewController = PretestSolutionViewController(withAnswerId: Validation.anyIsString(summaryData, with: "answerId"), pretestId: Validation.anyIsString(summaryData, with: "pretestId"))
			solutionViewController.nav = Nav(title: string.th_solution, isBack: true, isRight: true, imageRight: "closeWhiteIcon")
			navigationController?.pushViewController(solutionViewController, animated: true)
		} else {
			let solutionViewController = ExamSolutionViewController(examId: memberExamId, parameter: Validation.anyIsArrayAny(summaryData, with: "questions"), answers: [])
			solutionViewController.nav = Nav(title: string.th_solution, isBack: true, isRight: true, imageRight: "closeWhiteIcon")
			navigationController?.pushViewController(solutionViewController, animated: true)
		}
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		}
		return subjectsData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: BarPercentTableViewCell.cellIdentifier, for: indexPath) as! BarPercentTableViewCell
		if indexPath.section == 0 {
			cell.setExamSummaryData(data: summaryData, type: .circle, isPretest: type == "pretest")
            cell.setCircleTime(totalTime == nil ? 0 : totalTime)
			cell.isUserInteractionEnabled = false
            return cell
		} else {
			let subjectData = subjectsData[indexPath.item]
			let data = ["name" : Validation.anyIsString(subjectData, with: "subjectName"),
						"score" : Validation.anyIsFloat(subjectData, with: "score"),
						"totalScore" : Validation.anyIsFloat(subjectData, with: "subjectScore"),
						"categories" : Validation.anyIsArrayAny(subjectData, with: "categories")] as dictStringAny
			cell.setExamSummaryData(data: data, type: .line, last: indexPath.item == subjectsData.count-1 ? true : false)
			cell.isUserInteractionEnabled = true
            return cell
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! BarPercentTableViewCell
		cell.setBackground(.brandcolor3)
		UIView.animate(withDuration: 0.25) {
			cell.setBackground(.white)
		}
		let categoriesView = ExamSummarySubjectViewController(parameter: Validation.anyIsArrayAny(subjectsData[indexPath.item], with: "categories"), navTitle:  Validation.anyIsString(subjectsData[indexPath.item], with: "subjectName"))
		navigationController?.pushViewController(categoriesView, animated: true)
		
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		
	}
}
