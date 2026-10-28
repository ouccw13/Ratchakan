//
//  CalendarTableView.swift
//  ratchakan
//
//  Created by JJsobtid on 9/4/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class CalendarTableView: UIView, UITableViewDelegate, UITableViewDataSource {

	var calendarData: [dictStringAny]!
	
	var superviewFrame: CGRect!
	var topPosition: CGFloat!
	var lastPosition: CGFloat!
	var textViewHeight: CGFloat!
	
	var closeButton: UIButton!
	var titleTool: UILabel!
	var calendarTable: UITableView!
	var noEventDateView: UILabel!
	
	let topHeight: CGFloat = 48
	
	init(_ frame: CGRect, data: [dictStringAny], title: String) {
		super.init(frame: frame)
		
		backgroundColor = .white
		
		calendarData = data
		
		let titleView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: topHeight))
		titleView.backgroundColor = .clearCanTouch
		
		addSubview(titleView)
		
		closeButton = UIButton()
		closeButton.setParameter("", textColor: .clear, font: .kanitReg14, backgroundColor: .clearCanTouch)
		closeButton.setImage(#imageLiteral(resourceName: "closeIcon"), for: .normal)
		closeButton.addTarget(self, action: #selector(closeTool), for: .touchUpInside)
		
		addSubview(closeButton)
		
		closeButton.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize(width: 22, height: 22))
			make.trailing.equalTo(self.snp.trailing).offset(-MARGIN)
			make.top.equalTo(self.snp.top).offset(MARGIN)
		}
		
		titleTool = UILabel()
		titleTool.setParameter(font: .kanitReg16, color: .Celllabel, alignment: .center)
		
		addSubview(titleTool)
		
		titleTool.snp.makeConstraints { (make) in
			make.top.equalTo(self.snp.top).offset(MARGIN)
			make.leading.equalTo(self.snp.leading)
			make.trailing.equalTo(self.snp.trailing)
			make.height.equalTo(22)
		}
		
		calendarTable = UITableView(frame: CGRect(x: 0, y: topHeight, width: SCREEN_WIDTH, height: self.frame.height - TABBAR_HEIGHT), style: .plain)
		calendarTable.setParameter(.brandcolor_bg, separatorColor: .separateLine, showScrollVertical: true, horizontal: false, target: self)
		calendarTable.setDynamicHeight(53)
		calendarTable.register(AllCalendarCell.self, forCellReuseIdentifier: AllCalendarCell.cellIdentifier)
		
		insertSubview(calendarTable, belowSubview: titleTool)
		
		noEventDateView = UILabel()
		noEventDateView.setParameter(font: .kanitLight16, color: .brandcolor2, alignment: .center)
		noEventDateView.flexibleLine()
		calendarTable.insertSubview(noEventDateView, at: 0)
		noEventDateView.snp.makeConstraints { (make) in
			make.center.equalTo(calendarTable.snp.center)
			make.width.equalTo(SCREEN_WIDTH - 2*MARGIN)
		}
		noEventDateView.hide()

		setDataTool(title, data: data)
		
		dropShadow(color: .brandcoloralpha, opacity: 1.0, offSet: CGSize(width: 0, height: -3), radius: 6)
		
		let pan = UIPanGestureRecognizer(target: self, action: #selector(dragtool(_:)))
		titleView.addGestureRecognizer(pan)
		let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
		titleView.addGestureRecognizer(tap)
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func closeTool() {
		animationOut()
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return calendarData.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: AllCalendarCell.cellIdentifier, for: indexPath) as! AllCalendarCell
		cell.setData(calendarData[indexPath.item])
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! AllCalendarCell
		cell.backgroundColor = .brandcolor1
		UIView.animate(withDuration: 0.2) {
			cell.backgroundColor = .white
		}
		
		let calendarDetailViewController = DetailCalendarViewController()
		calendarDetailViewController.calendarData = calendarData[indexPath.item]
        let detailTitle = Validation.anyIsString(Validation.anyIsDictionary(calendarData[indexPath.item], with: "type"), with: "typeName").trimSpace()
        calendarDetailViewController.nav = Nav(title: detailTitle.isEmpty ? string.th_detail : detailTitle, isBack: true, isRight: true, imageRight: "downloadIcon", color: .navbrandcolor)
		Utility.getCurrentViewController().present(calendarDetailViewController, animated: true, completion: nil)
	}
	
	func setDataTool(_ title: String, data: [dictStringAny]) {
		let sameDate = calendarData.count == data.count && titleTool.text == title
		calendarData = data
		titleTool.text = title
		if !sameDate {
			calendarTable.reloadData()
			if calendarData.count == 0 {
				calendarTable.separatorStyle = .none
				noEventDateView.show()
				noEventDateView.text = "ไม่พบ Event"
			} else {
				noEventDateView.hide()
				calendarTable.separatorStyle = .singleLine
				calendarTable.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
			}
		}
	}
	
	func updateLayout() {
		let superview = self.superview
		if superview != nil {
			superviewFrame = superview!.frame
			frame = CGRect(x: 0, y: superviewFrame.size.height, width: superviewFrame.size.width, height: superviewFrame.size.height)
		}
	}
	func animationIn() {
		if frame.origin.y >= superviewFrame.size.height {
			topPosition = superviewFrame.size.height*0.5
			lastPosition = topPosition
//			let height = topPosition - topHeight
			self.isHidden = false
			UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
				self.frame = CGRect(x: self.frame.origin.x, y: self.topPosition*1.1, width: self.superviewFrame.size.width, height: self.superviewFrame.size.height)
			}, completion: { (finished) in
				UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
					self.frame = CGRect(x: self.frame.origin.x, y: self.topPosition*0.9, width: self.frame.size.width, height: self.frame.size.height)
				}, completion: { (finished) in
					UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
						self.frame = CGRect(x: self.frame.origin.x, y: self.topPosition, width: self.frame.size.width, height: self.frame.size.height)
					}, completion: { (finished) in
						self.calendarTable.frame = CGRect(x: 0, y: self.calendarTable.frame.origin.y, width: self.calendarTable.frame.width, height: self.frame.height - self.frame.origin.y - self.topHeight - TABBAR_HEIGHT)
						self.lastPosition = self.frame.origin.y
					})
				})
			})
		}
	}
	
	func animationOut() {
		let currentPosition = frame.origin.y
		let topPosition = superviewFrame.size.height
		
		UIView.animate(withDuration: 0.25, animations: {
			self.frame = CGRect(x: self.frame.origin.x, y: currentPosition*0.9, width: self.frame.size.width, height: self.frame.size.height)
		}) { (finish) in
			if finish {
				UIView.animate(withDuration: 0.25, animations: {
					self.frame = CGRect(x: self.frame.origin.x, y: topPosition, width: self.frame.size.width, height: self.frame.size.height)
				}, completion: { (fin) in
					if fin {
						self.isHidden = true
					}
				})
			}
		}
	}
	
	@objc fileprivate func tap(_ sender: UITapGestureRecognizer) {
		animationIn()
	}
	
	@objc fileprivate func dragtool(_ sender: UIPanGestureRecognizer) {
		let dragPosition = sender.translation(in: sender.view!).y
		let newPosition = lastPosition + dragPosition
		let height = frame.size.height - frame.origin.y - topHeight
		let lowPositionY: CGFloat = IS_IPHONE_5_OR_LESS ? 0.7 : (IS_IPAD ? 0.8 : 0.75)
		if newPosition >= round(frame.size.height*0.15) && newPosition <= frame.size.height*lowPositionY {
			frame = CGRect(x: frame.origin.x, y: newPosition, width: frame.size.width, height: frame.height)
			calendarTable.frame = CGRect(x: calendarTable.frame.origin.x, y: calendarTable.frame.origin.y, width: calendarTable.frame.width, height: height - TABBAR_HEIGHT)
		}
	
		if sender.state == .ended {
			lastPosition = frame.origin.y
			frame = CGRect(x: frame.origin.x, y: lastPosition, width: frame.size.width, height: frame.height)
			calendarTable.frame = CGRect(x: calendarTable.frame.origin.x, y: calendarTable.frame.origin.y, width: calendarTable.frame.width, height: frame.size.height - frame.origin.y - topHeight - TABBAR_HEIGHT)
		}
	}
	
	fileprivate func minSizeAnimationOut() {
		let topPosition = superviewFrame.size.height - TABBAR_HEIGHT
		UIView.animate(withDuration: 0.25, animations: {
			self.frame = CGRect(x: self.frame.origin.x, y: topPosition, width: self.frame.size.width, height: self.frame.size.height)
			self.calendarTable.frame = CGRect(x: self.calendarTable.frame.origin.x, y: self.calendarTable.frame.origin.y, width: self.calendarTable.frame.size.width, height: topPosition - self.topHeight)
		}) { (finished) in
			self.lastPosition = self.frame.origin.y
			self.isHidden = false
		}
	}
}
