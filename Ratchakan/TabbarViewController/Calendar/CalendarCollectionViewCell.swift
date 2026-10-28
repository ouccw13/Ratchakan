//
//  CalendarCollectionViewCell.swift
//  ratchakan
//
//  Created by JJsobtid on 13/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
//import AlamofireImage

class CalendarCollectionViewCell: UICollectionViewCell {

	var bgView: UIView!
	var calendarProfile: UIImageView!
	var calendarTitle: UILabel!
	var calendarDetail: UILabel!
	
	var calendarIcon: UIImageView!
	var dateLabel: UILabel!
	var countdownLabel: UILabel!
	var separateLine: UIView!
	
	var badgeLabel: UILabel!
	var accessoryImage: UIImageView!
	var positionLabel: UILabel!
	
	var height: CGFloat = 0
	
	var calendarData: [String: Any] = [:]
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		let col: CGFloat = (IS_IPAD ? 1 : 1)
		let width: CGFloat = (SCREEN_WIDTH/col) - (1/col+1)*MARGIN
		
		contentView.snp.makeConstraints { (make) in
			make.width.equalTo(width)
		}
		contentView.translatesAutoresizingMaskIntoConstraints = false
		
		bgView = UIView(frame: CGRect(origin: CGPoint(), size: frame.size))
		bgView.backgroundColor = .white
		bgView.cornerView(radius: 10.0)
		
		calendarProfile = UIImageView()
		calendarProfile.contentMode = .scaleAspectFit
		
		badgeLabel = UILabel()
		badgeLabel.setParameter(font: .kanitReg12, color: .white, alignment: .center)
		badgeLabel.backgroundColor = .brandcolor1
		badgeLabel.cornerView(radius: 21.0/2)
		badgeLabel.text = "20"
		
		calendarIcon = UIImageView(image: UIImage(named: "calIcon"))
		calendarIcon.contentMode = .scaleAspectFit
		
		calendarTitle = UILabel()
		calendarTitle.setParameter(font: .kanitReg14, color: .Celllabel)
		calendarTitle.flexibleLine()
		calendarTitle.text = ( arc4random()%2 == 0 ? "สำนักงานปลัดกระทรวงวัฒนธรรมกระทรวงกระทรวงกสาธารณสุข" : "รายสำนักงานปลัดกระทรวงวัฒนธรรม")
		
		calendarDetail = UILabel()
		calendarDetail.setParameter(font: .kanitReg12, color: .guestcolor)
		calendarDetail.flexibleLine()
		calendarDetail.text = ( arc4random()%2 == 0 ? "2 บรรทัด ลองพิมพ์อะไรยาว ๆ ให้มันเกินบรรทัดที่กำหนดดูว่าจะเป็นอย่างไร ไหนลงทดสอบสิ รันโปรแกรม" : "รายละเอียด")
		
		countdownLabel = UILabel()
		countdownLabel.setParameter(font: .kanitReg12, color: .Celllabel)
		countdownLabel.text = "เหลือ 000 วัน"//( arc4random()%2 == 0 ? "เหลือ \(Datetime().daysBetween(1618954079, fromDate: 1518867679)) วัน" : "เหลือ \(Datetime().daysBetween(1518965079)) วัน")
		countdownLabel.textAlignment = .right
		
		dateLabel = UILabel()
		dateLabel.setParameter(font: .kanitReg12, color: .brandcolor3_dark)
		dateLabel.flexibleLine()
		dateLabel.text = "1 ธ.ค. 60 - 31 มี.ค. 61"
		
		separateLine = UIView()
		separateLine.lineView(withColor: .separateLine)
		
		accessoryImage = UIImageView()
		accessoryImage.image = UIImage(named: "chevronIcon")
		accessoryImage.contentMode = .scaleAspectFit
		
		contentView.addSubview(bgView)
		
