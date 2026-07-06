//
//  PackageCollectionViewCell.swift
//  ratchakan
//
//  Created by JJsobtid on 19/4/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class PackageCollectionViewCell: UICollectionViewCell {

	static let cellIdentifier = "PackageCollectionViewCell"
	let priceHeight: CGFloat = 28
	
	var packageProfileImageView, discountView: UIImageView!
	var titleLabel, detailLabel, timeLabel, priceLabel, discountLabel: UILabel!
	var line: UIView!
	override init(frame: CGRect) {
		super.init(frame: frame)
		dropShadow(color: .brandcoloralpha, opacity: 1, offSet: CGSize(width: 0, height: 5), radius: 10.0)
		
		backgroundColor = .clear
		contentView.backgroundColor = .white
		contentView.cornerView(radius: 10)
		
		packageProfileImageView = UIImageView()
		packageProfileImageView.contentMode = .scaleAspectFit
		
		discountView = UIImageView(image: UIImage(named: "discountIcon"))
		discountView.contentMode = .scaleAspectFit
		
		discountLabel = UILabel()
		discountLabel.setParameter(font: .kanitReg12, color: .white, alignment: .center)
		
		titleLabel = UILabel()
		titleLabel.setParameter(font: .kanitLight14, color: .Celllabel)
		titleLabel.flexibleLine()
		
		detailLabel = UILabel()
		detailLabel.setParameter(font: .kanitLight12, color: .placeholdercolor)
		detailLabel.flexibleLine()
		
		timeLabel = UILabel()
		timeLabel.setParameter(font: .kanitLight14, color: .brandcolor3_dark)
		timeLabel.text = "ระยะเวลา 1 ปี"
		
		priceLabel = UILabel()
		priceLabel.setParameter(font: .kanitMed14, color: .white, alignment: .center)
		priceLabel.cornerView(radius: priceHeight/2)
		priceLabel.backgroundColor = .brandcolor1
		
		contentView.addsubviews([packageProfileImageView, titleLabel, detailLabel, timeLabel, priceLabel, discountView, discountLabel])
		addsubviews([discountView, discountLabel])
		
		setLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
		URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
	}
	func downloadImage(from url: URL) {
		packageProfileImageView.image = UIImage(named: "logo")
		getData(from: url) { data, response, error in
			guard let data = data, error == nil else { return }
			DispatchQueue.main.async() { [weak self] in
				self?.packageProfileImageView.image = UIImage(data: data)
			}
		}
	}
	
	func setCellData(_ data: Any, withType: String) {
		if withType == "purchase" {
			if let package = data as? Package {
				titleLabel.text = package.name
				timeLabel.text = "ระยะเวลา \(Datetime.changeDayToYear(package.duration))"
				packageProfileImageView.af_setImage(withURL: URL(string: package.imageURL)!)
				detailLabel.text = package.detail
				if package.price.isPromotion {
					priceLabel.text = "\(Utility.commaNumber(package.price.inapp)) \(Utility.commaNumber(package.price.inappDc)) บาท"
					discountLabel.text = "-\(Int(100.0-(100.0*Float(package.price.inappDc)/Float(package.price.inapp))))%"
					priceLabel.snp.remakeConstraints { (make) in
						make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
						make.bottom.equalTo(contentView.snp.bottom).offset(-MARGIN)
						make.height.equalTo(priceHeight)
						make.width.equalTo(108)
					}
					let total = "\(Utility.commaNumber(package.price.inapp))"
					let totalAttString = NSMutableAttributedString(string: "\(Utility.commaNumber(package.price.inapp)) \(Utility.commaNumber(package.price.inappDc)) บาท")
					totalAttString.addAttribute(.font, value: UIFont.kanitLight14, range: NSMakeRange(0, total.count))
					totalAttString.addAttribute(.strikethroughStyle, value: 1, range: NSMakeRange(0, total.count))
					priceLabel.attributedText = totalAttString
					
					Utility.show([discountView, discountLabel], hides: [])
					discountView.image = UIImage(named: "discountIcon")
				} else {
					priceLabel.text = "\(Utility.commaNumber(package.price.inapp)) บาท"
					priceLabel.snp.remakeConstraints { (make) in
						make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
						make.bottom.equalTo(contentView.snp.bottom).offset(-MARGIN)
						make.height.equalTo(priceHeight)
						make.width.equalTo(85)
					}
					discountView.hide()
					discountLabel.hide()
				}
			} else if let package = data as? PackageBundle {
				titleLabel.text = package.name
				timeLabel.text = ""
				packageProfileImageView.af_setImage(withURL: URL(string: package.imageURL)!, placeholderImage: UIImage(named: "logo"))
				detailLabel.text = package.details.joined(separator: "\n")
				priceLabel.text = "\(Utility.commaNumber(package.price.inapp)) \(Utility.commaNumber(package.price.inappDc)) บาท"
				discountLabel.text = "-\(Int(100.0-(100.0*Float(package.price.inappDc)/Float(package.price.inapp))))%"
				priceLabel.snp.remakeConstraints { (make) in
					make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
					make.bottom.equalTo(contentView.snp.bottom).offset(-MARGIN)
					make.height.equalTo(priceHeight)
					make.width.equalTo(108)
				}
				let total = "\(Utility.commaNumber(package.price.inapp))"
				let totalAttString = NSMutableAttributedString(string: "\(Utility.commaNumber(package.price.inapp)) \(Utility.commaNumber(package.price.inappDc)) บาท")
				totalAttString.addAttribute(.font, value: UIFont.kanitLight14, range: NSMakeRange(0, total.count))
				totalAttString.addAttribute(.strikethroughStyle, value: 1, range: NSMakeRange(0, total.count))
				priceLabel.attributedText = totalAttString
				
				Utility.show([discountView], hides: [])
				discountLabel.hide()
				discountView.image = UIImage(named: "proIcon")
			}
		} else {
			let myPackage = data as! dictStringAny
			let countdown = Datetime().daysBetween(Validation.anyIsNumber(myPackage, with: "endDate"))
			titleLabel.text = Validation.anyIsString(myPackage, with: "packageName")
			timeLabel.text = countdown > 0 ? "เหลืออีก \(countdown) วัน" : "หมดอายุ"
			packageProfileImageView.af_setImage(withURL: URL(string: Validation.anyIsString(myPackage, with: "packageImage"))!, placeholderImage: UIImage(named: "logo"))
			timeLabel.flexibleLine()
			Utility.show([titleLabel, timeLabel, packageProfileImageView], hides: [detailLabel, priceLabel, discountView, discountLabel])
			timeLabel.snp.remakeConstraints { (make) in
				make.leading.equalTo(titleLabel.snp.leading)
				make.top.equalTo(titleLabel.snp.bottom).offset(4)
				make.trailing.equalTo(titleLabel.snp.trailing)
			}
		}
	}
	
	func selectedPackage() {
		contentView.borderView(color: .brandcolor1, width: 1.0)
		priceLabel.textColor = .brandcolor1
		priceLabel.backgroundColor = .brandcolor3
	}
	func unselectedPackage() {
		contentView.borderView(color: .clear, width: 1.0)
		priceLabel.textColor = .white
		priceLabel.backgroundColor = .brandcolor1
	}
	
	fileprivate func setLayout() {
		packageProfileImageView.snp.makeConstraints { (make) in
			make.top.equalTo(contentView.snp.top).offset(MARGIN)
			make.leading.equalTo(contentView.snp.leading).offset(SMALLINSET)
			make.bottom.equalTo(contentView.snp.bottom).offset(-MARGIN)
			make.width.equalTo(packageProfileImageView.snp.height)
		}
		priceLabel.snp.makeConstraints { (make) in
			make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
			make.bottom.equalTo(contentView.snp.bottom).offset(-MARGIN)
			make.height.equalTo(priceHeight)
			make.width.equalTo(85)
		}
		titleLabel.snp.makeConstraints { (make) in
			make.leading.equalTo(packageProfileImageView.snp.trailing).offset(SMALLINSET)
			make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
			make.top.equalTo(contentView.snp.top).offset(12)
		}
		detailLabel.snp.makeConstraints { (make) in
			make.top.equalTo(titleLabel.snp.bottom).offset(2)
			make.leading.equalTo(titleLabel.snp.leading)
			make.trailing.equalTo(titleLabel.snp.trailing)
		}
		timeLabel.snp.makeConstraints { (make) in
			make.leading.equalTo(titleLabel.snp.leading)
			make.top.equalTo(detailLabel.snp.bottom).offset(2)
			make.width.equalTo(90)
			make.height.equalTo(21)
		}
		discountView.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize(width: 42, height: 35))
			make.top.equalTo(contentView.snp.top).offset(-2)
			make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
		}
		discountLabel.snp.makeConstraints { (make) in
			make.height.equalTo(18)
			make.leading.equalTo(discountView.snp.leading).offset(2)
			make.trailing.equalTo(discountView.snp.trailing).offset(-2)
			make.top.equalTo(discountView.snp.top).offset(4)
		}
	}
}
