//
//  PopUpStartExamView.swift
//  ratchakan
//
//  Created by JJsobtid on 5/6/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

protocol PopUpStartExamDelegate {
	func startExam()
}
class PopUpStartExamView: UIView {

	lazy var api = API()
	
	lazy var currentView = Utility.getCurrentViewController()
	var whiteBackgroundView: UIView!
	var startButton: UIButton!
	var alertImageView: UIImageView!
	var titleExamLabel, titleLabel, detailLabel: UILabel!
	var loadingIndicator: UIActivityIndicatorView!
	
	var detailData: dictStringAny = [:]
	
	var delegate: PopUpStartExamDelegate?
	
	init(withSuper view: UIView) {
		super.init(frame: CGRect(origin: CGPoint(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT/2), size: CGSize.zero))
		
		backgroundColor = .blackalpha
		
		alertImageView = UIImageView()
		alertImageView.setParameter(name: "alertNewIcon", mode: .scaleAspectFit)
		
		whiteBackgroundView = UIView()
		whiteBackgroundView.backgroundColor = .white
		whiteBackgroundView.cornerView()
		
		titleExamLabel = UILabel()
		titleExamLabel.flexibleLine()
		titleExamLabel.setParameter(font: .kanitReg16, color: .Celllabel, alignment: .center)
		titleExamLabel.text = "ชื่อข้อสอบ"
		
		titleLabel = UILabel()
		titleLabel.setParameter(font: .kanitReg14, color: .guestcolor)
		titleLabel.text = "เนื้อหาข้อสอบ"
		detailLabel = UILabel()
		detailLabel.setParameter(font: .kanitReg14, color: .guestcolor, alignment: .right)
		detailLabel.text = "จำนวนข้อ"
		
		startButton = UIButton()
		startButton.setParameter("เริ่มสอบ", textColor: .white, font: .kanitReg18, backgroundColor: .brandcolor1)
		startButton.addTarget(self, action: #selector(startExamAction(_:)), for: .touchUpInside)
		startButton.isEnabled = false
		
        loadingIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
		
		whiteBackgroundView.addsubviews([titleExamLabel, titleLabel, detailLabel, startButton])
		addsubviews([whiteBackgroundView, alertImageView, loadingIndicator])
		
		UIApplication.shared.keyWindow?.addSubview(self)

		hideAlert()

		loadingData()
	}
	
	func loadingData() {
		api.getExamFree { (finished, response) in
			self.startButton.isEnabled = true
			if finished && Validation.anyIsNumber(response!, with: "status") == 200 {
				self.setConstraints()
				self.showAlert()
				self.detailData = Validation.anyIsDictionary(response!, with: "result")
				self.titleExamLabel.text = Validation.anyIsString(self.detailData, with: "name")
				var beforetitle: UILabel!
				var count = 0
				for subject in Validation.anyIsArrayAny(self.detailData, with: "subjects") {
					let titleSubject = UILabel()
					titleSubject.setParameter(font: .kanitLight14, color: .guestcolor)
					titleSubject.text = Validation.anyIsString(subject, with: "name")
					titleSubject.flexibleLine()
					let detailSubject = UILabel()
					detailSubject.setParameter(font: .kanitLight14, color: .guestcolor, alignment: .right)
					detailSubject.text = "\(Utility.commaNumber(Validation.anyIsNumber(subject, with: "qty"))) ข้อ"
					self.whiteBackgroundView.addsubviews([titleSubject, detailSubject])
					titleSubject.snp.makeConstraints({ (make) in
						if beforetitle == nil {
							make.top.equalTo(self.titleLabel.snp.bottom).offset(MARGIN)
						} else {
							make.top.equalTo(beforetitle.snp.bottom).offset(MARGIN)
						}
						make.leading.equalTo(self.titleLabel.snp.leading)
						make.trailing.equalTo(self.titleLabel.snp.trailing)
						if count == Validation.anyIsArrayAny(self.detailData, with: "subjects").count {
							make.bottom.equalTo(self.whiteBackgroundView.snp.bottom).offset(-49-MARGIN)
						}
					})
					detailSubject.snp.makeConstraints({ (make) in
						make.centerY.equalTo(titleSubject.snp.centerY)
						make.trailing.equalTo(self.detailLabel.snp.trailing)
						make.width.equalTo(self.detailLabel.snp.width)
					})
					count += 1
					beforetitle = titleSubject
				}
				self.startButton.snp.remakeConstraints { (make) in
					if beforetitle != nil {
						make.top.equalTo(beforetitle.snp.bottom).offset(MARGIN)
					} else {
						make.top.equalTo(self.titleLabel.snp.bottom).offset(MARGIN)
					}
					make.height.equalTo(49)
					make.leading.equalTo(self.whiteBackgroundView.snp.leading)
					make.bottom.equalTo(self.whiteBackgroundView.snp.bottom)
					make.trailing.equalTo(self.whiteBackgroundView.snp.trailing)
				}
			} else {
                
			}
			return
		}
	}
	
	@objc func startExamAction(_ sender: UIButton) {
		startButton.isEnabled = false
		self.loadingIndicator.startAnimating()
		api.getExamQuestion(Validation.anyIsString(detailData, with: "examId")) { (finished, response) in
			self.loadingIndicator.stopAnimating()
			self.startButton.isEnabled = true
			if finished {
				guard let questionsData = response!["result"] as? dictStringAny else {
					return
				}
				guard let questions = questionsData["questions"] as? [dictStringAny] else {
					return
				}
				self.hideAlert()
				let examStartView = ExamStartViewController()
                examStartView.modalPresentationStyle = .fullScreen
				examStartView.typeExam = "exam"
				examStartView.questionsData = questions
				examStartView.examData = self.detailData
				Utility.getCurrentViewController().present(examStartView, animated: true, completion: {
				})
			} else {
				dropdownAlert.errorNTryAgain()
			}
			return
		}
	}
	
	func showAlert() {
		snp.remakeConstraints { (make) in
			make.top.equalTo(0)
			make.leading.equalTo(0)
			make.width.equalTo(SCREEN_WIDTH)
			make.height.equalTo(SCREEN_HEIGHT)
		}
	}
	func hideAlert() {
		snp.remakeConstraints { (make) in
			make.size.equalTo(CGSize.zero)
		}
		whiteBackgroundView.snp.remakeConstraints { (make) in
			make.edges.equalTo(snp.edges)
		}
		alertImageView.snp.remakeConstraints { (make) in
			make.size.equalTo(CGSize.zero)
		}
	}
	
	func setConstraints() {
		whiteBackgroundView.snp.remakeConstraints { (make) in
			make.center.equalTo(CGPoint(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT/2))
			if IS_IPHONE_5_OR_LESS {
				make.width.equalTo(300)
			} else {
				make.width.equalTo(320)
			}
			make.height.greaterThanOrEqualTo(200)
		}
		alertImageView.snp.remakeConstraints { (make) in
			make.centerY.equalTo(whiteBackgroundView.snp.top)
			make.centerX.equalTo(whiteBackgroundView.snp.centerX)
			make.size.equalTo(CGSize(width: 98, height: 80))
		}
		
		titleExamLabel.snp.remakeConstraints { (make) in
			make.top.equalTo(whiteBackgroundView.snp.top).offset(54)
			make.leading.equalTo(whiteBackgroundView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(whiteBackgroundView.snp.trailing).offset(-MARGIN)
		}
		titleLabel.snp.remakeConstraints { (make) in
			make.top.equalTo(titleExamLabel.snp.bottom).offset(24)
			make.leading.equalTo(whiteBackgroundView.snp.leading).offset(24)
			make.trailing.equalTo(whiteBackgroundView.snp.trailing).offset(-24-SMALLINSET-65)
		}
		detailLabel.snp.remakeConstraints { (make) in
			make.centerY.equalTo(titleLabel.snp.centerY)
			make.trailing.equalTo(whiteBackgroundView.snp.trailing).offset(-24)
			make.width.equalTo(65)
		}
		startButton.snp.remakeConstraints { (make) in
			make.height.equalTo(49)
			make.leading.equalTo(whiteBackgroundView.snp.leading)
			make.bottom.equalTo(whiteBackgroundView.snp.bottom)
			make.trailing.equalTo(whiteBackgroundView.snp.trailing)
		}
		
		loadingIndicator.snp.remakeConstraints { (make) in
			make.center.equalTo(snp.center)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
