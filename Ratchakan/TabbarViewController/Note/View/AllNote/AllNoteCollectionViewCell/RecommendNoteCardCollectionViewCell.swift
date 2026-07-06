//
//  RecommendNoteCardCollectionViewCell.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 17/7/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit

class NoteCardCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RecommendCard"
    
    private let noteImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.dropShadow(color: .blackAlpha(alpha: 0.16))
        
        setupUI()
    }
    
    private func setupUI() {
        let tempImage:UIView = {
            let view = UIView()
            view.backgroundColor = .gray
            return view
        }()
        
        addSubview(tempImage)
        tempImage.snp.makeConstraints { (make) in
            let size = CGSize(width: contentView.frame.width, height: contentView.frame.width)
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.size.equalTo(size)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
