//
//  AllCalendarViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 26/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import FSCalendar
import MJRefresh

class AllCalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

	fileprivate var calendar: FSCalendar!
	fileprivate var refreshHeader: HeaderRefreshControl!
	fileprivate var calendarListTableView: UITableView!
	fileprivate var noEventDateView: UILabel!
	fileprivate var calendarData: [dictStringAny] = []
	fileprivate var calendarWithEvent: dictStringAny! = [:]
	fileprivate var calendarIsSorted: [String: Bool] = [:]
	fileprivate var tableData: [dictStringAny] = []
	fileprivate var loadingView: LoadingView!
	fileprivate var calendarTable: CalendarTableView!
	
	var selectedDate: Date!
	var firstTime: Bool = true
	
	lazy var api = API()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		calendar = FSCalendar(frame: CGRect(x: 0, y: PAGEBAR_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - TOP_VIEW - TABBAR_HEIGHT - PAGEBAR_HEIGHT))
		calendar.backgroundColor = .white
		calendar.dataSource = self
		calendar.delegate = self
		calendar.pagingEnabled = false
		calendar.allowsSelection = true
		calendar.allowsMultipleSelection = false
		calendar.firstWeekday = 1
		calendar.placeholderType = .none
		calendar.appearance.caseOptions = [.weekdayUsesSingleUpperCase, .headerUsesUpperCase]
		
		calendar.scope = .month
		calendar.scrollDirection = .vertical
		calendar.appearance.headerTitleFont = .kanitReg16
		calendar.appearance.titleFont = .kanitLight14
		calendar.appearance.weekdayFont = .kanitReg14
		calendar.appearance.headerTitleColor = .brandcolor1
		calendar.appearance.weekdayTextColor = .brandcolor2
		calendar.appearance.titleDefaultColor = .Celllabel
		calendar.appearance.titlePlaceholderColor = .Cellinformation
		calendar.appearance.titleTodayColor = .white
		calendar.appearance.todayColor = .successgreen
		calendar.appearance.selectionColor = .brandcolor2
		calendar.appearance.titleSelectionColor = .white

		view.addSubview(calendar)
		
		let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(reloadData))
        header.lastUpdatedTimeLabel?.hide()
		calendar.collectionView.mj_header = header
        calendar.collectionView.mj_header?.endRefreshing()
		
		loadingView = LoadingView(withSuperview: view)
		
		reloadData()
        // Do any additional setup after loading the view.
    }

	func scrollViewDidScroll(_ scrollView: UIScrollView) {

	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	// MARK: - FSCalendarDataSource
	func minimumDate(for calendar: FSCalendar) -> Date {
		return Datetime().firstDateOfThisMonth()
	}
	func maximumDate(for calendar: FSCalendar) -> Date {
		return Datetime().dateNextYear()
	}
	func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
		return nil
	}
	// MARK: - FSCalendarDelegate
	func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
		selectedDate = date
		selectedDate(date)
		setTableView(date)
	}
	func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
		if Validation.anyIsArrayAny(calendarWithEvent, with: Datetime().showDate(date, short: false, haveWeekday: true, showTime: false)).count != 0 {
			return 1
		}
		return 0
	}
	// MARK: - FSCalendarDelegateAppearance
	func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
		return [.brandcolor2]
	}
	func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
		return [.successgreen]
	}
	func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
		if Datetime().daysBetween(date, fromDate: Datetime.getCurrentTimestamp()) == 0 {
			return calendar.appearance.todayColor
		} else if Validation.anyIsArrayAny(calendarWithEvent, with: Datetime().showDate(date, short: false, haveWeekday: true, showTime: false)).count != 0 {
			return .separateLine
		}
		return nil
	}
	
	func setTableView(_ date: Date) {
		
		tableData = []
		DispatchQueue.main.async {
			let dateString = Datetime().showDate(date, short: false, haveWeekday: true, showTime: false)
			if not(Validation.dictionary(self.calendarIsSorted, with: dateString)) {
				self.loadingView.startLoading()
				self.calendarWithEvent[dateString] = Utility.sortArrayOfDictionary(Validation.anyIsArrayAny(self.calendarWithEvent, with: dateString), withInt: "dateTo", ascending: true)
				self.calendarIsSorted[dateString] = true
				self.loadingView.stopLoading()
			}
			if self.selectedDate == date {
				self.tableData = Validation.anyIsArrayAny(self.calendarWithEvent, with: dateString)
				if self.calendarTable == nil {
					self.calendarTable = CalendarTableView(self.view.frame, data: self.calendarWithEvent[dateString] as! [dictStringAny], title: dateString)
					self.view.addSubview(self.calendarTable)
					self.calendarTable.updateLayout()
				} else {
					self.calendarTable.setDataTool(dateString, data: self.calendarWithEvent[dateString] as! [dictStringAny])
				}
				self.calendarTable.animationIn()
			}
		}
	}
	
	@objc func reloadData() {
		calendarWithEvent = [:]
		calendarIsSorted = [:]
		loadingView.startLoading()
			self.api.getAllCalendar { (finished, response) in
                self.calendar.collectionView.mj_header?.endRefreshing()
				if not(self.firstTime) {
					self.calendar.collectionView.contentOffset = CGPoint(x: 0, y: 0)
				} else {
					self.firstTime = false
				}
				if finished {
					let data = Validation.anyIsDictionary(response!, with: "result")
					for (key, value) in data {
						let stringDate = Datetime().showDate(Int(key) ?? 0, short: false, haveWeekday: true, showTime: false)
						let calendar = value as! [dictStringAny]

						self.calendarWithEvent[stringDate] = Utility.sortArrayOfDictionary(calendar, withInt: "order", ascending: true)

					}
					self.calendar.reloadData()
					if self.selectedDate != nil {
						self.calendar(self.calendar, didSelect: self.selectedDate, at: .current)
					}
				}
				self.loadingView.stopLoading()
				return
			}
	}
	
	fileprivate func selectedDate(_ date: Date) {
		calendar.select(date, scrollToDate: not(IS_IPHONE_5_OR_LESS))
	}
}

