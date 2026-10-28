//
//  ExamArticleView.swift
//  ratchakan
//
//  Created by JJsobtid on 31/8/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import WebKit

protocol ExamArticleDelegate {
	func updateFrame()
}

class ExamArticleView: UIView, UITextViewDelegate, WKNavigationDelegate {

	let headerHeight: CGFloat = 50
	let ratioTop: CGFloat = IS_IPHONE_5_OR_LESS ? 0.2 : 0.25
	let ratioBottom: CGFloat = IS_IPHONE_5_OR_LESS ? 0.6 : 0.7
	var toolData: dictStringAny!
	var type: String!
	var theme: ExamTheme!
	
	var superviewFrame: CGRect!
	var topPosition: CGFloat!
	var lastPosition: CGFloat!
	var textViewHeight: CGFloat!
	
	var backgroundView: UIView!
	var titleTabView: UIView!
	var titleImageView: UIImageView!
	var detailTextView: CustomTextView!
	var webViewText: CustomWebView!
	var webLoadingIndicator: UIActivityIndicatorView!
	var scrollView: UIScrollView!
	
	var detailText: String!
	
	var delegate: ExamArticleDelegate?
	
	init(_ frame: CGRect, data: dictStringAny, theme: ExamTheme = .normal, type: String, detail: String) {
		super.init(frame: frame)
		
		backgroundColor = .clear
		
		toolData = data
		self.type = type
		self.theme = theme
		detailText = ""
		
		backgroundView = UIView(frame: CGRect(x: 0,
                                              y: headerHeight-SMALLINSET,
                                              width: SCREEN_WIDTH,
                                              height: frame.height-headerHeight+SMALLINSET))
		backgroundView.backgroundColor = .white
		backgroundView.dropShadow(color: .brandcoloralpha,
                                  opacity: 1,
                                  offSet: CGSize(width: 0, height: -3),
                                  radius: 6)
		addSubview(backgroundView)
		
		scrollView = UIScrollView(frame: CGRect(x: 0,
                                                y: 0,
                                                width: SCREEN_WIDTH,
                                                height: frame.height-headerHeight))
		scrollView.isScrollEnabled = true
		
		detailTextView = CustomTextView(frame: CGRect(x: 0,
                                                      y: MARGIN,
                                                      width: SCREEN_WIDTH,
                                                      height: 0))
		detailTextView.delegate = self
		detailTextView.backgroundColor = .brandcolor1
        detailTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: MARGIN, right: 0)
		
		let configuration = WKWebViewConfiguration()
		webViewText = CustomWebView(frame: CGRect(x: 0,
                                                  y: -22,
                                                  width: SCREEN_WIDTH - 2*MARGIN,
                                                  height: 0),
                                    configuration: configuration)
		webViewText.navigationDelegate = self
		webViewText.backgroundColor = .clear
        webViewText.scrollView.contentInset = UIEdgeInsets(top: MARGIN, left: 0, bottom: MARGIN, right: 0)
		webViewText.scrollView.layer.masksToBounds = false
		webViewText.isOpaque = false
		webViewText.scrollView.isScrollEnabled = false
		
        webLoadingIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
		webViewText.addSubview(webLoadingIndicator)
		
		backgroundView.addSubview(scrollView)
		scrollView.addsubviews([detailTextView, webViewText])
		
		titleImageView = UIImageView(frame: CGRect(x: frame.width-104, y: 0, width: 129, height: headerHeight))
		titleImageView.contentMode = .scaleAspectFit
		titleImageView.isUserInteractionEnabled = true
		addSubview(titleImageView)
		setDataTool(type, detail: detail)
		
		let pan = UIPanGestureRecognizer(target: self, action: #selector(dragtool(_:)))
		titleImageView.addGestureRecognizer(pan)
		let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
		titleImageView.addGestureRecognizer(tap)
		
	}
	
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		if !backgroundView.frame.contains(point) && !titleImageView.frame.contains(point) {
			return nil
		}
		return super.hitTest(point, with: event)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func closeTool() {
		animationOut()
	}
	
