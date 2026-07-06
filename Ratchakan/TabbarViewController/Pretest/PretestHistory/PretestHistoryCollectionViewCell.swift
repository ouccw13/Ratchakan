//
//  PretestHistoryCollectionViewCell.swift
//  ratchakan
//
//  Created by JJsobtid on 12/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class PretestHistoryCollectionViewCell: UICollectionViewCell {
	
	static let cellIdentifier: String = "PretestHistoryCollectionViewCell"
	
	var type: String!
	
	var bgView: UIView!
	var pretestTitle: UILabel!
	var pretestStatus: UILabel!
	var pretestStatusDetail: UILabel!
	var pretestDoneTime: UILabel!
	var pretestDoneDate: UILabel!
	var pretestResult: UILabel!
	var bowTagImageView: UIImageView!
	var clockImage: UIImageView!
	var calendarImage: UIImageView!
	
	var memberExamId: String!
	
	var subjectData: [String: Any] = [:]
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		dropShadow(color: .brandcoloralpha, opacity: 1, offSet: CGSize(width: 0, height: 5), radius: 10.0)
		
		bgView = UIView(frame: CGRect(origin: CGPoint(), size: frame.size))
		bgView.backgroundColor = .white
		bgView.cornerView(radius: 10.0)
		
		pretestTitle = UILabel()
		pretestTitle.setParameter(font: .kanitReg16, color: .Celllabel)
		pretestTitle.text = "ลองชื่อ pretest ยาว ๆ หน่อย ว่าเป็นอย่างไรบ้าง เวลามาอยู่ในหน้าจอ"
		
		pretestStatus = UILabel()
		pretestStatus.setParameter(font: .kanitLight14, color: .Celllabel)
		pretestStatus.text = "สถานะ : "
		pretestStatusDetail = UILabel()
		pretestStatusDetail.setParameter(font: .kanitLight14, color: .brandcolor3_dark)
		pretestStatusDetail.text = ( arc4random()%2 == 0 ? "สอบจริง" : "ฝึกซ้อม")
		
		clockImage = UIImageView()
		clockImage.contentMode = .scaleAspectFit
		clockImage.image = UIImage(named: "pretestTimeIcon")

		calendarImage = UIImageView()
		calendarImage.image = UIImage(named: "calIcon")
		calendarImage.contentMode = .scaleAspectFit
		
		pretestDoneTime = UILabel()
		pretestDoneTime.setParameter(font: .kanitLight14, color: .guestcolor)
		pretestDoneTime.text = "\(Datetime.timeFromSec(40, haveSpace: false)) นาที"
		
		pretestDoneDate = UILabel()
		pretestDoneDate.setParameter(font: .kanitLight14, color: .guestcolor)
		pretestDoneDate.text = "\(Datetime().showDate(1518409843, short: false, showTime: true))"
		
		pretestResult = UILabel()
		pretestResult.setParameter(font: .kanitReg18, color: .brandcolor3_dark, alignment: .right)
		
		bowTagImageView = UIImageView(image: UIImage(named: "tagbowPretest"))
		bowTagImageView.contentMode = .scaleAspectFill

		contentView.addsubviews([bgView, pretestTitle, pretestStatus, pretestStatusDetail, clockImage, pretestDoneTime, calendarImage, pretestDoneDate, pretestResult])
		addsubviews([bowTagImageView])
		
		setLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setCellData(_ data: Any, name: String = "", type: String) {
		self.type = type
		if type == "pretest" {
			if let historyData = data as? PretestHistoryModel {
				pretestTitle.text = name
				pretestStatusDetail.text = historyData.isPass ? "ผ่าน" : "ไม่ผ่าน"
				pretestDoneTime.text = historyData.timeToShow
                let arrDate = historyData.dateToShow.split(separator: " ")
                if arrDate.count == 5 {
                    let year = Int(arrDate[2])! + 543
                    let convertThaiDate = arrDate[0] + " " + arrDate[1] + " " + "\(year) " + arrDate[3] + " " + arrDate[4]
                    pretestDoneDate.text = convertThaiDate
                }
                let score = Utility.checkFloat(historyData.score).floatValue.convertFloatZerotoInt
                let totalScore = Utility.checkFloat(historyData.totalScore).floatValue.convertFloatZerotoInt
                if score.contains(".1") || score.contains(".2") || score.contains(".3") || score.contains(".4") || score.contains(".5") || score.contains(".6") || score.contains(".7") || score.contains(".8") || score.contains(".9") {
                    pretestResult.text = score + "0" + "/" + totalScore
                }else{
                    pretestResult.text = score + "/" + totalScore
                }
				if historyData.isPractice {
					bowTagImageView.hide()
				} else {
					bowTagImageView.show()
				}
				if historyData.isPass {
					pretestStatusDetail.textColor = .kermitGreen
					pretestResult.textColor = .kermitGreen
				} else {
					pretestStatusDetail.textColor = .brandcolor1
					pretestResult.textColor = .brandcolor1
				}
			} else {
				let pretestData = data as! [String : Any]
				if Validation.dictionary(pretestData as [String : AnyObject], with: "group_name") {
					pretestTitle.text = pretestData["group_name"] as? String
				}
				if Validation.dictionary(pretestData as [String : AnyObject], with: "description") {
					pretestStatus.text = pretestData["description"] as? String
				}
			}
		} else if type == "exam" {
			let examData = data as! [String : Any]
			memberExamId = Validation.anyIsString(examData, with: "memberExamId")
			pretestTitle.text = Validation.anyIsString(examData, with: "examName")
            let score = Validation.anyIsFloat(examData, with: "score").convertFloatZerotoInt
            let totalScore = Validation.anyIsFloat(examData, with: "examScore").convertFloatZerotoInt
            if score.contains(".1") || score.contains(".2") || score.contains(".3") || score.contains(".4") || score.contains(".5") || score.contains(".6") || score.contains(".7") || score.contains(".8") || score.contains(".9") {
                pretestResult.text = score + "0" + "/" + totalScore
            }else{
                pretestResult.text = score + "/" + totalScore
            }
			pretestStatusDetail.textColor = .brandcolor3_dark
			pretestResult.textColor = pretestStatusDetail.textColor
			pretestDoneTime.text = Datetime.timeFromSec(Validation.anyIsNumber(examData, with: "totalTime"), haveSpace: false)
			pretestDoneDate.text = Datetime().showDate(Validation.anyIsNumber(examData, with: "testDate"), short: false, showTime: true)
			
			Utility.show([], hides: [pretestStatus, pretestStatusDetail, bowTagImageView])
			clockImage.snp.remakeConstraints { (make) in
				make.width.equalTo(17)
				make.height.equalTo(17)
				make.top.equalTo(pretestTitle.snp.bottom).offset(11)
				make.leading.equalTo(pretestTitle.snp.leading)
			}
			pretestDoneTime.snp.remakeConstraints { (make) in
				make.centerY.equalTo(clockImage.snp.centerY)
				make.height.equalTo(21)
				make.leading.equalTo(clockImage.snp.trailing).offset(10)
				make.trailing.equalTo(pretestResult.snp.leading).offset(-MARGIN)
			}
			calendarImage.snp.remakeConstraints { (make) in
				make.width.equalTo(17)
				make.height.equalTo(17)
				make.top.equalTo(clockImage.snp.bottom).offset(12)
				make.centerX.equalTo(clockImage.snp.centerX)
			}
			pretestDoneDate.snp.remakeConstraints { (make) in
				make.centerY.equalTo(calendarImage.snp.centerY)
				make.height.equalTo(21)
				make.leading.equalTo(pretestDoneTime.snp.leading)
				make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
			}
		}
	}
	
	fileprivate func setLayout() {
		bgView.snp.remakeConstraints { (make) in
			make.edges.equalTo(contentView.snp.edges)
		}
		bowTagImageView.snp.remakeConstraints { (make) in
			make.top.equalTo(bgView.snp.top).offset(-2)
			make.size.equalTo(CGSize(width: 72, height: 62))
			make.trailing.equalTo(bgView.snp.trailing).offset(6)
		}
		pretestResult.snp.remakeConstraints { (make) in
			make.size.equalTo(CGSize(width: SCREEN_WIDTH/2 - MARGIN, height: 27))
			make.centerY.equalTo(contentView.snp.centerY)
			make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
			make.width.equalTo(150)
		}
		pretestTitle.snp.remakeConstraints { (make) in
			make.height.equalTo(24)
			make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
			make.top.equalTo(contentView.snp.top).offset(10)
		}
		pretestStatus.snp.remakeConstraints { (make) in
			make.size.equalTo(CGSize(width: 45, height: 24))
			make.top.equalTo(pretestTitle.snp.bottom).offset(4)
			make.leading.equalTo(pretestTitle.snp.leading)
		}
		pretestStatusDetail.snp.remakeConstraints { (make) in
			make.size.equalTo(CGSize(width: 85, height: 24))
			make.leading.equalTo(pretestStatus.snp.trailing).offset(4)
			make.centerY.equalTo(pretestStatus.snp.centerY)
		}
		clockImage.snp.remakeConstraints { (make) in
			make.width.equalTo(17)
			make.height.equalTo(17)
			make.top.equalTo(pretestStatus.snp.bottom).offset(11)
			make.leading.equalTo(pretestTitle.snp.leading)
		}
		pretestDoneTime.snp.remakeConstraints { (make) in
			make.centerY.equalTo(clockImage.snp.centerY)
			make.height.equalTo(21)
			make.leading.equalTo(clockImage.snp.trailing).offset(10)
			make.trailing.equalTo(pretestResult.snp.leading).offset(-MARGIN)
		}
		calendarImage.snp.remakeConstraints { (make) in
			make.width.equalTo(17)
			make.height.equalTo(17)
			make.top.equalTo(clockImage.snp.bottom).offset(12)
			make.centerX.equalTo(clockImage.snp.centerX)
		}
		pretestDoneDate.snp.remakeConstraints { (make) in
			make.centerY.equalTo(calendarImage.snp.centerY)
			make.height.equalTo(21)
			make.leading.equalTo(pretestDoneTime.snp.leading)
			make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
		}
	}
}
