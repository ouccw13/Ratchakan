//
//  SolutionViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 23/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import WebKit
import ScreenShield

class ExamSolutionViewController: CustomViewControllerPushNavAndNoTabbar, CustomNavDelegate, SolutionCellDelegate {

	var solutionView: SolutionView!
	
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
	
	var memberExamId: String!
	var solutionsData, answersData: [dictStringAny]!
	
	var nav: Nav? {
		didSet {
			fillUI()
		}
	}
	var toolView: ExamToolView!
	
	convenience init(examId: String, parameter: [dictStringAny], answers: [dictStringAny]) {
		
		self.init(nibName: nil, bundle: nil)
		solutionsData = parameter
		answersData = answers
		memberExamId = examId
		
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
        
        topView = UIView()
        topView.backgroundColor = .navbrandcolor
        
        // Do any additional setup after loading the view.
        fillUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ScreenShield.shared.protectFromScreenRecording()
    }
	
	fileprivate func fillUI() {
		if !isViewLoaded || nav == nil {
			return
		}
		
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
        navTitleLabel.set(text: nav?.title)
        topView.addSubview(navTitleLabel)
		
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
		
		solutionView = SolutionView(CGRect(), data: solutionsData, examId: memberExamId)
		solutionView.delegate = self
        
		
		view.insertSubview(solutionView, belowSubview: topView)
		solutionView.snp.makeConstraints { (make) in
			make.top.equalTo(topView.snp.bottom)
			make.leading.equalTo(topView.snp.leading)
			make.trailing.equalTo(topView.snp.trailing)
			if Utility.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_11() {
				make.bottom.equalTo(view.snp.bottom)
			} else {
				make.bottom.equalTo(view.snp.bottom).offset(TABBAR_HEIGHT)
			}
		}
	}
	
    func back() {
		navigationController?.popViewController(animated: true)
	}
	func next() {
		Utility.backToRootView()
	}
	
    func showTool(_ title: String, detail: String, video: String?) {
		if toolView == nil {
            toolView = ExamToolView(self.view.frame, data: [:], theme: .normal, type: title == "บทความ" ? .tool : .solution, detail: detail, video: video)
            self.view.addSubview(toolView)
			toolView.updateLayout()
		} else {
            toolView.setDataTool(title, detail: detail, video: video)
		}
		toolView.animationIn()
	}
	func reportQuestion(_ questionId: String, pretestId: String) {
		let reportView = ExamReportViewController(id: questionId, isPretest: false, pretestId: "")
        reportView.modalTransitionStyle = .crossDissolve
        reportView.modalPresentationStyle = .fullScreen
		present(reportView, animated: true, completion: nil)
	}
}

class PretestSolutionViewController: CustomViewControllerPushNavAndNoTabbar, CustomNavDelegate, SolutionCellDelegate {

    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
    
	var nav: Nav? {
		didSet {
			fillUI()
		}
	}
	
	var solutionView: SolutionView!
	var toolView: ExamToolView!
	var pretestId, answerId: String!

	init(withAnswerId id: String, pretestId: String) {
		super.init(nibName: nil, bundle: nil)
		answerId = id
		self.pretestId = pretestId
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brandcolor_bg
        
        topView = UIView()
        topView.backgroundColor = .navbrandcolor
        fillUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ScreenShield.shared.protectFromScreenRecording()
    }
	
