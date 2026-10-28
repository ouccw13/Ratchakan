//
//  SubjectTab.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 21/7/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit

class AllNoteHeader: UICollectionReusableView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    static let identifier = "SubjectTab"

    let mockData:[String] = [ "ครูผู้ช่วย", "ข้าราชการพลเรือน", "สอบท้องถิ่น" , "นักวิชาการสาธารณสุข/ใบประกอบวิชาชื่อ", "ปลัดอำเภอ", "สำนักงานคณะกรรมการการเลือกตั้ง" ]
    
    var collectionView: UICollectionView!
    
    let underBar: UIView = {
        let view = UIView()
        view.backgroundColor = .weakness_d_s
        return view
    }()
    
    var whenSubjectTapped: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setupUI()
    }
    
    private func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = {
            let lo = UICollectionViewFlowLayout()
            lo.scrollDirection = .horizontal
            lo.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
            lo.minimumInteritemSpacing = 0
            lo.minimumLineSpacing = 0
            return lo
        }()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clearCanTouch
        collectionView.allowsSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SubjectCell.self, forCellWithReuseIdentifier: "SubjectCell")
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
    }
    
    private func setupUI() {
        backgroundColor = .white
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
            make.leading.equalTo(collectionView.snp.leading)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    private func moveUnderBar(indexPath: IndexPath) {
        
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? SubjectCell {
        
            underBar.isHidden = false
            cell.isSelected = true
            
            
            cell.hideCurrentBarView()
            underBar.snp.remakeConstraints { (make) in
                make.size.equalTo(CGSize(width: cell.frame.width, height: 3))
                make.leading.equalTo(cell.snp.leading)
                make.bottom.equalTo(self.snp.bottom)
            }
            
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mockData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectCell", for: indexPath) as! SubjectCell
        cell.titleText = mockData[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = frame.height
        let width = mockData[indexPath.row].width(withConstrainedHeight: 2, font: .kanitReg14) + 32
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moveUnderBar(indexPath: indexPath)
        whenSubjectTapped?()
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
        label.font = .kanitReg14
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
            make.center.equalTo(contentView.snp.center)
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
    }
    
    func hideCurrentBarView() {
        currentBarView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
