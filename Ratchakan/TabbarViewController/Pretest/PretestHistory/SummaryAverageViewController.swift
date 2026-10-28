//
//  SummaryAverageViewController.swift
//  
//
//  Created by JJsobtid on 12/2/2561 BE.
//

import UIKit

class SummaryAverageViewController: UIViewController {

	var memberStat: PretestSummaryModel!
	
	var scrollView: UIScrollView!
	var summaryPointView, averagePointView: UIView!
	var titleSummaryLabel, titleAverageLabel: UILabel!
	var summaryLine, topAverageLine, bottomAverageLine: UIView!
	var scoreView, totalScoreView, TScroreView, averageScoreView, sdView, maxView, minView, timeView, avTimeView: PointView!
	
	init(withData data: PretestSummaryModel) {
		super.init(nibName: nil, bundle: nil)
		memberStat = data
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = .brandcolor_bg
		
		scrollView = UIScrollView()
		
		summaryPointView = UIView()
		summaryPointView.backgroundColor = .white
		titleSummaryLabel = UILabel()
		titleSummaryLabel.setParameter(font: .kanitLight14, color: .Celllabel)
		titleSummaryLabel.text = "รวมคะแนน"
		summaryLine = UIView()
		summaryLine.backgroundColor = .separateLine
		scoreView = PointView()
		scoreView.setData(title: "คะแนนที่ได้", sub: "(Xi)", score: checkFloat(memberStat.score))
		totalScoreView = PointView()
		totalScoreView.setData(title: "คะแนนเต็ม", sub: " ", score: checkFloat(memberStat.totalScore))
		TScroreView = PointView()
		TScroreView.setData(title: "คะแนนมาตรฐาน", sub: "(T)", score: checkFloat(memberStat.Tscore))
	
		averagePointView = UIView()
		averagePointView.backgroundColor = .white
		titleAverageLabel = UILabel()
		titleAverageLabel.setParameter(font: .kanitLight14, color: .Celllabel)
		titleAverageLabel.text = "รวมค่าเฉลี่ยทั้งหมด"
		topAverageLine = UIView()
		topAverageLine.backgroundColor = .separateLine
		averageScoreView = PointView()
		//x̅
		averageScoreView.setData(title: "ค่าเฉลี่ย", sub: "(x̄)", score: checkFloat(memberStat.mean))
		sdView = PointView()
		sdView.setData(title: "ค่ากระจาย", sub: "(SD)", score: checkFloat(memberStat.sd))
		maxView = PointView()
		maxView.setData(title: "สูงสุด", sub: "(Max)", score: checkFloat(memberStat.max))
		minView = PointView()
		minView.setData(title: "ต่ำสุด", sub: "(Min)", score: checkFloat(memberStat.min))
		
		bottomAverageLine = UIView()
		bottomAverageLine.backgroundColor = .separateLine
		timeView = PointView()
		timeView.setData(title: "เวลาที่ใช้ในการสอบ", sub: "(Hr)", score: Datetime.timeFromSec(memberStat.time, haveSpace: false, haveHour: true))
		avTimeView = PointView()
		avTimeView.setData(title: "เวลาเฉลี่ยในการสอบ", sub: "(Hr)", score: Datetime.timeFromSec(Int(memberStat.averageTime), haveSpace: false, haveHour: true))
		
		summaryPointView.addsubviews([titleSummaryLabel, summaryLine, scoreView, totalScoreView, TScroreView])
		averagePointView.addsubviews([titleAverageLabel, topAverageLine, averageScoreView, sdView, maxView, minView, bottomAverageLine, timeView, avTimeView])
		scrollView.addsubviews([summaryPointView, averagePointView])
		view.addsubviews([scrollView])//summaryPointView, averagePointView])
		
        // Do any additional setup after loading the view.
		setLayout()
	}
	
