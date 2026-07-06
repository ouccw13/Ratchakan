//
//  EditProfileCollectionViewCell.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 12/11/2568 BE.
//  Copyright © 2568 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import UIKit

class EditProfileCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "EditProfileCollectionViewCell"
    
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var detailNameLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setEditProfileData(title: String,index: Int, memberData: MemberDataModel) {
        titleNameLabel.text = title
        if index == 0 {
            detailNameLabel.text  = memberData.displayName
        }else if index == 1 {
            if Validation.email(memberData.email ?? "") {
                titleNameLabel.setParameter(font: .kanitReg16, color: .successgreen)
            }else{
                titleNameLabel.setParameter(font: .kanitReg16, color: .Celllabel)
            }
            detailNameLabel.text = memberData.email
        }else if index == 2 {
            if Validation.tel(memberData.phoneNumber ?? "") {
                titleNameLabel.setParameter(font: .kanitReg16, color: .successgreen)
            }else{
                titleNameLabel.setParameter(font: .kanitReg16, color: .Celllabel)
            }
            detailNameLabel.text = memberData.phoneNumber
        }else if index == 3 {
            detailNameLabel.text = string.th_change_password
        }else if  index == 4 {
            if memberData.birthday != "" {
                detailNameLabel.text = memberData.birthday
            }else{
                detailNameLabel.text = string.th_unknown
            }
        }else{
            detailNameLabel.text = memberData.gender?.genderThai()
        }
    }
}
