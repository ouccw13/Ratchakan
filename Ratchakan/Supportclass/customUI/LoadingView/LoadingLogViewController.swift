//
//  LoadingLogViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 11/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import Lottie

class LoadingLogViewController: UIViewController {

	var resultLoadingView: CircleView!
	var detailLabel: UILabel!
	var phoneNum: String?
	let loadingAnimation = LottieAnimationView(name: "loading")
	var resultText: String!
	
	var result: Bool? {
		didSet {
			if result! {
				typeMark = .correct
			} else {
				typeMark = .error
			}
			finishedLoading()
		}
	}
	var resultLoading: [String: Any]?
	var typeMark: CheckmarkType?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .brandcolor1
		
		loadingAnimation.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
		loadingAnimation.contentMode = .scaleAspectFit
		loadingAnimation.center = CGPoint(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT/2)
		view.addSubview(loadingAnimation)
		loadingAnimation.loopMode = .loop
		loadingAnimation.play()
		detailLabel = UILabel()
		detailLabel.setParameter(font: .kanitReg16, color: .white, alignment: .center)
		detailLabel.text = "กำลังดำเนินการ"
		detailLabel.flexibleLine()
		view.addSubview(detailLabel)
		detailLabel.snp.makeConstraints { (make) in
			make.top.equalTo(view.snp.centerY).offset(70)
			make.leading.equalTo(view.snp.leading).offset(MARGIN)
			make.trailing.equalTo(view.snp.trailing).offset(-MARGIN)
		}
		pushView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func pushView() {

		
	}
	
	func finishedLoading() {
		self.detailLabel.text = self.resultText
		self.loadingAnimation.stop()
		self.loadingAnimation.hide()
		self.resultLoadingView = CircleView(withColor: .white, type: typeMark!, frame: CGRect(x: 0, y: 0, width: 60, height: 60))
		self.view.addSubview(resultLoadingView)
		self.resultLoadingView.snp.makeConstraints { (make) in
			make.center.equalTo(view.snp.center)
			make.width.equalTo(60)
			make.height.equalTo(60)
		}
		self.resultLoadingView.alpha = 0.99
		self.resultLoadingView.animation()
			
		UIView.animate(withDuration: 1.75, animations: {
			self.resultLoadingView.alpha = 1.0
		}) { (finish) in
//			if finish {
				if self.typeMark == .correct {
					if let phone = self.phoneNum {
						let confirmPhone = ConfirmPhoneViewController()
						confirmPhone.beforeView = "signUp"
						confirmPhone.phoneNumber = phone.trimSpace()
						UIApplication.shared.delegate?.window!?.rootViewController?.dismiss(animated: true, completion: {
							Utility.getCurrentViewController().present(confirmPhone, animated: true, completion: nil)
						})
					} else {
						Utility.backToRootView({
							_ = PopUpStartExamView(withSuper: Utility.getCurrentViewController().view)
						})
//						Utility.backToRootView()
					}
				} else {
					self.dismiss(animated: true, completion: nil)
				}
//			}
		}
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
