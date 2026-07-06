//
//  ImageTableViewCell.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 17/8/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit

class PreviewTableViewCell: UITableViewCell {
    
    static let identifier = "PreviewCell"
    
    var note: Note! {
        didSet {
            ownerImage.sd_setImage(with: URL(string: note.publisher.logo ?? ""))
            ownerNameLabel.text = note.publisher.name
            currentPageText.text = "1/\(note.noteImages!.count)"
            pageControl.pages = note.noteImages!.count
            pageControl.selectedPage = 0
            if note.isFavorite == true {
                loveButton.setImage(UIImage(named: "iconLoved"), for: .normal)
            }else{
                loveButton.setImage(UIImage(named: "iconLove")?.maskWithColor(color: .white), for: .normal)
            }
            let date = NSDate(timeIntervalSince1970: TimeInterval(note.createdAt ?? 1616422623))
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone() as TimeZone
            let localDate = dateFormatter.string(from: date as Date)
            dateLabel.text = localDate
        }
    }
    
    private var imageCollectionView: UICollectionView!
    
    private let ownerImage: UIImageView! = {
        let iv = UIImageView()
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private let ownerNameLabel: UILabel! = {
        let lb = UILabel()
        lb.font = .kanitReg14
        lb.textColor = .white
        return lb
    }()
    
    private let dateLabel: UILabel! = {
        let lb = UILabel()
        lb.text = "11 ก.ค. 63"
        lb.font = .kanitLight10
        lb.textColor = .white
        return lb
    }()
    
    private let loveButton: UIButton! = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconLove")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        button.backgroundColor = .clearCanTouch
        return button
    }()
    
    private let currentPageText: UILabel! = {
        let label = UILabel()
        label.font = .kanitLight10
        label.textColor = .white
        return label
    }()
    
    private let pageControl: CustomPageControl! = {
        let pc = CustomPageControl()
        pc.dotColor = .brownGrey
        pc.selectedColor = .reddishPink
        return pc
    }()
    
    var whenCollectionViewDidTap: ((IndexPath) -> ())!
    var whenLoveButtonDidTap: ((String) -> ())!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        setupCollectionView()
        setupUI()
    }
    
    private func setupCollectionView() {
        let flowLayout: UICollectionViewFlowLayout = {
            let lo = UICollectionViewFlowLayout()
            lo.scrollDirection = .horizontal
            lo.minimumLineSpacing = 0
            lo.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
            return lo
        }()
        
        imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        imageCollectionView.backgroundColor = .black
        imageCollectionView.isPagingEnabled = true
        imageCollectionView.hideScrollIndicatior()
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.register(ImagePreviewCollectionViewCell.self, forCellWithReuseIdentifier: ImagePreviewCollectionViewCell.identifier)
    }
    
    private func setupUI() {
        
        contentView.addSubview(imageCollectionView)
        imageCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom)
            make.height.equalTo(IS_IPAD ? 464 : 276)
        }
        
        let gradientView = UIImageView(image: UIImage(named: "noteCardGradient"))
        contentView.addSubview(gradientView)
        gradientView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom)
            make.height.equalTo(96)
        }
        
        let textStackView: UIStackView = {
            let sv = UIStackView()
            sv.addArrangedSubview(ownerNameLabel)
            sv.addArrangedSubview(dateLabel)
            sv.axis = .vertical
            sv.distribution = .fillEqually
            return sv
        }()
        
        let ownerStackView: UIStackView = {
            let sv = UIStackView()
            sv.addArrangedSubview(ownerImage)
            sv.addArrangedSubview(textStackView)
            sv.axis = .horizontal
            sv.distribution = .fill
            sv.spacing = 10
            return sv
        }()
        
        gradientView.addSubview(ownerStackView)
        
        ownerStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(gradientView.snp.leading).offset(16)
            make.bottom.equalTo(gradientView.snp.bottom).offset(-10)
        }
        
        ownerImage.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        ownerImage.layer.cornerRadius = 18
        
        contentView.addSubview(loveButton)
        loveButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(gradientView.snp.trailing).offset(-16)
            make.bottom.equalTo(gradientView.snp.bottom).offset(-16)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        loveButton.addTarget(self, action: #selector(loveButtonDidTap), for: .touchUpInside)
        
        let pageView:UIView = {
            let view = UIView()
            view.backgroundColor = .black
            view.alpha = 0.2
            return view
        }()
        
        contentView.addSubview(pageView)
        contentView.addSubview(currentPageText)
        
        pageView.snp.makeConstraints { (make) in
            make.width.equalTo(45)
            make.height.equalTo(16)
            make.top.equalTo(contentView.snp.top).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
        pageView.layer.cornerRadius = 16/2
        
        currentPageText.snp.makeConstraints { (make) in
            make.center.equalTo(pageView.snp.center)
        }
        
        contentView.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(gradientView.snp.centerX)
            make.bottom.equalTo(gradientView.snp.bottom).offset(-18)
        }
    }
    
    @objc private func loveButtonDidTap() {
        note.isFavorite = !note.isFavorite
        if note.isFavorite == true {
            loveButton.setImage(UIImage(named: "iconLoved"), for: .normal)
        }else{
            loveButton.setImage(UIImage(named: "iconLove")?.maskWithColor(color: .white), for: .normal)
        }
        whenLoveButtonDidTap(note.id)
    }
    
    private func updateCurrentPageText(page: Int, pages: Int) {
        currentPageText.text = "\(page)/\(pages)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PreviewTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return note.noteImages!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePreviewCollectionViewCell.identifier, for: indexPath) as! ImagePreviewCollectionViewCell
        
        let imageData = note.noteImages![indexPath.row]
        
        cell.imageUrl = imageData.url
        cell.isMyNote = note.isMyNote
        cell.isPreview = imageData.isPreview
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: SCREEN_WIDTH, height: IS_IPAD ? 464 : 276)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        whenCollectionViewDidTap(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        pageControl.selectPage(indexPath: indexPath)
        updateCurrentPageText(page: indexPath.row + 1, pages: note.noteImages!.count)
        
    }
}

class ImagePreviewCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImagePreviewCell"
    
    var imageUrl: String! {
        didSet {
            let url = URL(string: imageUrl)
            previewImageView.sd_setImage(with: url)
        }
    }
    
    var isMyNote: Bool = false
    
    var isPreview: Bool = true {
        didSet {
            if !isMyNote {
                blurView.isHidden = isPreview
                lock.isHidden = isPreview
                unlockLabel.isHidden = isPreview
            }
        }
    }
    
    var previewImageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
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
        contentView.addSubview(previewImageView)
        previewImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        
        contentView.addSubview(blurView)
        blurView.snp.makeConstraints { (make) in
            make.top.equalTo(previewImageView.snp.top)
            make.bottom.equalTo(previewImageView.snp.bottom)
            make.leading.equalTo(previewImageView.snp.leading)
            make.trailing.equalTo(previewImageView.snp.trailing)
        }
        
        blurView.isHidden = true
        
        contentView.addSubview(lock)
        lock.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 30, height: 36))
            make.centerX.equalTo(contentView.snp.centerX)
            make.centerY.equalTo(contentView.snp.centerY).offset(-28)
        }
        
        contentView.addSubview(unlockLabel)
        unlockLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(lock.snp.bottom).offset(8)
        }
        
        lock.isHidden = true
        unlockLabel.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
