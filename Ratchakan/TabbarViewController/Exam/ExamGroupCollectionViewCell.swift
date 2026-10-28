//
//  ExamSubjectCollectionViewCell.swift
//  ratchakan
//
//  Created by JJsobtid on 5/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import AlamofireImage

class ExamGroupCollectionViewCell: UICollectionViewCell {
	
	var bgView: UIView!
	var subjectImage: UIImageView!
	var subjectTitle: UILabel!
	var subjectDetail: UILabel!
	var accessoryImage: UIImageView!
	
	var examData: [String: Any] = [:]
	var groupId: String!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		dropShadow(color: .brandcoloralpha, opacity: 1, offSet: CGSize(width: 0, height: 5), radius: 10.0)
		
		bgView = UIView(frame: CGRect(origin: CGPoint(), size: frame.size))
		bgView.backgroundColor = .white
		bgView.cornerView(radius: 10.0)
		
		subjectImage = UIImageView()
		subjectImage.contentMode = .scaleAspectFit
		subjectImage.image = UIImage(named: "AppIcon")
		
		subjectTitle = UILabel()
		subjectTitle.setParameter(font: .kanitReg16, color: .Celllabel)
		subjectTitle.text = "แนวข้อสอบ"
		
		subjectDetail = UILabel()
		subjectDetail.setParameter(font: .kanitReg12, color: .guestcolor)
		subjectDetail.numberOfLines = 2
		subjectDetail.text = ( arc4random()%2 == 0 ? "2 บรรทัด ลองพิมพ์อะไรยาว ๆ ให้มันเกินบรรทัดที่กำหนดดูว่าจะเป็นอย่างไร ไหนลงทดสอบสิ รันโปรแกรม" : "รายละเอียด")
		
		accessoryImage = UIImageView()
		accessoryImage.image = UIImage(named: "chevronIcon")
		accessoryImage.contentMode = .scaleAspectFit
		
		contentView.addSubview(bgView)
		contentView.addSubview(subjectImage)
		contentView.addSubview(accessoryImage)
		contentView.addSubview(subjectTitle)
		contentView.addSubview(subjectDetail)
		
		setLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    func setCellData(_ data: [String: Any]) {
        let statusSale = Validation.dictionary(data as [String : AnyObject],with: "status")
        if statusSale == true {
            subjectImage.af_setImage(withURL: URL(string: Validation.anyIsString(data, with: "coverImage"))!, placeholderImage: UIImage(named: "AppIcon"))
            
            if Validation.dictionary(data as [String : AnyObject], with: "name") {
                subjectTitle.text = data["name"] as? String
            }
            if Validation.dictionary(data as [String : AnyObject], with: "description") {
                subjectDetail.text = data["description"] as? String
            }
            if Validation.dictionary(data as [String : AnyObject], with: "examGroupId") {
                groupId = data["examGroupId"] as? String ?? ""
            }
        }
    }
	
	fileprivate func setLayout() {
		bgView.snp.remakeConstraints { (make) in
			make.edges.equalTo(contentView.snp.edges)
		}
		
		subjectImage.snp.remakeConstraints { (make) in
			make.width.equalTo(38)
			make.height.equalTo(38)
			make.centerY.equalTo(contentView.snp.centerY)
			make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
		}

		accessoryImage.snp.remakeConstraints { (make) in
			make.width.equalTo(6.6)
			make.height.equalTo(11)
			make.centerY.equalTo(contentView.snp.centerY)
			make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
		}
		
		subjectTitle.snp.remakeConstraints { (make) in
			make.height.equalTo(24)
			make.leading.equalTo(subjectImage.snp.trailing).offset(MARGIN)
			make.trailing.equalTo(accessoryImage.snp.leading).offset(-MARGIN)
			make.top.equalTo(MARGIN)
		}
		
		subjectDetail.snp.remakeConstraints { (make) in
			make.top.equalTo(subjectTitle.snp.bottom).offset(4)
			make.leading.equalTo(subjectTitle.snp.leading)
			make.trailing.equalTo(subjectTitle.snp.trailing)
		}
		
		subjectDetail.sizeToFit()
	}
}

class ExamCollectionViewCell: UICollectionViewCell {
	
	static let cellIdentifier: String = "ExamCollectionViewCell"
	
	var bgView: UIView!
	var subjectTitle: UILabel!
	var subjectDetail: UILabel!
	var accessoryImage, tagFreeImageView: UIImageView!
	
	var examData: [String: Any] = [:]
	var groupId: String!
	
