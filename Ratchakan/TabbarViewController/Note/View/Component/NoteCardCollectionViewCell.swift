//
//  RecommendNoteCardCollectionViewCell.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 17/7/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit
import Cosmos

class NoteCardCollectionViewCell: UICollectionViewCell {
    
    var viewModel: Note! {
        didSet {
            noteTitle.text = viewModel.name
            ownerLabel.text = viewModel.publisher.name
            sellLabel.text = "ขายได้ \(viewModel.soldCount!) ชุด"
            let avgRating = viewModel.rating.point/Double(viewModel.rating.count)
            ratingStar.rating = (viewModel.rating.count != 0) ? (avgRating * 100)/5  : 0
            loveButton.setImage(UIImage(named: viewModel.isFavorite == true  ? "iconLoved" : "iconLove"), for: .normal)
            readButton.isHidden = !viewModel.isMyNote
            sellLabel.isHidden = viewModel.isMyNote
            noteImageView.sd_setImage(with: URL(string: viewModel.thumbnail!))
            if viewModel.publisher.logo ?? "" == "https://exambank.s3.ap-southeast-1.amazonaws.com/images/publisher/https://exambank.s3.ap-southeast-1.amazonaws.com/images/publisher/logo-1604998358178.png" {
                ownerImage.sd_setImage(with: URL(string: "https://exambank.s3.ap-southeast-1.amazonaws.com/images/publisher/logo-1604998358178.png"))
            }else{
                ownerImage.sd_setImage(with: URL(string: viewModel.publisher.logo ?? ""))
            }
            priceLabel.text = (viewModel.priceTier.cash.price == 0) ? "ฟรี" : String(viewModel.priceTier.cash.price)
            bahtLabel.isHidden = viewModel.priceTier.cash.price == 0
        }
    }
    
    var noteTag: NoteTag = .none {
        didSet {
            updateTag(tag: noteTag)
        }
    }
    
    var lovebuttonDidTap: ((Note) -> ())!
    var readButtonDidTap: ((String) -> ())!
    
    static let identifier = "NoteCard"
    
