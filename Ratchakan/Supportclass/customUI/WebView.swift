//
//  CustomWebView.swift
//  ratchakan
//
//  Created by JJsobtid on 24/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import WebKit

class WebView: CustomViewControllerPresentNavAndNoTabbar, CustomNavDelegate, UIWebViewDelegate, WKNavigationDelegate {

	var topView: CustomNav!
	var url: URL!
	
	let nav: Nav = Nav(title: "SOBTID", isBack: true, isRight: true, imageRight: "reloadIcon")
	
	var webView: WKWebView!
	var loadingWeb: UIActivityIndicatorView!
	
	convenience init(link: String, title: String = "SOBTID") {
		
		self.init(nibName: nil, bundle: nil)
		url = URL(string: link)
		self.title = title
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
		
		topView = CustomNav(frame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: TOP_VIEW))
		
		// Do any additional setup after loading the view.
		let navModel = CustomViewModelFromNav(withNav: nav)
		topView.viewModel = navModel
		topView.delegate = self
		topView.titleNavLabel.text = title
		
		let configuration = WKWebViewConfiguration()
		webView = CustomWebView(frame: CGRect(x: 0, y: TOP_VIEW, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-TOP_VIEW), configuration: configuration)
		webView.navigationDelegate = self
		webView.allowsBackForwardNavigationGestures = true
		webView.backgroundColor = .brandcolor_bg
        webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		webView.load(URLRequest(url: url))
		
		webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
		
        loadingWeb = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
		loadingWeb.center = webView.center
		
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
		
		view.addSubview(webView)
		view.addSubview(topView)

		topView.snp.remakeConstraints { (make) in
			make.top.equalTo(0)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
			make.height.equalTo(TOP_VIEW)
		}
		
		webView.snp.makeConstraints { (make) in
			make.top.equalTo(topView.snp.bottom)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
			make.bottom.equalTo(view.snp.bottom)
		}
		
		view.addSubview(loadingWeb)
		loadingWeb.startAnimating()
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
	}
	
	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		loadingWeb.startAnimating()
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		loadingWeb.stopAnimating()
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
		webView.evaluateJavaScript("document.title", completionHandler: {(response, error) in
		})
	}
	func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
		decisionHandler(.allow)
	}
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		if navigationAction.request.url != nil
		{
			print(str: navigationAction.request.url!)
		}
		decisionHandler(.allow)
	}

	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			print(str: webView.estimatedProgress)
		}
	}
	
	// MARK: - NAV DELEGATE
	func back() {
		dismiss(animated: true, completion: nil)
	}
	func next() {
		webView.reload()
		loadingWeb.startAnimating()
	}
}

