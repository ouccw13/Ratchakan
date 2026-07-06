//
//  PreviewCollectionViewCell.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 31/8/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit

class PreviewCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PreviewCell"
    
    var noteImage: NoteImage! {
        didSet {
            let url = URL(string: noteImage.url)
            imageView.sd_setImage(with: url)
            if !isMyNote {
                blurView.isHidden = noteImage.isPreview
                lock.isHidden = noteImage.isPreview
            }
        }
    }
    var isMyNote: Bool = false
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        return iv
    }()
    
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    let lock = UIImageView(image: UIImage(named: "iconLock"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .black
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        imageView.layer.borderColor = UIColor.reddishPink.cgColor

        imageView.addSubview(blurView)
        blurView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        blurView.isHidden = true

        contentView.addSubview(lock)
        lock.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 16, height: 19))
            make.center.equalTo(blurView.snp.center)
        }
        lock.isHidden = true
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.layer.borderWidth = isSelected ? 1 : 0
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