	fileprivate func fillUI() {
		if !isViewLoaded || nav == nil {
			return
		}
		
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
        navTitleLabel.set(text: nav?.title)
        topView.addSubview(navTitleLabel)
		
		view.addSubview(topView)
        topView.snp.remakeConstraints { (make) in
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

		solutionView = SolutionView(CGRect(), data: [], examId: answerId, isPretest: true, pretestId: pretestId)
		solutionView.delegate = self

		view.insertSubview(solutionView, belowSubview: topView)
		solutionView.snp.makeConstraints { (make) in
			make.top.equalTo(topView.snp.bottom)
			make.leading.equalTo(topView.snp.leading)
			make.trailing.equalTo(topView.snp.trailing)
			make.bottom.equalTo(view.snp.bottom)
		}
	}
	
	// MARK: - Nav Delegate
	func back() {
		navigationController?.popViewController(animated: true)
	}
	func next() {
		Utility.backToRootView()
	}
	
    func showTool(_ title: String, detail: String, video: String?) {
        if toolView == nil {
            toolView = ExamToolView(self.view.frame, data: [:], theme: .normal, type: title == "บทความ" ? .tool : .solution, detail: detail, video: video)
            self.view.addSubview(toolView)
            toolView.updateLayout()
        } else {
            toolView.setDataTool(title, detail: detail, video: video)
        }
        toolView.animationIn()
    }
	func reportQuestion(_ questionId: String, pretestId: String) {
		let reportView = ExamReportViewController(id: questionId, isPretest: true, pretestId: pretestId)
        reportView.modalPresentationStyle = .fullScreen
        reportView.modalTransitionStyle = .crossDissolve
		present(reportView, animated: true, completion: nil)
	}
}

class SolutionView: UIView, UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate, UIScrollViewDelegate, WKUIDelegate {
	
	lazy var api = API()
	var webview: WKWebView!
	var examId: String!
	var solutionDatas: [dictStringAny]!
	var contentHeights: [CGFloat] = []
	
	var isPretest: Bool!
	var pretestId: String!
	var pretestQuestions: [Question]!
	
	var delegate: SolutionCellDelegate?
	var loaded: Int!
	var loadingView: LoadingView!
	
