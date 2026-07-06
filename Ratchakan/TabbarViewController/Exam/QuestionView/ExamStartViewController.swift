//
//  ExamStartViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 9/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCrashlytics
import SystemConfiguration
import ScreenShield

class ExamStartViewController: UIViewController, CustomButtonClick, UIPageViewControllerDelegate, ExamQuestionDelegate, UIScrollViewDelegate, ExamListDelegate {
	
	var typeExam: String!
	var examData: dictStringAny!  {
        didSet {
            fillUI()
        }
    }
//    var examData: Exams!
//    {
//		didSet {
//			fillUI()
//		}
//	}
	var pretestData: dictStringAny! {
		didSet {
			fillUI()
		}
	}
	var pretestEndDate: Int!
	
	var ref: DatabaseReference!
	var realtimeListener: DatabaseHandle!
	
	var questionsData: [dictStringAny]!
	
	lazy var api = API()
	
    // container view for capture screen
    var captureView: UIView!
	var topBar: UIView!
	var bottomBar: UIView!
	var questionPageView: UIPageViewController!
	var examModel: ExamStartProtocol!
	var toolView: ExamToolView!
	
	var finishButton: CustomBottomButton!
	var timeLabel: UILabel!
	var timeIcon: UIImageView!
	var numQuestionLabel: UILabel!
	var numQuestionIcon: UIImageView!
	var timeSec, pretestTotalTime: Int!
	var processBar: BarProcessView!
	var nowQuestion: Int!
	var timer: Timer!
	var timerRunning: Bool!
	var reportButton: UIButton!
	var listButton: UIButton!
	var numCap: Int = 0
	var numRecord: Int = 0
	var isRecord: Bool = false
	var sendAns: Bool = false
	
	var loadingIndicator: UIActivityIndicatorView!
	
	let customButton: BottomButton = BottomButton(title: string.th_finish_exam, color: .brandcolor1)
	
	override func viewDidLoad() {
        super.viewDidLoad()
		listenNotiCapScreen(#selector(capScreenDetect))
		
		timerRunning = false
		
		view.backgroundColor = .white
		nowQuestion = 1
        
//        captureView = UIView()
//        captureView.backgroundColor = .white
//        view.addSubview(captureView)
        
        
		topBar = UIView()
		topBar.backgroundColor = UIColor(white: 1.0, alpha: 0.15)
		
		timeLabel = UILabel()
		timeLabel.text = Datetime.timeFromSec(0, haveSpace: true)
		timeLabel.font = .kanitReg16
		timeLabel.textColor = .Celllabel
		timeLabel.textAlignment = .center
		
		if timeSec == nil {
			timeSec = 0
		}
		let timeText = Datetime.timeFromSec(timeSec, haveSpace: true)
		
		let attributedString = NSMutableAttributedString(string: "")
		
		let iconsSize = CGRect(x: 0, y: -2.2, width: 15, height: 16)
		let timeAttachment = NSTextAttachment()
		timeAttachment.image = UIImage(named: "timeIcon")
		timeAttachment.bounds = iconsSize
		attributedString.append(NSAttributedString(attachment: timeAttachment))
		attributedString.append(Utility.setStringAttributes(" \(timeText)", textColor: .Celllabel, font: .kanitReg16, underline: false))
		
		timeLabel.attributedText = attributedString
		
		numQuestionLabel = UILabel()
		numQuestionLabel.text = "0/10"
		numQuestionLabel.font = .kanitReg16
		numQuestionLabel.textColor = .Celllabel
		numQuestionLabel.textAlignment = .center
		
		setNumQuestionText(" 0/10")

		bottomBar = UIView()
        bottomBar.backgroundColor = .brandcolor_bg//.brandcoloralpha
		
		listButton = UIButton()
		listButton.withImage("listExamIcon")
		listButton.addTarget(self, action: #selector(listExam), for: .touchUpInside)
		
		finishButton = CustomBottomButton(frame: CGRect(x: 0, y: 0, width: 135, height: BOTTOM_BAR))
		
        loadingIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)

		fillUI()
        
//        captureView.addsubviews([topBar,questionPageView.view,bottomBar])
//        captureView.snp.makeConstraints{ (make) in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
//            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(appLifeCycleDetect(noification:)), name: .ApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appLifeCycleDetect(noification:)), name: .ApplicationResignActive, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .ApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: .ApplicationResignActive, object: nil)
    }
    
    @objc func appLifeCycleDetect(noification:Notification) {
        if (noification.name == Notification.Name.ApplicationDidBecomeActive) {
            print("Test APP BecomeActive")
        }else if (noification.name == Notification.Name.ApplicationResignActive) {
            print("Test APP ResignActive")
        }else if (noification.name == Notification.Name.ApplicationDidEnterBackground) {
            print("Test APP DidEnterBackground")
        }
    }
    
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		let userDefault = UserDefaults.standard
		
		if !userDefault.bool(forKey: "examInstruction") {

		}
		
		if not(timerRunning) {
			runTimer()
		}
		if pretestData != nil {
			api.getTimeStamp { (finished, response) in
				if finished {
					let time = Validation.anyIsNumber(Validation.anyIsDictionary(response!, with: "result"), with: "time")
					print(str: time)
					if self.pretestEndDate - time > 0 {
						self.timeSec = self.pretestEndDate - time
					}
				}
				return
			}
		}
        ScreenShield.shared.protect(view: view)
        ScreenShield.shared.protectFromScreenRecording()
	}
	
