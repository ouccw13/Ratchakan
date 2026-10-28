//
//  StatSubjectViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 19/3/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import DGCharts
class StatSubjectViewController: CustomViewControllerPushNavAndNoTabbar, UITableViewDelegate, UITableViewDataSource, ChartViewDelegate {
    
	var summaryTableView: UITableView!
	
	var statSubject: SubjectModel!
	
	convenience init(parameter: SubjectModel) {
		
		self.init(nibName: nil, bundle: nil)
		statSubject = parameter
	
	}
	
	override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .brandcolor_bg
		
		summaryTableView = UITableView(frame: CGRect(), style: .plain)
		summaryTableView.setParameter(target: self)
		summaryTableView.contentInset = UIEdgeInsets(top: 0.01, left: 0, bottom: MARGIN, right: 0)
		summaryTableView.register(BarPercentTableViewCell.self, forCellReuseIdentifier: BarPercentTableViewCell.cellIdentifier)
		summaryTableView.register(GraphTableViewCell.self, forCellReuseIdentifier: GraphTableViewCell.cellIdentifier)
		summaryTableView.setDynamicHeight(71)
		
		view.addSubview(summaryTableView)
		summaryTableView.snp.makeConstraints { (make) in
			make.top.equalTo(view.snp.top).offset(PAGEBAR_HEIGHT)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
			make.bottom.equalTo(view.snp.bottom)
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func viewDidLayoutSubviews() {
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func back() {
		navigationController?.popViewController(animated: true)
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		}
		return statSubject.memberScore.subjects.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: GraphTableViewCell.cellIdentifier, for: indexPath) as! GraphTableViewCell
            cell.setData(statSubject.graph, xTitle: "ครั้ง", yTitle: "เปอร์เซ็นต์",hexColor: statSubject.colorHex)
            cell.chart.delegate = self
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: BarPercentTableViewCell.cellIdentifier, for: indexPath) as! BarPercentTableViewCell
			let subjectData = statSubject.memberScore.subjects[indexPath.item]
			let data = ["name" : subjectData.name,
						"score" : subjectData.score,
						"totalScore" : Float(100.0),
						"categories" : subjectData.categories] as [String : Any]
			cell.setExamSummaryData(data: data, type: .line, last: indexPath.item == statSubject.memberScore.subjects.count-1 ? true : false)
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 1 {
			let cell = tableView.cellForRow(at: indexPath) as! BarPercentTableViewCell
			cell.setBackground(.brandcolor3)
			UIView.animate(withDuration: 0.25) {
				cell.setBackground(.white)
			}
			let categoriesView = ExamSummarySubjectViewController(parameter: statSubject.memberScore.subjects[indexPath.item].categories, navTitle: statSubject.memberScore.subjects[indexPath.item].name)
			navigationController?.pushViewController(categoriesView, animated: true)
		}
	}
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let customMarkerView = CustomMarkerView()
        if entry.y >= 0.0 {
            customMarkerView.chartView = chartView
            chartView.marker = customMarkerView
            guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] else { return }
            let index = dataSet.entryIndex(entry: entry)
            customMarkerView.lbValue.text =  "\(Double(statSubject.graph.percentages?[index].score ?? 0.00).removeZerosFromEnd())%"
        }else{
            chartView.highlightValue(nil, callDelegate: false)
        }
    }

}