// MARK: - ALL CALENDAR CELL CLASS
class AllCalendarCell: UITableViewCell {
	
	static let cellIdentifier = "AllCalendarCell"

	var titleLabel: UILabel!
	var detailLabel: UILabel!
	var dateLabel: UILabel!
	
	var detailTestData: Any!
	
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		backgroundColor = .white
		selectionStyle = .none
		
		titleLabel = UILabel()
		titleLabel.setParameter(font: .kanitReg16, color: .Celllabel)
		titleLabel.flexibleLine()
		
		detailLabel = UILabel()
		detailLabel.setParameter(font: .kanitLight14, color: .Celllabel)
		detailLabel.flexibleLine()
		
		dateLabel = UILabel()
		dateLabel.setParameter(font: .kanitLight14, color: .guestcolor)
		
		contentView.addsubviews([titleLabel, detailLabel, dateLabel])
		titleLabel.snp.remakeConstraints({ (make) in
			make.leading.equalTo(contentView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
			make.top.equalTo(contentView.snp.top).offset(MARGIN)
			make.height.equalTo(21)
		})
		detailLabel.snp.remakeConstraints({ (make) in
			make.top.equalTo(titleLabel.snp.bottom).offset(4)
			make.leading.equalTo(titleLabel.snp.leading)
			make.trailing.equalTo(titleLabel.snp.trailing)
		})
		dateLabel.snp.remakeConstraints { (make) in
			make.top.equalTo(detailLabel.snp.bottom).offset(4)
			make.leading.equalTo(detailLabel.snp.leading)
			make.trailing.equalTo(detailLabel.snp.trailing)
			make.bottom.equalTo(contentView.snp.bottom).offset(-MARGIN)
		}
	
	}
	
	func setData(_ data: dictStringAny) {
		titleLabel.text = Validation.anyIsString(Validation.anyIsDictionary(data, with: "type"), with: "typeName")
		detailLabel.text = Validation.anyIsString(Validation.anyIsDictionary(data, with: "bureau"), with: "name")
		dateLabel.text = Datetime().showDate(Validation.anyIsNumber(data, with: "dateFrom"), toDate: Validation.anyIsNumber(data, with: "dateTo"), shortDate: true)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
}
