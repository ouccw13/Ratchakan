//
//  SummarySubjectViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 12/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class SummarySubjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var pretestData: PretestHistoryModel!
	var subjectTableView: UITableView!
	
	convenience init(withData data: PretestHistoryModel) {
		self.init(nibName: nil, bundle: nil)
		pretestData = data
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		subjectTableView = UITableView(frame: CGRect(), style: .plain)
		subjectTableView.setParameter(target: self)
		subjectTableView.contentInset = UIEdgeInsets(top: MARGIN, left: 0, bottom: MARGIN, right: 0)
		subjectTableView.setDynamicHeight(71)
		subjectTableView.register(BarPercentTableViewCell.self, forCellReuseIdentifier: BarPercentTableViewCell.cellIdentifier)
		
		view.addSubview(subjectTableView)
		subjectTableView.snp.makeConstraints { (make) in
			make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
			make.top.equalTo(view.snp.top).offset(PAGEBAR_HEIGHT)
			make.bottom.equalTo(view.snp.bottom)
		}
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	// MARK: - Table View Delegate
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		}
		return pretestData.getSubjectNum()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: BarPercentTableViewCell.cellIdentifier, for: indexPath) as! BarPercentTableViewCell
		if indexPath.section == 0 {
			cell.setExamSummaryData(data: pretestData.rawData, type: .circle, isPretest: true)
			cell.setCircleTime(pretestData.totalTime)
			cell.isUserInteractionEnabled = false
		} else {
			let subjectData = pretestData.getSubject(atIndex: indexPath.item)
			let data = ["name" : Validation.anyIsString(subjectData, with: "subjectName"),
						"score" : Validation.anyIsFloat(subjectData, with: "score"),
						"totalScore" : Validation.anyIsFloat(subjectData, with: "subjectScore"),
						"categories" : Validation.anyIsArrayAny(subjectData, with: "categories")] as dictStringAny
            cell.setExamSummaryData(data: data, type: .line, last: indexPath.item == pretestData.getSubjectNum()-1 ? true : false)
			cell.isUserInteractionEnabled = true
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! BarPercentTableViewCell
		cell.setBackground(.brandcolor3)
		UIView.animate(withDuration: 0.25) {
			cell.setBackground(.white)
		}
		let categoriesView = ExamSummarySubjectViewController(parameter: Validation.anyIsArrayAny(pretestData.getSubject(atIndex: indexPath
			.item), with: "categories"), navTitle:  Validation.anyIsString(pretestData.getSubject(atIndex: indexPath
				.item), with: "subjectName"))
		navigationController?.pushViewController(categoriesView, animated: true)
		
	}
	
}
