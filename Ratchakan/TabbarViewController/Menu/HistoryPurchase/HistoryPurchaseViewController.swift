//
//  HistoryPurchaseViewController.swift
//  ratchakan
//
//  Created by Chatchawarn.sobtid on 10/11/2568 BE.
//  Copyright © 2568 BE Chatcha.sobtid. All rights reserved.
//
import UIKit
import ObjectMapper

class HistoryPurchaseViewController: CustomViewControllerPushNavAndNoTabbar, CustomNavDelegate {
    
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
    var collectionView: UICollectionView!
    var collectionLayout: CollectionLayout!
    
    var titleNav: String?
    var paymentHistory: [PaymentHistory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView = UIView()
        topView.backgroundColor = .navbrandcolor
        view.backgroundColor = .brandcolor_bg
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.setAnimatedTouch()
        backButton.adjustsImageWhenHighlighted = false
        backButton.adjustsImageWhenDisabled = false
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        topView.addSubview(backButton)
        
        navTitleLabel = UILabel()
        navTitleLabel.text = self.titleNav
        navTitleLabel.setParameter(font: .navTitleFont, color: .cellWhiteLabel)
        navTitleLabel.numberOfLines = 2
        navTitleLabel.lineBreakMode = .byWordWrapping
        topView.addSubview(navTitleLabel)
        view.addSubview(topView)
        
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.height.equalTo(TOP_VIEW)
        }
        
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
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
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
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: MARGIN, left: MARGIN, bottom: MARGIN, right: MARGIN)
        collectionView.regis(nibName: HistoryPurchaseCollectionViewCell.cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.getHistoryPurchaseData()
        }
    }
    
    func getHistoryPurchaseData() {
        let api = API()
        api.getPaymentHistory({ (finished, response) in
            let paymentHistoryData = Mapper<HistoryPurchaseDataModel>().map(JSON: response ?? [:])
            self.paymentHistory = paymentHistoryData?.resultHistoryPurchase?.paymentHistory ?? []
            self.paymentHistory.sort{ $0.transactionDate ?? 0 > $1.transactionDate ?? 0 }
            self.collectionView.reloadData()
        })
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
}

extension HistoryPurchaseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.paymentHistory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryPurchaseCollectionViewCell.cellIdentifier, for: indexPath) as! HistoryPurchaseCollectionViewCell
        cell.setHistoryPurchaseData(paymentData: self.paymentHistory[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HistoryPurchaseCollectionViewCell else { return }
        cell.setHistoryPurchaseData(paymentData: self.paymentHistory[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 180)
    }
}


