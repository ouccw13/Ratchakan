//
//  MenuButtonTableViewCell.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 3/11/2568 BE.
//  Copyright © 2568 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import UIKit

class MenuButtonTableViewCell: UITableViewCell {
    
    static let identifier = "MenuButtonTableViewCell"
    var menuData: [String: Any]! {
        didSet {
            let title = menuData["title"] as! String
            let imageName = menuData["imageName"] as! String
            titleLabel.text = title
            titleIconImageView.image = UIImage(named: imageName)
            if imageName == "appleIcon" {
                titleIconImageView.setImageColor(color: .black)
            }
            titleIconImageView.frame.size.width = 80
            titleIconImageView.frame.size.height = 80
        }
    }
    
    var titleLabel: UILabel!
    private var titleIconImageView: UIImageView!
    var arrowImageView: UIImageView!
    var versionNameLabel: UILabel!
    private var separatorLineView: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        separatorLineView = UIView()
        separatorLineView.backgroundColor = .brandcolor1
        contentView.addSubview(separatorLineView)
        separatorLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.bottom.equalTo(contentView.snp.bottom)
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
        
        titleIconImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
        contentView.addSubview(titleIconImageView)
        titleIconImageView.snp.makeConstraints {
            $0.size.equalTo(IS_IPAD ? 28 : 16)
            $0.leading.equalTo(contentView.snp.leading).offset(18)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
        
//        titleLabel = CustomLabel(withTitle: "security_account".localized(),
//                                 font: IS_IPAD ? .kanitReg20 : .kanitMed14,
//                                 color: .secondaryBlackColor,
//                                 alignment: .left)
        titleLabel = UILabel()
        titleLabel.setParameter(font: .kanitMed18, color: .Celllabel)
        titleLabel.unFlexibleLine()
        contentView.addSubview(titleLabel)
        
//       versionNameLabel = CustomLabel(withTitle: "security_account".localized(),
//                                      font: .kanitReg16,
//                                 color: .secondaryBlackColor)
        versionNameLabel = UILabel()
        versionNameLabel.setParameter(font: .kanitMed18, color: .Celllabel)
        versionNameLabel.unFlexibleLine()
        versionNameLabel.hide()
        contentView.addSubview(versionNameLabel)
        
        arrowImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "icExamNext")
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        contentView.addSubview(arrowImageView)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleIconImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(arrowImageView.snp.leading).offset(-8)
            $0.centerY.equalTo(titleIconImageView.snp.centerY)
        }
        
        versionNameLabel.snp.makeConstraints {
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
    func setupCell(menuData: [String: Any], lastCell: Bool) {
        self.menuData = menuData
        let title = menuData["title"] as! String
        let imageName = menuData["imageName"] as! String
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        if imageName == "appleIcon" {
            titleIconImageView.setImageColor(color: .brandcolor1)
        }
//        if title == "language" {
//            if #available(iOS 13.0, *) {
//                if UITraitCollection.current.userInterfaceStyle == .dark {
//                    titleIconImageView.image = UIImage(named: ImageNames.Menu.languageDark)?.withTintColor(.mainPink, renderingMode: .alwaysOriginal)
//                }
//                else {
//                    titleIconImageView.image = UIImage(named: ImageNames.Menu.language)?.withTintColor(.mainPink, renderingMode: .alwaysOriginal)
//                }
//            }
//        }else
        if title == "version" {
            titleIconImageView.image = UIImage(named: "iconVersionApp")
            versionNameLabel.show()
            arrowImageView.hide()
            versionNameLabel.set(text: Utility.getAppVersion())
        }
        else{
            versionNameLabel.hide()
            arrowImageView.show()
            titleIconImageView.image = UIImage(named: imageName)
        }
        titleIconImageView.frame.size.width = 80
        titleIconImageView.frame.size.height = 80
        separatorLineView.isHidden = lastCell
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