	func setDataTool(_ title: String = "บทความ", detail: String) {
		let sameTool = detailText == detail
		detailText = detail.removeHtmlTagWithP()
		type = title
		if title == "th" {
			titleImageView.image = UIImage(named: "articleThIcon")
		} else {
			titleImageView.image = UIImage(named: "articleEngIcon")
		}
		if not(sameTool) {
			if Validation.mathMLDetect(detailText) {
				webViewText.show()
				webLoadingIndicator.show()
				detailTextView.hide()
				webViewText.setQuestionText(detailText)
				webLoadingIndicator.startAnimating()
			} else {
				webViewText.hide()
				webLoadingIndicator.hide()
				detailTextView.show()
				detailTextView.setTextAndAttribute(detailText)
			}
			scrollView.contentSize = scrollView.scrollViewContentFitToSubview()
			UIView.animate(withDuration: 0.5, animations: {
				self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
			})
		}
		
	}
	func updateLayout() {
		let superview = self.superview
		if superview != nil {
			superviewFrame = superview!.frame
			frame = CGRect(x: 0, y: superviewFrame.size.height, width: superviewFrame.size.width, height: superviewFrame.size.height)
		}
	}
	func animationIn(_ ratioTop: CGFloat) {
		UIView.animate(withDuration: 0.25, animations: {
			self.frame = CGRect(x: self.frame.origin.x, y: SCREEN_HEIGHT*ratioTop, width: self.frame.width, height: SCREEN_HEIGHT - BOTTOM_BAR - CHOICE_HEIGHT - self.frame.origin.y)
		}) { (finished) in
			self.frame = CGRect(x: self.frame.origin.x, y: SCREEN_HEIGHT*ratioTop, width: self.frame.width, height: SCREEN_HEIGHT - BOTTOM_BAR - CHOICE_HEIGHT - self.frame.origin.y)
			self.backgroundView.frame = CGRect(origin: self.backgroundView.frame.origin, size: CGSize(width: self.backgroundView.frame.width, height: SCREEN_HEIGHT - BOTTOM_BAR - CHOICE_HEIGHT - self.headerHeight - self.frame.origin.y))
			self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x, y: self.scrollView.frame.origin.y, width: self.scrollView.frame.width, height: self.backgroundView.frame.height)
			self.scrollView.contentSize = self.scrollView.scrollViewContentFitToSubview()
			self.webLoadingIndicator.center = self.scrollView.center
			self.delegate?.updateFrame()
		}
	}
	
	func animationOut() {
		UIView.animate(withDuration: 0.25, animations: {
			self.frame = CGRect(x: self.frame.origin.x, y: SCREEN_HEIGHT - BOTTOM_BAR - CHOICE_HEIGHT - self.headerHeight, width: self.frame.width, height: SCREEN_HEIGHT - BOTTOM_BAR - CHOICE_HEIGHT - self.frame.origin.y)
			self.backgroundView.frame = CGRect(origin: self.backgroundView.frame.origin, size: CGSize(width: self.backgroundView.frame.width, height: CHOICE_HEIGHT))
			self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x, y: self.scrollView.frame.origin.y, width: self.scrollView.frame.width, height: self.backgroundView.frame.height)
			self.scrollView.contentSize = self.scrollView.scrollViewContentFitToSubview()
			self.webLoadingIndicator.center = self.scrollView.center
		}) { (finished) in
			self.delegate?.updateFrame()
		}
	}
	
	func checkInOrOut(moveOut: Bool = true) {
		if frame.origin.y > SCREEN_HEIGHT * ratioBottom {
			animationIn(0.4)
		} else {
			if moveOut {
				animationOut()
			}
		}
	}
	
	@objc fileprivate func tap(_ sender: UITapGestureRecognizer) {
		checkInOrOut()
	}
	
	@objc fileprivate func dragtool(_ sender: UIPanGestureRecognizer) {
		let translation = sender.translation(in: sender.view).y
		let newPoint = CGPoint(x: frame.origin.x, y: frame.origin.y + translation)
		if SCREEN_HEIGHT * ratioTop < newPoint.y && newPoint.y <= SCREEN_HEIGHT - BOTTOM_BAR - CHOICE_HEIGHT - headerHeight {
			center = CGPoint(x: center.x, y: center.y + translation)
			sender.setTranslation(CGPoint.zero, in: sender.view)
			backgroundView.frame = CGRect(origin: backgroundView.frame.origin, size: CGSize(width: backgroundView.frame.width, height: SCREEN_HEIGHT - BOTTOM_BAR - CHOICE_HEIGHT - headerHeight - frame.origin.y))
			frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: SCREEN_HEIGHT - BOTTOM_BAR - CHOICE_HEIGHT - frame.origin.y)
			scrollView.frame = CGRect(x: scrollView.frame.origin.x, y: scrollView.frame.origin.y, width: scrollView.frame.width, height: backgroundView.frame.height)
			scrollView.contentSize = scrollView.scrollViewContentFitToSubview()
			webLoadingIndicator.center = scrollView.center
		}
		
		if sender.state == .ended {
			if sender.velocity(in: sender.view).y > 750 {
				animationOut()
			} else if sender.velocity(in: sender.view).y < -750 {
				animationIn(ratioTop)
			} else {
			}
		}
	}
	
	
	// MARK: - WKWebView NavigationDelegate
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		webView.evaluateJavaScript("document.body.style.webkitTouchCallout='none'; document.body.style.KhtmlUserSelect='none'", completionHandler: nil)
		
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
			frame.size.width = SCREEN_WIDTH - 2*MARGIN
			webView.frame = frame
			self.scrollView.contentSize = self.scrollView.scrollViewContentFitToSubview()
		}
		webLoadingIndicator.stopAnimating()
	}

}
