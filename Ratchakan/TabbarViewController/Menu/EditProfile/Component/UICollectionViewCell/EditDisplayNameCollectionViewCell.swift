//
//  EditDisplayNameCollectionViewCell.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 14/11/2568 BE.
//  Copyright © 2568 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import UIKit

class EditDisplayNameCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "EditDisplayNameCollectionViewCell"
    
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var detailNameTextField: UITextField!
    
    var textChanged: ((String) -> Void)?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setDisplayName(titleName: String) {
        titleNameLabel.text = titleName
        detailNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
}

extension EditDisplayNameCollectionViewCell: UITextFieldDelegate {
    @objc private func textFieldDidChange(_ textField: UITextField) {
        textChanged?(textField.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.isSecureTextEntry {
            let currentPWText = textField.text ?? ""
            
            guard let stringRange = Range(range, in: currentPWText) else { return false }
            
            let updateText = currentPWText.replacingCharacters(in: stringRange, with: string)
            
            textField.text = updateText
            
            return false
        }
        return true
    }
}
