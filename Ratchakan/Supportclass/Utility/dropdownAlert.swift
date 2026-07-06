//
//  dropdownAlert.swift
//  ratchakan
//
//  Created by JJsobtid on 20/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit

class dropdownAlert: UIButton {

	let HEIGHT = 70 + STATUSBAR
	let ANIMATION_TIME = 0.3
	let TIME = 3.0
	let X_BUFFER: CGFloat = 10
	let Y_BUFFER: CGFloat = 10
	
	let defaultViewColor = UIColor.errorRed
	let defaultTextColor = UIColor.white
	
	var titleText: UILabel!
	var messageText: UILabel!
	var closeButton: UIButton!
	var isShowing: Bool?
	
	func alertView() -> dropdownAlert {
		return dropdownAlert(frame: CGRect(x: 0, y: -HEIGHT, width: SCREEN_WIDTH, height: HEIGHT))
	}
	func alertView(withAction action: Selector, target: Any) -> dropdownAlert {
		return dropdownAlert(frame: CGRect(x: 0, y: -HEIGHT, width: SCREEN_WIDTH, height: HEIGHT), action: action, target: target)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = defaultViewColor
		
		titleText = UILabel(frame: CGRect(x: X_BUFFER, y: STATUSBAR, width: frame.size.width - 2*X_BUFFER, height: 30))
		titleText?.font = UIFont.kanitReg16
		titleText?.textAlignment = .center
		titleText?.textColor = defaultTextColor
		addSubview(titleText)
		
		messageText = UILabel(frame: CGRect(x: X_BUFFER, y: STATUSBAR + Y_BUFFER*2.4, width: frame.size.width - 2*X_BUFFER, height: 40))
		messageText.font = UIFont.kanitLight14
		messageText.textColor = defaultTextColor
		messageText.lineBreakMode = .byWordWrapping
		messageText.numberOfLines = 2
		messageText.textAlignment = .center
		addSubview(messageText)
		
		addTarget(self, action: #selector(hideView(_:)), for: .touchUpInside)
		
		isShowing = false
	}
	convenience init(frame: CGRect, action: Selector, target: Any) {
		self.init(frame: frame)
		
		closeButton = UIButton(type: .custom)
		closeButton.frame = CGRect(x: frame.size.width - 40, y: STATUSBAR + 25, width: 20, height: 20)
		closeButton.withImageColor("closeIcon")
		addSubview(closeButton)
		
		addTarget(target, action: action, for: .touchUpInside)
		closeButton.addTarget(self, action: #selector(removeViewFromCloseButton), for: .touchUpInside)

	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func removeViewFromCloseButton() {
		UIView.animate(withDuration: ANIMATION_TIME, animations: {
			var frame = self.frame
            if IS_IPAD {
                if SCREEN_WIDTH >= 650.0 && SCREEN_WIDTH <= 768.0 {
                    print("Test IPAD PRO 9.7")
                    frame.origin.y = self.messageText.text == "กรุณาลองใหม่อีกครั้ง" ? -self.HEIGHT :  830
               }
               else if SCREEN_WIDTH >= 1024.0 {
                   debugPrint("Test IPAD PRO 12.9 gen 5")
                   frame.origin.y = self.messageText.text == "กรุณาลองใหม่อีกครั้ง" ? -self.HEIGHT :  1080
               } else {
                   print("Test IPAD PRO gen3 11.0")
                   frame.origin.y = self.messageText.text == "กรุณาลองใหม่อีกครั้ง" ? -self.HEIGHT :  950
               }
            }else{
                frame.origin.y = self.messageText.text == "กรุณาลองใหม่อีกครั้ง" ? -self.HEIGHT : (IS_IPHONE_6 ? 540 : (IS_IPHONE_6P ? 600 : 700))
            }
			self.frame = frame
		}) { (finished) in
			self.removeFromSuperview()
			self.isShowing = false
		}
	}
	
	@objc func hideView(_ alertView: UIButton?) {
		if alertView != nil {
			UIView.animate(withDuration: ANIMATION_TIME, animations: {
				var frame = alertView!.frame
                if IS_IPAD {
                    if SCREEN_WIDTH >= 650.0 && SCREEN_WIDTH <= 768.0 {
                        print("Test IPAD PRO 9.7")
                        frame.origin.y = self.messageText.text == "กรุณาลองใหม่อีกครั้ง" ? -self.HEIGHT :  830
                   }
                   else if SCREEN_WIDTH >= 1024.0 {
                       debugPrint("Test IPAD PRO 12.9 gen 5")
                       frame.origin.y = self.messageText.text == "กรุณาลองใหม่อีกครั้ง" ? -self.HEIGHT :  1080
                   } else {
                       print("Test IPAD PRO gen3 11.0")
                       frame.origin.y = self.messageText.text == "กรุณาลองใหม่อีกครั้ง" ? -self.HEIGHT :  950
                   }
                }else{
                    frame.origin.y = self.messageText.text == "กรุณาลองใหม่อีกครั้ง" ? -self.HEIGHT : (IS_IPHONE_6 ? 540 : (IS_IPHONE_6P ? 600 : 700))
                }
				alertView!.frame = frame
			})
			self.perform(#selector(removeView(_:)), with: alertView, afterDelay: ANIMATION_TIME)
		}
	}
	@objc func removeView(_ alertView: UIButton?) {
		if alertView != nil {
			alertView!.removeFromSuperview()
			isShowing = false
		}
	}
	@objc func viewWasTapped(_ alertView: UIButton) {
		hideView(alertView)
	}
	
	func title(_ title: String, message: String, backgroundColor: UIColor, textColor: UIColor, seconds: Int) {
		var time: Double = Double(seconds)
        if message == "กรุณาเลือกปัญหาที่ต้องการรายงาน" || message == "กรุณาอธิบายปัญหาที่เกิดขึ้น" {
            titleText.text = message
            self.backgroundColor = backgroundColor
            self.cornerView(radius: 8.0)
            if let button = closeButton {
                button.imageView?.tintColor = textColor
            }
            
            if !message.isEmpty && message != "" {
                var frame = titleText.frame
                frame.origin.y =  0
                if IS_IPAD {
                    if SCREEN_WIDTH >= 650.0 && SCREEN_WIDTH <= 768.0 {
                        print("Test IPAD PRO 9.7")
                        frame.origin.x = -250
                   }
                   else if SCREEN_WIDTH >= 1024.0 {
                       debugPrint("Test IPAD PRO 12.9 gen 5")
                       frame.origin.x = -380
                   } else {
                       print("Test IPAD PRO gen3 11.0")
                       frame.origin.x = -280
                   }
                }else{
                    frame.origin.x = (IS_IPHONE_6 ? -55 : (IS_IPHONE_6P ? -75 : (IS_IPHONE_X ? -60 : -85)))
                }
                titleText.frame = frame
            } else {
                var frame = titleText.frame
                frame.size.height = HEIGHT-2*Y_BUFFER-STATUSBAR
                frame.origin.y = Y_BUFFER+STATUSBAR
                titleText.frame = frame
            }
            
            if seconds == -1 {
                time = TIME
            }

            Utility.getCurrentViewController().view.addSubview(self)
            
            isShowing = true
            
            UIView.animate(withDuration: ANIMATION_TIME) {
                var frame = self.frame
                if IS_IPAD {
                    if SCREEN_WIDTH >= 650.0 && SCREEN_WIDTH <= 768.0 {
                        print("Test IPAD PRO 9.7")
                        frame.origin.x = 260
                        frame.origin.y = 830
                        frame.size.width = 250
                        frame.size.height = 30
                   }
                   else if SCREEN_WIDTH >= 1024.0 {
                       debugPrint("Test IPAD PRO 12.9 gen 5")
                       frame.origin.x = 400
                       frame.origin.y = 1080
                       frame.size.width = 250
                       frame.size.height = 30
                   } else {
                       print("Test IPAD PRO gen3 11.0")
                       frame.origin.x = 300
                       frame.origin.y = 950
                       frame.size.width = 250
                       frame.size.height = 30
                   }
                }else{
                    frame.origin.x = (IS_IPHONE_6 ? 80 : (IS_IPHONE_X ? 80 : 100))
                    frame.origin.y = (IS_IPHONE_6 ? 540 : (IS_IPHONE_6P ? 600 : 700))
                    frame.size.width = 240
                    frame.size.height = 27
                }
                self.frame = frame
            }
        }else{
            titleText.text = title
            self.backgroundColor = backgroundColor
            if let button = closeButton {
                button.imageView?.tintColor = textColor
            }
            
            if !message.isEmpty && message != "" {
                messageText.text = message
                
                if messageTextIsOneLine() {
                var frame = titleText.frame
                frame.origin.y = STATUSBAR+5
                frame.origin.x = IS_IPAD ? -5 : 5
                titleText.frame = frame
                }
                
                var frame_message = messageText.frame
                frame_message.origin.x = IS_IPAD ? -7 : 3
                messageText.frame = frame_message
                
            } else {
                var frame = titleText.frame
                frame.size.height = HEIGHT-2*Y_BUFFER-STATUSBAR
                frame.origin.y = Y_BUFFER+STATUSBAR
                titleText.frame = frame
            }
            
            if seconds == -1 {
                time = TIME
            }
        
            Utility.getCurrentViewController().view.addSubview(self)
            
            isShowing = true
            
            UIView.animate(withDuration: ANIMATION_TIME) {
                var frame = self.frame
                frame.origin.y = 0
                self.frame = frame
            }
        }
		
		self.perform(#selector(viewWasTapped(_ :)), with: self, afterDelay: time+ANIMATION_TIME)
	}
	
	static func title(_ title: String, message: String, backgroundColor: UIColor = .errorRed, textColor: UIColor) {
		dropdownAlert().alertView().title(title, message: message, backgroundColor: backgroundColor, textColor: textColor, seconds: -1)
	}
	static func title(_ title: String, message: String, backgroundColor: UIColor = .errorRed, textColor: UIColor, action: Selector, target: Any, time: Double = 5.0) {
		dropdownAlert().alertView(withAction: action, target: target).title(title, message: message, backgroundColor: backgroundColor, textColor: textColor, seconds: Int(time))
	}
	static func errorNTryAgain() {
		dropdownAlert.title(string.th_error, message: string.th_try_again, backgroundColor: .errorRed, textColor: .white)
	}
	
	fileprivate func messageTextIsOneLine() -> Bool {
        let size = messageText.text?.size(withAttributes: [NSAttributedString.Key.font : UIFont.kanitLight14])

		if (size?.width)! > messageText.frame.size.width {
			return false
		}
		
		return true
	}
}
