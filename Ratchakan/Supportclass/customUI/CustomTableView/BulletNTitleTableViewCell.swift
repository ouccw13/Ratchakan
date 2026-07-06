//
//  BulletNTitleTableViewCell.swift
//  ratchakan
//
//  Created by JJsobtid on 30/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import WebKit
import DTCoreText

protocol BulletNTitleTableCellDelegate {
	func selectCell()
}

class BulletNTitleTableViewCell: UITableViewCell, WKNavigationDelegate {
	
	static let cellIdentifier: String = "BulletNTitleTableViewCell"
	
	var identifier: String!
	
	var bulletImage: UIImageView!
	var titleLabel: UILabel!
	var separateLine: UIView!
	var detailTextView: CustomTextView!
	var webViewText: CustomWebView!
	
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
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
        backgroundColor = .clear
		bulletImage = UIImageView()
		bulletImage.setParameter(name: "emptySelect", mode: .scaleAspectFit)
		
		titleLabel = UILabel()
        titleLabel.setParameter(font: .kanitReg22, color: .Celllabel, alignment: .left)
		
		separateLine = UIView()
		separateLine.lineView(withColor: .separateLine)
		
		contentView.addsubviews([bulletImage, titleLabel, separateLine])
		bulletImage.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize(width: 16, height: 16))
			make.leading.equalTo(contentView.snp.leading).offset(18.5)
			make.centerY.equalTo(contentView.snp.centerY)
		}
		titleLabel.snp.makeConstraints { (make) in
			make.leading.equalTo(bulletImage.snp.trailing).offset(10)
			make.trailing.equalTo(contentView.snp.trailing)/*.offset(-13.5)*/
            make.centerY.equalTo(contentView.snp.centerY).offset(-2)
			make.height.equalTo(26)
		}
		separateLine.snp.makeConstraints { (make) in
			make.leading.equalTo(bulletImage.snp.leading)
			make.trailing.equalTo(contentView.snp.trailing)
			make.bottom.equalTo(contentView.snp.bottom)
			make.height.equalTo(SEPARATE_LINE_WIDHT)
		}
	
		let configuration = WKWebViewConfiguration()
		webViewText = CustomWebView(frame: CGRect(x: 53, y: -20, width: SCREEN_WIDTH - 53 - MARGIN, height: 55), configuration: configuration)
		webViewText.navigationDelegate = self
		webViewText.backgroundColor = .clear
        webViewText.scrollView.contentInset = UIEdgeInsets(top: MARGIN, left: 0, bottom: MARGIN, right: 0)
		webViewText.scrollView.layer.masksToBounds = false
		webViewText.isOpaque = false
		webViewText.scrollView.isScrollEnabled = false
		webViewText.isUserInteractionEnabled = false
		webViewText.clipsToBounds = true
		
		contentView.clipsToBounds = true
		
		contentView.addSubview(webViewText)
		
		webViewText.hide()
	}
	
	func setData(title: String, selected: Bool, last: Bool) {
//		let ran = (arc4random() % 2 == 1 ? true : false)
		titleLabel.text = title
		last ? separateLine.hide() : separateLine.show()
		if selected {
			bulletImage.setParameter(name: "selectedIcon", mode: .scaleAspectFit)
		} else {
			bulletImage.setParameter(name: "emptySelect", mode: .scaleAspectFit)
		}
	}
	
	func setQuestion(title: String, selected: Bool, last: Bool) {
		//		let ran = (arc4random() % 2 == 1 ? true : false)
//		let title = (arc4random() % 2 == 1 ? title : title + "<img src=\"\">")
		if Validation.mathMLDetect(title.removeHtmlTagWithP()) {
			titleLabel.hide()
			webViewText.show()
			webViewText.setQuestionList(title.removeHtmlTagWithP())
		} else {
			titleLabel.show()
			webViewText.hide()
			let fontSize: CGFloat = 22
			let coreText: dictStringAny = [DTDefaultFontFamily : "Sarabun",
										   DTUseiOS6Attributes : true,
										   DTDefaultFontSize : fontSize,
										   DTDefaultFontName : "Sarabun",
										   DTDefaultTextColor: DTHexStringFromDTColor(.Celllabel)]
			let data = title.removeHtmlTagWithP().data(using: .utf8)
			let attString = NSMutableAttributedString(htmlData: data, options: coreText, documentAttributes: nil)
			DTCoreTextFontDescriptor.overrideFontNameforFontFamily("Sarabun", bold: false, italic: false)

			attString?.addAttribute(.foregroundColor, value: UIColor.Celllabel, range: NSRange(location: 0, length: attString!.length))
			titleLabel.text = title
//			titleLabel.numberOfLines = 0
			titleLabel.attributedText = attString!
			titleLabel.lineBreakMode = .byTruncatingTail
		}
		last ? separateLine.hide() : separateLine.show()
		if selected {
			bulletImage.setParameter(name: "selectedIcon", mode: .scaleAspectFit)
		} else {
			bulletImage.setParameter(name: "emptySelect", mode: .scaleAspectFit)
		}
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
	}
}
