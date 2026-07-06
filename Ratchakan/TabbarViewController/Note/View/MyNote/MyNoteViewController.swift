//
//  MyNoteViewController.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 14/7/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit

class MyNoteViewController: UIViewController {
    
    var viewModel: MyNoteViewModel!
    
    let likeFromOtherPageNotificationName = Notification.Name("OtherPageLike")
    
    var collectionView: UICollectionView!
    
    var loadingView: LoadingView!
    
    var noDataView: NoDataView!
    
    var shouldReloadFavorite: Bool = false
    
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MyNoteViewModel()
        setupCollectionView()
        setupUI()
        loadingView = LoadingView(withSuperview: view)
        loadingView.startLoading()
        bindViewModel()
        bindObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    private func bindObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseNote(notification:)), name: NoteDetailViewController().notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLike(notification:)), name: likeFromOtherPageNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkLoginStatus(notification:)), name: Notification.Name(rawValue: NotiCenter.checkLogIn), object: nil)
    }
    
    @objc private func checkLoginStatus(notification: NSNotification) {
        bindViewModel()
    }
    
    private func bindViewModel() {
        
        viewModel.loadMyNote { [weak self] in
            self?.collectionView.reloadSections(IndexSet(integer: 1))
            self?.loadingView.stopLoading()
            self?.refreshControl.endRefreshing()
            
            self?.viewModel.loadFavorite {
                self?.collectionView.reloadSections(IndexSet(integer: 0))
                self?.noDataView.isHidden = !self!.viewModel.didDataIsEmpty
            }
        }
    }
    
    private func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 10
            return layout
        }()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NoteCardCollectionViewCell.self, forCellWithReuseIdentifier: NoteCardCollectionViewCell.identifier)
        collectionView.register(RecommendCollectionViewCell.self, forCellWithReuseIdentifier: RecommendCollectionViewCell.identifier)
        collectionView.addSubview(refreshControl)
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.insertSubview(refreshControl, at: 0)
        }
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func setupUI() {
        
        view.backgroundColor = .brandcolor_bg
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(PAGEBAR_HEIGHT)
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        refreshControl.tintColor = .brandcolor1
        
        noDataView = NoDataView(view.frame)
        collectionView.addSubview(noDataView)
        noDataView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.snp.edges)
        }
        noDataView.isHidden = true
    }
    
    @objc func purchaseNote(notification: NSNotification) {
        
        if notification.name == NoteDetailViewController().notificationName {
            viewModel.loadMyNote {
                self.collectionView.reloadSections(IndexSet(integer: 1))
                self.collectionView.reloadItems(inSection: 1)
            }
            let id = notification.object as! String
            if viewModel.purchasedNoteContainInFavorite(id: id) {
                collectionView.reloadSections(IndexSet(integer: 0))
                collectionView.reloadItems(inSection: 0)
            }
        }
        
    }
    
    @objc func updateLike(notification: NSNotification) {
        if notification.name == likeFromOtherPageNotificationName {
            let param = notification.object as! [String : Any]
            let note = param["note"] as! Note
            let page = param["page"] as! UIViewController
            if page == AllNoteViewController() || page == MyNoteViewController() {
                viewModel.changeFavoriteStatus(note: note)
                noDataView.isHidden = !viewModel.didDataIsEmpty
                collectionView.reloadItems(inSection: 0)
                collectionView.reloadItems(inSection: 1)
            }
        }
    }
    
    private func updateLikeInsideView(note: Note,fromSection: Int) {
        if fromSection == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.viewModel.updateLike(id: note.id,note: note)
                self.viewModel.updateLikeMyNote(id: note.id,note: note)
                self.viewModel.changeFavoriteStatus(note: note)
                self.collectionView.reloadSections(IndexSet(integer: 0))
                self.collectionView.reloadItems(inSection: 1)
                self.viewModel.favoriteNote(id: note.id)
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.viewModel.changeFavoriteStatus(note: note)
                self.collectionView.reloadSections(IndexSet(integer: 0))
                self.collectionView.reloadItems(inSection: 1)
                self.viewModel.favoriteNote(id: note.id)
            }
        }
    }
    
    @objc private func refresh() {
        bindViewModel()
    }
    
    private func pushToNoteDetail(noteId: String) {
        let noteDetail = NoteDetailViewController()
        noteDetail.viewModel = NoteDetailViewModel(withId: noteId)
        navigationController?.pushViewController(noteDetail, animated: true)
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
}

extension MyNoteViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.isFavoriteVisible() == true ? 1 : 0
        case 1:
            let myNote = viewModel.myNote.filter{$0.isMyNote == true }
            if myNote.count > 0 {
                return myNote.count
            }else{
                return viewModel.numberOfMyNote
            }
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as! RecommendCollectionViewCell
            cell.delegate = self
            cell.setDataSource(viewModel.getFavoriteNote())
            cell.noteTag = .love
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCardCollectionViewCell.identifier, for: indexPath) as! NoteCardCollectionViewCell
            cell.viewModel = viewModel.getData(indexPath: indexPath)
            cell.lovebuttonDidTap = { (note) in
                let note = self.viewModel.getData(indexPath: indexPath)

                self.updateLikeInsideView(note: note, fromSection: 1)
                
                let param: [String : Any] = ["note": note,
                                            "page": self]
                NotificationCenter.default.post(name: self.likeFromOtherPageNotificationName, object: param)
            }
            cell.readButtonDidTap = { (id) in
                self.pushToRead(noteId: id)
            }
            
            return cell
        default: return UICollectionViewCell()
        }
    }
}

extension MyNoteViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let section = indexPath.section
        
        let width = (SCREEN_WIDTH / (IS_IPAD ? 3 : 2)) - 21
        let height = width + 76
        return (section == 1) ? .init(width: width, height: height) : .init(width: SCREEN_WIDTH, height: 309)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return (section == 1) ? .init(top: 16, left: 16, bottom: 16, right: 16) : .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        
        if section == 1 {
            pushToNoteDetail(noteId: viewModel.getData(indexPath: indexPath).id)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            collectionView.reloadData()
        }
    }
}

extension MyNoteViewController: RecommendNoteViewDelegate {
    
    func readButtonDidtap(id: String) {
        pushToRead(noteId: id)
    }
    
    func recommendNoteViewLoveButtonDidTap(note: Note, noteTag: NoteTag) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let param: [String : Any] = ["note": note,
                                        "page": self]
            NotificationCenter.default.post(name: MyNoteViewController().likeFromOtherPageNotificationName, object: param)
            self.updateLikeInsideView(note: note, fromSection: 0)
        }
    }
    
    func moreButtonDidTap(tag: NoteTag) {
        let moreNote = MoreNoteViewController()
        moreNote.viewModel = MoreNoteViewModel(type: .more, noteTag: tag)
        navigationController?.pushViewController(moreNote, animated: true)
    }
    
    func itemDidTap(id: String) {
        pushToNoteDetail(noteId: id)
    }
}