	func runTimer() {
		timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
		timerRunning = true
	}
	func stopTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
            timerRunning = false
        }
	}
	@objc func updateTime() {
		if pretestData != nil {
			timeSec = timeSec - 1
			pretestTotalTime = pretestTotalTime + 1
			if timeSec == 0 {
				if Utility.getCurrentViewController().isKind(of: ExamListViewController.self) {
					let listVC = Utility.getCurrentViewController() as! ExamListViewController
                    listVC.modalTransitionStyle = .crossDissolve
                    listVC.modalPresentationStyle = .fullScreen
					listVC.dismiss(animated: true) {
						self.sendAnswers()
					}
				} else {
					sendAnswers()
				}
			}
		} else {
			timeSec = timeSec + 1
		}

		let timeText = Datetime.timeFromSec(timeSec, haveSpace: true)
		
		let attributedString = NSMutableAttributedString(string: "")
		
		let iconsSize = CGRect(x: 0, y: -2.2, width: 15, height: 16)
		let timeAttachment = NSTextAttachment()
		timeAttachment.image = UIImage(named: "timeIcon")
		timeAttachment.bounds = iconsSize
		attributedString.append(NSAttributedString(attachment: timeAttachment))
		attributedString.append(Utility.setStringAttributes(" \(timeText)", textColor: .Celllabel, font: .kanitReg16, underline: false))
		
		timeLabel.attributedText = attributedString

		recordScreenDetect()

	}
	
	@objc func capScreenDetect() {
		numCap = numCap + 1
        let alertCapScreen = UIAlertController(title: "คำเตือน!!!", message: "คุณได้ทำการบันทึกหน้าจอไปแล้ว \(numCap)/3 ครั้ง", preferredStyle: UIAlertController.Style.alert)
		alertCapScreen.addAction(UIAlertAction(title: string.th_confirm, style: .default, handler: { action in
			if self.numCap >= 3 {
				self.sendAnswers()
			}
		}))
		present(alertCapScreen, animated: true, completion: nil)
	}
	
	func recordScreenDetect() {
		for screen in UIScreen.screens {
			if #available(iOS 11.0, *) {
				if screen.isCaptured || screen.mirrored != nil {
					checkRecord()
					isRecord = true
				} else {
					isRecord = false
				}
			} else {
				if screen.mirrored != nil {
					checkRecord()
					isRecord = true
				} else {
					isRecord = false
				}
			}
		}
	}
	func checkRecord() {
		if not(isRecord) {
			numRecord = numRecord + 1
			if numRecord <= 1 {
                let alertCapScreen = UIAlertController(title: "ห้ามทำการบันทึกหน้าจอ", message: "กรุณาหยุดบันทึกหน้าจอในเวลา 10 วินาที", preferredStyle: UIAlertController.Style.alert)
				alertCapScreen.addAction(UIAlertAction(title: string.th_confirm, style: .default, handler: { action in
				}))
				present(alertCapScreen, animated: true, completion: nil)
				perform(#selector(recordNSendAnswer), with: nil, afterDelay: 10.0)
			} else if numRecord > 1 {
                let alertCapScreen = UIAlertController(title: "สิ้นสุดการสอบ", message: "คุณพยายามบันทึกหน้าจอเป็นครั้งที่สอง", preferredStyle: UIAlertController.Style.alert)
				alertCapScreen.addAction(UIAlertAction(title: string.th_confirm, style: .default, handler: { action in
					self.sendAnswers()
				}))
				present(alertCapScreen, animated: true, completion: nil)
			}
		}
	}
	@objc func recordNSendAnswer() {
		if isRecord {
			sendAnswers()
		}
	}
	
	fileprivate func setNumQuestionText(_ question: String) {
		let iconsSize2 = CGRect(x: 0, y: -2, width: 13, height: 13)
		
		let attributedString2 = NSMutableAttributedString(string: "")
		let numAttachment = NSTextAttachment()
		numAttachment.image = UIImage(named: "examIcon")
		numAttachment.bounds = iconsSize2
		attributedString2.append(NSAttributedString(attachment: numAttachment))
		attributedString2.append(Utility.setStringAttributes( question, textColor: .Celllabel, font: .kanitReg16, underline: false))
		
		numQuestionLabel.attributedText = attributedString2
	}
	
	fileprivate func setNumQuestion() {
		processBar.animationLineNum(questionNum: Float(nowQuestion))
		setNumQuestionText(" \(nowQuestion!)/\(examModel.totalQuestion!)")
	}
	@objc func nq() {
		nowQuestion = nowQuestion + 1
		setNumQuestion()
		
	}
	@objc func bq() {
		nowQuestion = nowQuestion - 1
		setNumQuestion()
	}
	
	@objc func tapView() {
		timeSec = timeSec + 1
		let timeText = Datetime.timeFromSec(timeSec, haveSpace: true)
		
		let attributedString = NSMutableAttributedString(string: "")
		
		let iconsSize = CGRect(x: 0, y: -2.2, width: 15, height: 16)
		let timeAttachment = NSTextAttachment()
		timeAttachment.image = UIImage(named: "timeIcon")
		timeAttachment.bounds = iconsSize
		attributedString.append(NSAttributedString(attachment: timeAttachment))
		attributedString.append(Utility.setStringAttributes(" \(timeText)", textColor: .Celllabel, font: .kanitReg16, underline: false))
		
		timeLabel.attributedText = attributedString
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	fileprivate func fillUI() {
		if !isViewLoaded || (examData == nil && pretestData == nil) {
			return
		}
		let finishModel = CustomBottomButtonFromModel(withButton: customButton)
		finishButton.viewModel = finishModel
		finishButton.delegate = self
		
		view.addSubview(topBar)
        topBar.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.height.equalTo(45)
            make.top.equalTo(STATUSBAR)
           make.top.equalTo(STATUSBAR)
        }
		topBar.addSubview(timeLabel)
		timeLabel.snp.makeConstraints { (make) in
			make.leading.equalTo(topBar.snp.leading)
			make.trailing.equalTo(topBar.snp.centerX)
			make.height.equalTo(topBar.snp.height)
			make.centerY.equalTo(topBar.snp.centerY)
		}
		topBar.addSubview(numQuestionLabel)
		numQuestionLabel.snp.makeConstraints { (make) in
			make.leading.equalTo(topBar.snp.centerX)
			make.trailing.equalTo(topBar.snp.trailing)
			make.height.equalTo(topBar.snp.height)
			make.centerY.equalTo(topBar.snp.centerY)
		}
		let separateLineTop = UIView()
		separateLineTop.backgroundColor = .brandcolor3
		topBar.addSubview(separateLineTop)
		separateLineTop.snp.makeConstraints { (make) in
			make.width.equalTo(2)
			make.height.equalTo(18)
			make.center.equalTo(topBar.snp.center)
		}
		
		view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints { (make) in
            make.height.equalTo(BOTTOM_BAR)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.bottom.equalTo(self.view.snp.bottom)
        }
		bottomBar.addSubview(finishButton)
		finishButton.snp.makeConstraints { (make) in
			make.bottom.equalTo(bottomBar.snp.bottom)
			make.width.equalTo(135)
			make.trailing.equalTo(bottomBar.snp.trailing)
			make.height.equalTo(BOTTOM_BAR)
		}
		bottomBar.addsubviews([listButton])
		listButton.snp.makeConstraints { (make) in
			make.top.equalTo(bottomBar.snp.top).offset(14)
			make.width.equalTo(25)
			make.height.equalTo(22)
			make.leading.equalTo(bottomBar.snp.leading).offset(MARGIN)
		}
		
		if typeExam == "exam" {
            examModel = ExamStartProtocol(withData: examData, questions: questionsData)
			Crashlytics.crashlytics().setCustomValue(examModel.parameter.id, forKey: "exam_id")
		} else {
			examModel = ExamStartProtocol(withPretest: pretestData)
			Crashlytics.crashlytics().setCustomValue(examModel.pretest.pretestID, forKey: "pretest_id")
			if timeSec <= 0 {
				timeSec = Validation.anyIsNumber(pretestData, with: "duration") * 60
			}
			pretestTotalTime = 0
			let timeText = Datetime.timeFromSec(timeSec, haveSpace: true)
			
			let attributedString = NSMutableAttributedString(string: "")
			
			let iconsSize = CGRect(x: 0, y: -2.2, width: 15, height: 16)
			let timeAttachment = NSTextAttachment()
			timeAttachment.image = UIImage(named: "timeIcon")
			timeAttachment.bounds = iconsSize
			attributedString.append(NSAttributedString(attachment: timeAttachment))
			attributedString.append(Utility.setStringAttributes(" \(timeText)", textColor: .Celllabel, font: .kanitReg16, underline: false))
			
			timeLabel.attributedText = attributedString
		}
		processBar = BarProcessView.init(CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 4), questionNum: examModel.totalQuestion)
		view.addSubview(processBar)
		processBar.snp.makeConstraints { (make) in
			make.leading.equalTo(topBar.snp.leading)
			make.trailing.equalTo(topBar.snp.trailing)
			make.height.equalTo(4)
			make.top.equalTo(topBar.snp.bottom)
		}
		setNumQuestion()
        
		questionPageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
		questionPageView.dataSource = examModel
		questionPageView.delegate = self
        if #available(iOS 11.0, *) {
            //
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
		let scrollView = questionPageView.view.subviews.filter { $0 is UIScrollView }.first as! UIScrollView
		scrollView.delegate = self
		
		let startingViewController = examModel.questionViewController(atIndex: 0)
		startingViewController?.delegate = self
		if startingViewController == nil {
			dismiss(animated: true, completion: nil)
			return
		}
		let questionControllers: [UIViewController] = [startingViewController!]
		questionPageView.setViewControllers(questionControllers, direction: .forward, animated: false, completion: nil)
        addChild(questionPageView)
        questionPageView.didMove(toParent: self)
		view.insertSubview(questionPageView.view, belowSubview: topBar)
		
		view.addSubview(loadingIndicator)
		loadingIndicator.snp.makeConstraints { (make) in
			make.center.equalTo(view.snp.center)
		}
	}

	@objc func appCrash(_ sender: Notification) {
		api.checkMemberPretestOnline(action: .delete, pretestId: examModel.pretest.pretestID) { (finished, response) in
			return
		}
	}
	
    func showTool(_ detail: String) {
		let view: ExamQuestionViewController = questionPageView.viewControllers?.first as! ExamQuestionViewController
		view.delegate = self
		
		if toolView == nil {
            toolView = ExamToolView(self.view.frame, data: [:], theme: .normal, type: .tool, detail: detail)
			self.view.addSubview(toolView)
			toolView.updateLayout()
		} else {
            toolView.setDataTool(detail: detail)
		}
		toolView.animationIn()
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		let view = questionPageView.viewControllers?.first as! ExamQuestionViewController
		view.delegate = self
		if not(view.questionData!.haveTool) {
			if toolView != nil && not(toolView.isHidden) {
				toolView.animationOut()
			}
		} else {
			if toolView != nil && not(toolView.isHidden) {
                toolView.setDataTool(detail: view.questionData!.tool)
			}
		}
		if nowQuestion > view.index! + 1 {
			bq()
		} else if nowQuestion < view.index! + 1 {
			nq()
		}
	}
	
	@objc func reportedExam() {

	}
	
	@objc func listExam() {
		let listExamView = ExamListViewController()
		listExamView.examListData = examModel.examData
		listExamView.delegate = self
        listExamView.modalTransitionStyle = .crossDissolve
        listExamView.modalPresentationStyle = .fullScreen
		present(listExamView, animated: true, completion: nil)
	}
	
	fileprivate func sendAnswers() {
		finishButton.isUserInteractionEnabled = false
		loadingIndicator.startAnimating()
		self.stopTimer()
		if typeExam == "exam" {
			self.api.sendExamAnswer(self.examModel.parameter, time: self.timeSec) { (finished, response) in
				self.loadingIndicator.stopAnimating()
				if finished {
					self.viewDisappear()
					let summaryView = ExamSummaryViewController(parameter: response!["result"] as! dictStringAny, time: self.timeSec)
					let navSummaryView = UINavigationController(rootViewController: summaryView)
                    navSummaryView.modalPresentationStyle = .fullScreen
					self.present(navSummaryView, animated: true, completion: nil)
				} else {
					if self.numRecord >= 1 || self.numCap >= 3 {
						self.timer = nil
						self.timer.invalidate()
					}
					self.runTimer()
					self.finishButton.isUserInteractionEnabled = true
					dropdownAlert.errorNTryAgain()
				}
			}
		} else {
			sendAns = true
			self.api.sendPretestAnswer(pretestData: self.examModel.pretest, self.examModel.examData, totalTime: self.pretestTotalTime, { (finished, response) in
				self.loadingIndicator.stopAnimating()
				if finished {
					self.viewDisappear()
					if Validation.anyIsNumber(response!, with: "type") == 1 {
                        self.deleteRealtimeMember()
						let alertView = PretestDoneView(withView: self.view)
						alertView.acceptAddTarget(self, selector: #selector(self.pretestDone(_:)))
						alertView.showLayout()
					} else {
						let summaryView = ExamSummaryViewController(parameter: response!["result"] as! dictStringAny, time: self.pretestTotalTime, typeExam: "pretest")
						let navSummaryView = UINavigationController(rootViewController: summaryView)
                        navSummaryView.modalPresentationStyle = .fullScreen
						self.present(navSummaryView, animated: true, completion: nil)
					}
				} else {
					self.runTimer()
					self.finishButton.isUserInteractionEnabled = true
					dropdownAlert.errorNTryAgain()
					if self.numRecord >= 1 || self.numCap >= 3 {
						self.questionPageView.view.isUserInteractionEnabled = false
						self.sendAnswers()
						self.finishButton.isUserInteractionEnabled = false
					}
				}
			})
		}
	}
	
	func next(tag: Int) {
		let numAns = examModel.examData.filter { (question) -> Bool in
			return question.isAnswer
		}.count
        let confirmAlert = UIAlertController(title: "ต้องการจบการสอบหรือไม่?", message: typeExam == "" ? nil : "ทำข้อสอบไป \(numAns)/\(examModel.totalQuestion!) ข้อ", preferredStyle: UIAlertController.Style.alert)
        
        // Change Title With Color and Font:
          let myString  = "ต้องการจบการสอบหรือไม่?"
          var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont.kanitReg14])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.Celllabel, range: NSRange(location:0,length:myMutableString.length))
        confirmAlert.setValue(myMutableString, forKey: "attributedTitle")

          // Change Message With Color and Font
          let message  = typeExam == "" ? nil : "ทำข้อสอบไป \(numAns)/\(examModel.totalQuestion!) ข้อ"
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: (message ?? "") as String, attributes: [NSAttributedString.Key.font:UIFont.kanitReg12])
        messageMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.messageAlert, range: NSRange(location:0,length:messageMutableString.length))
        confirmAlert.setValue(messageMutableString, forKey: "attributedMessage")
        
        let cancelAction = UIAlertAction(title: string.th_cancel, style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.messageAlert, forKey: "titleTextColor")
        
        let confirmAction = UIAlertAction(title: string.th_ok, style: .default, handler: { action in
            self.sendAnswers()
        })
        confirmAction.setValue(UIColor.brandcolor1, forKey: "titleTextColor")
        
		confirmAlert.addAction(cancelAction)
		confirmAlert.addAction(confirmAction)
		present(confirmAlert, animated: true, completion: nil)
	}
	@objc func pretestDone(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	func deleteRealtimeMember() {
		self.api.checkMemberPretestOnline(action: .delete, pretestId: self.examModel.pretest.pretestID, { (finished, response) in
			if finished {
				return
			} else {
				self.deleteRealtimeMember()
			}
		})
	}
	
	func didSelectIndexPath(_ indexPath: IndexPath) {
		let examQuestioinView = examModel.questionViewController(atIndex: indexPath.item)
		examQuestioinView?.delegate = self
		questionPageView.setViewControllers([examQuestioinView!], direction: .reverse, animated: false, completion: nil)
        nowQuestion = ((examQuestioinView?.index ?? 0) + 1)
		setNumQuestion()
	}
	
    func nextQuestion(_ index: Int) {
        if let examQuestioinView = examModel.questionViewController(atIndex: index+1) {
            examQuestioinView.delegate = self
            questionPageView.setViewControllers([examQuestioinView], direction: .forward, animated: true, completion: { _ in
                self.nq()
            })
        } else {
            next(tag: 0)
        }
    }
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let positionScroll = (scrollView.contentOffset.x - scrollView.frame.width)/scrollView.frame.width
		print(str: positionScroll)
		processBar.animationLineNum(questionNum: Float(CGFloat(nowQuestion) + positionScroll))
	}
}
