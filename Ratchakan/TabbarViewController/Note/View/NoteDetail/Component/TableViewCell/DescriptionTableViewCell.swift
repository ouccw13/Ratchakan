//
//  DescriptionTableViewCell.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 17/8/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit

protocol descriptionCellDelegate {
    func actionButtonDidPress(owned: Bool)
    func tagDidTap(tag: SearchTag)
}

class DescriptionTableViewCell: UITableViewCell {
    
    static let identifier = "DescriptionCell"
    
    var delegate: descriptionCellDelegate?
    
    var note: Note! {
        didSet {
            titleLabel.text = note.name
            descriptionLabel.text = note.description
            let buttonText = note.isMyNote ? "อ่านโน้ต" : (note.priceTier.cash.price == 0) ? "ฟรี" : "ราคา \(note.priceTier.cash.price) บาท"
            actionButton.setTitle(buttonText, for: .normal)
            updateUI()
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setParameter(font: .kanitReg16, color: .Celllabel, alignment: .left)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.setParameter(font: .kanitReg12, color: .placeholdercolor, alignment: .left)
        label.numberOfLines = 0
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.setParameter("", textColor: .white, font: .kanitReg16, backgroundColor: .weakness_d_s)
        return button
    }()
    
    private var tagCollectionView: UICollectionView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupCollectionView()
        setupUI()
    }
    
    private func setupCollectionView() {
        tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: TagFlowLayout())
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.isScrollEnabled = false
        tagCollectionView.backgroundColor = .clear
        tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(MARGIN)
            make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
            make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
            make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
        }

        contentView.addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(MARGIN)
            make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
            make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
            make.height.equalTo(0)
        }
        
        contentView.addSubview(actionButton)
        actionButton.snp.makeConstraints { (make) in
            make.top.equalTo(tagCollectionView.snp.bottom).offset(MARGIN)
            make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
            make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
            make.bottom.equalTo(contentView.snp.bottom).offset(-MARGIN)
            make.height.equalTo(50)
        }
        actionButton.cornerView(radius: 25)
        actionButton.addTarget(self, action: #selector(actionButtonDidTap(sender:)), for: .touchUpInside)
        
    }
    
    private func updateUI() {
        tagCollectionView.snp.remakeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(MARGIN)
            make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
            make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
            make.height.equalTo(self.collectionViewHeight())
        }
    }
    
    private func collectionViewHeight() -> CGFloat{
        
        var numberOfRow = 1
        let collectionWidth = SCREEN_WIDTH - 32
        
        var currentWidth:CGFloat = 0
        
        for item in note.tags! {
            
            let textWidth = item.name.width(withConstrainedHeight: 3, font: .kanitLight14)
            
            if currentWidth + textWidth < collectionWidth {
                currentWidth += textWidth + 8
            } else {
                numberOfRow += 1
                currentWidth = textWidth + 8
            }
        }
        return CGFloat((32 * numberOfRow))
    }
    
    @objc private func actionButtonDidTap(sender: UIButton) {
        delegate?.actionButtonDidPress(owned: note.isMyNote)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DescriptionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return note.tags!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as! TagCollectionViewCell
        cell.titleText = note.tags![indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let textWidth = note.tags![indexPath.row].name.width(withConstrainedHeight: 3, font: .kanitLight14)
        let width = (textWidth > collectionView.frame.width) ? collectionView.frame.width - 16 : textWidth
        return .init(width: width + 16, height: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.tagDidTap(tag: note.tags![indexPath.row])
    }
}


