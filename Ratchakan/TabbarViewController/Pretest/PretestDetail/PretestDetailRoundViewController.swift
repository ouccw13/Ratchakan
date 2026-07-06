//
//  PretestDetailRoundViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 15/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import AlamofireImage

class PretestDetailRoundViewController: CustomUIViewControllerWithNav, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, CustomButtonClick, CustomNavDelegate, PretestDetailCellDelegate {

	var fromNoti: Bool = false
	
	var tablePretestView: UITableView!
	var banner: UIImageView!
	var nextButton: CustomBottomButton!
	var backButton: UIButton!
	let nextButtonModel = BottomButton(title: "โหลดข้อมูล")
	var topView: CustomNav!
	var promotionId: String?
	var promotionModel: PromotionPretestModel?
	
	var nowChangeRound: UIButton!
	
	var timer: Timer!
	var count: Int = 0
	
	lazy var api = API()
	var loadingView: LoadingView!
	
	var pretestList: [PretestModel] = [] {
		didSet {
			if isViewLoaded {
				tablePretestView.reloadData()
				setNextButton()
				for pretest in pretestList {
					pretest.loadPretestData()
				}
				if pretestList.count == 1 {
					if let pretest = pretestList.first {
						pretest.pretestDictionary.bindAndFire { (dictionary) in
							self.setNextButton()
						}
					}
				}
			}
		}
	}
	
	@objc func updateTime() {
		if nextButton.button.titleLabel?.text != string.th_change_round {
			if let pretest = pretestList.first {
				let timeRemain = pretest.originalRound.pretestDate - Int(Datetime.getCurrentTimestamp())
				if timeRemain <= 60*30 {
					self.nextButton.setTitle("จะเริ่มสอบใน \(Datetime.timeFromSec(CLong(timeRemain), haveSpace: false, haveHour: false))")
					self.nextButton.setColorButton(.brandcolor3_dark, canTouch: false)
				} else {
					self.nextButton.setTitle("ยังไม่ถึงเวลาสอบ")
					self.nextButton.setColorButton(.darkgraybg, canTouch: false)
				}
				if timeRemain <= 0 {
					timer.invalidate()
					timer = nil
				}
			}
		}
	}
	
	func checkNextButton() {
		if pretestList.count == 1 {
			if let pretest = pretestList.first {
				if pretest.ownerPretest.value {
					if pretest.originalRound.action == 0 || pretest.originalRound.action == 1 {
						self.nextButton.setColorButton(.darkgraybg, canTouch: false)
						if timer == nil {
							timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
                            RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
						}
					} else if pretest.originalRound.action == 1 {
						self.nextButton.setTitle("เข้าห้องสอบ")
						self.nextButton.setColorButton(.brandcolor1, canTouch: true)
					} else if pretest.originalRound.action == 2 {
						if pretest.summitPretest.value {
							self.nextButton.setTitle("ฝึกซ้อม")
							self.nextButton.setColorButton(.darkgraybg, canTouch: false)
						} else {
							self.nextButton.setTitle("เริ่มสอบ")
							self.nextButton.setColorButton(.brandcolor1, canTouch: true)
						}
					} else if pretest.originalRound.action == 3 {
						self.nextButton.setTitle("ฝึกซ้อม")
						self.nextButton.setColorButton(.darkgraybg, canTouch: false)
					} else {
						if pretest.summitPretest.value {
							self.nextButton.setTitle("ฝึกซ้อม")
							if pretest.originalRound.action == 4 {
								self.nextButton.setColorButton(.brandcolor1, canTouch: true)
							} else {
								self.nextButton.setColorButton(.darkgraybg, canTouch: false)
							}
						} else {
							if pretest.originalRound.action == 2 {
								self.nextButton.setTitle(string.th_start_exam)
							} else {
								self.nextButton.setTitle("ฝึกซ้อม")
							}
							self.nextButton.setColorButton(.brandcolor1, canTouch: true)
						}
					}
				} else {
					self.nextButton.setTitle(string.th_regis_test)
				}
			}
		} else if pretestList.count > 1 {
			self.nextButton.setTitle(string.th_regis_test)
			self.nextButton.setColorButton(.brandcolor1, canTouch: true)
		}
	}
	func setNextButton() {
		if nextButton.button.titleLabel?.text != string.th_change_round {
			checkNextButton()
		}
	}
	var pretest: PretestModel?
	
