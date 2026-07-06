//
//  SolutionCollectionViewCell.swift
//  ratchakan
//
//  Created by JJsobtid on 23/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import DTCoreText
import WebKit

protocol SolutionCellDelegate {
    func showTool(_ title: String, detail: String, video: String?)
	func reportQuestion(_ questionId: String, pretestId: String)
}

class SolutionCollectionViewCell: UITableViewCell, UITextViewDelegate {
	
	static let cellIdentifier = "SolutionCollectionViewCell"
	
	var viewBG: UIView!
	var showDetailSolutionButton: UIButton!
	var reportSolutionButton: UIButton!
	var solutionText: CustomWebView!//CustomTextView!
	var answerLabel: UILabel!
	
	var delegate: SolutionCellDelegate?
	var index: Int!
    var id, solutionDetail, videoDetail, questionDetail: String!
	
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		let width: CGFloat = SCREEN_WIDTH - 4*MARGIN
		selectionStyle = .none
		
		contentView.backgroundColor = .white
		contentView.snp.makeConstraints { (make) in
			make.top.equalTo(snp.top).offset(SMALLINSET)
			make.leading.equalTo(snp.leading).offset(MARGIN)
			make.trailing.equalTo(snp.trailing).offset(-MARGIN)
			make.bottom.equalTo(snp.bottom).offset(-SMALLINSET)
		}
		showDetailSolutionButton = UIButton()
		showDetailSolutionButton.setParameter(string.th_detail_solution, textColor: .white, font: .kanitReg16, backgroundColor: .brandcolor1)
		showDetailSolutionButton.addTarget(self, action: #selector(showSolution), for: .touchUpInside)
		
		reportSolutionButton = UIButton()
		reportSolutionButton.withImage("reportIcon")
		reportSolutionButton.setParameter("", textColor: .clear, font: .kanitLight14, backgroundColor: .clearCanTouch)
		reportSolutionButton.addTarget(self, action: #selector(reportExam), for: .touchUpInside)
		
		answerLabel = UILabel()
		answerLabel.setParameter(font: .thSarabunBI22, color: .Celllabel)
		
		let ques = "<p>1. <a href=\"jstool:\">Read article</a> <strong>Read the dialogs and choose the expression that BEST completes each missing part.Read the dialogs and choose the expression that BEST completes each missing partRead the dialogs and choose the expression that BEST completes each missing partRead the dialogs and choose the expression that BEST completes each missing partRead the dialogs and choose the expression that BEST completes each missing partRead the dialogs and choose the expression that BEST completes each missing partRead the dialogs and choose the expression that BEST completes each missing partRead the dialogs and choose the expression that BEST completes each missing part (1)</strong></p><p>&nbsp;&nbsp;1.&nbsp;How have you been?</p><p style=\"color:rgb(255,0,0);\">&nbsp;&nbsp;2.&nbsp;How it&rsquo;s going?&nbsp;</p><p>&nbsp;&nbsp;3.&nbsp;You haven&rsquo;t seen them for ages.</p><p>&nbsp;&nbsp;4.&nbsp;Long time no see.</p><p>&nbsp;&nbsp;5.&nbsp;Nice to see you.&nbsp; เทสภาษาไทยหน่อยสิ</p>"
		
		let configuration = WKWebViewConfiguration()
		solutionText = CustomWebView(frame: CGRect(x: 0, y: -24, width: width, height: 0), configuration: configuration)
		solutionText.backgroundColor = .clear
        solutionText.scrollView.contentInset = UIEdgeInsets(top: MARGIN, left: 0, bottom: MARGIN, right: 0)
		solutionText.scrollView.layer.masksToBounds = false
		solutionText.isOpaque = false
		solutionText.scrollView.isScrollEnabled = false
		
		solutionText.setQuestionText(ques)
		
		contentView.addsubviews([solutionText, showDetailSolutionButton, reportSolutionButton, answerLabel])
		showDetailSolutionButton.snp.makeConstraints { (make) in
			make.leading.equalTo(contentView.snp.leading)
			make.trailing.equalTo(contentView.snp.trailing)
			make.bottom.equalTo(contentView.snp.bottom)
			make.height.equalTo(44)
		}
		reportSolutionButton.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize(width: 20, height: 20))
			make.bottom.equalTo(showDetailSolutionButton.snp.top).offset(-MARGIN)
			make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
		}
		answerLabel.snp.makeConstraints { (make) in
			make.height.equalTo(29)
			make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(reportSolutionButton.snp.leading).offset(-SMALLINSET)
			make.centerY.equalTo(reportSolutionButton.snp.centerY).offset(6)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setData(_ solution: dictStringAny, answer: dictStringAny) {
		id = Validation.anyIsString(answer, with: "questionId")
		let questionType = Validation.anyIsString(answer, with: "questionType")
		var correctAnswer: [String] = []
		var questionText = Validation.anyIsString(answer, with: "question").removeHtmlTagWithP()
        var correct: Bool = false
		if questionType == "C4A1" || questionType == "C5A1" || questionType == "C5A2" {
			let choices = Utility.sortArrayOfDictionary(Validation.anyIsArrayAny(answer, with: "questionChoice"), withInt: "order", ascending: true)
			for choice in choices {
				let boolAnswer = Validation.anyIsBool(choice, with: "correct")
				let userAnswer = Validation.anyIsBool(choice, with: "memberAnswer")
				var choiceText = "<span>&nbsp;&nbsp;\(Validation.anyIsString(choice, with: "prefix")).&nbsp;</span><span>\(Validation.anyIsString(choice, with: "detail").removeHtmlTag())</span>"
				if not(boolAnswer) && userAnswer {
					choiceText = "<div class=\"choice\" style=\"color:rgb(208,2,27);\">\(choiceText)</div>"
				} else if boolAnswer && userAnswer {
					choiceText = "<div class=\"choice\" style=\"color:rgb(41, 156, 80);\"><strong>\(choiceText)</strong></div>"
					correct = true
				} else {
					choiceText = "<div class=\"choice\" style=\"color:rgb(74,74,74);\">\(choiceText)</div>"
				}
				if boolAnswer {
					correctAnswer.append("\(Validation.anyIsString(choice, with: "prefix"))")
				}
				if Validation.anyIsNumber(choice, with: "order") == 1 {
					questionText = questionText + "<p>" + choiceText
				} else if Validation.anyIsNumber(choice, with: "order") == choices.count {
					questionText = questionText + choiceText + "</p>"
				} else {
					questionText = questionText + choiceText
				}
			}
		}
		if Validation.anyIsBool(answer, with: "haveSolution") {
			showDetailSolutionButton.enableButton(color: .brandcolor1)
			solutionDetail = Validation.anyIsString(answer, with: "questionSolution")
            videoDetail = Validation.anyIsString(answer, with: "videoSolution")
		} else {
			showDetailSolutionButton.disableButton(canTouch: false)
		}
		if Validation.anyIsBool(answer, with: "haveTool") {
			questionText = questionText.findFirstCloseBracket(insertText: "<strong><a href=\"jstool:\" style=\"color: rgb(255,50,85)\">\(Validation.anyIsString(answer, with: "language") == "th" ? string.th_read_article : string.en_read_article)</a></strong><br>")
			questionDetail = Validation.anyIsString(answer, with: "questionTool")
			solutionText.accessibilityIdentifier = questionDetail
		}
		
		solutionText.setQuestionText(questionText)

		contentView.layoutIfNeeded()

		answerLabel.text = "เฉลย : \(correctAnswer.joined(separator: ", "))"

		index = Validation.anyIsNumber(solution, with: "index")
	}
	
	@objc func showSolution() {
        delegate?.showTool(string.th_detail_solution, detail: solutionDetail, video: videoDetail)
	}
	@objc func reportExam() {
		delegate?.reportQuestion(id, pretestId: "")
	}
}
