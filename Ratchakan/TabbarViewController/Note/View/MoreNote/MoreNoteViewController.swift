//
//  MoreNoteViewController.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 17/8/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit

class MoreNoteViewController: UIViewController {
    
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
    
    var viewModel: MoreNoteViewModel!
//    {
//        didSet {
////            navigationView.titleNavLabel.text = viewModel.titleText
//            navTitleLabel.text = viewModel.titleText
//        }
//    }

//    private let navigationView: CustomNav = {
//        let nav = CustomNav(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TOP_VIEW))
//        nav.viewModel = CustomViewModelFromNav(withNav: Nav(title: "รายละเอียด", isBack: true, isRight: false, color: UIColor.navbrandcolor))
//        return nav
//    }()
    
    private var collectionView: UICollectionView!
    
    private var loadingView: LoadingView!
    
    private var noDataView: NoDataView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .brandcolor_bg
//        navigationView.delegate = self
        bindViewModel()
        setupCollectionView()
        setupUI()
        bindObserver()
    }
    
    private func bindObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseNote(notification:)), name: NoteDetailViewController().notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLikeObserver(notification:)), name: MyNoteViewController().likeFromOtherPageNotificationName, object: nil)
    }
    
    private func bindViewModel() {
        
        loadingView = LoadingView(withSuperview: view)
        loadingView.startLoading()
        viewModel.loadNote { (finished) in
            self.loadingView.stopLoading()
            self.collectionView.reloadData()
            self.noDataView.isHidden = !self.viewModel.dataIsEmpty
        }
    }
    
    private func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
            let width = SCREEN_WIDTH / (IS_IPAD ? 3 : 2) - 21
            layout.itemSize = .init(width: width, height: width + 76)
            layout.sectionInset = .init(top: 16, left: 16, bottom: 16, right: 16)
            return layout
        }()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NoteCardCollectionViewCell.self, forCellWithReuseIdentifier: NoteCardCollectionViewCell.identifier)
    }
    
    private func setupUI() {
        topView = UIView()
        topView.backgroundColor = .navbrandcolor
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(TOP_VIEW)
        }
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.setAnimatedTouch()
        backButton.adjustsImageWhenHighlighted = false
        backButton.adjustsImageWhenDisabled = false
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        topView.addSubview(backButton)
        
        navTitleLabel = UILabel()
        navTitleLabel.setParameter(font: .navTitleFont, color: .cellWhiteLabel)
        navTitleLabel.numberOfLines = 2
        navTitleLabel.lineBreakMode = .byWordWrapping
        navTitleLabel.set(text: viewModel.titleText)
        topView.addSubview(navTitleLabel)
        
        if IS_IPAD {
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY)/*.offset(INSET)*/
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
//                make.leading.equalTo(backButton.snp.trailing).offset(10)
                make.centerY.equalTo(topView.snp.centerY)/*.offset(INSET)*/
                make.centerX.equalTo(topView.snp.centerX)
//                make.trailing.equalTo(topView.snp.trailing).offset(-10)
            }
        }else{
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6  || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
//                make.leading.equalTo(backButton.snp.trailing).offset(10)
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.centerX.equalTo(topView.snp.centerX)
//                make.trailing.equalTo(topView.snp.trailing).offset(-10)
            }
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(TOP_VIEW)
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        noDataView = NoDataView(view.frame)
        collectionView.addSubview(noDataView)
        noDataView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.snp.edges)
        }
        noDataView.isHidden = true
    }
    
    @objc private func purchaseNote(notification: NSNotification) {
        let id = notification.object as! String
        viewModel.updatePurchasedNoteFromId(id: id)
        collectionView.reloadData()
    }
    
    @objc private func updateLikeObserver(notification: NSNotification) {
        let param = notification.object as! [String : Any]
        let note = param["note"] as! Note
        let page = param["page"] as! UIViewController
        
        if page != self {
            viewModel.updateLike(id: note.id)
            collectionView.reloadData()
        }
    }
    
    
    private func pushToRead(noteId: String) {
        loadingView.startLoading()
        viewModel.loadNoteDetail(noteId: noteId) { (note) in
            self.loadingView.stopLoading()
            let read = ReadNoteViewController()
            read.viewModel = ReadNoteViewModel(note: note)
            read.modalPresentationStyle = .fullScreen
            self.present(read, animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MoreNoteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItem
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCardCollectionViewCell.identifier, for: indexPath) as! NoteCardCollectionViewCell
        let note = viewModel.getData(atIndexPath: indexPath)
        cell.viewModel = note
        
        cell.lovebuttonDidTap = { (note) in
            let param: [String : Any] = [ "note" : note,
                                          "page" : self ]
            NotificationCenter.default.post(name: MyNoteViewController().likeFromOtherPageNotificationName, object: param)
            self.viewModel.favoriteNote(indexPath: indexPath)
            self.collectionView.reloadData()
        }
        
        cell.readButtonDidTap = { (id) in
            self.pushToRead(noteId: id)
        }
        
        return cell
    }
}

extension MoreNoteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let noteDetail = NoteDetailViewController()
        noteDetail.viewModel = NoteDetailViewModel(withId: viewModel.getNoteId(atIndexPath: indexPath))
        navigationController?.pushViewController(noteDetail, animated: true)
    }
}

extension MoreNoteViewController: CustomNavDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