	var nav: Nav? {
		didSet {
			fillUI()
		}
	}
	override var preferredStatusBarStyle: UIStatusBarStyle {
		if UIColor.dark(color: nav!.color) {
			return .lightContent
		} else {
			return .default
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .brandcolor_bg
		
		tablePretestView = UITableView(frame: CGRect(), style: .plain)
		tablePretestView.setDynamicHeight(496)
		tablePretestView.backgroundColor = .clear
		tablePretestView.separatorColor = .clear
		tablePretestView.showsVerticalScrollIndicator = false
		tablePretestView.delegate = self
		tablePretestView.dataSource = self
		tablePretestView.contentInset = UIEdgeInsets(top: SCREEN_WIDTH/2 - STATUSBAR, left: 0, bottom: BOTTOM_BAR, right: 0)
		tablePretestView.register(PretestDetailPurchaseTableViewCell.self, forCellReuseIdentifier: PretestDetailPurchaseTableViewCell.cellIdentifier)
		
		banner = UIImageView()
		banner.backgroundColor = .brandcolor2
		banner.af_setImage(withURL: URL(string: "https://s3-ap-southeast-1.amazonaws.com/sobtidimage/advertisement/banner/tablet/8d8f05e9278948b40d44101761540d22-RlWVbopJ1GZ8d6tk.jpg")!)
		view.addSubview(banner)
		view.addSubview(tablePretestView)
        // Do any additional setup after loading the view.
		tablePretestView.snp.makeConstraints { (make) in
			make.edges.equalTo(view.snp.edges)
		}
		
		nextButton = CustomBottomButton(frame: CGRect(x:0, y:0, width: SCREEN_WIDTH, height: BOTTOM_BAR))
		nextButton.viewModel = CustomBottomButtonFromModel(withButton: nextButtonModel)
		view.addSubview(nextButton)
		nextButton.setColorButton(.brandcolor1, canTouch: false)
		nextButton.delegate = self
		nextButton.snp.makeConstraints { (make) in
			make.bottom.equalTo(self.view.snp.bottom)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			make.height.equalTo(BOTTOM_BAR)
		}
		
		backButton = UIButton(type: .custom)
		backButton.withImageColor("backIcon")
		backButton.tintColor = .Celllabel
		backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
		view.addSubview(backButton)
		backButton.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize(width: 22, height: 17))
			make.leading.equalTo(view.snp.leading).offset(MARGIN)
			make.top.equalTo(view.snp.top).offset(MARGIN + STATUSBAR)
		}
		
		if Utility.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_11() {
			
		} else {
			tablePretestView.contentOffset = CGPoint(x: 0, y: -(SCREEN_WIDTH/2 - STATUSBAR))
		}
		
		loadingView = LoadingView(withSuperview: view)
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

	func fillUI() {
		topView = CustomNav(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TOP_VIEW))
		let navModel = CustomViewModelFromNav(withNav: nav!)
		topView.viewModel = navModel
		topView.delegate = self
		view.addSubview(topView)
		topView.snp.makeConstraints { (make) in
			make.top.equalTo(0)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			make.height.equalTo(TOP_VIEW)
		}
		Utility.convertUIImageView(backButton.imageView!, toColor: UIColor.dark(color: nav!.color) ? .white : .black)
		topView.alpha = 0
		
		tablePretestView.contentOffset = CGPoint(x: 0, y: -SCREEN_WIDTH/2)
		
