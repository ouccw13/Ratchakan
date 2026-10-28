//
//  HeaderMenuView.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 10/11/2568 BE.
//  Copyright © 2568 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import UIKit

class HeaderMenuView: BasedView {
    
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setHeaderMenuData(member: member) {
        if member.gender != "" {
            profileIcon.cornerView(radius: 40.0)
            self.profileIcon.image = UIImage(named: member.gender)
        }else{
            if member.member_id != "" {
                profileIcon.image = UIImage(named: "unknown")
            }
        }
        if member.member_id != "" {
            self.profileNameLabel.text = "\(member.name)  \(member.surname)"
            self.profileDescriptionLabel.textColor = .guestcolor
            var numPackage = 0
            for package in member.packages {
                if package.endDate >= Datetime.getCurrentTimestamp() {
                    numPackage += 1
                }
            }
            if numPackage != 0 {
                self.profileDescriptionLabel.text = "คุณมี \(numPackage) แพ็กเกจ"
            }else{
                self.profileDescriptionLabel.text = "ยังไม่ได้สมัคร​แพ็กเกจ"
            }
        }
    }
}
