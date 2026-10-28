//
//  Datetime.swift
//  ratchakan
//
//  Created by JJsobtid on 19/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation

class Datetime {
	
	fileprivate func chkDate(_ sender: Any) -> String {
		var str_date = ""
		
		guard let date = sender as? String else {
			guard let datens = sender as? Date else {
				let timestamp = Double(sender as? UInt ?? UInt(sender as! Int))
				let updateTimestamp = Date.init(timeIntervalSince1970: timestamp)
				str_date = updateTimestamp.description
				return str_date
			}
			str_date = datens.description
			return str_date
		}
		str_date = date
		return str_date
	}
	
	fileprivate func component(date: String) -> DateComponents {
		let dateFormat = self.getFormatter(date)
		if let fromDateTime = dateFormat.date(from: date) {
		
			let calendar = Calendar.init(identifier: .buddhist)
			let component = calendar.dateComponents([.weekday, .day, .month, .year, .minute, .hour], from: fromDateTime)

			return component
		}
		return DateComponents.init()
	}
	
	fileprivate func getFormatter(_ sender: Any) -> DateFormatter {
		let str_date = self.chkDate(sender)
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		
		dateFormatter.timeZone = TimeZone.current
		dateFormatter.locale = Locale.init(identifier: "en_US")
		
		if dateFormatter.date(from: str_date) == nil {
			dateFormatter.dateFormat = "yyyy-MM-dd"
			if dateFormatter.date(from: str_date) == nil {
				dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a ZZZ"
				if dateFormatter.date(from: str_date) == nil {
					dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
				}
			}
		}
		
		return dateFormatter
		
	}
	
	fileprivate func shortYear(_ sender: Any) -> String {
		var year: String = "\(sender)"
		if year.count >= 2 {
			let index = year.index(year.endIndex, offsetBy: -2)
			year = String(year[index...])
		} else {
			
		}
		return year
	}
	
	static func getCurrentTimestamp() -> UInt {
		return UInt(Date.init().timeIntervalSince1970)
	}
	
	func showDateWithFormat(_ format: String, date: Any) -> String {
		let str_date = self.chkDate(date)
		let date_comp = self.component(date: str_date)
		let arrFormat = format.split(separator: "-")
		
		var date = ""
		if DataConfig.month.count > date_comp.month!-1 {
			for form in arrFormat {
				if form == "ww" {
					date = "\(date)"
				}
			}
		}
		
		return date
	}
	func showDate(_ sender: Any, short: Bool, haveWeekday: Bool = false, showTime: Bool) -> String {
		
		let str_date = self.chkDate(sender)
		let date_comp = self.component(date: str_date)
		
		var date = ""
		if DataConfig.month.count > date_comp.month!-1 {
			let y = (short) ? shortYear(date_comp.year!) : "\(date_comp.year!)"
			let mn = (short) ? DataConfig.shortMonth[date_comp.month!-1] : DataConfig.month[date_comp.month!-1]
			let weekday = (haveWeekday ? "วัน\((DataConfig.weekday)[date_comp.weekday!-1]) ที่ " : "")
			date = "\(weekday)\(date_comp.day!) \(mn) \(y)"
			if short {
				date = "\(weekday)\(date_comp.day!) \(mn) \(y)"
			}
			if showTime {
				var h = "\(date_comp.hour!)"
				if date_comp.hour! < 10 { h = "0\(h)" }
				var m = "\(date_comp.minute!)"
				if date_comp.minute! < 10 { m = "0\(m)" }
				date = "\(weekday)\(date_comp.day!) \(mn) \(y) \(h):\(m) น."
			}
		}
		
		return date
	}
	
