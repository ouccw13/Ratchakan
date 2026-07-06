//
//  MenuVC.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 3/11/2568 BE.
//  Copyright © 2568 BE Chatcha.sobtid. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Alamofire
import ObjectMapper
import SwiftJWT

class MenuVC: UIViewController {
    
    lazy var globalParameter = GlobalParameter.storeObserverSharedInstance
    var api: API!
    var listenerAccount: ListenerRegistration!
    var member: dictStringAny!
    let userDefaultData = UserDefaultData.storeObserverSharedInstance
    private let menuData = DataConfig.tableUserMenuTell
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var menuTableView: UITableView!
    private var mainButtonTableViewContainerView: UIView!
    private var contentStackView: UIStackView!
    var headerMenuView: HeaderMenuView!
    var menuView: MenuMasterView!
    var menuDetailView: MenuDetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .brandcolor_bg
        
        scrollView = {
            let scrollView = UIScrollView()
            scrollView.backgroundColor = .white
            scrollView.contentInset = .init(top: 0, left: 0, bottom: 20, right: 0)
            scrollView.showsVerticalScrollIndicator = false
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            return scrollView
        }()
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.snp.bottom)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
        }
        
        contentView = {
            let view = UIView()
            view.backgroundColor = .clearCanTouch
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.leading.equalTo(scrollView.snp.leading)
            $0.trailing.equalTo(scrollView.snp.trailing)
            $0.width.equalTo(SCREEN_WIDTH)
        }
        
        headerMenuView = HeaderMenuView()
        headerMenuView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerMenuView)
        headerMenuView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(150)
        }
        
        contentStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = IS_IPAD ? 12 : (IS_IPHONE_6 ? 10 : (SCREEN_WIDTH == 320.0 ? 10 : 14))
            return stackView
        }()
        contentView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(headerMenuView.snp.bottom).offset(20)
            $0.leading.equalTo(view.snp.leading).offset(20)
            $0.trailing.equalTo(view.snp.trailing).offset(-20)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
        
        mainButtonTableViewContainerView = UIView()
        mainButtonTableViewContainerView.backgroundColor = .white
        contentStackView.addArrangedSubview(mainButtonTableViewContainerView)
        
        
        menuTableView = UITableView()
        menuTableView.backgroundColor = .clear
        menuTableView.isScrollEnabled = false
        menuTableView.rowHeight = IS_IPAD ? 65 : 50
        menuTableView.separatorColor = .clear
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.register(MenuButtonTableViewCell.self, forCellReuseIdentifier: MenuButtonTableViewCell.identifier)
        mainButtonTableViewContainerView.addSubview(menuTableView)
        menuTableView.snp.makeConstraints {
            $0.top.equalTo(mainButtonTableViewContainerView.snp.top).offset(5)
            $0.leading.equalTo(mainButtonTableViewContainerView.snp.leading).offset(2)
            $0.bottom.equalTo(mainButtonTableViewContainerView.snp.bottom).offset(-6)
            $0.trailing.equalTo(mainButtonTableViewContainerView.snp.trailing).offset(-2)
        }
        self.setViewModel()
    }
    
    func setViewModel() {
        api = API()
        let member = api.getMember()
        headerMenuView.setHeaderMenuData(member: member)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.menuTableView.reloadData()
        }
        scrollView.contentSize = scrollView.scrollViewContentFitToSubview()
    }
}

extension MenuVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataConfig.ratchakanAppMenuSectionI.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuButtonTableViewCell.identifier,
                                                 for: indexPath) as! MenuButtonTableViewCell
        cell.setupCell(menuData: DataConfig.ratchakanAppMenuSectionI[indexPath.row]/*self.getMenuData(at: indexPath)*/, lastCell:  tableView.numberOfRows(inSection: indexPath.section) == (indexPath.row + 1))
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let c = cell as? MenuButtonTableViewCell else {
            return
        }
        c.setupCell(menuData: DataConfig.ratchakanAppMenuSectionI[indexPath.row]/*self.getMenuData(at: indexPath)*/,
                    lastCell: tableView.numberOfRows(inSection: indexPath.section) == (indexPath.row + 1))
    }
}