		bgView.snp.makeConstraints { (make) in
			make.edges.equalTo(contentView.snp.edges)
		}
		bgView.addsubviews([calendarProfile, calendarTitle, calendarDetail, separateLine, calendarIcon, dateLabel, countdownLabel, badgeLabel, accessoryImage])
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setData(_ data: dictStringAny, type: String) {
		calendarProfile.af_setImage(withURL: URL(string: Validation.anyIsString(Validation.anyIsDictionary(data, with: "bureau"), with: "image"))!, placeholderImage: UIImage(named: "logo"))
		calendarTitle.text = Validation.anyIsString(Validation.anyIsDictionary(data, with: "bureau"), with: "name")
		if type == "general" {
			Utility.show([calendarProfile, separateLine, calendarTitle, calendarDetail, calendarIcon, dateLabel, countdownLabel], hides: [badgeLabel, accessoryImage])
			calendarDetail.text = "\(Validation.anyIsNumber(data, with: "vacancyQty")) ตำแหน่ง \(Validation.anyIsNumber(data, with: "vacancyPositionQty")) อัตรา"//Validation.anyIsString(data, with: "detail").removeHtmlTag()
			dateLabel.text = Datetime().showDate(Validation.anyIsNumber(data, with: "dateFrom"), toDate: Validation.anyIsNumber(data, with: "dateTo"), shortDate: true)
			var dateCountString = string.th_today
			if Datetime().daysBetween(Validation.anyIsNumber(data, with: "dateFrom")) <= 0 {
//				if Datetime().daysBetween(Validation.anyIsNumber(data, with: "dateTo")) > 0 {
//					dateCountString = "\(string.th_today) - \(Datetime().showDate(Validation.anyIsNumber(data, with: "dateTo"), short: true, showTime: false))"
//				}
			} else {
				dateCountString = "จะถึงใน \(Datetime().daysBetween(Validation.anyIsNumber(data, with: "dateFrom"))) วัน"
			}
			countdownLabel.text = dateCountString
		} else if type == "bureau" {
			Utility.show([calendarProfile, badgeLabel, calendarTitle, accessoryImage], hides: [separateLine, calendarDetail, calendarIcon, dateLabel, countdownLabel])
			let count = Validation.anyIsNumber(data, with: "calendarQty") > 99 ? "99+" : "\(Validation.anyIsNumber(data, with: "calendarQty"))"
			badgeLabel.text = count
		} else {
			Utility.show([calendarProfile, separateLine, calendarTitle, calendarDetail, calendarIcon, dateLabel, countdownLabel], hides: [badgeLabel, accessoryImage])
			calendarDetail.text = Validation.anyIsString(Validation.anyIsDictionary(data, with: "type"), with: "typeName")
			dateLabel.text = Datetime().showDate(Validation.anyIsNumber(data, with: "dateFrom"), toDate: Validation.anyIsNumber(data, with: "dateTo"), shortDate: true)
			countdownLabel.text = Datetime().daysBetween(Validation.anyIsNumber(data, with: "dateFrom")) <= 0 ? string.th_today : "ถึงใน \(Datetime().daysBetween(Validation.anyIsNumber(data, with: "dateFrom"))) วัน"
		}
		setLayout(type)
	}
	fileprivate func setLayout(_ type: String) {
		
		if type == "bureau" {
			calendarProfile.snp.remakeConstraints({ (make) in
				make.width.equalTo(60)
				make.height.equalTo(60)
				make.top.equalTo(bgView.snp.top).offset(13)
				make.leading.equalTo(bgView.snp.leading).offset(13)
				make.bottom.equalTo(bgView.snp.bottom).offset(-13)
			})
			accessoryImage.snp.remakeConstraints({ (make) in
				make.size.equalTo(CGSize(width: 6.6, height: 11))
				make.centerY.equalTo(bgView.snp.centerY)
				make.trailing.equalTo(bgView.snp.trailing).offset(-MARGIN)
			})
			calendarTitle.snp.remakeConstraints({ (make) in
				make.leading.equalTo(calendarProfile.snp.trailing).offset(MARGIN)
				make.trailing.equalTo(accessoryImage.snp.leading).offset(-MARGIN)
				make.centerY.equalTo(calendarProfile.snp.centerY)
			})
			badgeLabel.snp.remakeConstraints({ (make) in
				make.size.equalTo(CGSize(width: 21, height: 21))
				make.top.equalTo(calendarProfile.snp.top).offset(-3)
				make.trailing.equalTo(calendarProfile.snp.trailing).offset(3)
			})
		} else {
			calendarProfile.snp.remakeConstraints({ (make) in
				make.size.equalTo(CGSize(width: 40, height: 40))
				make.centerY.equalTo(bgView.snp.centerY)
				make.leading.equalTo(bgView.snp.leading).offset(MARGIN)
			})
			separateLine.snp.remakeConstraints({ (make) in
				make.width.equalTo(SEPARATE_LINE_WIDHT)
				make.top.equalTo(bgView.snp.top).offset(MARGIN)
				make.bottom.equalTo(bgView.snp.bottom).offset(-MARGIN)
				make.leading.equalTo(calendarProfile.snp.trailing).offset(MARGIN)
			})
			calendarTitle.snp.remakeConstraints({ (make) in
				make.top.equalTo(bgView.snp.top).offset(MARGIN)
				make.leading.equalTo(separateLine.snp.trailing).offset(MARGIN)
				make.trailing.equalTo(bgView.snp.trailing).offset(-MARGIN)
			})
			calendarDetail.snp.remakeConstraints({ (make) in
				make.leading.equalTo(calendarTitle.snp.leading)
				make.trailing.equalTo(calendarTitle.snp.trailing)
				make.top.equalTo(calendarTitle.snp.bottom).offset(1)
				make.bottom.equalTo(calendarIcon.snp.top).offset(-12)
			})
			calendarIcon.snp.remakeConstraints({ (make) in
				make.size.equalTo(CGSize(width: 17, height: 16))
				make.leading.equalTo(calendarTitle.snp.leading)
				make.bottom.equalTo(bgView.snp.bottom).offset(-MARGIN)
			})
			dateLabel.snp.remakeConstraints({ (make) in
				make.centerY.equalTo(calendarIcon.snp.centerY)
				//				make.height.equalTo(18)
				make.leading.equalTo(calendarIcon.snp.trailing).offset(SMALLINSET)
				make.trailing.equalTo(countdownLabel.snp.leading)
			})
			countdownLabel.snp.remakeConstraints({ (make) in
				make.bottom.equalTo(bgView.snp.bottom).offset(-MARGIN)
				make.trailing.equalTo(bgView.snp.trailing).offset(-MARGIN)
				make.height.equalTo(15)
				make.width.equalTo(75)
			})
		}
		contentView.layoutIfNeeded()
		height = contentView.frame.height
		contentView.dropShadow(color: .brandcoloralpha, opacity: 1, offSet: CGSize(width: 0, height: 8), radius: 10.0)
	}
}
