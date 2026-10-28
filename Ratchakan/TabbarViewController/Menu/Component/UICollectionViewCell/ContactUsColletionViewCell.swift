//
//  contactUsColletonViewCell.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 10/11/2568 BE.
//  Copyright © 2568 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import UIKit

class ContactUsColletionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "ContactUsColletionViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var lineBottomView: UIView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setContactData(title: String, detail:String) {
        titleLabel.text = title
        detailLabel.text = detail
        detailLabel.numberOfLines = 0
        detailLabel.lineBreakMode = .byWordWrapping
    }
}
