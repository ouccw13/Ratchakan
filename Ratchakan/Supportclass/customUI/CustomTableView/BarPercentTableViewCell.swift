//
//  BarPercentTableViewCell.swift
//  ratchakan
//
//  Created by JJsobtid on 30/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

enum BarType {
	case circle
	case line
}

class BarPercentTableViewCell: UITableViewCell {

	static let cellIdentifier: String = "BarPercentTableViewCell"
	
	var identifier: String!
	
	var viewBG: UIView!
	var titleLabel: UILabel!
	
	var headerLabel: UILabel!
	var scoreImage: UIImageView!
	var scoreLabel: UILabel!
	var timeImage: UIImageView!
	var timeLabel: UILabel!
	var circleBar: CircleView!
	var trophyImageView: UIImageView!
	var scoreInTrophyLabel: UILabel!
	
	var lineBar: BarProcessView!
	var accessoryImage: UIImageView!
	var separateLine: UIView!
	
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		backgroundColor = .clear
		selectionStyle = .none
		
		createUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	fileprivate func createUI() {
		viewBG = UIView()
		viewBG.backgroundColor = .white
		
		titleLabel = UILabel()
		titleLabel.flexibleLine()
		
		//CIRCLE
		headerLabel = UILabel()
		headerLabel.setParameter(font: .kanitLight16, color: .Celllabel, alignment: .left)
		headerLabel.text = string.th_analysis_summary_exam
		
		circleBar = CircleView(withBackground: .separateLine, frame: CGRect(x: 0, y: 0, width: 160, height: 160))
		circleBar.drawPercentCircle()
		
		trophyImageView = UIImageView()
		trophyImageView.setParameter(name: "scoreIcon", mode: .scaleAspectFit)
		scoreInTrophyLabel = UILabel()
		scoreInTrophyLabel.setParameter(font: .kanitReg36, color: .brandcolor1, alignment: .center)
		
		scoreImage = UIImageView()
		scoreImage.setParameter(name: "examIcon", mode: .scaleAspectFit)
		scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 0))
		scoreLabel.setParameter(font: .kanitReg18, color: .Celllabel, alignment: .left)
		
		timeImage = UIImageView()
		timeImage.setParameter(name: "timeIcon", mode: .scaleAspectFit)
		timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 0))
		timeLabel.setParameter(font: .kanitReg18, color: .Celllabel, alignment: .left)
		
		//LINE
        if IS_IPAD {
            if SCREEN_WIDTH >= 650.0 && SCREEN_WIDTH <= 768.0 {
                print("Test IPAD PRO 9.7")
                lineBar = BarProcessView(frame: CGRect(x: 0, y: 0, width: contentView.frame.width * 2.1, height: MARGIN))
           }
           else if SCREEN_WIDTH >= 1024.0 {
               debugPrint("Test IPAD PRO 12.9 gen 5")
               lineBar = BarProcessView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 3*(MARGIN + 12) , height: MARGIN))
           } else {
               print("Test IPAD PRO gen3 11.0")
               lineBar = BarProcessView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 10*MARGIN , height: MARGIN))
           }
        }
        else {
            lineBar = BarProcessView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 3*MARGIN, height: MARGIN))
        }
		
		accessoryImage = UIImageView()
		accessoryImage.setParameter(name: "chevronIcon", mode: .scaleAspectFit)
		
		separateLine = UIView()
		separateLine.lineView(withColor: .separateLine)
		
		contentView.addsubviews([viewBG, headerLabel])
		viewBG.addsubviews([titleLabel, circleBar, trophyImageView, scoreInTrophyLabel, scoreImage, scoreLabel, timeImage, timeLabel, separateLine, lineBar, accessoryImage])
        setLayout(type: .line, isPretest: false)
	}
	
    func setExamSummaryData(data: dictStringAny, type: BarType, last: Bool = false, isPretest: Bool = false,widthLineBar:CGFloat = 0.0) {
		
		if type == .circle {
			let score = Validation.anyIsFloat(Validation.anyIsDictionary(data, with: "memberScore"), with: "score")
			let totalScore = isPretest ? Validation.anyIsFloat(data, with: "totalScore") : Validation.anyIsFloat(data, with: "examScore")
			scoreInTrophyLabel.text = "\(Utility.checkFloat(score))"
			scoreLabel.text = "\(Utility.checkFloat(score))/\(Utility.checkFloat(totalScore)) คะแนน"
			
			Utility.show([trophyImageView, scoreInTrophyLabel/*, titleLabel, circleBar*/, scoreImage, scoreLabel, timeImage, timeLabel, headerLabel], hides: [lineBar, accessoryImage, separateLine, titleLabel, circleBar])
			
			if isPretest {
				titleLabel.setParameter(font: .kanitReg16, color: .Celllabel, alignment: .center)
				if score/totalScore >= 0.6 {
					titleLabel.text = string.th_cong_exam
				} else {
					titleLabel.text = string.th_fail_exam
				}
				circleBar.animationPercent(CGFloat(score/totalScore))
				Utility.show([titleLabel, circleBar], hides: [trophyImageView, scoreInTrophyLabel])
			}
			
		} else {
			titleLabel.setParameter(font: .kanitReg14, color: .Celllabel, alignment: .left)
			titleLabel.text = Validation.anyIsString(data, with: "name")
			
			let score = Validation.anyIsFloat(data, with: "score")
			let totalScore = Validation.anyIsFloat(data, with: "totalScore")
            lineBar.updateData(CGFloat(score/totalScore), id: Validation.anyIsString(data, with: "name"))
			
			Utility.show([titleLabel, lineBar, accessoryImage, separateLine], hides: [scoreImage, scoreLabel, timeImage, timeLabel, headerLabel, trophyImageView, scoreInTrophyLabel, circleBar])
			if not(Validation.dictionary(data, with: "categories")) {
				accessoryImage.hide()
			}
			if last {
				separateLine.hide()
			}
		}
		
		setLayout(type: type, isPretest: isPretest)
	}
	func setCircleTime(_ time: Int) {
		let times = Datetime.timeFromSec(time, haveSpace: false, haveHour: true)
		timeLabel.text = times
		timeLabel.sizeToFit()
		timeLabel.snp.remakeConstraints({ (make) in
			make.leading.equalTo(timeImage.snp.trailing).offset(SMALLINSET)
			make.centerY.equalTo(scoreImage.snp.centerY)
			make.height.equalTo(30)
			make.width.equalTo(timeLabel.frame.width)
		})
		
		layoutIfNeeded()
		
		let widthText = (timeLabel.frame.origin.x + timeLabel.frame.size.width - scoreImage.frame.origin.x)/2
		scoreImage.snp.remakeConstraints({ (make) in
			make.size.equalTo(CGSize(width: 18, height: 18))
			make.leading.equalTo(viewBG.snp.centerX).offset(-widthText)
			make.bottom.equalTo(viewBG.snp.centerY).multipliedBy(1.75)
		})
		scoreLabel.snp.remakeConstraints({ (make) in
			make.leading.equalTo(scoreImage.snp.trailing).offset(SMALLINSET)
			make.centerY.equalTo(scoreImage.snp.centerY)
			make.height.equalTo(30)
		})
		timeImage.snp.remakeConstraints({ (make) in
			make.size.equalTo(CGSize(width: 18, height: 21))
			make.leading.equalTo(scoreLabel.snp.trailing).offset(MARGIN)
			make.centerY.equalTo(scoreImage.snp.centerY)
		})
		timeLabel.snp.remakeConstraints({ (make) in
			make.leading.equalTo(timeImage.snp.trailing).offset(SMALLINSET)
			make.centerY.equalTo(scoreImage.snp.centerY)
			make.height.equalTo(30)
		})
		
	}
	fileprivate func setLayout(type: BarType, isPretest: Bool) {
		if type == .circle {
			viewBG.snp.remakeConstraints({ (make) in
				make.top.equalTo(contentView.snp.top)
				make.leading.equalTo(contentView.snp.leading)
				make.trailing.equalTo(contentView.snp.trailing)
				make.height.equalTo(290)
				make.bottom.equalTo(contentView.snp.bottom).offset(-49)
			})
			headerLabel.snp.remakeConstraints({ (make) in
				make.top.equalTo(viewBG.snp.bottom).offset(MARGIN)
				make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
				make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
				make.height.equalTo(24)
			})
			trophyImageView.snp.remakeConstraints { (make) in
				make.size.equalTo(CGSize(width: 160, height: 160))
				make.centerX.equalTo(viewBG.snp.centerX)
				make.centerY.equalTo(viewBG.snp.centerY).offset(-24)
			}
			scoreInTrophyLabel.snp.remakeConstraints { (make) in
				make.top.equalTo(trophyImageView.snp.top).offset(37)
				make.leading.equalTo(trophyImageView.snp.leading)
				make.height.equalTo(48)
				make.trailing.equalTo(trophyImageView.snp.trailing)
			}
			if isPretest {
				circleBar.snp.remakeConstraints { (make) in
					make.centerX.equalTo(viewBG.snp.centerX)
					make.centerY.equalTo(viewBG.snp.centerY)
					make.bottom.equalTo(viewBG.snp.bottom).offset(-76)
					make.size.equalTo(CGSize(width: 160, height: 160))
				}
				titleLabel.snp.remakeConstraints({ (make) in
					make.centerY.equalTo(circleBar.snp.top).dividedBy(2)
					make.centerX.equalTo(viewBG.snp.centerX)
					make.leading.equalTo(viewBG.snp.leading).offset(MARGIN)
					make.trailing.equalTo(viewBG.snp.trailing).offset(-MARGIN)
				})
			}
			scoreLabel.sizeToFit()
			scoreLabel.snp.remakeConstraints({ (make) in
				make.trailing.equalTo(viewBG.snp.centerX).offset(-SMALLINSET)
				make.bottom.equalTo(viewBG.snp.centerY).multipliedBy(1.75)
				make.height.equalTo(30)
				make.width.equalTo(scoreLabel.frame.width)
			})
			scoreImage.snp.remakeConstraints({ (make) in
				make.size.equalTo(CGSize(width: 18, height: 18))
				make.trailing.equalTo(scoreLabel.snp.leading).offset(-SMALLINSET)
				make.centerY.equalTo(scoreLabel.snp.centerY)
			})
			timeImage.snp.remakeConstraints({ (make) in
				make.size.equalTo(CGSize(width: 18, height: 21))
				make.leading.equalTo(viewBG.snp.centerX).offset(SMALLINSET)
				make.centerY.equalTo(scoreImage.snp.centerY)
			})
			
		} else {
			accessoryImage.snp.remakeConstraints({ (make) in
				make.size.equalTo(CGSize(width: 6, height: 10))
				make.top.equalTo(contentView.snp.top).offset(MARGIN)
				make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
			})
			titleLabel.snp.remakeConstraints({ (make) in
				make.top.equalTo(contentView.snp.top).offset(SMALLINSET)
				make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
				make.trailing.equalTo(accessoryImage.snp.leading).offset(-MARGIN)
				make.bottom.equalTo(lineBar.snp.top).offset(-SMALLINSET)
			})
			lineBar.snp.remakeConstraints({ (make) in
                let margin = 1.7*MARGIN
				make.top.equalTo(titleLabel.snp.bottom).offset(SMALLINSET)
				make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
				make.trailing.equalTo(accessoryImage.snp.leading).offset(-MARGIN)
				make.height.equalTo(MARGIN)
				make.bottom.equalTo(contentView.snp.bottom).offset(-MARGIN)
			})
			separateLine.snp.remakeConstraints({ (make) in
				make.leading.equalTo(titleLabel.snp.leading)
				make.trailing.equalTo(contentView.snp.trailing)
				make.bottom.equalTo(contentView.snp.bottom)
				make.height.equalTo(SEPARATE_LINE_WIDHT)
			})
			viewBG.snp.remakeConstraints({ (make) in
				make.edges.equalTo(contentView.snp.edges)
			})
		}
	}
	
	func setBackground(_ color: UIColor) {
		backgroundColor = (color == .white ? .clear : color)
		viewBG.backgroundColor = color
	}
}
