//
//  ExamReportViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 29/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

let defaultReportText = "อธิบายรายละเอียด.."

class ExamReportViewController: UIViewController, CustomNavDelegate, CustomButtonClick, UITextViewDelegate, GenderSelectDelegate {

	var questionId: String!
	var pretestId: String!
	var isPretest: Bool!
	
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
	var reportButton: CustomBottomButton!
	
	lazy var api = API()
	
	let customButton: BottomButton = BottomButton(title: string.th_confirm, color: .brandcolor1)
	
	var scrollView: UIScrollView!
	
	var subjectReportLabel: UILabel!
	var subjectReportView: UIView!
	var detailReportLabel: UILabel!
	var detailTextView: UITextView!
	
	var typeButtons: [IconNLabelButton] = []
	
	var reportType: String!
	
	var reportTypeData: [String]? {
		didSet {
			fillUI()
		}
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		if UIColor.dark(color: .navbrandcolor) {
			return .lightContent
		} else {
			return .default
		}
	}
	
	convenience init(id: String, isPretest: Bool, pretestId: String) {
	
		self.init(nibName: nil, bundle: nil)
		
		questionId = id
		self.pretestId = pretestId
		self.isPretest = isPretest
		
		loadTypeReport()
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
		hideKeyboardWhenTappedAround()
		moveViewWhenKeyboradAppear()
		
		view.backgroundColor = .brandcolor_bg
		
        topView = UIView()
        topView.backgroundColor = .navbrandcolor

		scrollView = UIScrollView()
		scrollView.showsHorizontalScrollIndicator = false

		subjectReportLabel = UILabel()
		subjectReportLabel.setParameter(font: .kanitReg16, color: .Celllabel)
		subjectReportLabel.text = "กรุณาเลือกปัญหาที่ต้องการรายงาน"
		detailReportLabel = UILabel()
		detailReportLabel.setParameter(font: .kanitReg16, color: .Celllabel)
		detailReportLabel.text = "หมายเหตุ"
		detailTextView = UITextView()
		detailTextView.delegate = self
		detailTextView.font = .kanitLight14
		detailTextView.textContainerInset = UIEdgeInsets(top: MARGIN, left: MARGIN, bottom: MARGIN, right: MARGIN)
        detailTextView.backgroundColor = .white
        detailTextView.cornerView()
		detailTextView.borderView(color: .brandcolor3, width: 0.6)
		detailTextView.text = defaultReportText
		detailTextView.textColor = .guestcolor
		reportButton = CustomBottomButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: BOTTOM_BAR))

        // Do any additional setup after loading the view.
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
        navTitleLabel.set(text: string.th_report_exam)
        topView.addSubview(navTitleLabel)

		view.addSubview(topView);
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

		fillUI()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		scrollView.contentSize = scrollView.scrollViewContentFitToSubview()
	}
	
	override func viewDidLayoutSubviews() {
		scrollView.contentSize = scrollView.scrollViewContentFitToSubview()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	fileprivate func loadTypeReport() {
		api.reportedType { (finished, response) in
			if finished {
				let typeReport = response!["result"] as! dictStringAny
				self.reportTypeData = typeReport["type"] as? [String] 
			} else {
				dropdownAlert.errorNTryAgain()
			}
		}
	}
	
	fileprivate func fillUI() {
		if !isViewLoaded || reportTypeData == nil {
			return
		}
	
		let reportModel = CustomBottomButtonFromModel(withButton: customButton)
		reportButton.viewModel = reportModel
		reportButton.delegate = self
		view.addSubview(reportButton)
		reportButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			make.height.equalTo(BOTTOM_BAR)
		}
		
		view.insertSubview(scrollView, belowSubview: topView)
		scrollView.snp.makeConstraints { (make) in
			make.top.equalTo(topView.snp.bottom)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(reportButton.snp.top)
		}
		subjectReportView = UIView()
		subjectReportView.cornerView()
		subjectReportView.backgroundColor = .white
		var beforeTypeView: IconNLabelButton = IconNLabelButton()
		for type in reportTypeData! {
			let typeView = IconNLabelButton(frame: CGRect())
			typeView.circleNText(type, withID: type)
			typeView.delegate = self
			subjectReportView.addSubview(typeView)
			typeView.snp.makeConstraints({ (make) in
				make.leading.equalTo(subjectReportView.snp.leading)
				make.trailing.equalTo(subjectReportView.snp.trailing)
				make.height.equalTo(52)
			})
			if type.isEqual(reportTypeData!.first!) {
				typeView.snp.makeConstraints({ (make) in
					make.top.equalTo(subjectReportView.snp.top)
				})
			} else {
				let separateLine = UIView()
				separateLine.lineView(withColor: .Collectionbg)
				typeView.snp.makeConstraints({ (make) in
					make.top.equalTo(beforeTypeView.snp.bottom)
				})
				subjectReportView.addSubview(separateLine)
				separateLine.snp.makeConstraints({ (make) in
					make.leading.equalTo(subjectReportView.snp.leading)
					make.trailing.equalTo(subjectReportView.snp.trailing)
					make.height.equalTo(SEPARATE_LINE_WIDHT)
					make.top.equalTo(typeView.snp.top)
				})
			}
			beforeTypeView = typeView
			typeButtons.append(typeView)
		}
        let shadowBG = UIView(frame: CGRect(x: 0, y: 0, width: Int(SCREEN_WIDTH-(2*MARGIN)), height: 52*reportTypeData!.count))
		shadowBG.dropShadow(color: .brandcoloralpha, opacity: 1.0, offSet: CGSize(width: 0, height: 1), radius: 20)
		
		scrollView.addsubviews([subjectReportLabel, subjectReportView, detailReportLabel, detailTextView])
		scrollView.insertSubview(shadowBG, belowSubview: subjectReportView)
		subjectReportLabel.snp.makeConstraints { (make) in
			make.leading.equalTo(view.snp.leading).offset(32)
			make.trailing.equalTo(view.snp.trailing).offset(-32)
			make.height.equalTo(24)
			make.top.equalTo(scrollView.snp.top).offset(MARGIN)
		}
		subjectReportView.snp.makeConstraints { (make) in
			make.leading.equalTo(view.snp.leading).offset(MARGIN)
			make.trailing.equalTo(view.snp.trailing).offset(-MARGIN)
			make.top.equalTo(subjectReportLabel.snp.bottom).offset(MARGIN)
			make.height.equalTo(52*reportTypeData!.count)
		}
		shadowBG.snp.makeConstraints { (make) in
			make.edges.equalTo(subjectReportView.snp.edges)
		}
		detailReportLabel.snp.makeConstraints { (make) in
			make.leading.equalTo(subjectReportLabel.snp.leading)
			make.trailing.equalTo(subjectReportLabel.snp.trailing)
			make.height.equalTo(subjectReportLabel.snp.height)
			make.top.equalTo(subjectReportView.snp.bottom).offset(MARGIN)
		}
		detailTextView.snp.makeConstraints { (make) in
			make.leading.equalTo(view.snp.leading).offset(MARGIN)
			make.trailing.equalTo(view.snp.trailing).offset(-MARGIN)
			make.top.equalTo(detailReportLabel.snp.bottom).offset(MARGIN)
			make.height.equalTo(135)
		}
        
		scrollView.contentSize = scrollView.scrollViewContentFitToSubview()

	}
	
	func back() {
		dismiss(animated: true, completion: nil)
	}
	
	func next(tag: Int) {
		report()
	}
	
	func report() {
		if reportType == nil {
            let dialogMessage = UIAlertController(title:string.th_error, message: "กรุณาเลือกปัญหาที่ต้องการรายงาน", preferredStyle: .alert)
            // Present alert to user
            self.present(dialogMessage, animated: true, completion: nil)
            let when = DispatchTime.now() + 1.5
            DispatchQueue.main.asyncAfter(deadline: when){
              // your code with delay
              dialogMessage.dismiss(animated: true, completion: nil)
            }
        } else if detailTextView.text == defaultReportText || detailTextView.text.trimSpace() == "" {
            let dialogMessage = UIAlertController(title:string.th_error, message: "กรุณาอธิบายปัญหาที่เกิดขึ้น", preferredStyle: .alert)
            // Present alert to user
            self.present(dialogMessage, animated: true, completion: nil)
            let when = DispatchTime.now() + 1.5
            DispatchQueue.main.asyncAfter(deadline: when){
              // your code with delay
              dialogMessage.dismiss(animated: true, completion: nil)
            }
		} else {
			api.reportedQuestion(questionId, type: reportType, message: detailTextView.text, isExam: !isPretest, pretestId: pretestId) { (finished, response) in
				if finished {
                    let confirmAlert = UIAlertController(title: "รายงานสำเร็จ", message: nil, preferredStyle: UIAlertController.Style.alert)
					confirmAlert.addAction(UIAlertAction(title: string.th_ok, style: .default, handler: { action in
						self.back()
					}))
					self.present(confirmAlert, animated: true, completion: nil)
				} else {
					dropdownAlert.errorNTryAgain()
				}
			}
		}
	}
	
	func select(gender: String) {
		scrollView.contentSize = scrollView.scrollViewContentFitToSubview()
		for button in typeButtons {
			if button.identifier != gender {
				button.didUnselectedGender()
			}
		}
		reportType = gender
		view.endEditing(true)
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		
		if textView.textColor == .guestcolor {
			textView.text = ""
			textView.textColor = .Celllabel
		}
		
		var overlab:(Bool, CGFloat)
		
		var textViewPosition = textView.frame.origin.y + textView.frame.size.height
		if #available(iOS 10.0, *) {
			textViewPosition = textViewPosition + NAV_HEIGHT
		}
		if textViewPosition >= SCREEN_HEIGHT - BOTTOM_BAR {
			textViewPosition = SCREEN_HEIGHT - BOTTOM_BAR
		}
		if #available(iOS 10.0, *) {
			if textViewPosition >= SCREEN_HEIGHT {
				textViewPosition = SCREEN_HEIGHT
			}
		}
		if textViewPosition >= ORIGIN_Y_KEYBOARD {
			let differentOrigin = textViewPosition - ORIGIN_Y_KEYBOARD + MARGIN
			overlab = (true, differentOrigin)
		} else {
			overlab = (false, 0)
		}

		checkOverlab(overlab)
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text.isEmpty {
			textView.text = "อธิบายรายละเอียด.."
			textView.textColor = .guestcolor
		}
	}
}
