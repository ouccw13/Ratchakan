//
//  SummarySubjectTableViewCell.swift
//  ratchakan
//
//  Created by JJsobtid on 12/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class SummarySubjectTableViewCell: UITableViewCell {

	static let cellIdentifier: String = "SummarySubjectTableViewCell"
	
	var titleLabel: UILabel!

	var scoreLabel: UILabel!
	var scoreDetail: UILabel!
	var totalScoreLabel: UILabel!
	var totalScoreDetail: UILabel!
	
	var lineBar: BarProcessView!
	var separateLine: UIView!
	
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		backgroundColor = .white
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
		
		titleLabel = UILabel()
		titleLabel.setParameter(font: .kanitLight16, color: .Celllabel)
		
		scoreLabel = UILabel()
		scoreLabel.setParameter(font: .kanitReg16, color: .brandcolor1)
		
		scoreDetail = UILabel()
		scoreDetail.setParameter(font: .kanitLight10, color: .guestcolor)
		scoreDetail.text = "คะแนนของคุณ"
		
		totalScoreLabel = UILabel()
		totalScoreLabel.setParameter(font: .kanitReg16, color: .Celllabel, alignment: .right)
		
		totalScoreDetail = UILabel()
		totalScoreDetail.setParameter(font: .kanitLight10, color: .guestcolor, alignment: .right)
		totalScoreDetail.text = "คะแนนเต็ม"
		
		lineBar = BarProcessView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 3*MARGIN, height: MARGIN))
		
		separateLine = UIView()
		separateLine.lineView(withColor: .separateLine)
		
		contentView.addsubviews([titleLabel, scoreLabel, scoreDetail, totalScoreLabel, totalScoreDetail, lineBar, separateLine])
		
		setLayout()
	}
	
	func setSummaryData(data: dictStringAny, last: Bool = false) {
		
		let total: CGFloat = 100
		titleLabel.text = "สาระที่ 1 ศาสนา ศีลธรรม และ จริยธรรม"
		scoreLabel.text = "\(total * (data["percent"] as! CGFloat))"
		totalScoreLabel.text = "\(total)"
		
		lineBar.updateData(data["percent"] as! CGFloat, id: titleLabel.text ?? "")
		
		separateLine.show()
		if last {
			separateLine.hide()
		}
		
	}
	
	fileprivate func setLayout() {

		titleLabel.snp.remakeConstraints({ (make) in
			make.top.equalTo(contentView.snp.top).offset(10)
			make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
			make.height.equalTo(24)
		})
		lineBar.snp.remakeConstraints({ (make) in
			let margin = 1.5*MARGIN
			make.leading.equalTo(contentView.snp.leading).offset(margin)
			make.trailing.equalTo(contentView.snp.trailing).offset(-margin)
			make.height.equalTo(MARGIN)
			make.top.equalTo(titleLabel.snp.bottom).offset(10)
		})
		scoreDetail.snp.remakeConstraints { (make) in
			make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
			make.height.equalTo(15)
			make.bottom.equalTo(contentView.snp.bottom).offset(-10)
			make.trailing.equalTo(contentView.snp.centerX)
		}
		scoreLabel.snp.remakeConstraints { (make) in
			make.leading.equalTo(scoreDetail.snp.leading)
			make.trailing.equalTo(scoreDetail.snp.trailing)
			make.height.equalTo(24)
			make.top.equalTo(lineBar.snp.bottom).offset(14)
			make.bottom.equalTo(scoreDetail.snp.top).offset(-4)
		}
		totalScoreDetail.snp.remakeConstraints { (make) in
			make.leading.equalTo(contentView.snp.centerX)
			make.height.equalTo(15)
			make.bottom.equalTo(contentView.snp.bottom).offset(-10)
			make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
		}
		totalScoreLabel.snp.remakeConstraints { (make) in
			make.leading.equalTo(totalScoreDetail.snp.leading)
			make.trailing.equalTo(totalScoreDetail.snp.trailing)
			make.height.equalTo(scoreLabel.snp.height)
			make.centerY.equalTo(scoreLabel.snp.centerY)
		}
		separateLine.snp.remakeConstraints({ (make) in
			make.leading.equalTo(contentView.snp.leading).offset(24)
			make.trailing.equalTo(contentView.snp.trailing).offset(-24)
			make.bottom.equalTo(contentView.snp.bottom)
			make.height.equalTo(SEPARATE_LINE_WIDHT)
		})
	}
}
