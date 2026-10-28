//
//  PretestCollectionViewCell.swift
//  ratchakan
//
//  Created by JJsobtid on 14/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import SDWebImage

let ratioCoverPretest: CGFloat = 196 / 282.0

class PretestCollectionViewCell: UICollectionViewCell {
	
	var pretestID: String!
	
	var bgView: UIView!
	var pretestCover: UIImageView!
	var teacherImage: UIImageView!
	var pretestTitle: UILabel!
	var pretestDetail: UILabel!
	var normalBG: UIView!
	var normalPrice: UILabel!
	var normalPriceText: UILabel!
	var memberBG: UIView!
	var memberPrice: UILabel!
	var memberPriceText: UILabel!
	var marginPrice: CGFloat!
	
	var pretestViewModel: PretestViewModelFromPretest?
	var promotionViewModel: PromotionViewModelFromPromotion?
	
	var type: TypePretest? {
		didSet {
			setLayout()
		}
	}
	
	var pretestData: [String: Any] = [:]
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		dropShadow(color: .brandcoloralpha, opacity: 1, offSet: CGSize(width: 0, height: 8), radius: 10.0)
		
		bgView = UIView(frame: CGRect(origin: CGPoint(), size: frame.size))
		bgView.backgroundColor = .white
		bgView.cornerView(radius: 10.0)
		
		pretestCover = UIImageView()
		pretestCover.clipsToBounds = true
		pretestCover.contentMode = .scaleAspectFill
		
		teacherImage = UIImageView()
		teacherImage.contentMode = .scaleAspectFill
		teacherImage.cornerView(radius: 25)
		teacherImage.backgroundColor = .brandcolor2
		
		pretestTitle = UILabel()
		pretestTitle.setParameter(font: .kanitReg12, color: .Celllabel)
		pretestTitle.text = "Pretest Name"
		
		pretestDetail = UILabel()
		pretestDetail.setParameter(font: .kanitReg10, color: .Celllabel)
		pretestDetail.numberOfLines = 2
		pretestDetail.text = ( arc4random()%2 == 0 ? "2 บรรทัด ลองพิมพ์อะไรยาว ๆ ให้มันเกินบรรทัดที่กำหนดดูว่าจะเป็นอย่างไร ไหนลงทดสอบสิ รันโปรแกรม" : "รายละเอียด")
		
		normalPriceText = UILabel()
		normalPriceText.setParameter(font: .kanitReg12, color: .Celllabel, alignment: .right)
		normalPriceText.text = "ราคาปกติ"
		