	func checkFloat(_ num: Float) -> String {
		return Utility.checkFloat(num)
	}
	func setLayout() {
		scrollView.snp.makeConstraints { (make) in
			make.edges.equalTo(view.snp.edges)
		}
		titleSummaryLabel.snp.makeConstraints { (make) in
			make.top.equalTo(summaryPointView.snp.top).offset(14)
			make.leading.equalTo(summaryPointView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(summaryPointView.snp.trailing).offset(-MARGIN)
		}
		summaryLine.snp.makeConstraints { (make) in
			make.top.equalTo(titleSummaryLabel.snp.bottom).offset(14)
			make.leading.equalTo(titleSummaryLabel.snp.leading)
			make.height.equalTo(0.5)
			make.trailing.equalTo(titleSummaryLabel.snp.trailing)
		}
		scoreView.snp.makeConstraints { (make) in
			make.top.equalTo(summaryLine.snp.bottom).offset(8)
			make.leading.equalTo(titleSummaryLabel.snp.leading)
			make.bottom.equalTo(summaryPointView.snp.bottom).offset(-8)
			make.width.equalTo(70)
		}
		totalScoreView.snp.makeConstraints { (make) in
			make.top.equalTo(scoreView.snp.top)
			if IS_IPHONE_5_OR_LESS {
				make.centerX.equalTo(titleSummaryLabel.snp.centerX).offset(-MARGIN)
			} else {
				make.centerX.equalTo(titleSummaryLabel.snp.centerX)
			}
			make.bottom.equalTo(scoreView.snp.bottom)
			make.width.equalTo(70)
		}
		TScroreView.snp.makeConstraints { (make) in
			make.top.equalTo(scoreView.snp.top)
			make.bottom.equalTo(scoreView.snp.bottom)
			make.trailing.equalTo(titleSummaryLabel.snp.trailing)
			make.width.equalTo(105)
		}
		
		summaryPointView.snp.makeConstraints { (make) in
			make.top.equalTo(view.snp.top).offset(PAGEBAR_HEIGHT+MARGIN)
			make.leading.equalTo(view.snp.leading).offset(MARGIN)
			make.height.equalTo(138)
			make.trailing.equalTo(view.snp.trailing).offset(-MARGIN)
		}
		averagePointView.snp.makeConstraints { (make) in
			make.top.equalTo(summaryPointView.snp.bottom).offset(20)
			make.leading.equalTo(view.snp.leading).offset(MARGIN)
			make.height.equalTo(226)
			make.trailing.equalTo(view.snp.trailing).offset(-MARGIN)
		}
		
		titleAverageLabel.snp.makeConstraints { (make) in
			make.top.equalTo(averagePointView.snp.top).offset(14)
			make.leading.equalTo(averagePointView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(averagePointView.snp.trailing).offset(-MARGIN)
		}
		topAverageLine.snp.makeConstraints { (make) in
			make.top.equalTo(titleAverageLabel.snp.bottom).offset(14)
			make.leading.equalTo(titleAverageLabel.snp.leading)
			make.height.equalTo(0.5)
			make.trailing.equalTo(titleAverageLabel.snp.trailing)
		}
		bottomAverageLine.snp.makeConstraints { (make) in
			make.top.equalTo(topAverageLine.snp.bottom).offset(88)
			make.leading.equalTo(titleAverageLabel.snp.leading)
			make.height.equalTo(0.5)
			make.trailing.equalTo(titleAverageLabel.snp.trailing)
		}
		averageScoreView.snp.makeConstraints { (make) in
			make.top.equalTo(topAverageLine.snp.bottom).offset(8)
			make.leading.equalTo(titleAverageLabel.snp.leading)
			make.bottom.equalTo(bottomAverageLine.snp.top).offset(-8)
			make.width.equalTo(60)
		}
		sdView.snp.makeConstraints { (make) in
			make.top.equalTo(averageScoreView.snp.top)
			make.leading.equalTo(averageScoreView.snp.trailing).offset((SCREEN_WIDTH-(2*(MARGIN+60+70)))/3)
			make.bottom.equalTo(averageScoreView.snp.bottom)
			make.width.equalTo(70)
		}
		maxView.snp.makeConstraints { (make) in
			make.top.equalTo(averageScoreView.snp.top)
			make.leading.equalTo(sdView.snp.trailing).offset(-10+(SCREEN_WIDTH-(2*(MARGIN+60+70)))/3)
			make.bottom.equalTo(averageScoreView.snp.bottom)
			make.width.equalTo(70)
		}
		minView.snp.makeConstraints { (make) in
			make.top.equalTo(averageScoreView.snp.top)
			make.bottom.equalTo(averageScoreView.snp.bottom)
			make.trailing.equalTo(titleAverageLabel.snp.trailing)
			make.width.equalTo(60)
		}
		timeView.snp.makeConstraints { (make) in
			make.top.equalTo(bottomAverageLine.snp.bottom).offset(8)
			make.leading.equalTo(titleAverageLabel.snp.leading)
			make.bottom.equalTo(averagePointView.snp.bottom).offset(-8)
			make.trailing.equalTo(averagePointView.snp.centerX)
		}
		avTimeView.snp.makeConstraints { (make) in
			make.top.equalTo(timeView.snp.top)
			make.trailing.equalTo(titleAverageLabel.snp.trailing)
			make.bottom.equalTo(timeView.snp.bottom)
			make.leading.equalTo(averagePointView.snp.centerX)
		}
		view.layoutIfNeeded()
		scrollView.sizeToFit()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	class PointView: UIView {
		var titleLabel, subtitleLabel, pointLabel: UILabel!
		
		override init(frame: CGRect) {
			super.init(frame: frame)
			titleLabel = UILabel()
			titleLabel.setParameter(font: .kanitLight16, color: .Celllabel, alignment: .center)
			
			subtitleLabel = UILabel()
			subtitleLabel.setParameter(font: .kanitLight10, color: .Celllabel, alignment: .center)
			
			pointLabel = UILabel()
			pointLabel.setParameter(font: .kanitReg16, color: .brandcolor1, alignment: .center)
			
			addsubviews([titleLabel, subtitleLabel, pointLabel])
			
			titleLabel.snp.makeConstraints { (make) in
				make.leading.equalTo(snp.leading)
				make.trailing.equalTo(snp.trailing)
				make.top.equalTo(snp.top)
			}
			subtitleLabel.snp.makeConstraints { (make) in
				make.leading.equalTo(titleLabel.snp.leading)
				make.trailing.equalTo(titleLabel.snp.trailing)
				make.top.equalTo(titleLabel.snp.bottom).offset(2)
			}
			pointLabel.snp.makeConstraints { (make) in
				make.leading.equalTo(titleLabel.snp.leading)
				make.trailing.equalTo(titleLabel.snp.trailing)
				make.bottom.equalTo(snp.bottom)
			}
		}
		
		func setData(title: String, sub: String, score: String) {
			titleLabel.text = title
			subtitleLabel.text = sub
			pointLabel.text = score
		}
		
		required init?(coder aDecoder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
}
