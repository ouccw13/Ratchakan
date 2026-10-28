//
//  PretestDetailViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 16/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import SDWebImage

class PretestDetailViewController: CustomUIViewControllerWithNav, CustomNavDelegate, UITableViewDelegate, UITableViewDataSource, CustomButtonClick {
	
	lazy var api = API()
	
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
    var coverView: PretestDetailHeaderView!
    var coverHeight: CGFloat = 212
	var tableDetailView: UITableView!
	var pretestModel: PretestModel!
	var myPretest: Bool!
	var startPretestButton: CustomBottomButton!
	var historyPretestButton: CustomBottomButton!
	
	var loadingView: LoadingView!
	
	var nav: Nav? {
		didSet {
			fillUI()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .brandcolor_bg
				
        topView = UIView()
        topView.backgroundColor = .navbrandcolor
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.setAnimatedTouch()
        backButton.adjustsImageWhenHighlighted = false
        backButton.adjustsImageWhenDisabled = false
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        topView.addSubview(backButton)
        
        navTitleLabel = UILabel()
        navTitleLabel.setParameter(font: IS_IPHONE_6 || IS_IPHONE_5_OR_LESS ? .kanitReg16 : .navTitleFont, color: .cellWhiteLabel)
        navTitleLabel.numberOfLines = 2
        navTitleLabel.lineBreakMode = .byWordWrapping
        navTitleLabel.set(text: nav?.title)
        topView.addSubview(navTitleLabel)
        
		tableDetailView = UITableView(frame: CGRect(), style: .grouped)
		tableDetailView.setDynamicHeight(53)
		tableDetailView.register(PretestDetailTableViewCell.self, forCellReuseIdentifier: PretestDetailTableViewCell.cellIdentifier)
		tableDetailView.backgroundColor = .clear
		tableDetailView.separatorColor = .clear
		tableDetailView.delegate = self
		tableDetailView.dataSource = self
		tableDetailView.sectionHeaderHeight = 30
		
		if not(Utility.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_11()) {
			tableDetailView.tableHeaderView = createHeaderView(title: "รายละเอียดข้อสอบ")
		}
        coverHeight = (view.frame.width*212/375) + 230
        fillUI()

		loadingView = LoadingView(withSuperview: view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func back() {
		navigationController?.popViewController(animated: true)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		hideTabbar()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		listenNotiLogInOut(#selector(initAPI(_ :)))
		hideTabbar()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidAppear(animated)
		viewDisappear()
	}
	
	@objc func initAPI(_ sender: NSNotification) {
		api = API()
	}
	func hideTabbar() {
		navigationController?.isNavigationBarHidden = true
		navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
		tabBarController?.tabBar.isHidden = true
	}
	
	func fillUI() {
		if !isViewLoaded || nav == nil {
			return
		}
		
		view.addSubview(topView)
        
        coverView = PretestDetailHeaderView()
        if IS_IPAD {
            let banner = pretestModel.banner["tablet"] as? dictStringAny ?? ["path":""]
            let bannerTablet = banner["path"] as? String ?? ""
            coverView.setBanner(banner: bannerTablet)
        }else{
            let banner = pretestModel.banner["mobile"] as? dictStringAny ?? ["path":""]
            let bannerMobile = banner["path"] as? String ?? ""
            coverView.setBanner(banner: bannerMobile)
        }
        view.addSubview(coverView)
        
		topView.snp.makeConstraints { (make) in
			make.top.equalTo(0)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
            make.height.equalTo(IS_IPHONE_6P ? TOP_VIEW + MARGIN : TOP_VIEW)
		}
        if IS_IPAD {
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY)
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(backButton.snp.trailing).offset(10)
                make.centerY.equalTo(topView.snp.centerY)
                make.trailing.equalTo(topView.snp.trailing).offset(-10)
            }
        }else{
            backButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.leading.equalTo(topView.snp.leading).offset(5)
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
            navTitleLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(backButton.snp.trailing).offset(10)
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
                make.trailing.equalTo(topView.snp.trailing).offset(-10)
            }
        }
        coverView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.height.equalTo(coverHeight/2)
            make.trailing.equalTo(view.snp.trailing)
        }
        view.addSubview(tableDetailView)
		tableDetailView.snp.makeConstraints { (make) in
            make.top.equalTo(coverView.snp.bottom).offset(5)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			if myPretest != nil {
				make.bottom.equalTo(view.snp.bottom).offset(-BOTTOM_BAR)
			} else {
				make.bottom.equalTo(self.view.snp.bottom)
			}
		}
		
		if myPretest != nil {
			let startModel: BottomButton = BottomButton(title: string.th_start_exam, color: .brandcolor1)
			let startPretestViewModel = CustomBottomButtonFromModel(withButton: startModel)
			startPretestButton = CustomBottomButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH/2, height: BOTTOM_BAR))
			startPretestButton.tag = 0
			startPretestButton.delegate = self
			startPretestButton.viewModel = startPretestViewModel
			
