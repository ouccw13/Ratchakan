//
//  ExamToolViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 9/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import WebKit
import youtube_ios_player_helper

enum ExamToolType {
	case tool
	case solution
}

class ExamToolView: UIView, UITextViewDelegate, WKNavigationDelegate, YTPlayerViewDelegate {
	
	var toolData: dictStringAny!
	var type: ExamToolType!
	var theme: ExamTheme!
	
	var superviewFrame: CGRect!
	var topPosition: CGFloat!
	var lastPosition: CGFloat!
	var textViewHeight: CGFloat!
    var isPlayed: Bool = false
    var titleText: String = ""
	
    var topView: UIView!
	var closeButton: UIButton!
	var titleTool: UILabel!
	var detailTextView: CustomTextView!
	var webViewText: CustomWebView!
	var scrollView: UIScrollView!
    var videoPlayer: YTPlayerView!
    var playOrPauseVideo: UIButton!
    var blockHeadVideo: UIView!
    var blockFooterVideo: UIView!
	var detailText: String!
	
    init(_ frame: CGRect, data: dictStringAny, theme: ExamTheme = .normal, type: ExamToolType, detail: String = "บทความ", video: String? = nil) {
		super.init(frame: frame)
		
		backgroundColor = .white
		
		toolData = data
		self.type = type
		self.theme = theme
		detailText = ""
		
		closeButton = UIButton()
		closeButton.setParameter("", textColor: .clear, font: .kanitReg14, backgroundColor: .clearCanTouch)
		closeButton.setImage(#imageLiteral(resourceName: "closeIcon"), for: .normal)
		closeButton.addTarget(self, action: #selector(closeTool), for: .touchUpInside)
        addSubview(closeButton)
	
		closeButton.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize(width: 22, height: 22))
			make.trailing.equalTo(self.snp.trailing).offset(-MARGIN)
			make.top.equalTo(self.snp.top).offset(MARGIN)
		}
		
		titleTool = UILabel()
		titleTool.setParameter(font: .thSarabunB22, color: .Celllabel, alignment: .center)
		if type == .tool {
            titleText = "บทความ"
		} else {
            titleText = string.th_detail_solution
		}
		addSubview(titleTool)
		titleTool.snp.makeConstraints { (make) in
			make.top.equalTo(self.snp.top).offset(MARGIN)
			make.leading.equalTo(self.snp.leading)
			make.trailing.equalTo(self.snp.trailing)
			make.height.equalTo(22)
		}
		
		scrollView = UIScrollView(frame: CGRect(x: 0, y: 48, width: SCREEN_WIDTH, height: self.frame.height))
		
		let configuration = WKWebViewConfiguration()
        webViewText = CustomWebView(frame: CGRect(x: 0, y: 300, width: SCREEN_WIDTH - 2*MARGIN, height: 0), configuration: configuration)
		webViewText.navigationDelegate = self
		webViewText.backgroundColor = .clear
        webViewText.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: MARGIN, right: 0)
		webViewText.scrollView.layer.masksToBounds = false
		webViewText.isOpaque = false
		webViewText.scrollView.isScrollEnabled = true
        webViewText.scrollView.bounces = false
        webViewText.scrollView.showsVerticalScrollIndicator = false
        webViewText.scrollView.showsHorizontalScrollIndicator = false
        if IS_IPAD {
            if SCREEN_WIDTH >= 650.0 && SCREEN_WIDTH <= 768.0 {
                videoPlayer = YTPlayerView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 0.5 * MARGIN, height: 350))
            }
            else if SCREEN_WIDTH >= 1024.0 {
                videoPlayer = YTPlayerView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 17.5 * MARGIN, height: 350))
            } else {
                videoPlayer = YTPlayerView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 0.5 * MARGIN, height: 350))
            }
        } else {
            videoPlayer = YTPlayerView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 300))
        }
        
        blockHeadVideo = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 60))
        if IS_IPAD {
            detailTextView = CustomTextView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 3 * MARGIN, height: 0))
        } else{
            detailTextView = CustomTextView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 1 * MARGIN, height: 0))
        }
        detailTextView.delegate = self
        detailTextView.backgroundColor = .brandcolor1
        detailTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: MARGIN, right: 0)
        setDataTool(titleText, detail: detail, video: video)
        if IS_IPAD {
            blockFooterVideo = UIView(frame: CGRect(x: 0, y: 135, width: SCREEN_WIDTH, height: 100))
            blockFooterVideo.addTarget(self, selector: #selector(playVideoYoutube))
            addSubview(scrollView)
            scrollView.addsubviews([detailTextView, webViewText, videoPlayer, blockHeadVideo,blockFooterVideo])
        } else {
            blockFooterVideo = UIView(frame: CGRect(x: 0, y: 230, width: SCREEN_WIDTH, height: 45))
            blockFooterVideo.addTarget(self, selector: #selector(playVideoYoutube))
            addSubview(scrollView)
            scrollView.addsubviews([detailTextView, webViewText, videoPlayer, blockHeadVideo,blockFooterVideo])
        }
        
		dropShadow(color: .brandcolor1, opacity: 0.3, offSet: CGSize(width: 0, height: -3), radius: 6)
		
		let pan = UIPanGestureRecognizer(target: self, action: #selector(dragtool(_:)))
		addGestureRecognizer(pan)
		let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
		addGestureRecognizer(tap)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func closeTool() {
        videoPlayer.pauseVideo()
		animationOut()
	}
	
    func setDataTool(_ title: String = "บทความ", detail: String, video: String? = nil) {
		detailText = detail.removeHtmlTagWithP()
		titleTool.text = title
        if title == "เฉลยละเอียด" {
            if Validation.mathMLDetect(detailText)  {
				webViewText.show()
                webViewText.frame.origin.y = 300
				detailTextView.hide()
                webViewText.setSolutionText(detailText)
			} else {
				webViewText.hide()
				detailTextView.show()
                detailTextView.setTextAndAttribute(detailText)
			}
			scrollView.contentSize = scrollView.scrollViewContentFitToSubview()
			UIView.animate(withDuration: 0.5, animations: {
				self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
			})
			if superview != nil {
				if frame.origin.y >= superview!.frame.origin.y*0.5 {
					updateLayout()
					animationIn()
				}
			}
        } else {
            webViewText.show()
            webViewText.frame.origin.y = 0
            detailTextView.hide()
            videoPlayer.hide()
            webViewText.setQuestionText(detailText)
            scrollView.contentSize = scrollView.scrollViewContentFitToSubview()
            UIView.animate(withDuration: 0.5, animations: {
                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            })
            if superview != nil {
                if frame.origin.y >= superview!.frame.origin.y*0.5 {
                    updateLayout()
                    animationIn()
                }
            }
        }
        
        if let videoLink = video {
            if videoLink != "" {
                
                let playerVars: [String: Any] = [
                    "playsinline": 0,
                    "controls": 1,
                    "origin": "https://www.youtube.com", // This validates the request
                    "modestbranding": 1
                ]
//                let videoURL = NSURL(string: videoLink)
                let parts = videoLink.components(separatedBy: "https://youtu.be/")
                videoPlayer.load(withVideoId: parts[1], playerVars: playerVars)
                videoPlayer.playVideo()
                detailTextView.frame.origin.y = 300
            } else {
                videoPlayer.hide()
                detailTextView.frame.origin.y = 0
                webViewText.frame.origin.y = 0
            }
        }
	}
    
    @objc func playVideoYoutube() {
        if isPlayed {
            videoPlayer.pauseVideo()
            isPlayed = false
        }else{
            videoPlayer.playVideo()
            isPlayed = true
        }
    }
    
    func playerView(_ playerView: YTPlayerView, didFailWithError error: YTPlayerError) {
        print("YouTube Player Error: \(error)")
    }
	
	func updateLayout() {
		let superview = self.superview
		if superview != nil {
			superviewFrame = superview!.frame
			frame = CGRect(x: 0, y: superviewFrame.size.height, width: superviewFrame.size.width, height: superviewFrame.size.height)
        }
	}
	func animationIn() {
		if frame.origin.y >= superviewFrame.size.height {
			topPosition = superviewFrame.size.height*0.5
			lastPosition = topPosition
			self.isHidden = false
			UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
				self.frame = CGRect(x: self.frame.origin.x, y: self.topPosition*1.1, width: self.superviewFrame.size.width, height: self.superviewFrame.size.height)
			}, completion: { (finished) in
				UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
					self.frame = CGRect(x: self.frame.origin.x, y: self.topPosition*0.9, width: self.frame.size.width, height: self.frame.size.height)
				}, completion: { (finished) in
					UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
						self.frame = CGRect(x: self.frame.origin.x, y: self.topPosition, width: self.frame.size.width, height: self.frame.size.height)
					}, completion: { (finished) in
						self.scrollView.frame = CGRect(x: 0, y: self.scrollView.frame.origin.y, width: self.scrollView.frame.width, height: self.frame.height - self.frame.origin.y - 40)
						self.scrollView.contentSize = self.scrollView.scrollViewContentFitToSubview()
						self.lastPosition = self.frame.origin.y
					})
				})
			})
		}
	}
	
	func animationOut() {
		let currentPosition = frame.origin.y
		let topPosition = superviewFrame.size.height
		
		UIView.animate(withDuration: 0.25, animations: {
			self.frame = CGRect(x: self.frame.origin.x, y: currentPosition*0.9, width: self.frame.size.width, height: self.frame.size.height)
		}) { (finish) in
			if finish {
				UIView.animate(withDuration: 0.25, animations: {
					self.frame = CGRect(x: self.frame.origin.x, y: topPosition, width: self.frame.size.width, height: self.frame.size.height)
				}, completion: { (fin) in
					if fin {
						self.isHidden = true
					}
				})
			}
		}
	}
	
	@objc fileprivate func tap(_ sender: UITapGestureRecognizer) {
		animationIn()
	}
	
	@objc fileprivate func dragtool(_ sender: UIPanGestureRecognizer) {
		let dragPosition = sender.translation(in: sender.view!).y
		let newPosition = lastPosition + dragPosition
		let height = frame.size.height - frame.origin.y - 40
		if newPosition >= round(frame.size.height*0.15) && newPosition <= frame.size.height - BOTTOM_BAR {
			frame = CGRect(x: frame.origin.x, y: newPosition, width: frame.size.width, height: frame.height)
			scrollView.frame = CGRect(x: scrollView.frame.origin.x, y: scrollView.frame.origin.y, width: scrollView.frame.width, height: height)
			scrollView.contentSize = scrollView.scrollViewContentFitToSubview()
		}
		
		if sender.state == .ended {
			lastPosition = frame.origin.y
			
			let velocityX = sender.velocity(in: self).y
			if velocityX > 0 && velocityX > 1000 {
				minSizeAnimationOut()
			}
		}
	}
	
	fileprivate func minSizeAnimationOut() {
		let topPosition = superviewFrame.size.height - BOTTOM_BAR
		UIView.animate(withDuration: 0.25, animations: {
			self.frame = CGRect(x: self.frame.origin.x, y: topPosition, width: self.frame.size.width, height: self.frame.size.height)
		}) { (finished) in
			self.lastPosition = self.frame.origin.y
			self.isHidden = false
		}
	}
    
    // Enable Horizontal scrolling and disable Vertical scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0  ||  scrollView.contentOffset.y < 0{
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y:0)
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
	}
}
