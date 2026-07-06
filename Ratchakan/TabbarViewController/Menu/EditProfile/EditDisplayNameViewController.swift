//
//  EditDisplayNameViewController.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 13/11/2568 BE.
//  Copyright © 2568 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

class EditDisplayNameViewController: CustomViewControllerPushNavAndNoTabbar, CustomNavDelegate {
    
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
    var confirmButton: UIButton!
    var collectionView: UICollectionView!
    var collectionLayout: CollectionLayout!
    
    var titleNav: String?
    var listTitleName: [String] = ["ชื่อจริง","นามสกุล"]
    var firstName = BehaviorRelay<String>(value: "")
    var lastName = BehaviorRelay<String>(value: "")
    
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
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS ?  12 : 24)
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
    
    @objc func updateProfile() {
        var arrUpdate: dictStringAny = [:]
        if not(self.firstName.value.trimSpace().isEmpty) && not(self.lastName.value.trimSpace().isEmpty) {
            arrUpdate = ["name": self.firstName.value,
                                             "surname": self.lastName.value,
                                             "displayName": "\(self.firstName.value) \(self.lastName.value)"]
          let api = API()
            api.updateAccount({ (finished, response) in
                if finished {
                    self.back()
                }else{
                    let errorAlert = UIAlertController(title: string.th_fail_process, message: string.th_try_again, preferredStyle: UIAlertController.Style.alert)
                    errorAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: nil))
                    Utility.getCurrentViewController().present(errorAlert, animated: true, completion: nil)
                }
            }, value: arrUpdate)
        }else{
            dropAlertWith(string.th_fill_field)
        }
    }
    
    fileprivate func dropAlertWith(_ title: String) {
        dropdownAlert.title(string.th_error, message: title, textColor: .white)
    }
}

extension EditDisplayNameViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listTitleName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditDisplayNameCollectionViewCell.cellIdentifier, for: indexPath) as! EditDisplayNameCollectionViewCell
        cell.setDisplayName(titleName: listTitleName[indexPath.item])
        if indexPath.item == 0 {
            cell.detailNameTextField.placeholder = "ชื่อ"
            cell.textChanged = { [weak self] newText in
                self?.firstName.accept(newText)
            }
        }else if indexPath.item == 1 {
            cell.detailNameTextField.placeholder = "นามสกุล"
            cell.textChanged = { [weak self] newText in
                self?.lastName.accept(newText)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 65)
    }
}
