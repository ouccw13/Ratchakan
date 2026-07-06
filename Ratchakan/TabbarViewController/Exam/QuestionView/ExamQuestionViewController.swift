//
//  ExamQuestionViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 9/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import DTCoreText
import WebKit

protocol ExamQuestionDelegate {
    func showTool(_ detail: String)
	func nextQuestion(_ index: Int)
}

let fontSizeQuestionView: CGFloat = IS_IPAD ? 36 : IS_IPHONE_5_OR_LESS ? 24 : 30

class ExamQuestionViewController: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate, ChoicesViewDelegate, WKNavigationDelegate, ExamArticleDelegate {

	var index: Int?
	var scrollView: UIScrollView!
	var headerChoiceView: HeaderChoiceView!
	var choiceView: ChoicesView!
	var questionTest: String!
	var questionText: CustomTextView!
	var articleView: ExamArticleView!
	var webViewText: CustomWebView!
	var webViewLoading: UIActivityIndicatorView!
	
	var delegate: ExamQuestionDelegate?
	
	var questionData: Question? {
		didSet {
			fillUI()
		}
	}
	
	override func viewDidLayoutSubviews() {
		scrollView.contentSize = scrollView.scrollViewContentFitToSubview()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		scrollView = UIScrollView(frame: CGRect())
		scrollView.backgroundColor = .clear
        scrollView.contentInset = UIEdgeInsets(top: MARGIN, left: 0, bottom: 0, right: 0)
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.isScrollEnabled = true

		let ques = "1. <a href=\"jstool:\" class=\"colorBandText\">Read article</a> <p><strong>Read the dialogs and choose the expression that BEST completes each missing part.Read the dialogs and choose the expression that BEST completes each missing partRead the dialogs and choose the expression that BEST completes each missing partRead the dialogs and choose the expression that BEST completes each missing partRead the dialogs and choose the expression that BEST completes each missing partRead the dialogs and choose the expression that BEST completes each missing partRead the dialogs and choose the expression that BEST completes each missing partRead the dialogs and choose the expression that BEST completes each missing partRead the dialogs and choose the expression that BEST completes each missing partRead the dialogs and choose the expression that BEST completes each missing partRead the dialogs and choose the expression that BEST completes each missing partRead the dialogs and choose the expression that BEST completes each missing partRead the dialogs and choose the expression that BEST completes each missing partRead the dialogs and choose the expression that BEST completes each missing partRead the dialogs and choose the expression that BEST completes each missing part (1)</strong></p><p>&nbsp;&nbsp;1.&nbsp;How have you been?</p><p>&nbsp;&nbsp;2.&nbsp;How it&rsquo;s going?&nbsp;</p><p>&nbsp;&nbsp;3.&nbsp;You haven&rsquo;t seen them for ages.</p><p>&nbsp;&nbsp;4.&nbsp;Long time no see.</p><p>&nbsp;&nbsp;5.&nbsp;Nice to see you.&nbsp;</p>"

		let configuration = WKWebViewConfiguration()
		webViewText = CustomWebView(frame: CGRect(x: 0, y: -16, width: SCREEN_WIDTH - 2*MARGIN, height: 0), configuration: configuration)
		webViewText.navigationDelegate = self
		webViewText.backgroundColor = .clear
        webViewText.scrollView.contentInset = UIEdgeInsets(top: MARGIN, left: 0, bottom: MARGIN, right: 0)
		webViewText.scrollView.layer.masksToBounds = false
		webViewText.isOpaque = false
		webViewText.scrollView.isScrollEnabled = false
		
        webViewLoading = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
		
		questionText = CustomTextView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
		questionText.delegate = self
        questionText.textContainerInset = UIEdgeInsets(top: MARGIN, left: 0, bottom: MARGIN, right: 0)
		questionText.setTextAndAttribute(ques)
		
		articleView = ExamArticleView(CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 62), data: [:], type: "th", detail: "")
		articleView.delegate = self
		// Do any additional setup after loading the view.
		fillUI()
    }

	@objc func touch() {

	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		scrollView.contentSize = scrollView.scrollViewContentFitToSubview()
		questionData!.startTime()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		questionText.textViewDidChange()
		scrollView.contentSize = scrollView.scrollViewContentFitToSubview()

		view.layoutIfNeeded()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
			if let question = self.questionData {
				if question.haveTool {
					self.articleView.checkInOrOut(moveOut: false)
				}
			}
		})
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		questionData!.stopTime()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	class HeaderChoiceView: UIView {
		var imageHeaderChoice = UIImageView()
		var lineHeaderChoice = UIView()
		
		override init(frame: CGRect) {
			super.init(frame: frame)
			
			backgroundColor = .clear
			addsubviews([lineHeaderChoice, imageHeaderChoice])
			lineHeaderChoice.snp.makeConstraints { (make) in
				make.leading.equalTo(snp.leading)
				make.height.equalTo(6)
				make.trailing.equalTo(snp.trailing)
				make.bottom.equalTo(snp.bottom)
			}
			imageHeaderChoice.snp.makeConstraints { (make) in
				make.size.equalTo(CGSize(width: 79, height: 30))
				make.leading.equalTo(snp.leading)
				make.bottom.equalTo(snp.bottom)
			}
		}
		override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
			if !imageHeaderChoice.frame.contains(point) && !lineHeaderChoice.frame.contains(point) {
				return nil
			}
			return super.hitTest(point, with: event)
		}
		
		required init?(coder aDecoder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
	
	func fillUI() {
		if !isViewLoaded {
			return
		}
		
		guard let data = questionData else {
			return
		}
		
		var choicesViewFrame = CGRect()
		var choicesAnswer, choicesData: Any?
		if data.questionType == .c4a1 || data.questionType == .c5a1 || data.questionType == .c5a2 || data.questionType == .fillin || data.questionType == .subjective {
			choicesViewFrame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: CHOICE_HEIGHT)
		} else if data.questionType == .relative {
			choicesViewFrame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 2*CHOICE_HEIGHT)
		}
		if data.questionType == .c4a1 || data.questionType == .c5a1 || data.questionType == .c5a2 || data.questionType == .relative {
			choicesData = data.choices!
			choicesAnswer = data.answer
		}
		headerChoiceView = HeaderChoiceView()
		headerChoiceView.imageHeaderChoice.setParameter(name: data.language == "th" ? "answerIcon" : "answerEngIcon", mode: .scaleAspectFit)
		headerChoiceView.lineHeaderChoice.backgroundColor = .brandcolor1

		choiceView = ChoicesView(choicesViewFrame, type: data.questionType, data: choicesData, answer: choicesAnswer)
		choiceView.identifier = data.id
		choiceView.delegate = self
		choiceView.addShadow(with: .brandcoloralpha, alpha: 1.0, radius: 5.0, offset: CGSize(width: 0, height: -2))
		
		scrollView.addSubview(questionText)
		scrollView.addSubview(webViewText)
		
		view.addsubviews([scrollView, articleView, headerChoiceView, choiceView, webViewLoading])
		choiceView.snp.makeConstraints { (make) in
			make.width.equalTo(SCREEN_WIDTH)
			make.height.equalTo(choicesViewFrame.height)
			make.bottom.equalTo(view.snp.bottom).offset(-BOTTOM_BAR)
			make.centerX.equalTo(view.snp.centerX)
		}
		headerChoiceView.snp.makeConstraints { (make) in
			make.height.equalTo(30)
			make.leading.equalTo(choiceView.snp.leading)
			make.trailing.equalTo(choiceView.snp.trailing)
			make.bottom.equalTo(choiceView.snp.top)
		}
        articleView.snp.makeConstraints { (make) in
            make.bottom.equalTo(choiceView.snp.top).offset(SMALLINSET)
            make.height.equalTo(articleView.frame.height)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
        }
		scrollView.snp.makeConstraints { (make) in
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
			make.top.equalTo(45+STATUSBAR)
			make.bottom.equalTo(articleView.snp.top).offset(46)
		}
		webViewLoading.snp.makeConstraints { (make) in
			make.center.equalTo(view.snp.center)
		}
		
		webViewLoading.hide()
		
		scrollView.contentSize = scrollView.scrollViewContentFitToSubview()
		view.setNeedsDisplay()
		view.setNeedsLayout()
		view.layoutIfNeeded()
		
		index = data.order - 1
        var question = data.question ?? ""
        if Validation.mathMLDetect(question.removeHtmlTagWithP()) {
            if let choices: [Choice] = data.choices as? [Choice] {
                for choice in choices {
                    question = question.removeHtmlTagWithP() + "<div class=\"choice\"><span>&nbsp;&nbsp;\(choice.prefix!).&nbsp;</span><span>\(choice.detail!.removeHtmlTagWithP())</span></div>"
                }
            }
        }else{
            if let choices: [Choice] = data.choices as? [Choice] {
                for choice in choices {
                    question = question + "<div class=\"choice\"><span>&nbsp;&nbsp;\(choice.prefix!).&nbsp;</span><span>\(choice.detail.removeHtmlTagWithP())</span></div>"
                }
            }
        }
		articleView.isHidden = !data.haveTool
		if data.haveTool {
			articleView.setDataTool(data.language!, detail: data.tool)
		}

		if Validation.mathMLDetect(question) {
			webViewLoading.show()
			webViewLoading.startAnimating()
			webViewText.show()
			questionText.hide()
			webViewText.setQuestionText(question)
		} else {
			webViewText.hide()
			questionText.show()
			questionText.setTextAndAttribute(question)
		}
		view.layoutIfNeeded()
		articleView.topPosition = articleView.frame.origin.y
        if #available(iOS 13.0, *) {
            let articleFrame = CGRect(x: 0, y: SCREEN_HEIGHT - CHOICE_HEIGHT - BOTTOM_BAR - SMALLINSET - articleView.frame.height, width: scrollView.frame.width, height: articleView.frame.height)
            articleView.frame =  articleFrame
        }
	}
	
	func updateFrame() {

	}
	func selectedChoice(indexPath: IndexPath) {
		guard let type = questionData?.questionType else {
			return
		}
		if type == .c4a1 || type == .c5a1 || type == .cna1 || type == .c5a2 {
			let choiceData = questionData!.choices as! [Choice]
			questionData!.setAnswer(choiceData[indexPath.item])
		}
		delegate?.nextQuestion(index!)
	}
	
	func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
		if URL.relativeString.hasPrefix("jstool") {
			delegate?.showTool(questionData!.tool)
			return false
		}
		return true
	}
	
	// MARK: - WKWebView NavigationDelegate
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		webView.evaluateJavaScript("document.body.style.webkitTouchCallout='none'; document.body.style.KhtmlUserSelect='none'", completionHandler: nil)
		
		webViewLoading.stopAnimating()
		webViewLoading.hide()
		var frame = webView.frame;
		webView.evaluateJavaScript("document.getElementById('content').clientHeight") { (heightString, error) in
			if let err = error {
				print(err)
				return
			}
			guard let height = heightString as? Float else {
				return
			}
			frame.size.height = CGFloat(height + 30)
            frame.size.width = webView.scrollView.contentSize.width
			webView.frame = frame
			webView.scrollView.sizeToFit()
			self.scrollView.contentSize = self.scrollView.scrollViewContentFitToSubview()
		}
		
	}
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		if (navigationAction.request.url?.relativeString.hasPrefix("jstool"))! {
			delegate?.showTool(questionData!.tool)
			decisionHandler(.cancel)
		} else {
			decisionHandler(.allow)
		}
	}
}

