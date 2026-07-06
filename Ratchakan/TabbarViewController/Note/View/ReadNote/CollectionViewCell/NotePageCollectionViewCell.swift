//
//  NotePageCollectionViewCell.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 31/8/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit

class NotePageCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    static let identifier = "NotePageCell"
    
    var noteImage: NoteImage! {
        didSet {
            let url = URL(string: noteImage.url)
            imageView.sd_setImage(with: url)
            if !isMyNote {
                blurView.isHidden = noteImage.isPreview
                lock.isHidden = noteImage.isPreview
                unlockLabel.isHidden = noteImage.isPreview
            }
        }
    }
    
    var isMyNote: Bool = false
    
    var whenScrollViewZoomed: (() -> ())!
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .black
        sv.alwaysBounceVertical = false
        sv.alwaysBounceHorizontal = false
        sv.flashScrollIndicators()
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.minimumZoomScale = 1.0
        sv.maximumZoomScale = 5.0
        return sv
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    let lock = UIImageView(image: UIImage(named: "iconLock"))

    let unlockLabel: UILabel = {
        let label = UILabel()
        label.text = "กรุณาซื้อโน้ต"
        label.font = .kanitReg16
        label.textColor = .brownGrey
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        scrollView.delegate = self
        
        contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        }
        
        contentView.addSubview(blurView)
        blurView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        blurView.isHidden = true
        
        contentView.addSubview(lock)
        lock.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 40, height: 48))
            make.center.equalTo(blurView.snp.center)
        }
        lock.isHidden = true
        contentView.addSubview(unlockLabel)
        unlockLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(lock.snp.centerX)
            make.top.equalTo(lock.snp.bottom).offset(12)
        }
        unlockLabel.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        whenScrollViewZoomed()
    }
}
