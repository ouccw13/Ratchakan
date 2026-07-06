//
//  DeleteAccountCollectionViewCell.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 13/6/2566 BE.
//  Copyright © 2566 BE Chatcha.sobtid. All rights reserved.
//

import UIKit

class DeleteAccountCollectionViewCell: UICollectionViewCell {
    static let identifier = "DeleteAccountCollectionViewCell"
    @IBOutlet weak var titleAccountLabel: UILabel!
    @IBOutlet weak var descriptionAccountLabel: UILabel!
    @IBOutlet weak var titleSubscriptionLabel: UILabel!
    @IBOutlet weak var descriptionSubscriptionLabel: UILabel!
    @IBOutlet weak var gotoSubscriptionButton: UIButton!
    
    func updateUI() {
        titleAccountLabel.font = .kanitMed14
        titleAccountLabel.textColor = .Celllabel
        descriptionAccountLabel.font = .kanitLight14
        descriptionAccountLabel.textColor = .Cellinformation
        
        titleSubscriptionLabel.font = .kanitMed14
        titleSubscriptionLabel.textColor = .Celllabel
        descriptionSubscriptionLabel.font = .kanitLight14
        descriptionSubscriptionLabel.textColor = .Cellinformation
        
        gotoSubscriptionButton.titleLabel?.font = .kanitLight14
        gotoSubscriptionButton.titleLabel?.text = "https://apps.apple.com/account/subscriptions"
    }
    
    @IBAction func didClickManageSubscription() {
        guard let url = URL(string: "https://apps.apple.com/account/subscriptions") else { return }
        UIApplication.shared.open(url)
    }
}
