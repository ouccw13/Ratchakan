//
//  ExamListViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 30/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

protocol ExamListDelegate {
	func didSelectIndexPath(_ indexPath: IndexPath)
}

class ExamListViewController: UIViewController, CustomNavDelegate, UITableViewDelegate, UITableViewDataSource {

	var topView: CustomNav!
    var topViewIphone: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
	var listTableView: UITableView!
	
	var nav: Nav = Nav(title: string.th_list_exam, isBack: true, isRight: false)
	
	var examListData: [Question]!
	var delegate: ExamListDelegate?
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		if UIColor.dark(color: .navbrandcolor) {
			return .lightContent
		} else {
			return .default
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = .brandcolor_bg
        if IS_IPAD {
            topView = CustomNav(frame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: TOP_VIEW))
        }else{
            topViewIphone = UIView()
            topViewIphone.backgroundColor = .navbrandcolor
            
            backButton = UIButton()
            backButton.setImage(UIImage(named: "backIcon"), for: .normal)
            backButton.setAnimatedTouch()
            backButton.adjustsImageWhenHighlighted = false
            backButton.adjustsImageWhenDisabled = false
            backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
            topViewIphone.addSubview(backButton)
            
            navTitleLabel = UILabel()
            navTitleLabel.setParameter(font: IS_IPHONE_6 || IS_IPHONE_5_OR_LESS ? .kanitReg16 : .navTitleFont, color: .cellWhiteLabel)
            navTitleLabel.numberOfLines = 2
            navTitleLabel.lineBreakMode = .byWordWrapping
            navTitleLabel.set(text: string.th_list_exam)
            topViewIphone.addSubview(navTitleLabel)
        }
        
		listTableView = UITableView(frame: CGRect(), style: .grouped)
		listTableView.backgroundColor = .clear
		listTableView.separatorColor = .clear
		listTableView.setDynamicHeight(53)
		listTableView.register(BulletNTitleTableViewCell.self, forCellReuseIdentifier: BulletNTitleTableViewCell.cellIdentifier)
        
        if IS_IPAD {
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
            
            view.insertSubview(listTableView, belowSubview: topView)
            listTableView.snp.remakeConstraints { (make) in
                make.top.equalTo(topView.snp.bottom)
                make.leading.equalTo(topView.snp.leading)
                make.trailing.equalTo(topView.snp.trailing)
                make.bottom.equalTo(view.snp.bottom)
            }

        }else{
            view.addSubview(topViewIphone)
            topViewIphone.snp.makeConstraints { (make) in
                make.top.equalTo(0)
                make.leading.equalTo(self.view.snp.leading)
                make.trailing.equalTo(self.view.snp.trailing)
                make.height.equalTo(TOP_VIEW)
            }
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topViewIphone.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS ? 12 : 24)
                make.leading.equalTo(topViewIphone.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(topViewIphone.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS ? 12 : 24)
                make.centerX.equalTo(topViewIphone.snp.centerX)
            }
            view.insertSubview(listTableView, belowSubview: topViewIphone)
            listTableView.snp.remakeConstraints { (make) in
                make.top.equalTo(topViewIphone.snp.bottom)
                make.leading.equalTo(topViewIphone.snp.leading)
                make.trailing.equalTo(topViewIphone.snp.trailing)
                make.bottom.equalTo(view.snp.bottom)
            }
        }
		
		listTableView.delegate = self
		listTableView.dataSource = self
        // Do any additional setup after loading the view.
		
		fillUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	fileprivate func fillUI() {
		if !isViewLoaded {
			return
		}
		
	}
	
	func back() {
		dismiss(animated: true, completion: nil)
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return examListData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: BulletNTitleTableViewCell.cellIdentifier, for: indexPath) as! BulletNTitleTableViewCell
		
		let examData: Question = examListData[indexPath.item]
		cell.setQuestion(title: examData.question!, selected: examData.isAnswer, last: examListData.count - 1  == indexPath.item)

		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! BulletNTitleTableViewCell
		cell.backgroundColor = .brandcolor3
		UIView.animate(withDuration: 0.25) {
			cell.backgroundColor = .white
		}
		delegate?.didSelectIndexPath(indexPath)
		back()
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		
	}
}
