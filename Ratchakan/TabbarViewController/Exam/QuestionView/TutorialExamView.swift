//
//  TutorialExamView.swift
//  ratchakan
//
//  Created by JJsobtid on 5/6/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class TutorialExamView: UIView {

	var view: UIView
	var articleImageView, upArrowImageView, drowArrowImageView, handLeftImageView, handRightImageView: UIImageView!
	var readArticleLabel, questionListLabel: UILabel!
	
	init(withView view: UIView) {
		self.view = view
		super.init(frame: view.frame)
		backgroundColor = .blackalpha
		
		articleImageView = UIImageView(image: UIImage(named: "articleIcon"))
		articleImageView.contentMode = .scaleAspectFill
		articleImageView.alpha = 0
		upArrowImageView = UIImageView(image: UIImage(named: "arrowUp"))
		upArrowImageView.contentMode = .scaleAspectFit
		upArrowImageView.alpha = 0
		drowArrowImageView = UIImageView(image: UIImage(named: "arrowDown"))
		drowArrowImageView.contentMode = .scaleAspectFit
		drowArrowImageView.alpha = 0
		
		readArticleLabel = UILabel()
		readArticleLabel.setParameter(font: .kanitLight24, color: .white)
		readArticleLabel.text = "กดดูบทความ"
		readArticleLabel.alpha = 0
		questionListLabel = UILabel()
		questionListLabel.setParameter(font: .kanitLight24, color: .white)
		questionListLabel.text = "รายการคำถาม"
		questionListLabel.alpha = 0
		
		handLeftImageView = UIImageView(image: UIImage(named: "strokeLeft"))
		handLeftImageView.contentMode = .scaleAspectFit
		handLeftImageView.alpha = 0
		handRightImageView = UIImageView(image: UIImage(named: "strokeRight"))
		handRightImageView.contentMode = .scaleAspectFit
		handRightImageView.alpha = 0
		
		addTarget(self, selector: #selector(hideTutorial))
		addsubviews([articleImageView, upArrowImageView, readArticleLabel, drowArrowImageView, questionListLabel, handLeftImageView, handRightImageView])
		view.addSubview(self)
		
		setConstraints()
	}
	
	@objc func hideTutorial() {
		UIView.animate(withDuration: 0.5, animations: {
			self.alpha = 0
		}) { (finished) in
			self.removeFromSuperview()
		}
	}
	func showTutorial() {
		handLeftImageView.snp.remakeConstraints { (make) in
			make.leading.equalTo(snp.leading).offset(2*MARGIN)
			make.centerY.equalTo(snp.centerY)
			make.size.equalTo(CGSize(width: 100, height: 117))
		}
		handRightImageView.snp.remakeConstraints { (make) in
			make.trailing.equalTo(snp.trailing).offset(-2*MARGIN)
			make.centerY.equalTo(snp.centerY)
			make.size.equalTo(CGSize(width: 100, height: 117))
		}
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIView.AnimationOptions(rawValue: 0), animations: {
			self.layoutIfNeeded()
			self.articleImageView.alpha = 1
			self.upArrowImageView.alpha = 1
			self.drowArrowImageView.alpha = 1
			self.readArticleLabel.alpha = 1
			self.questionListLabel.alpha = 1
			self.handLeftImageView.alpha = 1
			self.handRightImageView.alpha = 1
		}) { (finished) in
			
		}
	}
	
	func setConstraints() {
		snp.remakeConstraints { (make) in
			make.edges.equalTo(view.snp.edges)
		}
		handLeftImageView.snp.remakeConstraints { (make) in
			make.center.equalTo(snp.center)
			make.size.equalTo(CGSize(width: 100, height: 117))
		}
		handRightImageView.snp.remakeConstraints { (make) in
			make.center.equalTo(snp.center)
			make.size.equalTo(CGSize(width: 100, height: 117))
		}
		drowArrowImageView.snp.remakeConstraints { (make) in
			make.leading.equalTo(snp.leading).offset(14)
			make.bottom.equalTo(snp.bottom).offset(-BOTTOM_BAR)
			make.size.equalTo(CGSize(width: 75, height: 75))
		}
		questionListLabel.snp.remakeConstraints { (make) in
			make.bottom.equalTo(drowArrowImageView.snp.top)
			make.leading.equalTo(drowArrowImageView.snp.trailing)
			make.trailing.equalTo(snp.trailing)
		}
		upArrowImageView.snp.remakeConstraints { (make) in
			make.top.equalTo(snp.top).offset(STATUSBAR+120)
			make.leading.equalTo(snp.leading).offset(48)
			make.size.equalTo(CGSize(width: 75, height: 75))
		}
		articleImageView.snp.remakeConstraints { (make) in
			make.size.equalTo(CGSize(width: 100, height: 45))
			make.leading.equalTo(snp.leading).offset(24)
			make.bottom.equalTo(upArrowImageView.snp.top)
		}
		readArticleLabel.snp.remakeConstraints { (make) in
			make.top.equalTo(upArrowImageView.snp.bottom)
			make.leading.equalTo(upArrowImageView.snp.trailing)
			make.trailing.equalTo(snp.trailing)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
