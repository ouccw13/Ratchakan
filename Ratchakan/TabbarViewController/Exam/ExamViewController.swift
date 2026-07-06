//
//  ExamViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 7/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//
import UIKit

class ExamViewController: CustomUIViewControllerWithNav {
    
    var topView: UIView!
    var navTitleLabel: UILabel!
    var refreshHeader: HeaderRefreshControl!
    var isFirstTime: Bool = true
    var collectionView: UICollectionView!
    var collectionLayout: CollectionLayout!
    var memberDefaultData = MemberDefaultData.storeObserverSharedInstance
    var nodataView: NoDataView!
    lazy var api: API! = API()
    var nav: Nav = Nav(title: string.th_exam, isBack: false, isRight: false, color: UIColor.navbrandcolor)
    var examGroupData: [[String: Any]] = []
    var db: Databases?
    var member: [String:Any]?
    var collectionData: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView = UIView()
        topView.backgroundColor = .navbrandcolor
        view.backgroundColor = .brandcolor_bg
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.height.equalTo(TOP_VIEW)
        }
        
        navTitleLabel = UILabel()
        navTitleLabel.setParameter(font: .navTitleFont, color: .cellWhiteLabel)
        navTitleLabel.set(text: string.th_exam)
        topView.addSubview(navTitleLabel)
        if IS_IPAD {
            navTitleLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY)/*.offset(INSET)*/
                make.centerX.equalTo(topView.snp.centerX)
            }
        }else{
            navTitleLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.centerX.equalTo(topView.snp.centerX)
            }
        }

        collectionLayout = CollectionLayout(withcol: (IS_IPAD ? 2 : 1), height: 91, axis: .vertical)
        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionLayout)
        collectionView.hideScrollIndicatior()
        collectionView.alwaysBounceVertical = true
        collectionView.setUp(self, bg: .clear)
        var topInset = MARGIN
        var bottomInset = MARGIN
        if !Utility.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_11() {
            bottomInset += TABBAR_HEIGHT
            topInset -= MARGIN
        }

        if HAVE_NOTCH {

        } else {
            collectionView.contentInset = UIEdgeInsets(top: topInset, left: MARGIN, bottom: bottomInset, right: MARGIN)
        }
        collectionView.register(ExamGroupCollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        view.insertSubview(collectionView, belowSubview: topView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.bottom.equalTo(self.view.snp.bottom)
        }

        refreshHeader = HeaderRefreshControl(withColor: .brandcolor1, titleAttribute: Utility.setStringAttributes(string.en_pull_refresh, textColor: .brandcolor1, font: .kanitReg14, underline: false), target: (self ,#selector(refreshData)))
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshHeader
        } else {
            collectionView.insertSubview(refreshHeader, at: 0)
        }

        nodataView = NoDataView(view.frame)
        collectionView.addSubview(nodataView)
        nodataView.snp.makeConstraints {
            $0.edges.equalTo(view.snp.edges)
        }
        nodataView.hide()
        
        view.layoutIfNeeded()
        
        db = api.db
        member = self.api.getDatabase().getMember()
        reloadData()
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstTime {
            isFirstTime = false
            checkMember()
        }
        fillUI()
    }
    
    @objc func checkLogin(_ Notification: Notification) {
        isFirstTime = true
        collectionData = []
        collectionView.reloadData()
        fillUI()
    }
    
    @objc func initAPI(_ sender: NSNotification) {
        api = API()
        member = api.getDatabase().getMember()
        reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listenNotiLogInOut(#selector(initAPI(_ :)))
    }
    
    private func showInfo() {
        DispatchQueue.main.async { [weak self] in
            let introViewController = IntroductionViewController()
            introViewController.modalPresentationStyle = .fullScreen
            self?.present(introViewController, animated: true, completion: nil)
        }
    }
    
    private func checkMember() {
        guard let member_id = member!["memberId"] as? String else {
            showInfo()
            return
        }

        if member_id == "" {
            showInfo()
        } else {
            api.checkProfile({ (_, _) in
                return
            })
            api.checkSession { (_, _) in
                return
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillUI() {
        if !isViewLoaded {
            return
        }
        
        if isFirstTime {
            reloadData()
        }
       
    }
    
    func reloadData() {
        if refreshHeader != nil {
            refreshHeader.setTitleBeginRefreshing()
        }
        api.getExamGroup { (finished, response) in
            if finished {
                guard let result = response!["result"] as? [[String: Any]] else {
                    return
                }
                self.examGroupData.removeAll()
                self.collectionData.removeAll()
                for item in result {
                    if item["examGroupId"] as! String == "87be4ca7-580e-4d26-b8c6-d94323676c10" || item["examGroupId"] as! String == "3408fa7c-d0f7-4d7d-b331-371aa68dcaa4" || item["examGroupId"] as! String == "326b7d39-5634-481d-8a5c-1cf09b37aff2" || (Validation.anyIsNumber(self.api.packages, with: item["examGroupId"] as! String) != 0 && Validation.anyIsNumber(self.api.packages, with: item["examGroupId"] as! String) >= Datetime.getCurrentTimestamp()) {
                        self.examGroupData.append(item)
                    }
                }
                
                self.collectionData = Utility.sortArrayOfDictionary(self.examGroupData, withInt: "order", ascending: true)
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.collectionView.reloadData()
                    self.collectionView.collectionViewLayout.invalidateLayout()
                }
                self.collectionData.isEmpty ? self.nodataView.show() : self.nodataView.hide()
                self.refreshHeader.endRefreshing()
                if self.isFirstTime {
                    self.isFirstTime = false
                }
            }else{
                self.refreshHeader.endRefreshing()
                Utility.showAlert(title: "เกิดข้อผิดพลาด", detail:  response?["message"] as? String ?? "ระบบไม่สามารถโหลดข้อมูลได้")
            }
        }
    }
    
    @objc func refreshData() {
        if refreshHeader != nil {
            refreshHeader.setTitleBeginRefreshing()
        }
        api.getExamGroup { (finished, response) in
            if finished {
                guard let result = response!["result"] as? [[String: Any]] else {
                    return
                }
                self.examGroupData.removeAll()
                self.collectionData.removeAll()
                for item in result {
                    if item["examGroupId"] as! String == "87be4ca7-580e-4d26-b8c6-d94323676c10" || item["examGroupId"] as! String == "3408fa7c-d0f7-4d7d-b331-371aa68dcaa4" || item["examGroupId"] as! String == "326b7d39-5634-481d-8a5c-1cf09b37aff2" || (Validation.anyIsNumber(self.api.packages, with: item["examGroupId"] as! String) != 0 && Validation.anyIsNumber(self.api.packages, with: item["examGroupId"] as! String) >= Datetime.getCurrentTimestamp()) {
                        self.examGroupData.append(item)
                    }
                }
                
                self.collectionData = Utility.sortArrayOfDictionary(self.examGroupData, withInt: "order", ascending: true)
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.collectionView.reloadData()
                    self.collectionView.collectionViewLayout.invalidateLayout()
                }
                self.collectionData.isEmpty ? self.nodataView.show() : self.nodataView.hide()
                self.refreshHeader.endRefreshing()
                if self.isFirstTime {
                    self.isFirstTime = false
                }
            }else{
                self.refreshHeader.endRefreshing()
                Utility.showAlert(title: "เกิดข้อผิดพลาด", detail:  response?["message"] as? String ?? "ระบบไม่สามารถโหลดข้อมูลได้")
            }
        }
    }
}

extension ExamViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ExamGroupCollectionViewCell
        cell.backgroundColor = .clear
        cell.setCellData(collectionData[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ExamGroupCollectionViewCell else { return }
        cell.setCellData(collectionData[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ExamGroupCollectionViewCell
        let examGroupView = ExamPageGroupViewController()//ExamGroupViewController()
        examGroupView.groupId = cell.groupId
        examGroupView.nav = Nav(title: cell.subjectTitle.text!, isBack: true, isRight: !true, imageRight: "iconFillter", color: .navbrandcolor)
        
        navigationController?.pushViewController(examGroupView, animated: true)
    }
}


