//
//  SubjectTab.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 21/7/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit

class SubjectTabHeader: UICollectionReusableView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    static let identifier = "SubjectTab"

    var viewModel: SubjectTabOption = SubjectTabOption(DataSource: []) {
        didSet {
            collectionView.reloadData()
            collectionView.selectItem(at: IndexPath(item: self.currentIndexPath?.item ?? 0, section: self.currentIndexPath?.section ?? 0), animated: true, scrollPosition: .centeredHorizontally)
            underBar.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: 5, height: 3))
                make.leading.equalTo(collectionView.snp.leading)
                make.bottom.equalTo(self.snp.bottom)
            }
        }
    }
    
    var collectionView: UICollectionView!
    
    let underBar: UIView = {
        let view = UIView()
        view.backgroundColor = .weakness_d_s
        return view
    }()
    
    var whenSubjectTapped: ((String, IndexPath) -> ())?
    var currentIndexPath: IndexPath?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCollectionView()
        setupUI()
    }
    
    private func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = {
            let lo = UICollectionViewFlowLayout()
            lo.scrollDirection = .horizontal
            lo.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            lo.minimumInteritemSpacing = 0
            lo.minimumLineSpacing = 0
            return lo
        }()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.backgroundColor = .clearCanTouch
        collectionView.allowsSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SubjectCell.self, forCellWithReuseIdentifier: "SubjectCell")
    }
    
    private func setupUI() {
        backgroundColor = .white
        underBar.isHidden = true
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
        }
        addSubview(underBar)

        underBar.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 5, height: 3))
//            make.leading.equalTo(collectionView.snp.leading)
            make.bottom.equalTo(collectionView.snp.bottom)
        }
    }
    
    private func moveUnderBar(indexPath: IndexPath) {
        collectionView.selectItem(at: IndexPath(row: indexPath.row, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? SubjectCell {
            self.currentIndexPath = indexPath
            cell.showCurrentBarView()

            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItem()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectCell", for: indexPath) as! SubjectCell
        cell.titleText = viewModel.getName(IndexPath: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = frame.height
        let width = viewModel.getName(IndexPath: indexPath).width(withConstrainedHeight: 2, font: .kanitReg14) + 50
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moveUnderBar(indexPath: indexPath)
        whenSubjectTapped?(viewModel.getId(IndexPath: indexPath), indexPath)
    }
}

fileprivate class SubjectCell: UICollectionViewCell {
    
    var titleText: String! {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .kanitReg16
        label.textColor = .Cellinformation
        return label
    }()
    
    let currentBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .weakness_d_s
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.top.equalTo(contentView.snp.top).offset(20)
            make.bottom.equalTo(contentView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        
        addSubview(currentBarView)
        currentBarView.isHidden = true
        currentBarView.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(3)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            titleLabel.textColor = isHighlighted ? .weakness_d_s : .Cellinformation
        }
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? .weakness_d_s : .Cellinformation
            currentBarView.isHidden = !isSelected
        }
    }
    
    func showCurrentBarView() {
        currentBarView.isHidden = false
        isSelected = true
    }

    func hideCurrentBarView() {
        currentBarView.isHidden = true
        isSelected = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SubjectTabOption {
    
    var dataSource: [NoteGrade] = []
    
    init(DataSource dataSource: [NoteGrade]) {
        self.dataSource = dataSource
    }
    
    func getNumberOfItem() -> Int {
        return dataSource.count
    }
    
    func getName(IndexPath indexPath: IndexPath) -> String {
        return dataSource[indexPath.row].name
    }
    
    func getId(IndexPath indexPath: IndexPath) -> String {
        return dataSource[indexPath.row].id
    }
}
