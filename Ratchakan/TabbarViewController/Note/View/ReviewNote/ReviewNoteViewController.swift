//
//  ReviewViewController.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 25/8/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit
import Cosmos

class ReviewNoteViewController: CustomViewControllerPushNavAndNoTabbar {
    
    var viewModel: ReviewNoteViewModel!
    
    var scoreValue: Double = 0 {
        didSet {
            ratingStar.rating = scoreValue
        }
    }
    
    var givenComment: String? {
        didSet {
            if let text = givenComment {
                commentTextView.text = text
                commentTextView.textColor = .greyishBrown
            }
        }
    }
    
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
    
//    private let navigationView: CustomNav = {
//        let nav = CustomNav(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TOP_VIEW))
//        nav.viewModel = CustomViewModelFromNav(withNav: Nav(title: "รายละเอียด", isBack: true, isRight: false, color: UIColor.navbrandcolor))
//        return nav
//    }()
    
    private let ratingStar: CosmosView = {
           let view = CosmosView()
           view.settings.filledImage = UIImage(named: "iconStar1Large")
           view.settings.emptyImage = UIImage(named: "iconStar3Large")
           view.settings.updateOnTouch = true
           view.settings.starSize = 25
           view.settings.starMargin = 10
           view.settings.totalStars = 5
           view.settings.fillMode = .full
           view.rating = 0
           return view
    }()
    
    private let commentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .kanitLight14
        textView.textColor = .brownGrey
        textView.text = "เพิ่มความคิดเห็น"
        return textView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .kanitLight14
        label.textColor = .brownGrey
        label.text = "เพิ่มความคิดเห็น"
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setParameter("ยืนยัน", textColor: .white, font: .kanitReg16, backgroundColor: .weakness_d_s)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .brandcolor_bg
        
        setupUI()
        hideKeyboardWhenTappedAround()
    }
    
    private func setupUI() {
        let scoreBgView = UIView()
        scoreBgView.backgroundColor = .white
        
        let headLabel: UILabel = {
            let label = UILabel()
            label.font = .kanitLight14
            label.textColor = .greyishBrown
            label.text = "ให้คะแนน"
            return label
        }()
        
        topView = UIView()
        topView.backgroundColor = .navbrandcolor
        
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(TOP_VIEW)
        }
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.setAnimatedTouch()
        backButton.adjustsImageWhenHighlighted = false
        backButton.adjustsImageWhenDisabled = false
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        topView.addSubview(backButton)
        
        navTitleLabel = UILabel()
        navTitleLabel.setParameter(font: .navTitleFont, color: .cellWhiteLabel)
        navTitleLabel.numberOfLines = 2
        navTitleLabel.lineBreakMode = .byWordWrapping
        navTitleLabel.set(text: "รายละเอียด")
        topView.addSubview(navTitleLabel)
//        navigationView.delegate = self
        
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
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.centerX.equalTo(topView.snp.centerX)
//                make.trailing.equalTo(topView.snp.trailing).offset(-10)
            }
        }
        
        view.addSubview(scoreBgView)
        scoreBgView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(TOP_VIEW + 16)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        scoreBgView.addSubview(headLabel)
        headLabel.snp.makeConstraints { (make) in
            make.top.equalTo(scoreBgView.snp.top).offset(12)
            make.leading.equalTo(scoreBgView.snp.leading).offset(16)
        }
        
        scoreBgView.addSubview(ratingStar)
        ratingStar.snp.makeConstraints { (make) in
            make.centerX.equalTo(scoreBgView.snp.centerX)
            make.top.equalTo(scoreBgView.snp.top).offset(36)
            make.bottom.equalTo(scoreBgView.snp.bottom).offset(-36)
        }
        
        let textBgView = UIView()
        textBgView.backgroundColor = .white
        
        view.addSubview(textBgView)
        textBgView.snp.makeConstraints { (make) in
            make.top.equalTo(scoreBgView.snp.bottom).offset(24)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(135)
        }
        textBgView.layer.cornerRadius = 11.2
        textBgView.layer.borderColor = UIColor.lightgraybg.cgColor
        textBgView.layer.borderWidth = 1
        
        textBgView.addSubview(commentTextView)
        commentTextView.snp.makeConstraints { (make) in
            make.top.equalTo(textBgView.snp.top).offset(16)
            make.bottom.equalTo(textBgView.snp.bottom).offset(-16)
            make.leading.equalTo(textBgView.snp.leading).offset(16)
            make.trailing.equalTo(textBgView.snp.trailing).offset(-16)
        }
        commentTextView.delegate = self
        
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(textBgView.snp.bottom).offset(24)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(50)
        }
        confirmButton.cornerView(radius: 25)
        confirmButton.addTarget(self, action: #selector(confirmButtonDidTap(sender:)), for: .touchUpInside)
    }
    
    @objc func confirmButtonDidTap(sender: UIButton) {
        viewModel.commentNote(rating: ratingStar.rating, comment: commentTextView.text ?? "") { (finished) in
            if finished {
                self.navigationController?.popViewController(animated: true)
            } else {
                let alert = UIAlertController(title: "เกิดข้อผิดพลาด", message: "ไม่สามารถให้คะแนนโน้ตได้", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ตกลง", style: .default))
                self.present(alert, animated: true)
            }
        }
    }

}

extension ReviewNoteViewController: CustomNavDelegate, UITextViewDelegate {
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .brownGrey {
            textView.text = nil
            textView.textColor = .greyishBrown
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "เพิ่มความคิดเห็น"
            textView.textColor = .brownGrey
        }
    }
    
}
