//
//  ContactUsViewController.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 10/11/2568 BE.
//  Copyright © 2568 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class ContactUsViewController: CustomViewControllerPushNavAndNoTabbar, CustomNavDelegate {
    
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
    var collectionView: UICollectionView!
    var collectionLayout: CollectionLayout!

    var titleNav: String?
    var contactUsDataSource: ContactUsDataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        menuViewModel = MenuViewModel()
        topView = UIView()
        topView.backgroundColor = .navbrandcolor
        view.backgroundColor = .brandcolor_bg
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.setAnimatedTouch()
        backButton.adjustsImageWhenHighlighted = false
        backButton.adjustsImageWhenDisabled = false
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        topView.addSubview(backButton)
        
        navTitleLabel = UILabel()
        navTitleLabel.text = self.titleNav
        navTitleLabel.setParameter(font: .navTitleFont, color: .cellWhiteLabel)
        navTitleLabel.numberOfLines = 2
        navTitleLabel.lineBreakMode = .byWordWrapping
        topView.addSubview(navTitleLabel)
        view.addSubview(topView)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: MARGIN, bottom: 0, right: MARGIN)
        collectionView.regis(nibName: ContactUsColletionViewCell.cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.height.equalTo(TOP_VIEW)
        }
        
        if IS_IPAD {
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY)/*.offset(INSET)*/
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
//                make.leading.equalTo(backButton.snp.trailing).offset(10)
                make.centerY.equalTo(topView.snp.centerY)/*.offset(INSET)*/
                make.centerX.equalTo(topView.snp.centerX)
//                make.trailing.equalTo(topView.snp.trailing).offset(-10)
            }
        }else{
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
//                make.leading.equalTo(backButton.snp.trailing).offset(10)
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6  || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.centerX.equalTo(topView.snp.centerX)
//                make.trailing.equalTo(topView.snp.trailing).offset(-10)
            }
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.getContactUsData()
        }
    }
    
    func getContactUsData() {
        let api = API()
        api.getContactUs({ (finished,response) in
            self.contactUsDataSource = Mapper<ContactUsDataModel>().map(JSON: response ?? [:])
            self.collectionView.reloadData()
        })
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
}

extension ContactUsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactUsColletionViewCell.cellIdentifier, for: indexPath)
        as! ContactUsColletionViewCell
        if self.contactUsDataSource != nil {
            if let contactData = self.contactUsDataSource.resultContactUS {
                if indexPath.row == 0 {
                    cell.setContactData(title: contactData.company ?? "" , detail: "56/1 ซอยเรวดี ถนนพระราม 6 แขวงสามเสนใน เขตพญาไท กรุงเทพมหานคร 10400")
                }else if indexPath.row == 1 {
                    cell.setContactData(title: "Tel" , detail: "02-060-2889")
                }else if indexPath.row == 2 {
                    cell.setContactData(title: "Email" , detail: contactData.email ?? "")
                }else if indexPath.row == 3 {
                    cell.setContactData(title: "Line" , detail: contactData.line ?? "")
                }else if indexPath.row == 4 {
                    cell.setContactData(title: "Instagram" , detail: contactData.instagram ?? "")
                }else if indexPath.row == 5 {
                    cell.setContactData(title: "Facebook" , detail: contactData.facebook ?? "")
                }else{
                    cell.setContactData(title: "Twitter", detail: contactData.twitter ?? "")
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ContactUsColletionViewCell else { return }
        if let contactData = self.contactUsDataSource.resultContactUS {
            if indexPath.row == 0 {
                cell.setContactData(title: contactData.company ?? "" , detail: contactData.address ?? "")
            }else if indexPath.row == 1 {
                cell.setContactData(title: "Tel" , detail: contactData.tel ?? "")
            }else if indexPath.row == 2 {
                cell.setContactData(title: "Email" , detail: contactData.email ?? "")
            }else if indexPath.row == 3 {
                cell.setContactData(title: "Line" , detail: contactData.line ?? "")
            }else if indexPath.row == 4 {
                cell.setContactData(title: "Instagram" , detail: contactData.instagram ?? "")
            }else if indexPath.row == 5 {
                cell.setContactData(title: "Facebook" , detail: contactData.facebook ?? "")
            }else{
                cell.setContactData(title: "Twitter", detail: contactData.twitter ?? "")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let contactData = self.contactUsDataSource.resultContactUS {
            var parameter = ""
            if indexPath.row == 0 {
                Utility.openMapOffice()
            }else if indexPath.row == 1 {
                parameter =  "02-060-2889"
                let strUrl = "tel::\(parameter)"
                if let urlTel = URL(string: strUrl) {
                    if UIApplication.shared.canOpenURL(urlTel) {
                        UIApplication.shared.open(urlTel)
                    }
                }
            }else if indexPath.row == 2 {
                parameter = contactData.email ?? ""
                let strUrl = "mailto:\(parameter)?subject=Customer Feedback"
                if let urlMail = URL(string: strUrl) {
                    if UIApplication.shared.canOpenURL(urlMail) {
                        UIApplication.shared.open(urlMail)
                    }
                }
            }else if indexPath.row == 3 {
                parameter = contactData.line ?? ""
                let strUrl = "http://line.me/ti/p/~\(parameter)"
                if let urlLine = URL(string: strUrl) {
                    if UIApplication.shared.canOpenURL(urlLine) {
                        UIApplication.shared.open(urlLine)
                    }
                }
            }else if indexPath.row == 4 {
                parameter = contactData.instagram ?? ""
                let strUrl = "https://www.instagram.com/\(parameter)/?hl=en"
                if let urlInstagram = URL(string: strUrl) {
                    if UIApplication.shared.canOpenURL(urlInstagram) {
                        UIApplication.shared.open(urlInstagram)
                    }
                }
            }else if indexPath.row == 5 {
                parameter = contactData.facebookId ?? ""
                let strUrl = "https://www.facebook.com/\(parameter)/"
                if let urlFacebook = URL(string: strUrl) {
                    if UIApplication.shared.canOpenURL(urlFacebook) {
                        UIApplication.shared.open(urlFacebook)
                    }
                }
            }else{
                parameter = contactData.twitterId ?? ""
                let strUrl = "https://x.com/\(parameter)"
                if let urlX = URL(string: strUrl) {
                    if UIApplication.shared.canOpenURL(urlX) {
                        UIApplication.shared.open(urlX)
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: collectionView.frame.width, height: IS_IPAD ? 70 : 100)
        }else{
            return CGSize(width: collectionView.frame.width, height: 70)
        }
    }
}