	func showDate(_ sender: Any, toDate: Any, shortDate: Bool, haveTime: Bool = false) -> String {
		var str_date = ""
		let str_dateFrom = self.chkDate(sender)
		let str_dateTo = self.chkDate(toDate)
		
		let dateFrom_comp = self.component(date: str_dateFrom)
		let dateTo_comp = self.component(date: str_dateTo)
		
		let yearFrom = (shortDate) ? self.shortYear(dateFrom_comp.year!) : "\(dateFrom_comp.year!)"
		let yearTo = (shortDate) ? self.shortYear(dateTo_comp.year!) : "\(dateTo_comp.year!)"
		let monthFrom = (shortDate) ? (DataConfig.shortMonth)[dateFrom_comp.month!-1] : (DataConfig.month)[dateFrom_comp.month!-1]
		let monthTo = (shortDate) ? (DataConfig.shortMonth)[dateTo_comp.month!-1] : (DataConfig.month)[dateTo_comp.month!-1]
		
		if DataConfig.month.count > dateFrom_comp.month!-1 && DataConfig.month.count > dateTo_comp.month!-1 {
			if dateFrom_comp.year == dateTo_comp.year {
				if dateFrom_comp.month == dateTo_comp.month {
					if dateFrom_comp.day == dateTo_comp.day {
						str_date = "\(dateTo_comp.day!) \(monthTo) \(yearTo)"
					} else {
						str_date = "\(dateFrom_comp.day!) - \(dateTo_comp.day!) \(monthTo) \(yearTo)"
					}
				} else {
					str_date = "\(dateFrom_comp.day!) \(monthFrom) - \(dateTo_comp.day!) \(monthTo) \(yearTo)"
				}
			} else {
				str_date = "\(dateFrom_comp.day!) \(monthFrom) \(yearFrom) - \(dateTo_comp.day!) \(monthTo) \(yearTo)"
			}
			
			if haveTime {
				let hTo: String = dateTo_comp.hour! < 10 ? "0\(dateTo_comp.hour!)" : "\(dateTo_comp.hour!)"
				let minTo: String = dateTo_comp.minute! < 10 ? "0\(dateTo_comp.minute!)" : "\(dateTo_comp.minute!)"
				
				str_date = str_date + " " + hTo + ":" + minTo + " น."
			}
		}
		
		return str_date
	}
	func showTime(_ sender: Any) -> String {
		let str_date = self.chkDate(sender)
		let date_comp = self.component(date: str_date)
		
		var date = ""
		if DataConfig.month.count > date_comp.month!-1 {
			var h = "\(date_comp.hour!)"
			if date_comp.hour! < 10 { h = "0\(h)" }
			var m = "\(date_comp.minute!)"
			if date_comp.minute! < 10 { m = "0\(m)" }
			date = "\(h):\(m) น."
		}
		return date
	}
	
	func firstDateOfThisMonth() -> Date {
		let now = Date.init()
		let calendar = Calendar.current
		var comp = calendar.dateComponents([.day, .year, .month, .weekOfMonth, .weekday], from: now)
		comp.day = 1
//		if comp.month == 0 {
//			comp.month = 11
//			comp.year = comp.year! - 1
//		} else {
//			comp.month = comp.month! - 1
//		}
		
		let dateMonth = calendar.date(from: comp)
		return dateMonth!
	}
	
	func birthDate(_ sender: Any) -> String {
		let str_date = self.chkDate(sender)
		let date_comp = self.component(date: str_date)
		
		var date = ""
		if DataConfig.month.count > date_comp.month!-1 {
			date = "\(date_comp.day!) \((DataConfig.month)[date_comp.month!-1]) \(date_comp.year!)"
			
		}
		
		return date
	}
	func statDate(_ sender: Any) -> String {
		let str_date = self.chkDate(sender)
		let date_comp = self.component(date: str_date)
		
		var date = "\(date_comp.day!)/\(date_comp.month!)/\(date_comp.year!%100)"

		return date
	}
	
	func daysBetween(_ date: Any, fromDate date2: Any = Date.init()) -> Int {
		let str_date = chkDate(date)
		let str_date_from = chkDate(date2)
		let dateFormat = getFormatter(str_date)
		let dateFormat2 = getFormatter(str_date_from)
		
		let dateTime = dateFormat.date(from: str_date)
		let date2Time = dateFormat2.date(from: str_date_from)
		
		let calendar = Calendar.current
		
		let date1 = calendar.startOfDay(for: date2Time!)
		let date2 = calendar.startOfDay(for: dateTime!)
		
		let components = calendar.dateComponents([.day], from: date1, to: date2)
		
		return components.day!
	}
	
