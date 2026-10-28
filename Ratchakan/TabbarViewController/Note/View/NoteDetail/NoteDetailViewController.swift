//
//  NoteDetailViewController.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 11/8/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit

class NoteDetailViewController: CustomUIViewControllerWithNav {
    
    var viewModel: NoteDetailViewModel!
    
    let notificationName = Notification.Name("noteDetail")
    
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
    
    private var tableView: UITableView!
    
    private var loadingView: LoadingView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .brandcolor_bg
        
        setupTableView()
        bindViewModel()
        setupUI()
        bindObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.loadDetail {
            self.tableView.reloadData()
        }
    }
    
    private func bindObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLikeObserver(notification:)), name: MyNoteViewController().likeFromOtherPageNotificationName, object: nil)
    }
    
    @objc private func updateLikeObserver(notification: NSNotification) {
        let param = notification.object as! [String : Any]
        let note = param["note"] as! Note
        let page = param["page"] as! UIViewController
        
        if page != self {
            if note.id == viewModel.note.id {
                viewModel.note.isFavorite = !viewModel.note.isFavorite
                tableView.reloadData()
            }
        }
    }
    
    private func bindViewModel() {
        loadingView = LoadingView(withSuperview: tableView)
        loadingView.startLoading()
        
        viewModel.loadDetail {
            self.loadingView.stopLoading()
            self.tableView.reloadData()
        }
        
        viewModel.purchaseCallback = { (success, isCancel) in
            guard let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? DescriptionTableViewCell else { return }
            
            if isCancel {
                self.loadingView.stopLoading()
                cell.actionButton.isUserInteractionEnabled = true
                let alert = UIAlertController(title: nil, message: "คำสั่งซื้อถูกยกเลิก", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ตกลง", style: .cancel))
                self.present(alert, animated: true)
                cell.isUserInteractionEnabled = true
            }
            
            if success {
                NotificationCenter.default.post(name: self.notificationName, object: self.viewModel.note.id)
                self.viewModel.loadDetail {
                    self.loadingView.stopLoading()
                    cell.actionButton.isUserInteractionEnabled = true
                    let alert = UIAlertController(title: nil, message: "การซื้อสำเร็จ", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ตกลง", style: .cancel) { _ in
                        self.tableView.reloadData()
                        cell.isUserInteractionEnabled = true
                    })
                    self.present(alert, animated: true)
                }
                
            } else {
                self.loadingView.stopLoading()
                cell.actionButton.isUserInteractionEnabled = true
                if self.viewModel.products.count == 0 {
                    Utility.showAlert(title: "เกิดข้อผิดพลาด", detail: "ไม่สามารถเชื่อมต่อกับ itune store ได้")
                }else{
                    let alert = UIAlertController(title: "เกิดข้อผิดพลาด", message: "ไม่สามารถทำการซื้อโน้ตได้ กรุณาติดต่อ Admin", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ตกลง", style: .cancel))
                    self.present(alert, animated: true)
                    
                    cell.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 500
        
        tableView.backgroundColor = .clear
        
        tableView.register(PreviewTableViewCell.self, forCellReuseIdentifier: PreviewTableViewCell.identifier)
        tableView.register(DescriptionTableViewCell.self, forCellReuseIdentifier: DescriptionTableViewCell.identifier)
        tableView.register(RateTableViewCell.self, forCellReuseIdentifier: RateTableViewCell.identifier)
        tableView.register(TotalRatingTableViewCell.self, forCellReuseIdentifier: TotalRatingTableViewCell.identifier)
        tableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: CommentsTableViewCell.identifier)
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
        navTitleLabel.set(text: "รายละเอียด")
        topView.addSubview(navTitleLabel)
        
        if IS_IPAD {
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY)
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY)
                make.centerX.equalTo(topView.snp.centerX)
            }
        }else{
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.centerX.equalTo(topView.snp.centerX)
            }
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(TOP_VIEW)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension NoteDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    enum TableViewSection:Int {
        case preview = 0, description, rate, totalRating, comments
        
        static var count: Int {
            return TableViewSection.comments.rawValue + 1
        }
    }
    
    func goToReadScreen(indexPath:IndexPath = IndexPath(item: 0, section: 0)) {
        let readNoteVC = ReadNoteViewController()
        readNoteVC.modalPresentationStyle = .fullScreen
        readNoteVC.viewModel = ReadNoteViewModel(note: viewModel.note, selectedIndexPath: indexPath)
        self.present(readNoteVC, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableViewSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = TableViewSection(rawValue: section) else { fatalError("Unexpected Section") }
        
        switch section {
        case .comments:
            return viewModel.numberOfComments
        case .rate:
            return viewModel.getRowWhenUserOwnThisNote
        default:
            return viewModel.getRowWhenNoteLoaded
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = TableViewSection(rawValue: indexPath.section) else { fatalError("Unexpected Section") }
        
        switch section {
        case .preview:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PreviewTableViewCell.identifier, for: indexPath) as! PreviewTableViewCell
            cell.note = viewModel.note
            cell.whenLoveButtonDidTap = { (id) in
                self.viewModel.favoriteNote(id: id)
                if let note = self.viewModel.note {
                    let param:[String : Any] = ["note" : note,
                                                "page" : self ]
                    NotificationCenter.default.post(name: MyNoteViewController().likeFromOtherPageNotificationName, object: param)
                }
            }
            cell.whenCollectionViewDidTap = { (ip) in
                self.goToReadScreen(indexPath: ip)
            }
            return cell
            
        case .description:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTableViewCell.identifier, for: indexPath) as! DescriptionTableViewCell
            cell.note = viewModel.note
            cell.delegate = self
            return cell
            
        case .rate:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: RateTableViewCell.identifier, for: indexPath) as! RateTableViewCell
            cell.comment = viewModel.getOwnedComment()
            cell.callBack = { (value, comment) in
                let reviewVC = ReviewNoteViewController()
                reviewVC.scoreValue = value
                reviewVC.givenComment = comment
                reviewVC.viewModel = ReviewNoteViewModel(id: self.viewModel.getId)
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.pushViewController(reviewVC, animated: true)
            }
            return cell
            
        case .totalRating:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TotalRatingTableViewCell.identifier, for: indexPath) as! TotalRatingTableViewCell
            cell.note = viewModel.note
            return cell
            
        case .comments:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentsTableViewCell.identifier, for: indexPath) as! CommentsTableViewCell
            cell.comment = viewModel.getComment(atIndexPath: indexPath)
            return cell
            
        }
    }
}

extension NoteDetailViewController: CustomNavDelegate, descriptionCellDelegate {
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func actionButtonDidPress(owned: Bool) {
        if owned {
            goToReadScreen()
        } else {
            loadingView.startLoading()
            guard let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? DescriptionTableViewCell else { return }
            cell.actionButton.isUserInteractionEnabled = false
            viewModel.purchaseNote()
        }
    }
    
    func tagDidTap(tag: SearchTag) {
        let moreNote = MoreNoteViewController()
        moreNote.viewModel = MoreNoteViewModel(type: .tag, tag: tag)
        navigationController?.pushViewController(moreNote, animated: true)
    }
}