			let historyModel: BottomButton = BottomButton(title: string.th_test_result, color: .brandcolor2)
			let historyPretestViewModel = CustomBottomButtonFromModel(withButton: historyModel)
			historyPretestButton = CustomBottomButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH/2, height: BOTTOM_BAR))
			historyPretestButton.tag = 1
			historyPretestButton.delegate = self
			historyPretestButton.viewModel = historyPretestViewModel
			
			view.addsubviews([startPretestButton, historyPretestButton])
			startPretestButton.snp.remakeConstraints ({ (make) in
				make.leading.equalTo(view.snp.leading)
				make.bottom.equalTo(view.snp.bottom)
				make.trailing.equalTo(view.snp.centerX)
				make.height.equalTo(BOTTOM_BAR)
			})
			historyPretestButton.snp.remakeConstraints({ (make) in
				make.leading.equalTo(view.snp.centerX)
				make.bottom.equalTo(view.snp.bottom)
				make.trailing.equalTo(view.snp.trailing)
				make.height.equalTo(BOTTOM_BAR)
			})
			pretestModel.loadPretestData()
			pretestModel.pretestDictionary.bindAndFire { (data) in
				if self.myPretest {
						self.startPretestButton.setColorButton(.brandcolor1, canTouch: true)
						self.historyPretestButton.setColorButton(.brandcolor2, canTouch: true)
				}
			}
			if not(myPretest) {
				historyPretestButton.hide()
				startPretestButton.setTitle(string.th_buy_pretest)
				startPretestButton.setColorButton(.brandcolor1, canTouch: true)
				startPretestButton.snp.remakeConstraints ({ (make) in
					make.leading.equalTo(view.snp.leading)
					make.bottom.equalTo(view.snp.bottom)
					make.trailing.equalTo(view.snp.trailing)
					make.height.equalTo(BOTTOM_BAR)
				})
            }else{
                if pretestModel.summitPretest.value == false {
                    historyPretestButton.hide()
                    startPretestButton.snp.remakeConstraints ({ (make) in
                        make.leading.equalTo(view.snp.leading)
                        make.bottom.equalTo(view.snp.bottom)
                        make.trailing.equalTo(view.snp.trailing)
                        make.height.equalTo(BOTTOM_BAR)
                    })
                }else{
                    historyPretestButton.show()
                    startPretestButton.snp.remakeConstraints ({ (make) in
                        make.leading.equalTo(view.snp.leading)
                        make.bottom.equalTo(view.snp.bottom)
                        make.trailing.equalTo(view.snp.centerX)
                        make.height.equalTo(BOTTOM_BAR)
                    })
                }
            }
		}
	}
	
	fileprivate func pushPurchaseDetailView() {
		if Utility.checkLogIn(member: API().getDatabase().getMember()) {
			let purchaseDetailView = PretestPurchaseViewController()
			purchaseDetailView.pretestList = [pretestModel]
			purchaseDetailView.nav = Nav(title: string.th_info_buyer, isBack: true, isRight: false)
			navigationController?.pushViewController(purchaseDetailView, animated: true)
		}
	}
	
	// MARK: - Bottom Button Delegate
    func next(tag: Int) {
        if tag == 0 {
            // start
            if not(myPretest) {
                pushPurchaseDetailView()
            } else {
                loadingView.startLoading()
                self.api.getTimeStamp({ (finished, response) in
                    self.loadingView.stopLoading()
                    if finished {
                        let time = Validation.anyIsNumber(Validation.anyIsDictionary(response!, with: "result"), with: "time")
                        let startStartView = ExamStartViewController()
                        startStartView.modalPresentationStyle = .fullScreen
                        startStartView.typeExam = "pretest"
                        startStartView.timeSec = self.pretestModel.originalRound.pretestEndDate - time
                        startStartView.pretestEndDate = self.pretestModel.originalRound.pretestEndDate
                        startStartView.pretestData = self.pretestModel.pretestDictionary.value
                        self.present(startStartView, animated: true, completion: {
                        })
                    } else {
                        dropdownAlert.errorNTryAgain()
                    }
                    return
                })
                return
            }
        } else if tag == 1 {
            // history
            let pretestHistoryVC = PretestHistoryViewController(pretestId: pretestModel.pretestID, pretestName: pretestModel.pretestName)
            let navPretestHistVC = UINavigationController(rootViewController: pretestHistoryVC)
            navPretestHistVC.modalPresentationStyle = .fullScreen
            navPretestHistVC.modalTransitionStyle = .crossDissolve
            present(navPretestHistVC, animated: true, completion: nil)
        }
    }
	
	// MARK: - Table View Delegate
	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return pretestModel.detailsFilterNotZero.count
        }
		return 1
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		var headerView: UIView!
        if section == 0 {
			headerView = createHeaderView(title: "รายละเอียดข้อสอบ")
		} else if section == 1 {
			headerView = createHeaderView(title: "เนื้อหาที่ออกสอบ")
		} else if section == 2 {
			headerView = createHeaderView(title: "ราคา")
		}

		return headerView
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: PretestDetailTableViewCell.cellIdentifier, for: indexPath) as! PretestDetailTableViewCell
        cell.isType = "Pretest"
        if indexPath.section == 0 {
			cell.detailTestData = ["\(pretestModel.questionNum)", "\(Utility.checkFloat(pretestModel.totalScore))", "\(pretestModel.timeLimit)"]
        } else if indexPath.section == 1 {
            cell.detailsInPretestModel = pretestModel.detailsFilterNotZero[indexPath.item]
		} else if indexPath.section == 2 {
			cell.detailTestData = pretestModel.regularPrice.counterservice
		}
        if pretestModel.details.count - 1 == indexPath.item {
            cell.setLayout(withSection: PretestDetailSection.withSection(section: indexPath.section),isShowBottom: false)
        }else{
            cell.setLayout(withSection: PretestDetailSection.withSection(section: indexPath.section),isShowBottom: true)
        }
		return cell
	}

	func createHeaderView(title: String) -> UIView {
		let headerView = UIView()
		headerView.backgroundColor = .clear
		let headerTitle = UILabel()
		headerTitle.setParameter(font: .kanitLight14, color: .Celllabel)
		headerTitle.text = title
		headerView.addSubview(headerTitle)
		headerTitle.snp.remakeConstraints { (make) in
			make.leading.equalTo(headerView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(headerView.snp.trailing).offset(-MARGIN)
			make.height.equalTo(21)
			make.bottom.equalTo(headerView.snp.bottom).offset(-4)
		}
		return headerView
	}
}
