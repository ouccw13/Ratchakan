//
//  DeleteAccountAppleViewController.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 13/6/2566 BE.
//  Copyright © 2566 BE Chatcha.sobtid. All rights reserved.
//

import UIKit
import Alamofire

class DeleteAccountAppleViewController: CustomViewControllerPushNavAndNoTabbar,CustomNavDelegate {
    var topView: CustomNav!
    let nav: Nav = Nav(title: "ลบบัญชีผู้ใช้", isBack: true, isRight: false)
    var collectionView: UICollectionView!
    var collectionLayout: CollectionLayout!
    
    lazy var api = API()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView = CustomNav(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TOP_VIEW))
        view.backgroundColor = .brandcolor_bg
        
        let navModel = CustomViewModelFromNav(withNav: nav)
        topView.viewModel = navModel
        topView.delegate = self
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.height.equalTo(TOP_VIEW)
        }
        
        collectionLayout = CollectionLayout(withcol: 1, height: 320,axis: .vertical)
        collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionLayout)
        collectionView.hideScrollIndicatior()
        collectionView.alwaysBounceVertical = false
        collectionView.setUp(self, bg: .clear)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.register(DeleteAccountCollectionViewCell.self, forCellWithReuseIdentifier: DeleteAccountCollectionViewCell.identifier)
        view.insertSubview(collectionView, belowSubview: topView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.bottom.equalTo(self.view.snp.bottom)
        }
    }
}

extension DeleteAccountAppleViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeleteAccountCollectionViewCell.identifier, for: indexPath) as! DeleteAccountCollectionViewCell
        cell.updateUI()
        return cell
    }
}

//class DeleteAcountAppleViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
//    @IBOutlet private var navtitleLabel: UILabel!
//    @IBOutlet private var collectionView: UICollectionView!
//    @IBOutlet private var validateTextforDeleteAccountLabel: UILabel!
//    @IBOutlet private var searchView: UIView!
//    @IBOutlet private var searchField: UITextField!
//    @IBOutlet private var searchViewBottomConstraint: NSLayoutConstraint!
//    @IBOutlet private var confirmButton: UIButton!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        hideKeyboardWhenTappedAround()
////        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
////        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
////        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
////        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//        setupUI()
//    }
//
////    @objc override func keyboardWillShow(notification: NSNotification) {
////        searchViewBottomConstraint?.constant = 30
////    }
////
////    @objc override func keyboardWillHide(notification: NSNotification) {
////        searchViewBottomConstraint?.constant = 20
////    }
//
////    override func viewDidLayoutSubviews() {
////        super.viewDidLayoutSubviews()
////        collectionView.collectionViewLayout.invalidateLayout()
////    }
//
//    private func setupUI() {
////        navtitleLabel.text = "ลบบัญชีผู้ใช้"
////        collectionView.register(UINib(nibName: "DeleteAccountCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: DeleteAccountCollectionViewCell.identifier)
////        collectionView.register(DeleteAccountCollectionViewCell.self, forCellWithReuseIdentifier: DeleteAccountCollectionViewCell.identifier)
////        collectionView.reloadData()
////        collectionView.register(DeleteAccountCollectionViewCell.self, forCellWithReuseIdentifier: "DeleteAccountCollectionViewCell")
////        validateTextforDeleteAccountLabel.font = .kanitReg14
////        validateTextforDeleteAccountLabel.textColor = .Celllabel
////        validateTextforDeleteAccountLabel.text = "กรุณาพิมพ์ \(#""ยืนยันการลบบัญชี""#) เพื่อยืนยัน"
////        validateTextforDeleteAccountLabel.changeFont(ofText: #""ยืนยันการลบบัญชี""#, with: .kanitMed14)
////        searchView.borderView(color: .lightGray, width: 1.0)
////        confirmButton.backgroundColor = .lightgraybg
////        confirmButton.setTitle("ยืนยัน", for: .normal)
////        confirmButton.borderView(color: .lightgraybg, width: 1.0)
////        confirmButton.cornerView(radius: 25.0, clip: true)
////        confirmButton.isEnabled = false
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: 320)
//    }
//    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeleteAccountCollectionViewCell.identifier, for: indexPath) as! DeleteAccountCollectionViewCell
//        cell.updateUI()
//        return cell
//    }
//}
//
//
