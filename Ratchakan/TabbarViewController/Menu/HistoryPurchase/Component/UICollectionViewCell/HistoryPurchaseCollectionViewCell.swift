//
//  HistoryPurchaseCollectionViewCell.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 11/11/2568 BE.
//  Copyright © 2568 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import UIKit

class HistoryPurchaseCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "HistoryPurchaseCollectionViewCell"
    
    @IBOutlet weak var paymentNameLabel: UILabel!
    @IBOutlet weak var paymentCodeLabel: UILabel!
    @IBOutlet weak var transactionDateLabel: UILabel!
    @IBOutlet weak var transactionStatusLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setHistoryPurchaseData(paymentData: PaymentHistory) {
        paymentNameLabel.text = paymentData.name
        paymentCodeLabel.text = "\(paymentData.paymentCode ?? "") (\(Validation.intDictionary(DataConfig.typePayment, withInt: paymentData.channel ?? 0)))"
        if let transactionDate = paymentData.transactionDate {
            transactionDateLabel.text = "\(string.th_operation_date) : \(Datetime().showDate(transactionDate, short: true, showTime: true))"
        }
        if paymentData.isPaid == true {
            transactionStatusLabel.text = "\(string.th_confirm_purchase)"
            transactionStatusLabel.textColor = .greenpurchase
        }else{
            transactionStatusLabel.text = "\(string.th_confirm_not_purchase)"
            transactionStatusLabel.textColor = .redPurchase
        }
    }
}
