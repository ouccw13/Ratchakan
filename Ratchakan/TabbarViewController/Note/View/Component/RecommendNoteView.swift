//
//  RecommendNoteView.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 21/7/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit

class RecommendNoteView: UIView {
    
    var dataSource: [Note] = []
    
    var noteTag: NoteTag = .none {
        didSet {
            titleLabel.text = noteTag.rawValue
        }
    }
    
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
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 5)
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
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(12)
            make.leading.equalTo(self.snp.leading).offset(MARGIN)
        }
        
        addSubview(moreButton)
        moreButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(8)
            make.trailing.equalTo(self.snp.trailing).offset(-MARGIN)
        }
        moreButton.addTarget(self, action: #selector(moreButtonDidTap), for: .touchUpInside)
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.height.equalTo(247)
            make.top.equalTo(titleLabel.snp.bottom).offset(SMALLINSET)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom).offset(-SMALLINSET)
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
    
    func updateLikeAtPosition(_ position: Int!) {
        guard let position = position else { return }
        if noteTag == .love {
            dataSource.remove(at: position)
            UIView.transition(with: collectionView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.collectionView.deleteItems(at: [IndexPath(item: position, section: 0)])
            })
        } else {

        }
    }
    
    @objc private func moreButtonDidTap() {

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RecommendNoteView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCardCollectionViewCell.identifier, for: indexPath) as! NoteCardCollectionViewCell
        
        cell.viewModel = dataSource[indexPath.row]
        cell.noteTag = noteTag
        cell.lovebuttonDidTap = { (note) in
            self.updateLikeAtPosition(indexPath.row)
        }
        cell.readButtonDidTap = { (id) in
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
}

