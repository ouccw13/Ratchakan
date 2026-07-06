//
//  StatSubjectGroupCollectionViewCell.swift
//  ratchakan
//
//  Created by JJsobtid on 20/3/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class StatSubjectGroupCollectionViewCell: UICollectionViewCell {
	
	static let cellIdentifier = "StatSubjectGroupCollectionViewCell"
	
	var bgView: UIView!
	var subjectTitle: UILabel!
	var accessoryImage: UIImageView!
	var leftBarView: UIView!
	
	var statSubjectData: SubjectModel!
	var statGroupData: SubjectGroupModel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		bgView = UIView(frame: CGRect(origin: CGPoint(), size: frame.size))
		bgView.backgroundColor = .white
		bgView.cornerView(radius: 2.0)
		
		subjectTitle = UILabel()
        subjectTitle.setParameter(font: IS_IPAD ? .kanitReg16 : .kanitReg14, color: .Celllabel)
		subjectTitle.text = "แนวข้อสอบ"
		
		accessoryImage = UIImageView()
		accessoryImage.image = UIImage(named: "chevronIcon")
		accessoryImage.contentMode = .scaleAspectFit
		
		leftBarView = UIView()
		
		contentView.addSubview(bgView)
		bgView.addSubview(leftBarView)
		bgView.addSubview(accessoryImage)
		bgView.addSubview(subjectTitle)
		
		setLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setCellData(_ data: SubjectModel, group: SubjectGroupModel) {
		statSubjectData = data
		statGroupData = group
		subjectTitle.text = statSubjectData.name
        subjectTitle.flexibleLine()
		leftBarView.backgroundColor = UIColor.color(fromHexString: data.colorHex)
	}
	
	fileprivate func setLayout() {
		bgView.snp.remakeConstraints { (make) in
			make.edges.equalTo(contentView.snp.edges)
		}
		
		leftBarView.snp.remakeConstraints { (make) in
			make.top.equalTo(contentView.snp.top)
			make.leading.equalTo(contentView.snp.leading)
			make.bottom.equalTo(contentView.snp.bottom)
			make.width.equalTo(6)
		}
		
		accessoryImage.snp.remakeConstraints { (make) in
			make.width.equalTo(6.6)
			make.height.equalTo(11)
            make.top.equalTo(14)
//            make.centerY.equalTo(contentView.snp.centerY)
			make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
		}
		
		subjectTitle.snp.remakeConstraints { (make) in
//			make.height.equalTo(12)
			make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(accessoryImage.snp.leading).offset(-MARGIN)
			make.top.equalTo(/*MARGIN*/10)
		}
	}
}
