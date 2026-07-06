//
//  IntroView.swift
//  ratchakan
//
//  Created by JJsobtid on 28/3/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class IntroView: UIViewController {

	var imageUrl, titleString, detailString: String!
	
	var imageView: UIImageView!
	var titleLabel, detailLabel: UILabel!
	
	convenience init(parameter: dictStringAny) {
		
		self.init(nibName: nil, bundle: nil)
		
		titleString = Validation.anyIsString(parameter, with: "title")
		detailString = Validation.anyIsString(parameter, with: "detail")
		imageUrl = Validation.anyIsString(parameter, with: "image")
		
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

		imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.af_setImage(withURL: URL(string: imageUrl)!)
		titleLabel = UILabel()
		titleLabel.setParameter(font: .kanitReg18, color: .Celllabel, alignment: .center)
		titleLabel.flexibleLine()
		titleLabel.text = titleString
		
		detailLabel = UILabel()
		detailLabel.setParameter(font: .kanitLight14, color: .guestcolor, alignment: .center)
		detailLabel.flexibleLine()
		detailLabel.text = detailString
		
		view.addsubviews([imageView, titleLabel, detailLabel])
		imageView.snp.makeConstraints { (make) in
			make.width.equalTo(280)
			make.height.equalTo(250)
			make.centerX.equalTo(view.snp.centerX)
			make.bottom.equalTo(view.snp.centerY)
		}
		
		titleLabel.snp.makeConstraints { (make) in
			make.leading.equalTo(view.snp.leading).offset(2*MARGIN)
			make.trailing.equalTo(view.snp.trailing).offset(-2*MARGIN)
			make.top.equalTo(imageView.snp.bottom).offset(35)
		}
		
		detailLabel.snp.makeConstraints { (make) in
			make.leading.equalTo(view.snp.leading).offset(2*MARGIN)
			make.trailing.equalTo(view.snp.trailing).offset(-2*MARGIN)
			make.top.equalTo(titleLabel.snp.bottom).offset(MARGIN)
		}
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
