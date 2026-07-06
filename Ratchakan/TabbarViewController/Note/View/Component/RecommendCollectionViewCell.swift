//
//  RecommendCollectionViewCell.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 11/8/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit

protocol RecommendNoteViewDelegate {
    func moreButtonDidTap(tag: NoteTag)
    func recommendNoteViewLoveButtonDidTap(note: Note, noteTag: NoteTag)
    func readButtonDidtap(id: String)
    func itemDidTap(id: String)
}

class RecommendCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RecommendCell"
    
    var delegate : RecommendNoteViewDelegate?
    
    var dataSource: [Note] = []
    var noteTag: NoteTag = .none {
        didSet {
            titleLabel.text = noteTag.rawValue
        }
    }
    
    let recommendNote: RecommendNoteView = {
        let view = RecommendNoteView()
        return view
    }()
    
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private var collectionView: UICollectionView!
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .kanitLight14
        label.textColor = .canceltext
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setParameter("ดูเพิ่มเติม >", textColor: .placeholdercolor, font: .sarabunL12, backgroundColor: .clearCanTouch)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupColView()
        setupUI()
    }
    
    private func setupColView() {
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 153, height: 229)
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            layout.minimumInteritemSpacing = 10
            return layout
        }()
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(NoteCardCollectionViewCell.self, forCellWithReuseIdentifier: NoteCardCollectionViewCell.identifier)
    }
    
    private func setupUI() {
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(15)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom)
            make.height.equalTo(294)
        }
        
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.top).offset(12)
            make.leading.equalTo(bgView.snp.leading).offset(MARGIN)
        }
        
        bgView.addSubview(moreButton)
        moreButton.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.top).offset(8)
            make.trailing.equalTo(bgView.snp.trailing).offset(-MARGIN)
        }
        moreButton.addTarget(self, action: #selector(moreButtonDidTap), for: .touchUpInside)
        
        bgView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.height.equalTo(247)
            make.top.equalTo(titleLabel.snp.bottom).offset(SMALLINSET)
            make.leading.equalTo(bgView.snp.leading)
            make.trailing.equalTo(bgView.snp.trailing)
            make.bottom.equalTo(bgView.snp.bottom).offset(-SMALLINSET)
        }
    }
    
    func setDataSource(_ notes: [Note]) {
        dataSource = notes
        collectionView.reloadData()
    }
    
    func addDataSource(_ note: Note) {
        dataSource.insert(note, at: 0)
        UIView.transition(with: collectionView, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
        })
    }
    
    private func dataSourcePosition(ntoe: Note) {
        
    }
    
    func updateLikeAtPosition(_ position: Int!) {
        guard let position = position else { return }
        if noteTag == .love {
            
            UIView.transition(with: collectionView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.collectionView.performBatchUpdates {
                    self.dataSource.remove(at: position)
                    self.collectionView.deleteItems(at: [IndexPath(item: position, section: 0)])
                } completion: { (_) in
                    self.collectionView.reloadData()
                }
            })
            
        } else {
            let cell = collectionView.cellForItem(at: IndexPath(item: position, section: 0)) as! NoteCardCollectionViewCell
            dataSource[position].isFavorite = dataSource[position].isFavorite == false ? true : false
            cell.viewModel = dataSource[position]
        }
    }
    
    @objc private func moreButtonDidTap() {
        delegate?.moreButtonDidTap(tag: noteTag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecommendCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCardCollectionViewCell.identifier, for: indexPath) as! NoteCardCollectionViewCell
        
        cell.viewModel = dataSource[indexPath.row]
        cell.noteTag = noteTag
        cell.lovebuttonDidTap = { (note) in
            self.delegate?.recommendNoteViewLoveButtonDidTap(note: self.dataSource[indexPath.row], noteTag: self.noteTag)
            self.updateLikeAtPosition(indexPath.row)
        }
        cell.readButtonDidTap = { (id) in
            self.delegate?.readButtonDidtap(id: id)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.itemDidTap(id: dataSource[indexPath.row].id)
    }
}

enum NoteTag: String {
    case recommend = "โน้ตแนะนำ"
    case popular = "โน้ตยอดนิยม"
    case love = "โน้ตที่ถูกใจ"
    case none = ""
}
