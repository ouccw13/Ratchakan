//
//  PretestDetailTableViewCell.swift
//  ratchakan
//
//  Created by JJsobtid on 16/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
enum PretestDetailSection {
	case detailTest
	case category
	case price
	
	static func withSection(section: Int) -> PretestDetailSection {
		switch section {
		case 0:
			return .detailTest
		case 1:
			return .category
		case 2:
			return .price
		default:
			return .detailTest
		}
	}
}
class PretestDetailTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
	
	static let cellIdentifier = "PretestDetailTableViewCell"
	
	var detailCollection: UICollectionView!
	var titleLabel: UILabel!
	var detailLabel: UILabel!
	var iconCell,coverImageView: UIImageView!
	var bottomLine: UIView!
	
	var detailTestData: Any!
    var detailsInPretestModel: DetailsInPretestModel!
    var isType:String = ""
    var tagStr:String = ""
	
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		backgroundColor = .white
		selectionStyle = .none
		
		let collectionLayout = CollectionLayout(withcol: 3, height: 60, axis: .horizontal, innerLine: 0, innerInteritem: 0)
		detailCollection = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 53), collectionViewLayout: collectionLayout)
		detailCollection.setUp(self, bg: .clear)
		detailCollection.register(detailCell.self, forCellWithReuseIdentifier: "reusecell")
		detailCollection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		detailCollection.canScroll(false)
		
		titleLabel = UILabel()
		titleLabel.setParameter(font: .kanitLight14, color: .guestcolor)
		titleLabel.flexibleLine()
		
		detailLabel = UILabel()
		detailLabel.setParameter(font: .kanitLight16, color: .guestcolor, alignment: .right)
		
		iconCell = UIImageView()
		iconCell.contentMode = .scaleAspectFit
        
        coverImageView = UIImageView()
        coverImageView.contentMode = .scaleAspectFill
		
		bottomLine = UIView()
		bottomLine.lineView(withColor: .Collectionbg)
		
		contentView.addsubviews([coverImageView,detailCollection, titleLabel, detailLabel, iconCell, bottomLine])
	}
	
    func setLayout(withSection section: PretestDetailSection,isShowBottom:Bool = true) {
		 if section == .detailTest {
			Utility.show([detailCollection], hides: [titleLabel, detailLabel, iconCell, bottomLine])
			detailCollection.snp.remakeConstraints({ (make) in
				make.edges.equalTo(contentView.snp.edges)
			})
		} else if section == .category {
            if isShowBottom == true {
                Utility.show([titleLabel, detailLabel, bottomLine], hides: [detailCollection, iconCell])
            }else{
                Utility.show([titleLabel, detailLabel], hides: [detailCollection, iconCell,bottomLine])
            }
			
			detailLabel.snp.remakeConstraints({ (make) in
				make.size.equalTo(CGSize(width: 80, height: 24))
				make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
				make.centerY.equalTo(contentView.snp.centerY)
			})
			titleLabel.snp.remakeConstraints({ (make) in
				make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
				make.trailing.equalTo(detailLabel.snp.leading).offset(-MARGIN)
				make.centerY.equalTo(contentView.snp.centerY)
				make.height.equalTo(21)
			})
			bottomLine.snp.remakeConstraints({ (make) in
				make.height.equalTo(1)
				make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
				make.trailing.equalTo(contentView.snp.trailing)
				make.bottom.equalTo(contentView.snp.bottom)
			})
            titleLabel.text = detailsInPretestModel.content
            detailLabel.text = "\(detailsInPretestModel.qty) ข้อ"
		} else if section == .price {
			Utility.show([titleLabel, iconCell], hides: [detailLabel, detailCollection, bottomLine])
			iconCell.snp.remakeConstraints({ (make) in
				make.size.equalTo(CGSize(width: 24, height: 24))
				make.centerY.equalTo(contentView.snp.centerY)
				make.centerX.equalTo(contentView.snp.leading).offset(28)
			})
			titleLabel.snp.remakeConstraints({ (make) in
				make.leading.equalTo(iconCell.snp.trailing).offset(MARGIN)
				make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
				make.centerY.equalTo(contentView.snp.centerY)
				make.height.equalTo(21)
			})
			iconCell.image = UIImage(named: "pretestdetailPrice")
			titleLabel.text = detailTestData as! Int == 0 ? "ฟรี" : "\(detailTestData as! Int) บาท"
		}
	}
    
    func setLayoutWithExamsData(_ exams: Exams,_ subject: SubjectList, section: PretestDetailSection,isShowBottom:Bool = true) {
        if section == .detailTest {
            tagStr = exams.tags?.joined(separator: "") ?? ""
            detailTestData = [tagStr,"\(exams.questionQty ?? 0)", "\(Utility.checkFloat(Float(exams.examScore ?? 0)))"]
            let collectionLayout = CollectionLayout(withcol: 3, height:53, axis: .horizontal, innerLine: 0, innerInteritem: 0)
            detailCollection.collectionViewLayout = collectionLayout
            
            detailCollection.reloadData()
            
            Utility.show([detailCollection], hides: [titleLabel, detailLabel, iconCell, bottomLine])
            detailCollection.snp.remakeConstraints({ (make) in
                make.edges.equalTo(contentView.snp.edges)
                make.height.equalTo(isType == "Exam" ? 85 : 53)
            })
        } else if section == .category {
            if isShowBottom == true {
                Utility.show([titleLabel, detailLabel, bottomLine], hides: [detailCollection, iconCell])
            }else{
                Utility.show([titleLabel, detailLabel], hides: [detailCollection, iconCell,bottomLine])
            }
            detailLabel.snp.remakeConstraints({ (make) in
                make.size.equalTo(CGSize(width: 80, height: 24))
                make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
                make.centerY.equalTo(contentView.snp.centerY)
            })
            titleLabel.snp.remakeConstraints({ (make) in
                make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
                make.trailing.equalTo(detailLabel.snp.leading).offset(-MARGIN)
                make.top.equalTo(contentView.snp.top).offset(MARGIN)
                make.bottom.equalTo(contentView.snp.bottom).offset(-MARGIN)
            })
            bottomLine.snp.remakeConstraints({ (make) in
                make.height.equalTo(1)
                make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
                make.trailing.equalTo(contentView.snp.trailing)
                make.bottom.equalTo(contentView.snp.bottom)
            })
            titleLabel.text = subject.subjectName ?? ""
            detailLabel.text = "\(subject.questionQty ?? 0) ข้อ"
        }
    }
		
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return (detailTestData as? [String] ?? []).count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reusecell", for: indexPath) as! detailCell
		let cellData = detailTestData as! [String]
		if indexPath.item == 0 {
            cell.title = tagStr != "" ? "\(cellData[indexPath.item])" : (isType == "Exam" ? "-" : "\(cellData[indexPath.item]) ข้อ")
		} else if indexPath.item == 1 {
            cell.title = isType == "Exam" ? "\(cellData[indexPath.item]) ข้อ"  : "\(cellData[indexPath.item]) คะแนน"
		} else {
            cell.title = isType == "Exam" ? "\(cellData[indexPath.item]) คะแนน"  : "\(cellData[indexPath.item]) นาที"
		}
		indexPath.item == cellData.count-1 ? cell.separateLine.hide() : cell.separateLine.show()
		
		return cell
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	class detailCell: UICollectionViewCell {
		
		var title: String? {
            didSet {
                titleLabel.text = title!
            }
		}
		
		var titleLabel: UILabel!
		var separateLine: UIView!
		
		override init(frame: CGRect) {
			super.init(frame: frame)
			backgroundColor = .clear
			titleLabel = UILabel()
            titleLabel.fixline(4)
            titleLabel.lineBreakMode = .byWordWrapping
			titleLabel.setParameter(font: .kanitLight14, color: .guestcolor, alignment: .center)
			
			contentView.addSubview(titleLabel)
			titleLabel.snp.makeConstraints { (make) in
				make.centerY.equalTo(contentView.snp.centerY)
				make.leading.equalTo(contentView.snp.leading).offset(6)
				make.trailing.equalTo(contentView.snp.trailing).offset(-6)
			}
			separateLine = UIView()
			separateLine.lineView(withColor: .Collectionbg)
			contentView.addSubview(separateLine)
			separateLine.snp.makeConstraints { (make) in
				make.trailing.equalTo(contentView.snp.trailing)
				make.top.equalTo(contentView.snp.top)
				make.bottom.equalTo(contentView.snp.bottom)
				make.width.equalTo(UNDERLINE_WIDHT)
			}
		}
		
		required init?(coder aDecoder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
}

