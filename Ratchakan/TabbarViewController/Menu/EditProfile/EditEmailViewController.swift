//
//  EditEmailViewController.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 13/11/2568 BE.
//  Copyright © 2568 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

class EditEmailViewController: CustomViewControllerPushNavAndNoTabbar, CustomNavDelegate {
    
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
    var confirmButton: UIButton!
    var collectionView: UICollectionView!
    var collectionLayout: CollectionLayout!
    
    var titleNav: String?
    var listTitleName: [String] = ["อีเมล"]
    var email = BehaviorRelay<String>(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        confirmButton = UIButton()
        confirmButton.setImage(UIImage(named: "checkIcon"), for: .normal)
        confirmButton.adjustsImageWhenHighlighted = false
        confirmButton.adjustsImageWhenDisabled = false
        confirmButton.addTarget(self, action: #selector(updateProfile), for: .touchUpInside)
        topView.addSubview(confirmButton)
        view.addSubview(topView)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: MARGIN, bottom: 0, right: MARGIN)
        collectionView.regis(nibName: EditDisplayNameCollectionViewCell.cellIdentifier)
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
                make.centerY.equalTo(topView.snp.centerY).offset(INSET)
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(INSET)
                make.centerX.equalTo(topView.snp.centerX)
            }
            confirmButton.snp.makeConstraints { (make) in
                make.trailing.equalTo(topView.snp.trailing).offset(-5)
                make.centerY.equalTo(topView.snp.centerY).offset(INSET)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
        }else{
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.centerX.equalTo(topView.snp.centerX)
            }
            confirmButton.snp.makeConstraints { (make) in
                make.trailing.equalTo(topView.snp.trailing).offset(-5)
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS ? 12 : 24)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.collectionView.reloadData()
        }
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func showSuccessAlert(_ detail: String) {
        let successAlert = UIAlertController(title: string.th_purchase_success, message: detail, preferredStyle: UIAlertController.Style.alert)
        successAlert.addAction(UIAlertAction(title: string.th_ok, style: .default, handler: { action in self.back() }))
        Utility.getCurrentViewController().present(successAlert, animated: true, completion: nil)
    }
    
    func changeEmail(_ value: dictStringAny) {
        let api = API()
        api.updateEmail({ (finished, response) in
            if finished {
                self.showSuccessAlert("เปลี่ยนอีเมลเรียบร้อย")
            }else{
                let errorAlert = UIAlertController(title: string.th_fail_process, message: string.th_try_again, preferredStyle: UIAlertController.Style.alert)
                errorAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: nil))
                Utility.getCurrentViewController().present(errorAlert, animated: true, completion: nil)
            }
        }, value: value)
    }
    
    @objc func updateProfile() {
        var arrUpdate: dictStringAny = [:]
        if Validation.email(self.email.value) {
            arrUpdate = ["email": self.email.value]
            let api = API()
            api.duplicateEmail({ (finished, response) in
                if finished {
                    self.changeEmail(arrUpdate)
                }else{
                    dropdownAlert.title(string.th_error, message: "มีอีเมลนี้อยู่ในระบบ", backgroundColor: .errorRed, textColor: .white)
                }
            }, email: self.email.value)
        }
    }
    
}

extension EditEmailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listTitleName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditDisplayNameCollectionViewCell.cellIdentifier, for: indexPath) as! EditDisplayNameCollectionViewCell
        cell.setDisplayName(titleName: listTitleName[indexPath.item])
        cell.detailNameTextField.placeholder = "อีเมล"
        cell.textChanged = { [weak self] newText in
            self?.email.accept(newText)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 65)
    }
}