class CustomTextView: UITextView {
	
	override var isFirstResponder: Bool {
		return false
	}
	override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		return false
	}
	fileprivate func setParagraph(_ attString: NSMutableAttributedString?, _ text: String, _ textColor: UIColor) {
		let paragraph = NSMutableParagraphStyle()
		paragraph.tailIndent = -MARGIN
		paragraph.headIndent = MARGIN
		paragraph.firstLineHeadIndent = MARGIN
		paragraph.lineHeightMultiple = 1.2
		paragraph.lineBreakMode = .byWordWrapping
		attString?.addAttribute(.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: attString!.length))
		attString?.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: attString!.length))
		isEditable = false
		dataDetectorTypes = .all
		isScrollEnabled = false
		backgroundColor = .clear
		tintColor = .Celllabel
		self.text = text
		attributedText = attString
		
		textViewDidChange()
	}
	
	func setTextAndAttribute(_ text: String) {
		
		let fontSize: CGFloat = fontSizeQuestionView
		let coreText: dictStringAny = [DTDefaultFontFamily : "TH Sarabun New",
									   DTUseiOS6Attributes : true,
									   DTDefaultFontSize : fontSize,
                                       DTDefaultFontName : "THSarabunNew"]
		
		let data = text.data(using: .utf8)
		let attString = NSMutableAttributedString(htmlData: data, options: coreText, documentAttributes: nil)
		DTCoreTextFontDescriptor.overrideFontNameforFontFamily("TH Sarabun New", bold: false, italic: false)
		setParagraph(attString, text, .Celllabel)
	}
	
	func setDetailCalendar(_ text: String) {
		
		let fontSize: CGFloat = 14
		let coreText: dictStringAny = [DTDefaultFontFamily : "Kanit",
									   DTUseiOS6Attributes : true,
									   DTDefaultFontSize : fontSize,
									   DTDefaultFontName : "Kanit-Light",
									   DTDefaultTextColor: DTHexStringFromDTColor(.guestcolor)]
		
		let data = text.data(using: .utf8)
		let attString = NSMutableAttributedString(htmlData: data, options: coreText, documentAttributes: nil)
		DTCoreTextFontDescriptor.overrideFontNameforFontFamily("Kanit", bold: false, italic: false)
		
		setParagraph(attString, text, .guestcolor)
	}
	
	
	func setQuestionList(_ text: String) {
		
		let fontSize: CGFloat = 14
		let coreText: dictStringAny = [DTDefaultFontFamily : "TH Sarabun New",
									   DTUseiOS6Attributes : true,
									   DTDefaultFontSize : fontSize,
									   DTDefaultFontName : "THSarabunNew",
									   DTDefaultTextColor: DTHexStringFromDTColor(.Celllabel)]
		
		let data = text.data(using: .utf8)
		let attString = NSMutableAttributedString(htmlData: data, options: coreText, documentAttributes: nil)
		DTCoreTextFontDescriptor.overrideFontNameforFontFamily("TH Sarabun New", bold: false, italic: false)
		
		setParagraph(attString, text, .Celllabel)
	}
	
	func textViewDidChange() {
		let fixedWidth = frame.size.width
		let newSize = sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
		var newFrame = frame
		newFrame.size = CGSize(width: CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth))), height: newSize.height)
		frame = newFrame
	}
}