    private let noteImageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "testNoteImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let noteTitle: UILabel! = {
        let label = UILabel()
        label.font = .kanitReg14
        label.textColor = .Celllabel
        return label
    }()
    
    private let ownerLabel: UILabel! = {
        let label = UILabel()
        label.font = .kanitReg12
        label.textColor = .white
        return label
    }()
    
    private let ownerImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(named: "logo")
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.cornerView()
        return imageView
    }()
    
    let bahtLabel: UILabel = {
        let label = UILabel()
        label.text = "฿"
        label.font = .kanitReg12
        label.textColor = .weakness_d_s
        return label
    }()
    
    private let priceLabel: UILabel! = {
        let label = UILabel()
        label.font = .kanitReg18
        label.textColor = .weakness_d_s
        return label
    }()
    
    private let sellLabel: UILabel! = {
        let label = UILabel()
        label.font = .kanitLight10
        label.textColor = .placeholdercolor
        return label
    }()
    
    private var ratingStar: CosmosView = {
        let view = CosmosView()
        view.settings.filledImage = UIImage(named: "iconStar1Small")
        view.settings.emptyImage = UIImage(named: "iconStar3Small")
        view.settings.updateOnTouch = false
        view.settings.starSize = 10
        view.settings.starMargin = 2
        view.settings.totalStars = 5
        view.settings.fillMode = .half
        view.rating = 0
        return view
    }()
    
    private let bannerView: UIView! = {
        let view = UIView()
        view.backgroundColor = .clearBlue
        return view
    }()
    
    private let bannerText: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .kanitReg10
        return label
    }()
    
    private let loveButton: UIButton! = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconLove"), for: .normal)
        button.backgroundColor = .clearCanTouch
        return button
    }()
    
    private let readButton: UIButton! = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 56, height: 28))
        button.setParameter("อ่านโน้ต", textColor: .weakness_d_s, font: .kanitReg10, backgroundColor: .clearCanTouch)
        button.layer.cornerRadius = 14
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.weakness_d_s.cgColor
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.dropShadow(color: .blackAlpha(alpha: 0.16))
        
        setupUI()
    }
    
    private func setupUI() {
        
        // note image
        
        contentView.addSubview(noteImageView)
        noteImageView.snp.makeConstraints { (make) in
            let size = CGSize(width: contentView.frame.width, height: contentView.frame.width)
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.size.equalTo(size)
        }
        
        // note title
        
        contentView.addSubview(noteTitle)
        noteTitle.snp.makeConstraints { (make) in
            make.top.equalTo(noteImageView.snp.bottom).offset(6)
            make.leading.equalTo(contentView.snp.leading).offset(6)
            make.trailing.equalTo(contentView.snp.trailing).offset(-6)
        }
        
        // owner background
        
        let ownerBG: UIImageView = {
            let view = UIImageView()
            view.image = UIImage(named: "noteCardGradient")
            return view
        }()
        
        noteImageView.addSubview(ownerBG)
        ownerBG.snp.makeConstraints { (make) in
            make.bottom.equalTo(noteImageView.snp.bottom)
            make.leading.equalTo(noteImageView.snp.leading)
            make.trailing.equalTo(noteImageView.snp.trailing)
            make.height.equalTo(42)
        }
        
        // note owner
        
        let ownerStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.spacing = 6
            return stackView
        }()
        
        ownerStackView.addArrangedSubview(ownerImage)
        ownerStackView.addArrangedSubview(ownerLabel)
        
        ownerBG.addSubview(ownerStackView)
        ownerStackView.snp.makeConstraints { (make) in
            make.bottom.equalTo(noteImageView.snp.bottom).offset(-6)
            make.leading.equalTo(noteImageView.snp.leading).offset(6)
            make.trailing.equalTo(noteImageView.snp.trailing).offset(-6)
        }
        
        ownerImage.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        // note price
        
        let priceStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.spacing = 2
            return stackView
        }()
        priceStackView.addArrangedSubview(bahtLabel)
        priceStackView.addArrangedSubview(priceLabel)
        
        contentView.addSubview(priceStackView)
        priceStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(6)
            make.top.equalTo(noteTitle.snp.bottom)
        }
        
        // sell label
        
        contentView.addSubview(sellLabel)
        sellLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView.snp.bottom).offset(-6)
            make.trailing.equalTo(contentView.snp.trailing).offset(-6)
        }
        
        contentView.addSubview(ratingStar)
        ratingStar.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView.snp.bottom).offset(-8)
            make.leading.equalTo(contentView.snp.leading).offset(6)
        }
        
        // banner
        
        bannerView.addSubview(bannerText)
        bannerText.snp.makeConstraints { (make) in
            make.center.equalTo(bannerView.snp.center)
        }
        
        noteImageView.addSubview(bannerView)
        bannerView.snp.makeConstraints { (make) in
            make.leading.equalTo(noteImageView.snp.leading)
            make.top.equalTo(noteImageView.snp.top).offset(13)
            make.size.equalTo(CGSize(width: 0, height: 0))
        }
        
        // love button
        
        loveButton.addTarget(self, action: #selector(loveButtonDidTap(_:)), for: .touchUpInside)
        contentView.addSubview(loveButton)
        loveButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.top.equalTo(noteImageView.snp.top).offset(12)
            make.trailing.equalTo(noteImageView.snp.trailing).offset(-12)
        }
        
        readButton.isHidden = true
        contentView.addSubview(readButton)
        readButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 56, height: 28))
            make.bottom.equalTo(contentView.snp.bottom).offset(-SMALLINSET)
            make.trailing.equalTo(contentView.snp.trailing).offset(-SMALLINSET)
        }
        readButton.addTarget(self, action: #selector(readButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private func updateTag(tag: NoteTag) {
        
        switch tag {
        case .recommend:
            bannerView.backgroundColor = .clearBlue
            bannerText.text = "แนะนำ"
        case .popular:
            bannerView.backgroundColor = .tomato
            bannerText.text = "ยอดนิยม"
        default:
            bannerText.text = ""
            bannerView.isHidden = true
        }
        
        bannerView.snp.remakeConstraints { (make) in
            make.leading.equalTo(noteImageView.snp.leading)
            make.top.equalTo(noteImageView.snp.top).offset(13)
            let width = (bannerText.text?.width(withConstrainedHeight: 17, font: .kanitReg10))! + 12
            make.size.equalTo(CGSize(width: width, height: 17))
        }
        
    }
    
    @objc func readButtonDidTap(_ sender: UIButton) {
        readButtonDidTap(viewModel.id)
    }
    
    @objc func loveButtonDidTap(_ sender: UIButton) {
        viewModel.isFavorite = !viewModel.isFavorite
        loveButton.setImage(UIImage(named: viewModel.isFavorite ? "iconLoved" : "iconLove"), for: .normal)
        lovebuttonDidTap(viewModel)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
