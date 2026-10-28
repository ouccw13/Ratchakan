//
//  AllNoteViewController.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 14/7/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit

class AllNoteViewController: UIViewController {
    
    var viewModel: AllNoteViewModel!
    
    var collectionView: UICollectionView!
    
    var loadingView: LoadingView!
    
    var refreshControl = UIRefreshControl()
    
    var kind:String = ""
    var indexPath : IndexPath = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AllNoteViewModel()
        setupCollectionView()
        setupUI()
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
        NotificationCenter.default.addObserver(self, selector: #selector(updateLikeObserver(notification:)), name: MyNoteViewController().likeFromOtherPageNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkLoginStatus(notification:)), name: Notification.Name(rawValue: NotiCenter.checkLogIn), object: nil)
    }
    
    @objc private func checkLoginStatus(notification: NSNotification) {
        bindViewModel()
    }
    
    private func bindViewModel() {
        
        viewModel.loadSuggestion {
            self.collectionView.reloadSections(IndexSet(integer: CollectionViewSection.recommend.rawValue))
            self.collectionView.reloadItems(inSection: 0)
        }
        
        viewModel.loadPopular {
            self.collectionView.reloadSections(IndexSet(integer: CollectionViewSection.popular.rawValue))
            self.collectionView.reloadItems(inSection: 1)
        }
        
        viewModel.loadGrade { (_) in
            self.loadingView.stopLoading()
            self.refreshControl.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .brandcolor_bg
        
        loadingView = LoadingView(withSuperview: collectionView)
        loadingView.startLoading()
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(PAGEBAR_HEIGHT)
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        refreshControl.tintColor = .brandcolor1
        
    }
    
    private func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 10
            layout.sectionHeadersPinToVisibleBounds = true
            return layout
        }()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NoteCardCollectionViewCell.self, forCellWithReuseIdentifier: NoteCardCollectionViewCell.identifier)
        collectionView.register(RecommendCollectionViewCell.self, forCellWithReuseIdentifier: RecommendCollectionViewCell.identifier)
        collectionView.register(NoDataCollectionViewCell.self, forCellWithReuseIdentifier: NoDataCollectionViewCell.identifier)
        collectionView.register(SubjectTabHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SubjectTabHeader.identifier)
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    func reloadHeaderData() {
         
    }
    
    private func updateLike(note: Note, fromSection: CollectionViewSection) {
        if fromSection == .recommend || fromSection == .popular {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.viewModel.updateLike(id: note.id, note: note)
                self.viewModel.updateLikeForGrade(id: note.id,note: note)
                self.collectionView.reloadItems(inSection: 2)
                self.collectionView.reloadItems(inSection: 1)
                self.viewModel.favoriteNote(id: note.id)
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.viewModel.updateLikeForGrade(id: note.id,note: note)
                self.collectionView.reloadItems(inSection: 2)
                self.viewModel.favoriteNote(id: note.id)
                self.collectionView.reloadItems(inSection: 0)
                self.collectionView.reloadItems(inSection: 1)
            }
        }
    }
    
    @objc private func purchaseNote(notification: NSNotification) {
        let id = notification.object as! String
        viewModel.updatePurchasedNoteFromId(id: id)
        collectionView.reloadItems(inSection: 0)
        collectionView.reloadItems(inSection: 1)
        collectionView.reloadItems(inSection: 2)
    }
    
    @objc private func updateLikeObserver(notification: NSNotification) {
        let param = notification.object as! [String : Any]
        let note = param["note"] as! Note
        let page = param["page"] as! UIViewController
        
        if page != self {
            viewModel.updateLike(id: note.id, note: note)
            viewModel.updateLikeForGrade(id: note.id,note: note)
            collectionView.reloadItems(inSection: 0)
            collectionView.reloadItems(inSection: 1)
            if page == AllNoteViewController() {
                reloadItemInSectionNote()
            }else{
                if page != MyNoteViewController() {
                    collectionView.reloadItems(inSection: 2)
                }else{
                    
                }
            }
        }
    }
    
    private func reloadItemInSectionNote() {
        var dataIndexPathArray: [IndexPath] = []
        UIView.performWithoutAnimation {
            self.collectionView.performBatchUpdates({

                let numberOfNote = self.viewModel.numberOfNote
                let currentItems = self.collectionView.numberOfItems(inSection: 2)
                var indexPathArray: [IndexPath] = []
                if numberOfNote < currentItems {
                    for index in 1...(currentItems - numberOfNote) {
                        indexPathArray.append(IndexPath(item: currentItems - index, section: 2))
                    }
                    self.collectionView.deleteItems(at: indexPathArray)
                } else if numberOfNote > currentItems {
                    for index in 1...(numberOfNote - currentItems) {
                        indexPathArray.append(IndexPath(item: (currentItems + index) - 1, section: 2))
                    }
                    self.collectionView.insertItems(at: indexPathArray)
                }

                for index in 0..<numberOfNote {
                    dataIndexPathArray.append(IndexPath(item: index, section: 2))
                }
                self.collectionView.reloadData()
            }) { (_) in
                UIView.performWithoutAnimation {
                    self.collectionView.reloadItems(at: dataIndexPathArray)
                    
                }
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

extension AllNoteViewController: UICollectionViewDataSource {
    
    enum CollectionViewSection: Int {
        case recommend = 0, popular, other, nodata
        
        static var count: Int {
            return CollectionViewSection.nodata.rawValue + 1
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CollectionViewSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let section = CollectionViewSection(rawValue: section) else { fatalError("Unexpected Section") }
        switch section {
        case .other:
            return viewModel.numberOfNote
        case .nodata:
            return viewModel.noDataVisible
        default:
            return viewModel.isRecommendVisible(section: section.rawValue)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let section = CollectionViewSection(rawValue: indexPath.section) else { fatalError("Unexpected Section") }
        
        switch section {
        case .recommend:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as! RecommendCollectionViewCell
            cell.delegate = self
            cell.setDataSource(viewModel.getRecommendCellData(indexPath: indexPath))
            cell.noteTag = .recommend
            return cell
        case .popular:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as! RecommendCollectionViewCell
            cell.delegate = self
            cell.setDataSource(viewModel.getRecommendCellData(indexPath: indexPath))
            cell.noteTag = .popular
            return cell
        case .other:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCardCollectionViewCell.identifier, for: indexPath) as! NoteCardCollectionViewCell
            let note = viewModel.getNoteData(indexPath: indexPath)
            cell.viewModel = note
            cell.lovebuttonDidTap = { (note) in
                let param: [String : Any] = ["note": note,
                                             "page": self]
                NotificationCenter.default.post(name: MyNoteViewController().likeFromOtherPageNotificationName, object: param)
                self.updateLike(note: note, fromSection: .other)
            }
            cell.readButtonDidTap = { (id) in
                self.pushToRead(noteId: id)
            }
            return cell
        case .nodata:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoDataCollectionViewCell.identifier, for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        self.kind = kind
        self.indexPath = indexPath
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SubjectTabHeader.identifier, for: indexPath) as! SubjectTabHeader
        sectionHeader.viewModel = SubjectTabOption(DataSource: viewModel.getTabData())
        sectionHeader.whenSubjectTapped = { (id,indexPath) in
            self.viewModel.currentId = id
            self.viewModel.currentIndexPath = indexPath
            if let header = self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: indexPath.item, section: self.indexPath.section)) as? SubjectTabHeader {
                // Do your stuff here
                if self.viewModel.getNoteData(indexPath: indexPath).gradeId == "326b7d39-5634-481d-8a5c-1cf09b37aff2" {
                    header.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .init())
                }else if self.viewModel.getNoteData(indexPath: indexPath).gradeId == "3408fa7c-d0f7-4d7d-b331-371aa68dcaa4" {
                    header.collectionView.selectItem(at: IndexPath(item: 1, section: 0), animated: true, scrollPosition: .init())
                }else if self.viewModel.getNoteData(indexPath: indexPath).gradeId == "87be4ca7-580e-4d26-b8c6-d94323676c10" {
                    header.collectionView.selectItem(at: IndexPath(item: 2, section: 0), animated: true, scrollPosition: .init())
                }
            }
            self.reloadItemInSectionNote()
        }
        return sectionHeader
    }
    
}

extension AllNoteViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if viewModel.numberOfGrades == 0 {
            return .zero
        } else {
            return (section == 2) ? CGSize(width: SCREEN_WIDTH, height: 45) : .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let section = indexPath.section

        let width = (SCREEN_WIDTH / (IS_IPAD ? 3 : 2)) - 21
        let height = width + 76
        return (section == 2) ? .init(width: width, height: height) : (section == 3) ? .init(width: SCREEN_WIDTH, height: 250) : .init(width: SCREEN_WIDTH, height: 309)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return (section == 2) ? .init(top: 16, left: 16, bottom: 16, right: 16) : .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let section = indexPath.section
        
        if section == 2 {
            pushToNoteDetail(noteId: viewModel.getNoteData(indexPath: indexPath).id)
        }
        
    }
    
}

extension AllNoteViewController: RecommendNoteViewDelegate {
    
    func recommendNoteViewLoveButtonDidTap(note: Note, noteTag: NoteTag) {
        let param: [String : Any] = ["note": note,
                                    "page": self]
        NotificationCenter.default.post(name: MyNoteViewController().likeFromOtherPageNotificationName, object: param)
        let section:CollectionViewSection = (noteTag == .recommend) ? .recommend : .popular
        updateLike(note: note, fromSection: section)
        collectionView.reloadItems(inSection: 0)
        collectionView.reloadItems(inSection: 1)
        collectionView.reloadItems(inSection: 2)
    }
    
    func moreButtonDidTap(tag: NoteTag) {
        let moreNote = MoreNoteViewController()
        moreNote.viewModel = MoreNoteViewModel(type: .more, noteTag: tag)
        navigationController?.pushViewController(moreNote, animated: true)
    }
    
    func itemDidTap(id: String) {
        pushToNoteDetail(noteId: id)
    }
    
    func readButtonDidtap(id: String) {
        pushToRead(noteId: id)
    }
}
