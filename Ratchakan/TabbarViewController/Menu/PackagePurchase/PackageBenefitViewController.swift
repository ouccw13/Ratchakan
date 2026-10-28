//
//  PackageBenefitViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 19/4/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class PackageBenefitViewController: CustomViewControllerPushNavAndNoTabbar, CustomNavDelegate, UITableViewDelegate, UITableViewDataSource {

//	var topView: CustomNav!
    var topView: UIView!
    var backButton: UIButton!
    var navTitleLabel: UILabel!
//	let nav: Nav = Nav(title: "สิทธิประโยชน์สำหรับ \(string.th_vip)", isBack: true, isRight: false)
	
	var tableView: UITableView!
	
	lazy var api = API()
	var detailData: [dictStringAny] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()

//		topView = CustomNav(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TOP_VIEW))
        topView = UIView()
        topView.backgroundColor = .navbrandcolor
		view.backgroundColor = .brandcolor_bg
		
//		let navModel = CustomViewModelFromNav(withNav: nav)
//		topView.viewModel = navModel
//		topView.delegate = self
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
        navTitleLabel.set(text: "สิทธิประโยชน์สำหรับ \(string.th_vip)")
        topView.addSubview(navTitleLabel)
        
		tableView = UITableView(frame: CGRect(), style: .grouped)
		tableView.setParameter(.clear, separatorColor: .separateLine, showScrollVertical: false, horizontal: false, target: self)
		tableView.setDynamicHeight(40)
		tableView.register(PackageDetailTableViewCell.self, forCellReuseIdentifier: PackageDetailTableViewCell.cellIdentifier)
		
		let otherView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 20))
		tableView.tableFooterView = otherView
		
		view.addSubview(tableView)
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
                make.leading.equalTo(backButton.snp.trailing).offset(10)
                make.centerY.equalTo(topView.snp.centerY).offset(IS_IPHONE_6 || IS_IPHONE_5_OR_LESS || IS_IPHONE_6P ? 12 : 24)
//                make.centerX.equalTo(topView.snp.centerX)
                make.trailing.equalTo(topView.snp.trailing).offset(-10)
            }
        }
        
		tableView.snp.makeConstraints { (make) in
			make.top.equalTo(topView.snp.bottom)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
			make.bottom.equalTo(view.snp.bottom)
		}
		
		reloadData()
    }
	
	func back() {
		navigationController?.popViewController(animated: true)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@objc func reloadData() {
		detailData = []
		api.getPackageDetail { (finished, response) in
			if finished {
				self.detailData = Validation.anyIsArrayAny(Validation.anyIsDictionary(response!, with: "result"), with: "details")
				self.tableView.reloadData()
			}
			return
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return detailData.count == 0 ? 0 : detailData.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: PackageDetailTableViewCell.cellIdentifier, for: indexPath) as! PackageDetailTableViewCell
		
		cell.setData(title: Validation.anyIsString(detailData[indexPath.item], with: "title"), detail: Validation.anyIsString(detailData[indexPath.item], with: "detail"), index: indexPath.item)
		return cell
	}
}

class PackageDetailTableViewCell: UITableViewCell {
	
	static let cellIdentifier: String = "PackageDetailTableViewCell"
	
	var titleLabel: UILabel!
	var detailLabel: UILabel!
	
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		selectionStyle = .none
		
		createUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	fileprivate func createUI() {
        backgroundColor = .white
		titleLabel = UILabel()
		titleLabel.flexibleLine()
		titleLabel.setParameter(font: .kanitLight16, color: .Celllabel)
		
		detailLabel = UILabel()
		detailLabel.flexibleLine()
		detailLabel.setParameter(font: .kanitLight12, color: .guestcolor)
		
		contentView.addsubviews([titleLabel, detailLabel])
		
	}
	
    func setData(title: String, detail: String, index: Int) {
        titleLabel.font = .kanitLight16
        titleLabel.textAlignment = .left
        titleLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
            make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
            make.top.equalTo(contentView.snp.top).offset(5.5)
            make.bottom.equalTo(detailLabel.snp.top)
        }
        detailLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(contentView.snp.bottom).offset(-5.5)
        }
        titleLabel.text = title
        detailLabel.text = detail
    }
	
}