	var isTouched: Bool = false {
		didSet {
			var transform = CGAffineTransform.identity
			if isTouched { transform = transform.scaledBy(x: 0.96, y: 0.96) }
			UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
				self.transform = transform
			}, completion: nil)
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		let width: CGFloat = (SCREEN_WIDTH) - 2*MARGIN
		
		contentView.snp.makeConstraints { (make) in
			make.width.equalTo(width)
		}
		contentView.translatesAutoresizingMaskIntoConstraints = false
		
		bgView = UIView(frame: CGRect(origin: CGPoint(), size: frame.size))
		bgView.backgroundColor = .white
		bgView.cornerView(radius: 10.0)
	
		subjectTitle = UILabel()
		subjectTitle.setParameter(font: .kanitReg16, color: .Celllabel)
		subjectTitle.flexibleLine()
		subjectTitle.text = "แนวข้อสอบ"
		
		subjectDetail = UILabel()
		subjectDetail.setParameter(font: .kanitLight14, color: .guestcolor)
		subjectDetail.flexibleLine()
		subjectDetail.text = ""
		
		accessoryImage = UIImageView()
		accessoryImage.image = UIImage(named: "chevronIcon")
		accessoryImage.contentMode = .scaleAspectFit
		
		tagFreeImageView = UIImageView(image: UIImage(named: "tagFreeIcon"))
		tagFreeImageView.contentMode = .scaleAspectFill
		tagFreeImageView.hide()
		
		contentView.addsubviews([bgView, tagFreeImageView, accessoryImage])
		bgView.addsubviews([subjectTitle, subjectDetail])
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		isTouched = true
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		isTouched = false
	}
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesCancelled(touches, with: event)
		isTouched = false
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setCellData(_ data: [String: Any], indexPath: IndexPath) {
		examData = data
		if let subjectTitleStr = data["name"] as? String {
			subjectTitle.text = subjectTitleStr
		}
		if Validation.dictionary(data as [String : AnyObject], with: "description") {
			subjectDetail.text = data["description"] as? String ?? ""
		}
		if Validation.dictionary(data as [String : AnyObject], with: "examGroupId") {
			groupId = data["examGroupId"] as? String ?? ""
		}
		for tag in Validation.anyIsArrayString(data, with: "tags") {
			if subjectDetail.text == "" {
				subjectDetail.text = tag
			} else {
				subjectDetail.text = subjectDetail.text! + ", \(tag)"
			}
		}
		if Validation.anyIsBool(data, with: "free") {
			tagFreeImageView.show()
		}
		setLayout()
	}
	func setCell(withExam exam: Exams, indexPath: IndexPath) {
		subjectTitle.text = exam.name
		subjectDetail.text = exam.description
		groupId = exam.examGroupId
        let tags = exam.tags ?? []
		for tag in tags {
			if subjectDetail.text == "" {
				subjectDetail.text = tag
			} else {
				subjectDetail.text = subjectDetail.text! + ", \(tag)"
			}
		}
        if exam.free ?? false  {
			tagFreeImageView.show()
		}
		setLayout()
	}
	
	fileprivate func setLayout() {
		bgView.snp.remakeConstraints { (make) in
			make.edges.equalTo(contentView.snp.edges)
		}
		tagFreeImageView.snp.remakeConstraints { (make) in
			make.top.equalTo(contentView.snp.top).offset(-6)
			make.trailing.equalTo(contentView.snp.trailing).offset(4)
			make.size.equalTo(CGSize(width: 54, height: 54))
		}
		accessoryImage.snp.remakeConstraints { (make) in
			make.width.equalTo(6.6)
			make.height.equalTo(11)
			make.centerY.equalTo(bgView.snp.centerY)
			make.trailing.equalTo(bgView.snp.trailing).offset(-MARGIN)
		}
		subjectTitle.snp.remakeConstraints { (make) in
			make.leading.equalTo(bgView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(accessoryImage.snp.leading).offset(-MARGIN)
			make.top.equalTo(bgView.snp.top).offset(MARGIN)
		}
		
		subjectDetail.snp.remakeConstraints { (make) in
			make.top.equalTo(subjectTitle.snp.bottom).offset(2)
			make.leading.equalTo(subjectTitle.snp.leading)
			make.trailing.equalTo(subjectTitle.snp.trailing)
			make.bottom.equalTo(bgView.snp.bottom).offset(-MARGIN)
		}
		
		contentView.layoutIfNeeded()
		contentView.dropShadow(color: .brandcoloralpha, opacity: 1, offSet: CGSize(width: 0, height: 8), radius: 10.0)
	
	}
}
