//
//  DetailCalendarViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 13/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class DetailCalendarViewController: CustomViewControllerPresentNavAndNoTabbar, CustomNavDelegate, UITableViewDelegate, UITableViewDataSource {

	enum type: Int {
		case title
		case position
		case date
		case detail
		case reference
		
		static func returnType(i: Int) -> type {
			switch i {
			case 0:
				return .title
			case 1:
				return .position
			case 2:
				return .date
			case 3:
				return .detail
			case 4:
				return .reference
			default:
				return .reference
			}
		}
	}
	
	var sectionTable: [type] = [.title, .position, .date, .detail, .reference]
	
	var topView: CustomNav!
	var tableDetailView: UITableView!
	var calendarData: dictStringAny!
	
	var nav: Nav? {
		didSet {
			fillUI()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .brandcolor_bg
		
		topView = CustomNav(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TOP_VIEW))
		tableDetailView = UITableView(frame: CGRect(), style: .grouped)
		tableDetailView.setDynamicHeight(44)
		tableDetailView.backgroundColor = .clear
		tableDetailView.separatorColor = .clear
		tableDetailView.delegate = self
		tableDetailView.dataSource = self
		tableDetailView.sectionHeaderHeight = 30
		tableDetailView.showsVerticalScrollIndicator = false
		tableDetailView.register(CalendarDetailTableCell.self, forCellReuseIdentifier: CalendarDetailTableCell.cellIdentifier)
		tableDetailView.register(CalendarDetailTableCell.self, forCellReuseIdentifier: "detail")
		
		fillUI()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func back() {
		dismiss(animated: true, completion: nil)
	}
	func next() {
        let confirmAlert = UIAlertController(title: "ต้องการบันทึกลงปฏิทิน?", message: nil, preferredStyle: UIAlertController.Style.alert)
		confirmAlert.addAction(UIAlertAction(title: string.th_cancel, style: .cancel, handler: nil))
		confirmAlert.addAction(UIAlertAction(title: string.th_confirm, style: .default, handler: { action in
			Utility.addEvent(title: "\(Validation.anyIsString(self.calendarData, with: "name")) \(Validation.anyIsString(Validation.anyIsDictionary(self.calendarData, with: "bureau"), with: "name"))", startDate: UInt(Validation.anyIsNumber(self.calendarData, with: "dateFrom")), endDate: UInt(Validation.anyIsNumber(self.calendarData, with: "dateTo")), note: Validation.anyIsString(self.calendarData, with: "detail").removeHtmlTag(), type: "calendar", url: Validation.anyIsString(self.calendarData, with: "reference"))
		}))
		present(confirmAlert, animated: true, completion: nil)

	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		hideTabbar()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		hideTabbar()
		
	}
	
	func hideTabbar() {
		navigationController?.isNavigationBarHidden = true
		navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
		tabBarController?.tabBar.isHidden = true
	}
	
	func fillUI() {
		if !isViewLoaded {
			return
		}
		
		let navViewModel = CustomViewModelFromNav(withNav: nav!)
		topView.viewModel = navViewModel
		topView.delegate = self
		
		view.addSubview(topView);
		topView.snp.makeConstraints { (make) in
			make.top.equalTo(0)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			make.height.equalTo(TOP_VIEW)
		}
		view.insertSubview(tableDetailView, belowSubview: topView)
		tableDetailView.snp.makeConstraints { (make) in
			make.top.equalTo(topView.snp.bottom)
			make.leading.equalTo(self.view.snp.leading)
			make.trailing.equalTo(self.view.snp.trailing)
			make.bottom.equalTo(self.view.snp.bottom)
		}
		
		tableDetailView.reloadData()
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return sectionTable.count
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == type.position.rawValue {
			return Validation.anyIsArrayAny(calendarData, with: "vacancy").count + 1
		}
		return 1
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		var headerView: UIView = UIView()
		if section == 0 {

		} else if section == type.position.rawValue {
			headerView = createHeaderView(title: "เปิดรับสมัคร")
		} else if section == type.date.rawValue {
			headerView = createHeaderView(title: "วันที่")
		} else if section == type.detail.rawValue {
			headerView = createHeaderView(title: "รายละเอียดเพิ่มเติม")
		} else if section == type.reference.rawValue {
			headerView = createHeaderView(title: "ที่มา")
		}
		return headerView
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: CalendarDetailTableCell
		if indexPath.section == type.detail.rawValue {
			cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as! CalendarDetailTableCell
		} else {
			cell = tableView.dequeueReusableCell(withIdentifier: CalendarDetailTableCell.cellIdentifier, for: indexPath) as! CalendarDetailTableCell
		}
		cell.setData(calendarData, section: type.returnType(i: indexPath.section), row: indexPath.item)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == type.reference.rawValue {
			Utility.open(url: Validation.anyIsString(calendarData, with: "reference").addPrefixHTTP())
		}
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

class CalendarDetailTableCell: UITableViewCell {
	
	static let cellIdentifier = "CalendarDetailTableCell"
	
	var titleLabel: UILabel!
	var calendarProfile: UIImageView!
	var detailTextView: CustomTextView!
	var detailLabel: UILabel!
	var bottomLine: UIView!
	
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		backgroundColor = .white
		selectionStyle = .none
		
		titleLabel = UILabel()
		titleLabel.setParameter(font: .kanitLight14, color: .Celllabel)
		
		calendarProfile = UIImageView()
		calendarProfile.setParameter(name: "logo", mode: .scaleAspectFit)
		
		detailTextView = CustomTextView()
		
		detailLabel = UILabel()
		detailLabel.setParameter(font: .kanitLight14, color: .Celllabel, alignment: .right)
		
		bottomLine = UIView()
		bottomLine.lineView(withColor: .separateLine)
		
		contentView.addsubviews([titleLabel, calendarProfile, detailTextView, detailLabel, bottomLine])
	}
	
	func setData(_ data: dictStringAny, section: DetailCalendarViewController.type, row: Int) {
		titleLabel.unFlexibleLine()
		if section == .title {
			Utility.show([titleLabel, calendarProfile], hides: [detailTextView, detailLabel, bottomLine])
			titleLabel.text = Validation.anyIsString(Validation.anyIsDictionary(data, with: "bureau"), with: "name")
			titleLabel.setParameter(font: .kanitReg14, color: .Celllabel)
			titleLabel.flexibleLine()
			
			calendarProfile.af_setImage(withURL: URL(string: Validation.anyIsString(Validation.anyIsDictionary(data, with: "bureau"), with: "image"))!, placeholderImage: UIImage(named: "logo"))
			
		} else if section == .position {
			Utility.show([titleLabel, detailLabel, bottomLine], hides: [detailTextView, calendarProfile])
			if row != 0 {
				titleLabel.text = Validation.anyIsString(Validation.anyIsArrayAny(data, with: "vacancy")[row-1], with: "positionName")
				titleLabel.textColor = .guestcolor
				titleLabel.lineBreakMode = .byTruncatingTail
				
				detailLabel.text = "\(Validation.anyIsNumber(Validation.anyIsArrayAny(data, with: "vacancy")[row-1], with: "qty")) อัตรา"
				detailLabel.textColor = .Celllabel
				bottomLine.hide()
			} else {
				titleLabel.text = "จำนวน"
				titleLabel.setParameter(font: .kanitLight14, color: .Celllabel)
				
				var totalQty = 0
				for position in Validation.anyIsArrayAny(data, with: "vacancy") {
					totalQty = totalQty + Validation.anyIsNumber(position, with: "qty")
				}
				detailLabel.text = "\(Validation.anyIsArrayAny(data, with: "vacancy").count) ตำแหน่ง \(totalQty) อัตรา"
				detailLabel.textColor = .brandcolor1
			}
		} else if section == .date {
			Utility.show([titleLabel, detailLabel], hides: [detailTextView, calendarProfile, bottomLine])
			titleLabel.text = Datetime().showDate(Validation.anyIsNumber(data, with: "dateFrom"), toDate: Validation.anyIsNumber(data, with: "dateTo"), shortDate: true)
			titleLabel.textColor = .guestcolor

			detailLabel.text = Datetime().daysBetween(Validation.anyIsNumber(data, with: "dateFrom")) <= 0 ? string.th_today : "จะถึงใน \(Datetime().daysBetween(Validation.anyIsNumber(data, with: "dateFrom"))) วัน"
			detailLabel.textColor = .brandcolor1
			
		} else if section == .detail {
			Utility.show([detailTextView], hides: [titleLabel, detailLabel, calendarProfile, bottomLine])
			let detailData = Validation.anyIsString(data, with: "detail")
			
			detailTextView.setDetailCalendar(Utility.empty(str: detailData, ph: "ไม่พบรายละเอียด"))
		} else if section == .reference {
			Utility.show([titleLabel], hides: [calendarProfile, detailLabel, bottomLine, detailLabel])
			titleLabel.text =  Validation.anyIsString(data, with: "reference")
			titleLabel.textColor = .brandcolor1
		}
		setLayout(withSection: section, row: row, data: data)
	}
	
	fileprivate func setTitleConstrain() {
		titleLabel.snp.remakeConstraints({ (make) in
			make.leading.equalTo(self.contentView.snp.leading).offset(MARGIN)
			make.top.equalTo(self.contentView.snp.top).offset(11.5)
			make.bottom.equalTo(self.contentView.snp.bottom).offset(-11.5)
			make.height.equalTo(21)
			make.trailing.equalTo(self.detailLabel.snp.leading).offset(-SMALLINSET)
		})
	}
	
	fileprivate func setLayout(withSection section: DetailCalendarViewController.type, row: Int, data: dictStringAny) {
		if section == .title {
			calendarProfile.snp.remakeConstraints({ (make) in
				make.size.equalTo(CGSize(width: 60, height: 60))
				make.top.equalTo(self.contentView.snp.top).offset(10)
				make.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
				make.trailing.equalTo(self.contentView.snp.trailing).offset(-MARGIN)
			})
			titleLabel.snp.remakeConstraints({ (make) in
				make.leading.equalTo(self.contentView.snp.leading).offset(MARGIN)
				make.centerY.equalTo(self.calendarProfile.snp.centerY)
				make.height.lessThanOrEqualTo(60)
				make.trailing.equalTo(self.calendarProfile.snp.leading).offset(-MARGIN)
			})
		} else if section == .position {
			setTitleConstrain()
			detailLabel.snp.remakeConstraints({ (make) in
				if row != 0 {
					var qty = Validation.anyIsNumber(Validation.anyIsArrayAny(data, with: "vacancy")[row-1], with: "qty")
					let qtyWidth: CGFloat = 40
					var positionWidth: CGFloat = 8.5
					while(qty >= 10) {
						positionWidth = positionWidth + 8.5
						qty = qty / 10
					}
					make.width.equalTo(positionWidth + qtyWidth)
				}
				make.centerY.equalTo(self.contentView.snp.centerY)
				make.height.equalTo(21)
				make.trailing.equalTo(self.contentView.snp.trailing).offset(-MARGIN)
			})
			if row == 0 {
				titleLabel.snp.remakeConstraints({ (make) in
					make.leading.equalTo(self.contentView.snp.leading).offset(MARGIN)
					make.top.equalTo(self.contentView.snp.top).offset(11.5)
					make.bottom.equalTo(self.contentView.snp.bottom).offset(-11.5)
					make.height.equalTo(21)
					make.trailing.equalTo(self.contentView.snp.centerX)
				})
				detailLabel.snp.remakeConstraints({ (make) in
					make.leading.equalTo(self.contentView.snp.centerX)
					make.centerY.equalTo(self.contentView.snp.centerY)
					make.height.equalTo(21)
					make.trailing.equalTo(self.contentView.snp.trailing).offset(-MARGIN)
				})
				bottomLine.snp.remakeConstraints({ (make) in
					make.height.equalTo(1)
					make.leading.equalTo(self.contentView.snp.leading).offset(MARGIN)
					make.trailing.equalTo(self.contentView.snp.trailing)
					make.bottom.equalTo(self.contentView.snp.bottom)
				})
			}
		} else if section == .date {
			setTitleConstrain()
			detailLabel.snp.remakeConstraints({ (make) in
				make.leading.equalTo(self.contentView.snp.centerX)
				make.centerY.equalTo(self.contentView.snp.centerY)
				make.height.equalTo(21)
				make.trailing.equalTo(self.contentView.snp.trailing).offset(-MARGIN)
			})
		} else if section == .detail {
			detailTextView.layoutIfNeeded()
			let sizeThatFitsTextView = detailTextView.sizeThatFits(CGSize(width: SCREEN_WIDTH, height: CGFloat(MAXFLOAT)))
			detailTextView.frame = CGRect(origin: CGPoint(), size: sizeThatFitsTextView)
			detailTextView.sizeToFit()
			self.detailTextView.snp.remakeConstraints({ (make) in
				make.top.equalTo(self.contentView.snp.top)
				make.leading.equalTo(self.contentView.snp.leading)
				make.trailing.equalTo(self.contentView.snp.trailing)
				make.height.equalTo(detailTextView.contentSize.height)
				make.bottom.equalTo(self.contentView.snp.bottom)
			})
			detailTextView.layoutIfNeeded()
			detailTextView.updateConstraints()

		} else if section == .reference {
			titleLabel.snp.remakeConstraints({ (make) in
				make.leading.equalTo(self.contentView.snp.leading).offset(MARGIN)
				make.top.equalTo(self.contentView.snp.top).offset(11.5)
				make.bottom.equalTo(self.contentView.snp.bottom).offset(-11.5)
				make.height.equalTo(21)
				make.trailing.equalTo(self.contentView.snp.trailing).offset(-MARGIN)
			})
		}
		self.contentView.layoutIfNeeded()
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
	
}