		checkNextButton()
	}

	func hideTabbar() {
		navigationController?.isNavigationBarHidden = true
		navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
		tabBarController?.tabBar.isHidden = true
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@objc func back() {
		if fromNoti {
			dismiss(animated: true, completion: nil)
		} else {
			navigationController?.popViewController(animated: true)
		}
	}
	
	func next(tag: Int) {
		if pretestList.count == 1 {
			if let pretest = pretestList.first {
				if pretest.ownerPretest.value {
					if nextButton.button.titleLabel?.text == string.th_change_round {
						if Validation.anyIsArrayString(pretest.round.value[pretest.selectedRound.round], with: "registerMember").count == pretest.limitNumRegis {
							dropdownAlert.title("ไม่สามารถเปลี่ยนรอบได้", message: "Pretest รอบนี้เต็มแล้ว", backgroundColor: .errorRed, textColor: .white)
							return
						} else if pretest.selectedRound.pretestDate <= Datetime.getCurrentTimestamp() {
							dropdownAlert.title("ไม่สามารถเปลี่ยนรอบได้", message: "Pretest รอบนี้เริ่มสอบไปแล้ว", backgroundColor: .errorRed, textColor: .white)
							return
						}
						loadingView.startLoading()
						view.isUserInteractionEnabled = false
						pretest.changeRound({ (finished, response) in
							self.view.isUserInteractionEnabled = true
							self.loadingView.stopLoading()
							if finished {
                                let successAlert = UIAlertController(title: "เปลี่ยนรอบสำเร็จ", message: "คุณทำการเปลี่ยนรอบแล้ว", preferredStyle: UIAlertController.Style.alert)
								successAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: nil))
								self.present(successAlert, animated: true, completion: nil)
								self.nextButton.setTitle("เปลี่ยนรอบสำเร็จ")
								self.nextButton.setColorButton(.brandcolor3_dark, canTouch: false)
							} else {
								self.tablePretestView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
								self.nextButton.setTitle(string.th_error)
								dropdownAlert.errorNTryAgain()
							}
							self.checkNextButton()
							self.nowChangeRound.setTitle(string.th_change_round, for: .normal)
							return
						})
					} else {
						if pretest.originalRound.action >= 2 {
							if pretest.summitPretest.value && pretest.originalRound.action != 4 {
								
							} else {
								loadingView.startLoading()
								api.checkMemberPretestOnline(action: .add, pretestId: pretest.pretestID) { (finished, response) in
									self.loadingView.stopLoading()
									if finished {
										self.api.getTimeStamp({ (finished, response) in
											if finished {
												let time = Validation.anyIsNumber(Validation.anyIsDictionary(response!, with: "result"), with: "time")
												let startStartView = ExamStartViewController()
                                                startStartView.modalPresentationStyle = .fullScreen
												startStartView.typeExam = "pretest"
												startStartView.timeSec = pretest.originalRound.pretestEndDate - time
												startStartView.pretestEndDate = pretest.originalRound.pretestEndDate
												startStartView.pretestData = pretest.pretestDictionary.value
												self.present(startStartView, animated: true, completion: {
												})
											} else {
												dropdownAlert.errorNTryAgain()
											}
											return
										})
										return
									} else {
										self.loadingView.stopLoading()
                                        let errAlert = UIAlertController(title: "ไม่สามารถเข้าสอบได้ในขณะนี้", message: Validation.anyIsString(response ?? [:], with: "message"), preferredStyle: UIAlertController.Style.alert)
										errAlert.addAction(UIAlertAction(title: string.th_ok, style: .cancel, handler: nil))
										self.present(errAlert, animated: true, completion: nil)
										return
									}
								}
							}
						}
					}
				} else {
					pushPurchaseDetailView()
				}
			}
		} else {
			pushPurchaseDetailView()
		}
	}
	
	fileprivate func pushPurchaseDetailView() {
		var purchaseDetailView: PretestPurchaseViewController! = PretestPurchaseViewController()
		if Utility.checkLogIn(member: API().getDatabase().getMember()) {
			if let promotion = promotionModel {
				purchaseDetailView.promotionModel = promotion
				for pretest in pretestList {
					if pretest.ownerPretest.value {
                        let ownerAlert = UIAlertController(title: "ยืนยันที่จะซื้อชุดโปรโมชัน", message: "คุณเป็นเจ้าของ Pretest บางชุดแล้ว", preferredStyle: UIAlertController.Style.alert)
						ownerAlert.addAction(UIAlertAction(title: string.th_cancel, style: .cancel, handler: nil))
						ownerAlert.addAction(UIAlertAction(title: string.th_confirm, style: .default, handler: { action in
							purchaseDetailView.pretestList = self.pretestList
							purchaseDetailView.nav = Nav(title: string.th_info_buyer, isBack: true, isRight: false)
							self.navigationController?.pushViewController(purchaseDetailView, animated: true)
						}))
						present(ownerAlert, animated: true, completion: nil)
						return
					}
				}
			} else {

			}
			for pretest in pretestList {
				if Validation.anyIsArrayString(pretest.round.value[pretest.selectedRound.round], with: "registerMember").count == pretest.limitNumRegis {
					let detail = pretestList.count == 1 ? "Pretest" : "\(pretest.pretestName)"
					dropdownAlert.title("ไม่สามารถสมัครได้", message: "\(detail) รอบนี้เต็มแล้ว", backgroundColor: .errorRed, textColor: .white)
					purchaseDetailView = nil
					return
				}
			}
			purchaseDetailView.pretestList = pretestList
			purchaseDetailView.nav = Nav(title: string.th_info_buyer, isBack: true, isRight: false)
			navigationController?.pushViewController(purchaseDetailView, animated: true)
		}
	}
	
	func setBanner(_ url: String) {
        banner.af_setImage(withURL: URL(string: "https://s3-ap-southeast-1.amazonaws.com/sobtidimage/advertisement/banner/tablet/\(url)")!, completion:  { [weak self] (image) in
            if let img = image.value {
                if img.isDark {
                    self?.backButton.imageView?.tintColor = .white
                } else {
                    self?.backButton.imageView?.tintColor = .Celllabel
                }
            }
        })
	}
	
	// MARK: - PRETEST CELL DELEGATE
	func showDetail(pretestName: String, pretestData: PretestModel) {
		let detailView = PretestDetailViewController()
		detailView.pretestModel = pretestData
		let nav = Nav(title: pretestName, isBack: true, isRight: false, color: .brandcolor1)
		detailView.nav = nav
		
		navigationController?.pushViewController(detailView, animated: true)
	}
	func resetConstraint() {
		view.reSetLayout()
		tablePretestView.reSetLayout()
	}
	func changeRound(_ sender: UIButton) {
		if pretestList.count == 1 {
			nowChangeRound = sender
			if pretestList.first!.summitPretest.value {
				nowChangeRound.setTitle(string.th_change_round, for: .normal)
			} else {
				if nextButton.button.titleLabel?.text != string.th_change_round {
					nextButton.setTitle(string.th_change_round)
					nextButton.setColorButton(.brandcolor1, canTouch: true)
				} else {
					nextButton.setTitle(string.th_cancel)
					checkNextButton()
					if let pretest = pretestList.first {
						pretest.selectedRound = pretest.originalRound
						tablePretestView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
					}
				}
			}
		}
	}
	func cantSelectRound() {
		if pretestList.count == 1 {
			nextButton.setColorButton(.darkgraybg, canTouch: false)
		}
	}
	
	// MARK: - TABLEVIEW DELEGATE & DATASOURCE
	func numberOfSections(in tableView: UITableView) -> Int {
		return pretestList.count
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return MARGIN
	}
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let footview = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: MARGIN))
		footview.backgroundColor = .clear
		return footview
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: PretestDetailPurchaseTableViewCell.cellIdentifier, for: indexPath) as! PretestDetailPurchaseTableViewCell
		cell.backgroundColor = .brandcolor_bg
		cell.delegate = self
		cell.pretestModel = pretestList[indexPath.section]
		return cell
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		banner.snp.remakeConstraints { (make) in
			if -tablePretestView.contentOffset.y < SCREEN_WIDTH/2 {
				make.top.equalTo(-(SCREEN_WIDTH/2 + tablePretestView.contentOffset.y)/2)
				make.height.equalTo(SCREEN_WIDTH/2)
			} else {
				make.top.lessThanOrEqualTo(0)
				make.height.equalTo(-tablePretestView.contentOffset.y)
			}
			make.centerX.equalTo(view.snp.centerX)
			make.width.equalTo(banner.snp.height).multipliedBy(2)
		}
		if -tablePretestView.contentOffset.y < TOP_VIEW {
			UIView.animate(withDuration: 0.3, animations: {
				self.backButton.alpha = 0
				self.topView.alpha = 1
			})
		} else {
			UIView.animate(withDuration: 0.3, animations: {
				self.backButton.alpha = 1
				self.topView.alpha = 0
			})
		}
	}
}
