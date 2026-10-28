//
//  PretestDetailPurchaseTableViewCell.swift
//  ratchakan
//
//  Created by JJsobtid on 15/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

protocol PretestDetailCellDelegate {
	func showDetail(pretestName: String, pretestData: PretestModel)
	func resetConstraint()
	func changeRound(_ sender: UIButton)
	func cantSelectRound()
}

class PretestDetailPurchaseTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

	static let cellIdentifier = "PretestDetailPurchaseTableViewCell"
	
	var pretestModel: PretestModel? {
		didSet {
			pretestModel!.connectListener()
			setData()
		}
	}
	
	lazy var api = API()
	
	var detailPretestView: UIView!
	var selectRoundView: UIView!
	var detailSelectView: UIView!
	
	var namePretest: UILabel!
	var sponserPretest: UILabel!
	var teacherPretest: UILabel!
    var teacherIcon: UIImageView!
	var datePretest: UILabel!
    var dateIcon: UIImageView!
	var price: UILabel!
    var priceIcon: UIImageView!
	var teacherProfile: UIImageView!
    var shadowProfile: UIView!
	var moreDetail: UIButton!
	
	var selectDate: UILabel!
	var selectTime: UILabel!
	var collectionDate: UICollectionView!
	var collectionTime: UICollectionView!
	
	var selectDetail: UILabel!
	var selectRound: UILabel!
    var roundIcon: UIImageView!
	var numRound: UILabel!
    var numIcon: UIImageView!
	var changeRound: UIButton!
	
	var collectionDateData: [dictStringAny] = []
	var collectionTimeData: [dictStringAny] = []
	
	var selectDateFirst, canSelectRound: Bool!
	
	var selectDateCell, selectTimeCell: PretestCollectionSelectDateCell!
	
	var delegate: PretestDetailCellDelegate?
	
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	
		canSelectRound = true
		selectionStyle = .none
		
		detailPretestView = UIView()
		detailPretestView.backgroundColor = .white
		teacherProfile = UIImageView()
		teacherProfile.cornerView(radius: 25)
		teacherProfile.setParameter(name: "tempProfile", mode: .scaleAspectFit)
		shadowProfile = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
		shadowProfile.dropShadowCircle(color: .brandcoloralpha)
		namePretest = UILabel()
		namePretest.text = "ชื่อ Pretest"
		namePretest.setParameter(font: .kanitReg18, color: .Celllabel)
		sponserPretest = UILabel()
		sponserPretest.text = "\(string.th_sponsor_by) SOBTID"
		sponserPretest.setParameter(font: .kanitLight16, color: .Celllabel)
		teacherIcon = UIImageView()
		teacherIcon.setParameter(name: "pretestNameIcon", mode: .scaleAspectFit)
		teacherPretest = UILabel()
		teacherPretest.text = "ข้อสอบโดย อาจารย์..."
		teacherPretest.setParameter(font: .kanitLight14, color: .Celllabel)
		dateIcon = UIImageView()
		dateIcon.setParameter(name: "pretestCalendarIcon", mode: .scaleAspectFit)
		datePretest = UILabel()
		datePretest.text = "เปิดรับสมัคร วัน เดือน - วัน เดือน ปี"
		datePretest.setParameter(font: .kanitLight14, color: .Celllabel)
		priceIcon = UIImageView()
		priceIcon.setParameter(name: "pretestPriceIcon", mode: .scaleAspectFit)
		price = UILabel()
		price.text = "ราคา xx บาท"
		price.setParameter(font: .kanitLight14, color: .Celllabel)
		moreDetail = UIButton()
		moreDetail.setParameter(string.th_more_detail, textColor: .brandcolor1, font: .kanitReg14, backgroundColor: .clear)
		moreDetail.titleLabel?.textAlignment = .right
		moreDetail.addTarget(self, action: #selector(showDetailPretest), for: .touchUpInside)
		shadowProfile.addSubview(teacherProfile)
		detailPretestView.addsubviews([shadowProfile, namePretest, sponserPretest, teacherIcon, teacherPretest, dateIcon, datePretest, price, priceIcon, moreDetail])

		selectRoundView = UIView()
		selectRoundView.backgroundColor = .white
		selectDate = UILabel()
		selectDate.text = string.th_choose_date
		selectDate.setParameter(font: .kanitReg14, color: .Celllabel)
		selectTime = UILabel()
		selectTime.text = string.th_choose_time
		selectTime.setParameter(font: .kanitReg14, color: .Celllabel)
		
		let collectioinDateLayout = CollectionLayout(withcol: 2.001, height: 36, axis: .horizontal, innerLine: MARGIN)
		collectionDate = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 36), collectionViewLayout: collectioinDateLayout)
		collectionDate.setUp(self, bg: .clear)
		collectionDate.register(PretestCollectionSelectDateCell.self, forCellWithReuseIdentifier: PretestCollectionSelectDateCell.cellDateIdentifier)
        collectionDate.contentInset = UIEdgeInsets(top: 6, left: MARGIN, bottom: 4, right: MARGIN)
		
		let collectionTimeLayout = CollectionLayout(withcol: 3.001, height: 36, axis: .horizontal, innerLine: MARGIN)
		collectionTime = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 36), collectionViewLayout: collectionTimeLayout)
		collectionTime.setUp(self, bg: .clear)
		collectionTime.register(PretestCollectionSelectDateCell.self, forCellWithReuseIdentifier: PretestCollectionSelectDateCell.cellTimeIdentifier)

        collectionTime.contentInset = UIEdgeInsets(top: 6, left: MARGIN, bottom: 4, right: MARGIN)
		
		selectRoundView.addsubviews([selectDate, selectTime, collectionDate, collectionTime])
		
		detailSelectView = UIView()
		detailSelectView.backgroundColor = .white
		selectDetail = UILabel()
		selectDetail.text = "รอบที่เลือกไว้ : ชื่อ Pretest"
		selectDetail.setParameter(font: .kanitReg14, color: .guestcolor)
		roundIcon = UIImageView()
		roundIcon.setParameter(name: "pretestDateIcon", mode: .scaleAspectFit)
		selectRound = UILabel()
		selectRound.text = "กรุณาเลือกวันสอบ | กรุณาเลือกเวลาสอบ"
		selectRound.setParameter(font: .kanitLight16, color: .Celllabel)
		numRound = UILabel()
		numRound.text = "คนสมัคร xxx / xxx คน"
		numRound.setParameter(font: .kanitLight16, color: .Celllabel)
		numIcon = UIImageView()
		numIcon.setParameter(name: "pretestPplIcon", mode: .scaleAspectFit)
		changeRound = UIButton()
		changeRound.setParameter(string.th_change_round, textColor: .brandcolor1, font: .kanitReg14, backgroundColor: .clear)
		changeRound.addTarget(self, action: #selector(changeRoundClick), for: .touchUpInside)
		detailSelectView.addsubviews([selectDetail, roundIcon, selectRound, numIcon, numRound, changeRound])
		
		contentView.addsubviews([detailPretestView, selectRoundView, detailSelectView])
		
		setLayout()
	}
	
	@objc fileprivate func changeRoundClick() {
		if let pretest = pretestModel {
			if Datetime.getCurrentTimestamp() <= pretest.originalRound.pretestDate {
				if canSelectRound {
					changeRound.setTitle(string.th_change_round, for: .normal)
					canSelectRound = false
				} else {
					changeRound.setTitle(string.th_cancel, for: .normal)
					canSelectRound = true
				}
				delegate?.changeRound(changeRound)
			}
		}
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

    }
	
	@objc func showDetailPretest() {
		delegate?.showDetail(pretestName: namePretest.text!, pretestData: pretestModel!)
	}
	
	func setData() {
		guard let pretestData = pretestModel else {
			return
		}
		let viewFromModel = PretestViewModelFromPretest(pretest: pretestData)
		viewFromModel.connectListenerPretest()
		
		namePretest.text = viewFromModel.pretestName
		sponserPretest.text = "\(string.th_sponsor_by) \(viewFromModel.sponsorName)"
		teacherPretest.text = "ข้อสอบโดย \(viewFromModel.teacherName)"
		datePretest.text = "เปิดรับสมัคร \(Datetime().showDate(viewFromModel.startRegisDate, toDate: viewFromModel.endRegisDate, shortDate: true))"
		selectRound.text = "\(Datetime().showDate(viewFromModel.selectedRound.pretestDate, short: true, haveWeekday: not(IS_IPHONE_5_OR_LESS), showTime: false)) | \(Datetime().showTime(viewFromModel.selectedRound.pretestDate, to: viewFromModel.selectedRound.pretestEndDate))"
		numRound.text = "รับสมัคร \(viewFromModel.limitNumRegis) คน"
		price.text = "ราคา \(viewFromModel.regularPrice.counterservice) บาท"
		teacherProfile.af_setImage(withURL: URL(string: viewFromModel.teacherProfile)!, placeholderImage: UIImage(named: "tempProfile"))
		if viewFromModel.regularPrice.counterservice == 0 {
			price.text = "ฟรี"
		}
		selectDetail.text = "รอบที่เลือกไว้ : \(viewFromModel.pretestName)"
		
		viewFromModel.round.bindAndFire { (rounds) in
            
		}
		viewFromModel.pretestUpdate.bindAndFire { (date) in
            
		}
		
		viewFromModel.ownerPretest.bindAndFire { (owner) in
			if owner {
				self.canSelectRound = false
				self.changeRound.show()
			} else {
				self.canSelectRound = true
				self.changeRound.hide()
			}
		}
		
		collectionDateData = viewFromModel.dateGroup
		selectDate.snp.remakeConstraints { (make) in
			make.top.equalTo(selectRoundView.snp.top).offset(20)
			make.leading.equalTo(selectRoundView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(selectRoundView.snp.trailing).offset(-MARGIN)
			make.height.equalTo(21)
		}
		collectionDate.snp.remakeConstraints { (make) in
			make.top.equalTo(selectDate.snp.bottom).offset(-4)
			make.width.equalTo(SCREEN_WIDTH)
			make.leading.equalTo(selectRoundView.snp.leading)
			make.height.equalTo(CGFloat((36+6)))
		}
		collectionDate.reloadData()
        let collectioinDateLayout = CollectionLayout(withcol: CGFloat(collectionDateData.count) < 3 ? CGFloat(collectionDateData.count) : 2.5 , height: 36, axis: .horizontal, innerLine: MARGIN)
        collectionDate.setCollectionViewLayout(collectioinDateLayout, animated: false)
        collectionDate.reloadData()
        selectDateFirst = pretestData.roundFirst
		
		if selectDateFirst {
			if viewFromModel.dateGroup.count != 0 {
				collectionTimeData = Validation.anyIsArrayAny(viewFromModel.dateGroup[pretestData.originalRound.date], with: "group")
			} else {
				collectionTimeData = []
				delegate?.cantSelectRound()
			}
		} else {
			collectionTimeData = Validation.anyIsArrayAny(viewFromModel.dateGroup[pretestData.selectedRound.date], with: "group")
		}
		setCollectionTimeLayout()
	}
	
	func setCollectionTimeLayout() {
		selectTime.snp.remakeConstraints { (make) in
			make.top.equalTo(collectionDate.snp.bottom).offset(4)
			make.leading.equalTo(selectDate.snp.leading)
			make.trailing.equalTo(selectDate.snp.trailing)
			make.height.equalTo(21)
		}
		collectionTime.snp.remakeConstraints { (make) in
			make.top.equalTo(selectTime.snp.bottom).offset(-4)
			make.width.equalTo(SCREEN_WIDTH)
			make.leading.equalTo(selectRoundView.snp.leading)
			make.height.equalTo(CGFloat((36+6)))
			make.bottom.equalTo(selectRoundView.snp.bottom).offset(-20)
		}
		collectionTime.reloadData()
		let collectionTimeLayout = CollectionLayout(withcol: (collectionTimeData.count < 3 ? CGFloat(collectionTimeData.count) : 2.5), height: 36, axis: .horizontal)
		collectionTime.setCollectionViewLayout(collectionTimeLayout, animated: false)
		collectionTime.reloadData()
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == collectionDate {
			return collectionDateData.count
		}
		return collectionTimeData.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		var cell: PretestCollectionSelectDateCell
		if collectionView == collectionDate {
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: PretestCollectionSelectDateCell.cellDateIdentifier, for: indexPath) as! PretestCollectionSelectDateCell
			let dateData = collectionDateData[indexPath.item]
			cell.title.text = Datetime().showDate(Validation.anyIsNumber(dateData, with: "date"), short: true, haveWeekday: not(IS_IPHONE_5_OR_LESS), showTime: false)
			if (selectDateFirst && indexPath.item == pretestModel!.originalRound.date) || (not(selectDateFirst) && indexPath.item == pretestModel!.selectedRound.date) {
				if selectDateCell != nil {
					selectDateCell.unselectGradient()
				}
				cell.selectGradient()
				selectDateCell = cell
			} else {
				cell.unselectGradient()
			}
		} else {
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: PretestCollectionSelectDateCell.cellTimeIdentifier, for: indexPath) as! PretestCollectionSelectDateCell
			let timeData = collectionTimeData[indexPath.item]
			cell.title.text = Datetime().showTime(Validation.anyIsNumber(timeData, with: "pretestDate"), to: Validation.anyIsNumber(timeData, with: "pretestEndDate"))
			if (selectDateFirst && Validation.anyIsNumber(timeData, with: "round") == pretestModel!.originalRound.round) || (not(selectDateFirst) && Validation.anyIsNumber(timeData, with: "round") == pretestModel!.selectedRound.round) {
				if selectTimeCell != nil {
					selectTimeCell.unselectGradient()
				}
				cell.selectGradient()
				selectTimeCell = cell
			} else {
				cell.unselectGradient()
			}
		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if canSelectRound {
			let cell = collectionView.cellForItem(at: indexPath) as! PretestCollectionSelectDateCell
			collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
			if !cell.selectNow {
				cell.selectGradient()
				if collectionView == collectionDate {
					pretestModel!.roundFirst = false
					selectDateFirst = false
					selectDateCell.unselectGradient()
					selectDateCell = cell
					collectionTimeData = Validation.anyIsArrayAny(pretestModel!.dateGroup[indexPath.item], with: "group")
					
					let firstRoundOnThisDate = collectionTimeData.first!
					pretestModel!.selectedRound.set(round: Validation.anyIsNumber(firstRoundOnThisDate, with: "round"), from: Validation.anyIsNumber(firstRoundOnThisDate, with: "pretestDate"), toDate: Validation.anyIsNumber(firstRoundOnThisDate, with: "pretestEndDate"), dateIndex: indexPath.item, action: 0)
					setCollectionTimeLayout()
				} else {
					pretestModel!.roundFirst = false
					selectDateFirst = false
					selectTimeCell.unselectGradient()
					selectTimeCell = cell
					let selectTime = collectionTimeData[indexPath.item]
					pretestModel!.selectedRound.set(round: Validation.anyIsNumber(selectTime, with: "round"), from: Validation.anyIsNumber(selectTime, with: "pretestDate"), toDate: Validation.anyIsNumber(selectTime, with: "pretestEndDate"), dateIndex: pretestModel!.selectedRound.date, action: 0)
				}
				selectRound.text = "\(Datetime().showDate(pretestModel!.selectedRound.pretestDate, short: true, haveWeekday: not(IS_IPHONE_5_OR_LESS), showTime: false)) | \(Datetime().showTime(pretestModel!.selectedRound.pretestDate, to: pretestModel!.selectedRound.pretestEndDate))"
			}
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

	}
	
	func setLayout() {
		detailPretestView.snp.makeConstraints { (make) in
			make.leading.equalTo(contentView.snp.leading)
			make.trailing.equalTo(contentView.snp.trailing)
			make.top.equalTo(contentView.snp.top)
			make.height.equalTo(182)
		}
		detailSelectView.snp.makeConstraints { (make) in
			make.bottom.equalTo(contentView.snp.bottom)
			make.leading.equalTo(detailPretestView.snp.leading)
			make.trailing.equalTo(detailPretestView.snp.trailing)
			make.height.equalTo(112)
			make.top.equalTo(selectRoundView.snp.bottom).offset(2)
		}
		selectRoundView.snp.makeConstraints { (make) in
			make.top.equalTo(detailPretestView.snp.bottom).offset(2)
			make.leading.equalTo(detailPretestView.snp.leading)
			make.trailing.equalTo(detailPretestView.snp.trailing)
			make.bottom.equalTo(detailSelectView.snp.top).offset(-2)
		}
		
		moreDetail.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize(width: 120, height: 21))
			make.trailing.equalTo(contentView.snp.trailing).offset(-MARGIN)
			make.centerY.equalTo(priceIcon.snp.centerY)
		}
		shadowProfile.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize(width: 50, height: 50))
			make.top.equalTo(detailPretestView.snp.top).offset(24)
			make.trailing.equalTo(detailPretestView.snp.trailing).offset(-MARGIN)
		}
		teacherProfile.snp.makeConstraints { (make) in
			make.edges.equalTo(shadowProfile.snp.edges)
		}
		namePretest.snp.makeConstraints { (make) in
			make.leading.equalTo(detailPretestView.snp.leading).offset(24)
			make.top.equalTo(detailPretestView.snp.top).offset(19)
			make.trailing.equalTo(teacherProfile.snp.leading).offset(-24)
			make.height.equalTo(27)
		}
		sponserPretest.snp.makeConstraints { (make) in
			make.leading.equalTo(namePretest.snp.leading)
			make.trailing.equalTo(namePretest.snp.trailing)
			make.top.equalTo(namePretest.snp.bottom).offset(4)
			make.height.equalTo(24)
		}
		teacherIcon.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize(width: 16, height: 13))
			make.leading.equalTo(detailPretestView.snp.leading).offset(30)
			make.top.equalTo(sponserPretest.snp.bottom).offset(17)
		}
		teacherPretest.snp.makeConstraints { (make) in
			make.leading.equalTo(teacherIcon.snp.trailing).offset(13)
			make.trailing.equalTo(contentView.snp.trailing).offset(-24)
			make.height.equalTo(21)
			make.centerY.equalTo(teacherIcon.snp.centerY)
		}
		dateIcon.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize(width: 15, height: 14))
			make.top.equalTo(teacherIcon.snp.bottom).offset(14)
			make.centerX.equalTo(teacherIcon.snp.centerX)
		}
		datePretest.snp.makeConstraints { (make) in
			make.leading.equalTo(teacherPretest.snp.leading)
			make.trailing.equalTo(teacherPretest.snp.trailing)
			make.height.equalTo(21)
			make.centerY.equalTo(dateIcon.snp.centerY)
		}
		priceIcon.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize(width: 15, height: 17))
			make.top.equalTo(dateIcon.snp.bottom).offset(13)
			make.centerX.equalTo(dateIcon.snp.centerX)
		}
		price.snp.makeConstraints { (make) in
			make.leading.equalTo(datePretest.snp.leading)
			make.trailing.equalTo(moreDetail.snp.leading).offset(-MARGIN)
			make.height.equalTo(21)
			make.centerY.equalTo(priceIcon.snp.centerY)
		}
		
		selectDate.snp.makeConstraints { (make) in
			make.top.equalTo(selectRoundView.snp.top).offset(20)
			make.leading.equalTo(selectRoundView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(selectRoundView.snp.trailing).offset(-MARGIN)
			make.height.equalTo(21)
		}
		collectionDate.snp.makeConstraints { (make) in
			make.top.equalTo(selectDate.snp.bottom).offset(-4)
			make.width.equalTo(SCREEN_WIDTH)
			make.leading.equalTo(selectRoundView.snp.leading)
			make.height.equalTo(36)
		}
		selectTime.snp.makeConstraints { (make) in
			make.top.equalTo(collectionDate.snp.bottom).offset(4)
			make.leading.equalTo(selectDate.snp.leading)
			make.trailing.equalTo(selectDate.snp.trailing)
			make.height.equalTo(21)
		}
		collectionTime.snp.makeConstraints { (make) in
			make.top.equalTo(selectTime.snp.bottom).offset(-4)
			make.leading.equalTo(selectRoundView.snp.leading)
			make.width.equalTo(SCREEN_WIDTH)
			make.height.equalTo(36)
			make.bottom.equalTo(selectRoundView.snp.bottom).offset(-20)
		}
		
		changeRound.snp.makeConstraints { (make) in
			make.top.equalTo(detailSelectView.snp.top).offset(MARGIN)
			make.trailing.equalTo(detailSelectView.snp.trailing).offset(-MARGIN)
			make.width.equalTo(54)
			make.height.equalTo(21)
		}
		selectDetail.snp.makeConstraints { (make) in
			make.top.equalTo(detailSelectView.snp.top).offset(MARGIN)
			make.leading.equalTo(detailSelectView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(changeRound.snp.leading).offset(-MARGIN)
			make.height.equalTo(21)
		}
		roundIcon.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize(width: 14, height: 12))
			make.top.equalTo(selectDetail.snp.bottom).offset(MARGIN)
			make.leading.equalTo(detailSelectView.snp.leading).offset(17)
		}
		selectRound.snp.makeConstraints { (make) in
			make.centerY.equalTo(roundIcon.snp.centerY)
			make.leading.equalTo(roundIcon.snp.trailing).offset(MARGIN)
			make.trailing.equalTo(detailSelectView.snp.trailing).offset(-MARGIN)
			make.height.equalTo(24)
		}
		numIcon.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize(width: 17, height: 12))
			make.top.equalTo(roundIcon.snp.bottom).offset(MARGIN)
			make.centerX.equalTo(roundIcon.snp.centerX)
		}
		numRound.snp.makeConstraints { (make) in
			make.centerY.equalTo(numIcon.snp.centerY)
			make.leading.equalTo(selectRound.snp.leading)
			make.trailing.equalTo(selectRound.snp.trailing)
			make.height.equalTo(24)
		}
	}

}