	init(_ frame: CGRect, data: [dictStringAny], examId: String, isPretest: Bool = false, pretestId: String = "") {
		super.init(frame: frame)
		backgroundColor = .brandcolor_bg
		self.examId = examId
		self.isPretest = isPretest
		self.pretestId = pretestId
		
		let config = WKWebViewConfiguration()
		
		webview = WKWebView(frame: frame, configuration: config)
		webview.navigationDelegate = self
		webview.scrollView.delegate = self
		webview.isOpaque = false
        webview.scrollView.isScrollEnabled = true
		
		solutionDatas = Utility.sortArrayOfDictionary(data, withInt: "order", ascending: true)

		loaded = 0
		
		addSubview(webview)
		if Utility.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_11() {
			webview.snp.makeConstraints { (make) in
				make.edges.equalTo(snp.edges)
			}
		} else {
			webview.snp.makeConstraints({ (make) in
				make.leading.equalTo(snp.leading)
				make.trailing.equalTo(snp.trailing)
				make.top.equalTo(snp.top).offset(-STATUSBAR)
				make.bottom.equalTo(snp.bottom)
			})
		}
		layoutIfNeeded()

		loadingView = LoadingView(withSuperview: self)
		loadingView.startLoading()
		if isPretest {
			pretestQuestions = LoadPretest.getPretest(pretestId)
			api.getPretestSolution(answerId: examId) { (finished, response) in
				let request = response!["result"] as! URLRequest
				if Utility.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_11() {
					self.webview.load(request)
				} else {
					let task = URLSession.shared.dataTask(with: request) { data, response, error in
						guard let data = data, error == nil else {  // check for fundamental networking error
							return
						}
						
						if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {  // check for http errors
						}
						
						let responseString = String(data: data, encoding: .utf8)
						self.webviewLoad(url: responseString!, baseURL: request.url)
					}
					task.resume()
				}
			}
			
		} else {
			api.getSolution(examId: examId) { (finished, response) in
				let request = response!["result"] as! URLRequest
				if Utility.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_11() {
					self.webview.load(request)
				} else {
					let task = URLSession.shared.dataTask(with: request) { data, response, error in
						guard let data = data, error == nil else {
							// check for fundamental networking error
							return
						}
						
						if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
							// check for http errors
						}
						
						let responseString = String(data: data, encoding: .utf8)
						self.webviewLoad(url: responseString!, baseURL: request.url)
					}
					task.resume()
				}
			}
		}
		
	}
	func webviewLoad(url: String, baseURL: URL?) {
		webview.loadHTMLString(url, baseURL: baseURL)
	}
	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		print(str: error)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return solutionDatas.count
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return contentHeights[indexPath.item]
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: SolutionCollectionViewCell.cellIdentifier, for: indexPath) as! SolutionCollectionViewCell
		
		cell.backgroundColor = .clear
		cell.setData(["index": indexPath.item], answer: solutionDatas[indexPath.item])
		cell.solutionText.navigationDelegate = self
		cell.solutionText.tag = indexPath.item
		
		if contentHeights[indexPath.item] != 0.0 {
			cell.showDetailSolutionButton.show()
		} else {
			cell.showDetailSolutionButton.hide()
		}
		
		return cell
	}
    
	
	// MARK: - ScrollView Delegate
	func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
		scrollView.pinchGestureRecognizer?.isEnabled = false
	}

	// MARK: - WKWebView NavigationDelegate
	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		print(str: "start")
	}

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.style.webkitTouchCallout='none'; document.body.style.KhtmlUserSelect='none'", completionHandler: nil)
        webView.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
        self.loadingView.stopLoading()
    }
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		if isPretest {
			if (navigationAction.request.url?.relativeString.hasPrefix("jstool"))! {
				let index = Int(String((navigationAction.request.url?.relativeString.split(separator: "/")[1])!))
				showTool("บทความ", detail: pretestQuestions[index!].tool, video: nil)
				decisionHandler(.cancel)
			} else if (navigationAction.request.url?.relativeString.hasPrefix("jssolution"))! {
				let index = Int(String((navigationAction.request.url?.relativeString.split(separator: "/")[1])!))
                showTool(string.th_detail_solution, detail: pretestQuestions[index!].solution, video: pretestQuestions[index!].videoSolution)
				decisionHandler(.cancel)
			} else if (navigationAction.request.url?.relativeString.hasPrefix("jsreport"))! {
				let index = Int(String((navigationAction.request.url?.relativeString.split(separator: "/")[1])!))
				reportQuestion(pretestQuestions[index!].id)
				decisionHandler(.cancel)
			} else {
				decisionHandler(.allow)
			}
		} else {
			if (navigationAction.request.url?.relativeString.hasPrefix("jstool"))! {
				let index = Int(String((navigationAction.request.url?.relativeString.split(separator: "/")[1])!))
                showTool("บทความ", detail: Validation.anyIsString(solutionDatas[index!], with: "questionTool"), video: nil)
				decisionHandler(.cancel)
			} else if (navigationAction.request.url?.relativeString.hasPrefix("jssolution"))! {
				let index = Int(String((navigationAction.request.url?.relativeString.split(separator: "/")[1])!))
                showTool(string.th_detail_solution, detail: Validation.anyIsString(solutionDatas[index!], with: "questionSolution"), video: Validation.anyIsString(solutionDatas[index!], with: "videoSolution"))
				decisionHandler(.cancel)
			} else if (navigationAction.request.url?.relativeString.hasPrefix("jsreport"))! {
				let index = Int(String((navigationAction.request.url?.relativeString.split(separator: "/")[1])!))
				reportQuestion(Validation.anyIsString(solutionDatas[index!], with: "questionId"))
				decisionHandler(.cancel)
			} else {
				decisionHandler(.allow)
			}
		}
	}
	
    func showTool(_ title: String, detail: String, video: String?) {
        delegate?.showTool(title, detail: detail, video: video)
	}
	func reportQuestion(_ questionId: String) {
		delegate?.reportQuestion(questionId, pretestId: pretestId)
	}
}