	func fromThaiDate(_ date: String) -> Date {
		let arrDate = date.split(separator: " ")
		if arrDate.count == 3 {
			let monthIndex = (DataConfig.month.index(of: String(arrDate[1]))!) + 1
			let year = Int(arrDate[2])! - 543
            let dateNewFormat = "\(year)-\(monthIndex)-\((Int(arrDate[0]) ?? 0))"
			let dateFormatter = getFormatter(dateNewFormat)
			
			guard let date = dateFormatter.date(from: dateNewFormat) else {
				fatalError("ERROR: Date conversion failed due to mismatched format.")
			}
			return date
		} else {
			return Date()
		}
	}
    
    
	func showTime(_ sender: Any, to time: Any) -> String {
		var str_time = ""
		
		let str_dateFrom = self.chkDate(sender)
		let str_dateTo = self.chkDate(time)
		
		let dateFrom_comp = self.component(date: str_dateFrom)
		let dateTo_comp = self.component(date: str_dateTo)
		
		var h = "\(dateFrom_comp.hour!)"
		if dateFrom_comp.hour! < 10 { h = "0\(h)" }
		var m = "\(dateFrom_comp.minute!)"
		if dateFrom_comp.minute! < 10 { m = "0\(m)" }
		var h2 = "\(dateTo_comp.hour!)"
		if dateTo_comp.hour! < 10 { h2 = "0\(h2)" }
		var m2 = "\(dateTo_comp.minute!)"
		if dateTo_comp.minute! < 10 { m2 = "0\(m2)" }
		
		str_time = "\(h):\(m)-\(h2):\(m2) น."
		return str_time
	}
	
	func stringWith(timeinterval: UInt) -> String {
		let now = self.dateWith(timeinterval: timeinterval)
		let dateFormat = self.getFormatter(now.description)
		
		return dateFormat.string(from: now)
	}
	
	func dateWith(timeinterval: UInt) -> Date {
		let str_date = chkDate(timeinterval)
		let dateFormat = getFormatter(str_date)
//		dateFormat.date(from: date)
		
		return dateFormat.date(from: str_date)!//Date.init(timeIntervalSince1970: TimeInterval(timeinterval))
	}
	
	func dateNextYear() -> Date {
		let now = Date.init()
		let calendar = Calendar.current
		var comp = calendar.dateComponents([.year, .month, .weekOfMonth, .weekday], from: now)
		
		comp.year = comp.year!+1
		
		comp.day = 0
		
		let dateMonth = calendar.date(from: comp)
		return dateMonth!
	}
	
	static func timeFromSec(_ time: CLong, haveSpace: Bool, haveHour: Bool = true) -> String {
		var str = ""
		var times = time
		
		let h : CLong = times/3600
		var sh = "\(h)"
		if h < 10 {
			sh = "0\(h)"
		}
		times = times - (h * 3600)
		let m : CLong = times/60
		var sm = "\(m)"
		if m < 10 {
			sm = "0\(m)"
		}
		times = times - (m * 60)
		let s : CLong = times
		var ss = "\(s)"
		if s < 10 {
			ss = "0\(s)"
		}
		
		str = "\(sh):\(sm):\(ss)"

		if !haveHour {
			if h == 0 {
				str = "\(sm):\(ss)"
			} else {
				str = "\(sh):\(sm):\(ss)"
			}
		}
		if haveSpace {
			str = str.replacingOccurrences(of: ":", with: " : ")
		}
		return str
	}
	
	static func changeDayToYear(_ countDays: Int) -> String {
		let dayPerYear = 365
		let avDayPerWeek = 7
		var year = 0
		var week = 0
		var day = 0
		year = countDays/dayPerYear
		week = (countDays % dayPerYear) / avDayPerWeek
		day = (countDays % dayPerYear % avDayPerWeek)
		
		var str = ""
		if year != 0 {
			str += "\(year) ปี "
		}
		if week != 0 {
			str += "\(week) สัปดาห์ "
		}
		if day != 0 {
			str += "\(day) วัน"
		}
		if str == "" {
			str = "0 วัน"
		}
		return str
	}
}
