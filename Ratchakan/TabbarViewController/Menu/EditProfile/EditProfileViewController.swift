//
//  EditProfileViewController.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 10/11/2568 BE.
//  Copyright © 2568 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class EditProfileViewController: CustomViewControllerPushNavAndNoTabbar, CustomNavDelegate {
    
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
    var collectionView: UICollectionView!
    var collectionLayout: CollectionLayout!
    var datePicker: PickerView!
    var dateFormatter: DateFormatter!
    var genderPicker: PickerView!
    let genderData = DataConfig.genderData
    var nowGender: String? = ""
    
    var titleNav: String?
    var memberDataSourceModel: MemberDataModel!
    
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
        view.addSubview(topView)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: MARGIN, bottom: 0, right: MARGIN)
        collectionView.regis(nibName: EditProfileCollectionViewCell.cellIdentifier)
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
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.getProfileMember()
        }
    }
    
    func getProfileMember() {
        let api = API()
        let memberData = api.getDatabase().getMember()
        self.memberDataSourceModel = Mapper<MemberDataModel>().map(JSON: memberData)
        self.collectionView.reloadData()
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
}

extension EditProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataConfig.editUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditProfileCollectionViewCell.cellIdentifier, for: indexPath) as! EditProfileCollectionViewCell
        if self.memberDataSourceModel != nil {
            cell.setEditProfileData(title: DataConfig.editUser[indexPath.item]?.key ?? "",index: indexPath.item,memberData: self.memberDataSourceModel)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EditProfileCollectionViewCell else { return }
        if self.memberDataSourceModel != nil {
            cell.setEditProfileData(title: DataConfig.editUser[indexPath.item]?.key ?? "",index: indexPath.item,memberData: self.memberDataSourceModel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let editDisplayNameVC = EditDisplayNameViewController()
            editDisplayNameVC.titleNav = "ชื่อ"
            self.navigationController?.pushViewController(editDisplayNameVC, animated: true)
        }else if indexPath.item == 1 {
            let editEmailVC = EditEmailViewController()
            editEmailVC.titleNav = "อีเมล"
            self.navigationController?.pushViewController(editEmailVC, animated: true)
        }else if indexPath.item == 2 {
            let confirmPhoneVC = ConfirmPhoneViewController()
            confirmPhoneVC.beforeView = "menu"
            confirmPhoneVC.modalTransitionStyle = .crossDissolve
            confirmPhoneVC.modalPresentationStyle = .fullScreen
            Utility.getCurrentViewController().present(confirmPhoneVC, animated: true, completion: nil)
        }else if indexPath.item == 3 {
            let editPasswordVC = EditPasswordViewController()
            editPasswordVC.titleNav = "รหัสผ่าน"
            self.navigationController?.pushViewController(editPasswordVC, animated: true)
        }
        else if indexPath.item == 4 {
            let bottomIfIpad: CGFloat = (IS_IPAD ? TABBAR_HEIGHT : 0)
            if datePicker == nil {
                datePicker = PickerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: PICKER_HEIGHT))
                datePicker.delegate = self
                datePicker.type = .date
            }
            if datePicker.pickerShow == false {
                if let birthDay = memberDataSourceModel.birthday {
                    datePicker.defaultDate = Datetime().fromThaiDate(birthDay)
                    let datexxx = Datetime().fromThaiDate(birthDay)
                    dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-dd"
                    datePicker.date = dateFormatter.string(from: datexxx)
                }
                datePicker.pickerShow = true
                view.addSubview(datePicker)
                datePicker.snp.remakeConstraints({ (make) in
                    make.leading.equalTo(view.snp.leading)
                    make.trailing.equalTo(view.snp.trailing)
                    make.bottom.equalTo(view.snp.bottom).offset(-bottomIfIpad)
                    make.height.equalTo(PICKER_HEIGHT)
                })
            }
        }else if indexPath.item == 5 {
            let bottomIfIpad: CGFloat = (IS_IPAD ? TABBAR_HEIGHT : 0)
            if genderPicker == nil {
                genderPicker = PickerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: PICKER_HEIGHT*2/3))
                genderPicker.superViewController = self
                genderPicker.delegate = self
                genderPicker.type = .gender
            }
            if not(genderPicker.pickerShow) {
                view.addSubview(genderPicker)
                genderPicker.snp.remakeConstraints({ (make) in
                    make.leading.equalTo(view.snp.leading)
                    make.trailing.equalTo(view.snp.trailing)
                    make.bottom.equalTo(view.snp.bottom).offset(-bottomIfIpad)
                    make.height.equalTo(PICKER_HEIGHT*2/3)
                })
            }
        }
    }
}

extension EditProfileViewController: PickerDateDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func setBirthDay(_ birthday: String) {
        var arrUpdate: dictStringAny = [:]
        if birthday != "" {
            arrUpdate = ["birthday": Datetime().birthDate(birthday)]
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
        }
    }
    
    func setGender(_ gender: String) {
        
    }
    
    func cancel() {
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderData[row].genderThai()
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var arrUpdate: dictStringAny = [:]
        if genderData[row] != "" {
            arrUpdate = ["gender": genderData[row]]
            let api = API()
            api.updateAccount({ (finished,response) in
                if finished {
                    self.back()
                }else{
                    let errorAlert = UIAlertController(title: string.th_fail_process, message: string.th_try_again, preferredStyle: UIAlertController.Style.alert)
                    errorAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: nil))
                    Utility.getCurrentViewController().present(errorAlert, animated: true, completion: nil)
                }
            }, value: arrUpdate)
        }
    }
}