		normalBG = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 28))
		normalBG.cornerView(radius: 14)
		normalBG.addBackgroundGradient(colors: [.brandcolor1, .brandcolor2], horizontal: true)
		
		normalPrice = UILabel()
		normalPrice.setParameter(font: .kanitMed14, color: .white, alignment: .center)
		normalPrice.text = "80 บาท"
		normalPrice.cornerView(radius: 14)
		normalPrice.backgroundColor = .clear
		
		memberPriceText = UILabel()
		memberPriceText.setParameter(font: .kanitReg12, color: .redPurchase, alignment: .right)
		memberPriceText.text = "ราคา VIP"
		
		memberBG = UIView(frame: CGRect(x: 0, y: 0, width: 82, height: 28))
		memberBG.cornerView(radius: 14)
		memberBG.addBackgroundGradient(colors: [.brandcolor1, .brandcolor2], horizontal: true)
		
		memberPrice = UILabel()
		memberPrice.setParameter(font: .kanitMed14, color: .white, alignment: .center)
		memberPrice.text = "80 บาท"
		memberPrice.cornerView(radius: 14)
		memberPrice.backgroundColor = .clear
		
		contentView.addSubview(bgView)
		normalBG.addSubview(normalPrice)
		memberBG.addSubview(memberPrice)
		bgView.addsubviews([pretestCover, teacherImage, pretestTitle, pretestDetail, normalBG])
		bgView.snp.makeConstraints { (make) in
			make.edges.equalTo(contentView.snp.edges)
		}
		pretestCover.snp.makeConstraints { (make) in
			make.top.equalTo(bgView.snp.top)
			make.leading.equalTo(bgView.snp.leading)
			make.trailing.equalTo(bgView.snp.trailing)
			make.height.equalTo(frame.height * ratioCoverPretest)
		}
		
		marginPrice = (frame.height * 86 / 282 - 28)/2
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setLayout() {
		
		teacherImage.show()
		pretestDetail.show()
		normalBG.show()
		memberBG.show()
		pretestTitle.unFlexibleLine()
		if type == .allevent || type == .pastevent {
			teacherImage.snp.remakeConstraints({ (make) in
				make.size.equalTo(CGSize(width: 50, height: 50))
				make.centerY.equalTo(pretestCover.snp.bottom)
				make.leading.equalTo(bgView.snp.leading).offset(12)
			})
			
			normalBG.snp.remakeConstraints({ (make) in
				make.width.equalTo(90)
				make.height.equalTo(28)
				make.trailing.equalTo(bgView.snp.trailing).offset(-12)
				make.bottom.equalTo(bgView.snp.bottom).offset(-marginPrice)
			})
			normalPrice.snp.remakeConstraints({ (make) in
				make.edges.equalTo(normalBG.snp.edges)
			})
			
			pretestTitle.snp.remakeConstraints({ (make) in
				make.leading.equalTo(teacherImage.snp.leading)
                make.trailing.equalTo(normalBG.snp.leading).offset(-5)/*.offset(-SMALLINSET)*/
//				make.height.equalTo(21)
//				make.top.equalTo(teacherImage.snp.bottom).offset(10)
                make.centerY.equalTo(normalPrice.snp.centerY)
			})
			pretestDetail.snp.remakeConstraints({ (make) in
				make.leading.equalTo(pretestTitle.snp.leading)
				make.trailing.equalTo(pretestTitle.snp.trailing)
				make.top.equalTo(pretestTitle.snp.bottom)
				make.bottom.equalTo(contentView.snp.bottom).offset(-4)
			})
		} else if type == .pastevent {
			
		} else if type == .myevent {
			normalBG.hide()
			memberBG.hide()
			
			teacherImage.snp.remakeConstraints({ (make) in
				make.size.equalTo(CGSize(width: 50, height: 50))
				make.centerY.equalTo(pretestCover.snp.bottom)
				make.leading.equalTo(bgView.snp.leading).offset(12)
			})
			
			pretestTitle.snp.remakeConstraints({ (make) in
				make.leading.equalTo(teacherImage.snp.leading)
				make.trailing.equalTo(contentView.snp.trailing).offset(-SMALLINSET)
				make.height.equalTo(21)
				make.top.equalTo(teacherImage.snp.bottom).offset(SMALLINSET)
			})
			pretestDetail.snp.remakeConstraints({ (make) in
				make.leading.equalTo(pretestTitle.snp.leading)
				make.trailing.equalTo(pretestTitle.snp.trailing)
				make.top.equalTo(pretestTitle.snp.bottom)
				make.bottom.equalTo(contentView.snp.bottom).offset(-4)
			})
		}
		
		if let pretestViewModel = pretestViewModel {
			pretestTitle.text = pretestViewModel.pretestName
            pretestTitle.flexibleLine()
			pretestDetail.text = "โดย \(pretestViewModel.teacherName)"
			normalPrice.text = pretestViewModel.regularPrice.counterservice == 0 ? "ฟรี" : "\(pretestViewModel.regularPrice.inapp) บาท"
			memberPrice.text = "\(pretestViewModel.vipPrice.counterservice)"
			let nameCover = "8d8f05e9278948b40d44101761540d22-RlWVbopJ1GZ8d6tk.jpg"//pathCover[0]["path"] as! String
			pretestCover.af_setImage(withURL: URL(string: "https://s3-ap-southeast-1.amazonaws.com/sobtidimage/advertisement/banner/tablet/\(nameCover)")!, placeholderImage: UIImage(named: "placeholderImage"))

			if let banner = pretestViewModel.banner["tablet"] {
				let pathCover = banner as! dictStringAny
				let nameCover = pathCover["path"] as! String
				pretestCover.af_setImage(withURL: URL(string: "https://s3-ap-southeast-1.amazonaws.com/sobtidimage/advertisement/banner/tablet/\(nameCover)")!, placeholderImage: UIImage(named: "placeholderImage"))
			}
			teacherImage.af_setImage(withURL: URL(string: pretestViewModel.teacherProfile)!, placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
			pretestID = pretestViewModel.pretestID
		} else if let promotionViewModel = promotionViewModel {
			
			pretestTitle.text = promotionViewModel.promotionName
			if let banner = promotionViewModel.banner["tablet"] {
				let pathCover = banner as! dictStringAny
				let nameCover = pathCover["path"] as! String
				pretestCover.af_setImage(withURL: URL(string: "https://s3-ap-southeast-1.amazonaws.com/sobtidimage/advertisement/banner/tablet/\(nameCover)")!, placeholderImage: UIImage(named: "logo"))
			}
			normalPrice.text = promotionViewModel.regularPrice.counterservice == 0 ? "ฟรี" : "\(promotionViewModel.regularPrice.inapp) บาท"
			teacherImage.hide()
			pretestDetail.hide()
			pretestDetail.snp.removeConstraints()
			pretestTitle.fixline(3)
			pretestTitle.snp.remakeConstraints({ (make) in
				make.leading.equalTo(bgView.snp.leading).offset(12)
				make.trailing.equalTo(normalPrice.snp.leading).offset(-SMALLINSET)
				make.centerY.equalTo(normalPrice.snp.centerY)
			})
		}
		
	}
}