class CustomWebView : WKWebView {
	
	var contentDetail: String!
	
	override var isFirstResponder: Bool {
		return false
	}
	override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		return false
	}
    
    func setSolutionText(_ text: String) {
        contentDetail = text
        let htmlString = "<!doctype html xmlns:fb=@\"http://ogp.me/ns/fb#\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"><link href=\"style.css\" rel=\"stylesheet\"><head></head>"
        let retrunstr = "\(htmlString)<div id=\"content\">\(text)</div></body></html>"
        let data = retrunstr.data(using: .utf16)
        load(data!, mimeType: "text/html", characterEncodingName: "UTF-16", baseURL: Bundle.main.resourceURL!)
    }
	
	func setQuestionText(_ text: String) {
        contentDetail = text
		let htmlString = "<!doctype html xmlns:fb=@\"http://ogp.me/ns/fb#\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"><link href=\"style.css\" rel=\"stylesheet\"><head></head>"
        let retrunstr = "\(htmlString)<div id=\"content\">\(text)</div></body></html>"
        let data = retrunstr.data(using: .utf8)
		load(data!, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: Bundle.main.resourceURL!)
	}
    
	func setQuestionList(_ text: String) {
		let htmlString = "<!doctype html xmlns:fb=@\"http://ogp.me/ns/fb#\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"><link href=\"styleQuestionList.css\" rel=\"stylesheet\"><head> <style>body { font-family: 'Sarabun';font-size: 22px; }</style></head><body>"
        
		let retrunstr = "\(htmlString)<div class=\"list\" id=\"content\">\(text)</div></body></html>"
		
		let data = retrunstr.data(using: .utf8)
		load(data!, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: Bundle.main.resourceURL!)
	}
}

