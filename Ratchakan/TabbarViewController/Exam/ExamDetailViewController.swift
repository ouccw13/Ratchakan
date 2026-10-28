//
//  ExamDetailViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 16/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class ExamDetailViewController: CustomViewControllerPushNavAndNoTabbar, UITableViewDataSource, UITableViewDelegate, CustomNavDelegate, CustomButtonClick {

	var examDetailData: dictStringAny!
    var newexamDetailData: Exams!
	
	lazy var api = API()
	var member: dictStringAny!
	
	var isMember: Bool = false
	var isFree: Bool = false
	
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
	var packageView: UIView!
	var packageLabel: UILabel!
	var chevronImageView: UIImageView!
	var tableDetailExam: UITableView!
	var startExamButton: CustomBottomButton!
	
	var loadingView: LoadingView!
	
	let customButton: BottomButton = BottomButton(title: string.th_start_exam, color: .brandcolor1)
	
	var nav: Nav? {
		didSet {
			fillUI()
		}
	}
	var topViewHeroId: String!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		member = api.getDatabase().getMember()
		view.backgroundColor = .brandcolor_bg
		
		packageView = UIView()
		packageView.backgroundColor = .brandcoloralpha
		packageView.addTarget(self, selector: #selector(showPackageBenefit(_:)))
		packageLabel = UILabel()
		packageLabel.setParameter(font: .kanitLight14, color: .brandcolor1)
		chevronImageView = UIImageView(image: UIImage(named: "icExamNext"))
		chevronImageView.contentMode = .scaleAspectFit
		
		tableDetailExam = UITableView(frame: CGRect(), style: .grouped)
		tableDetailExam.setDynamicHeight(53)
		tableDetailExam.register(PretestDetailTableViewCell.self, forCellReuseIdentifier: PretestDetailTableViewCell.cellIdentifier)
		tableDetailExam.backgroundColor = .clear
		tableDetailExam.separatorColor = .clear
		tableDetailExam.delegate = self
		tableDetailExam.dataSource = self
		tableDetailExam.sectionHeaderHeight = 30
		
		if not(Utility.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_11()) {
			tableDetailExam.tableHeaderView = createHeaderView(title: "รายละเอียด")
		}
		
		startExamButton = CustomBottomButton(frame: CGRect(x:0, y:0, width: SCREEN_WIDTH, height: BOTTOM_BAR))
        // Do any additional setup after loading the view.
		fillUI()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		listenNotiLogInOut(#selector(initAPI(_ :)))
        if newexamDetailData.free ?? false || (Validation.anyIsNumber(api.packages, with: newexamDetailData.examGroupId ?? "") != 0 && Validation.anyIsNumber(api.packages, with: newexamDetailData.examGroupId ?? "") >= Datetime.getCurrentTimestamp()) {
			
		} else {
            packageLabel.text = newexamDetailData.alert
            packageLabel.fixline(2)
            packageLabel.lineBreakMode = .byWordWrapping
			packageView.snp.remakeConstraints { (make) in
				make.top.equalTo(topView.snp.bottom)
				make.leading.equalTo(view.snp.leading)
				make.height.equalTo(50)
				make.trailing.equalTo(view.snp.trailing)
			}
			UIView.animate(withDuration: 0.25) {
				self.view.layoutIfNeeded()
			}
		}
	}

	@objc func initAPI(_ sender: NSNotification) {
		api = API()
		member = api.getDatabase().getMember()
		setButton()
	}
	
	fileprivate func fillUI() {
		if !isViewLoaded || nav == nil {
			return
		}
		
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
        navTitleLabel.setParameter(font: .navTitleFont, color: .cellWhiteLabel)
        navTitleLabel.set(text: newexamDetailData.name)
        topView.addSubview(navTitleLabel)
		
		let startModel = CustomBottomButtonFromModel(withButton: customButton)
		startExamButton.viewModel = startModel
		startExamButton.delegate = self
		
		packageView.addsubviews([packageLabel, chevronImageView])
		view.addsubviews([packageView])
		
		view.addSubview(topView)
		topView.snp.makeConstraints { (make) in
			make.top.equalTo(0)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
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
                make.leading.equalTo(backButton.snp.trailing).offset(56)
                make.trailing.equalTo(topView.snp.trailing).offset(-56)
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
                make.leading.equalTo(backButton.snp.trailing).offset(MARGIN)
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.centerX.equalTo(topView.snp.centerX)
            }
        }
		
		view.addSubview(startExamButton)
		startExamButton.snp.makeConstraints { (make) in
			make.bottom.equalTo(view.snp.bottom)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
			make.height.equalTo(BOTTOM_BAR)
		}
		
		view.insertSubview(tableDetailExam, belowSubview: topView)
		tableDetailExam.snp.makeConstraints { (make) in
			make.top.equalTo(packageView.snp.bottom)
			make.bottom.equalTo(startExamButton.snp.top)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
		}
		
		packageView.snp.makeConstraints { (make) in
			make.top.equalTo(topView.snp.bottom)
			make.leading.equalTo(view.snp.leading)
			make.height.equalTo(0)
			make.trailing.equalTo(view.snp.trailing)
		}
		packageLabel.snp.makeConstraints { (make) in
			make.leading.equalTo(packageView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(packageView.snp.trailing).offset(-2*MARGIN)
			make.centerY.equalTo(packageView.snp.centerY)
		}
		chevronImageView.snp.makeConstraints { (make) in
			make.trailing.equalTo(packageView.snp.trailing).offset(-MARGIN)
			make.centerY.equalTo(packageLabel.snp.centerY)
			make.width.equalTo(7)
			make.height.equalTo(packageView.snp.height)
		}
		view.layoutIfNeeded()
		
		tableDetailExam.dataSource = self
		member = api.getDatabase().getMember()
		setButton()
	}
	
	func setButton() {
        if newexamDetailData.free ?? false || (Validation.anyIsNumber(api.packages, with: newexamDetailData.examGroupId ?? "")) != 0 && Validation.anyIsNumber(api.packages, with: newexamDetailData.examGroupId ?? "") >= Datetime.getCurrentTimestamp() {
			startExamButton.setTitle(string.th_start_exam)
		} else {
            startExamButton.setTitle("ซื้อแพ็กเกจ")
		}
	}
	
	// MARK: - Button Action
	func next(tag: Int) {
		if Utility.checkLogIn(member: member) {
            if newexamDetailData.free ?? false || (Validation.anyIsNumber(api.packages, with: newexamDetailData.examGroupId ?? "")) != 0 && Validation.anyIsNumber(api.packages, with: newexamDetailData.examGroupId ?? "") >= Datetime.getCurrentTimestamp() {
				loadingView = LoadingView(withSuperview: view)
				loadingView.startLoading()
                api.getExamQuestion(newexamDetailData.examId ?? "") { (finished, response) in
					self.loadingView.stopLoading()
					if finished {
						self.viewDisappear()
						guard let questionsData = response!["result"] as? dictStringAny else {
							return
						}
						guard let questions = questionsData["questions"] as? [dictStringAny] else {
							return
						}
						let examStartView = ExamStartViewController()
                        examStartView.modalPresentationStyle = .fullScreen
						examStartView.typeExam = "exam"
						examStartView.questionsData = questions
						examStartView.examData = questionsData
						self.present(examStartView, animated: true, completion: {
							self.navigationController?.popViewController(animated: false)
						})
					} else {
						dropdownAlert.errorNTryAgain()
					}
					return
				}
			} else {
					let packagePurchaseView = PagePackageViewController()
					self.navigationController?.pushViewController(packagePurchaseView, animated: true)
			}
		}
	}
	
	func back() {
		self.viewDisappear()
		navigationController?.popViewController(animated: true)
	}

	@objc func showPackageBenefit(_ sender: UIGestureRecognizer) {
		let packagePurchaseView = PagePackageViewController()
		navigationController?.pushViewController(packagePurchaseView, animated: false)
	}
	
	// MARK: - Table Delegate & DataSource
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
        }else{
            var subjects : [Int] = []
            if newexamDetailData.subjects?.count ?? 0 > 0 {
                for subject in newexamDetailData.subjects ?? [] {
                    let questionQty = subject.questionQty ?? 0
                    if questionQty > 0 {
                        subjects.append(questionQty)
                    }
                }
                return subjects.count
            }else{
                return newexamDetailData.subjects?.count ?? 0
            }
        }
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		var headerView: UIView!
		if section == 0 {
			headerView = createHeaderView(title: "รายละเอียดข้อสอบ")
		} else {
			headerView = createHeaderView(title: "เนื้อหาข้อสอบ")
		}
		
		return headerView
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PretestDetailTableViewCell.cellIdentifier, for: indexPath) as! PretestDetailTableViewCell
        var cellExamsData: Exams
        var cellSubjectData: SubjectList
        cellExamsData = newexamDetailData
        let subjects = newexamDetailData.subjects ?? []
        cellSubjectData = subjects[indexPath.item]
        cell.isType = "Exam"
        if (newexamDetailData.subjects?.count ?? 0) - 1 == indexPath.item {
            cell.setLayoutWithExamsData(cellExamsData,cellSubjectData, section: PretestDetailSection.withSection(section: indexPath.section),isShowBottom: false)
        }else{
            cell.setLayoutWithExamsData(cellExamsData,cellSubjectData, section: PretestDetailSection.withSection(section: indexPath.section),isShowBottom: true)
        }
		return cell
	}
	
	func createHeaderView(title: String) -> UIView {
		let headerView = UIView()
		headerView.backgroundColor = .clear
		let headerTitle = UILabel()
		headerTitle.setParameter(font: .kanitLight14, color: .Celllabel)
		headerTitle.text = title
		headerView.addSubview(headerTitle)
		headerTitle.snp.remakeConstraints { (make) in
			make.leading.equalTo(headerView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(headerView.snp.trailing).offset(-MARGIN)
			make.height.equalTo(21)
			make.bottom.equalTo(headerView.snp.bottom).offset(-4)
		}
		return headerView
	}

}
