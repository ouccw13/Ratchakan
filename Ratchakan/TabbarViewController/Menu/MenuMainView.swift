//
//  MenuMainView.swift
//  ratchakan
//
//  Created by JJsobtid on 29/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit
protocol selectMenuDelegate {
	func select(key: MenuCellType, withTitle title: String)
	
}

class MenuMasterView: CustomUIViewControllerNoNav, UITableViewDelegate, UITableViewDataSource {
	
	var tableView: UITableView!
	var tableData = DataConfig.tableUserMenuTell {
		didSet {
			if isViewLoaded {
				tableView.reloadData()
			}
		}
	}
	
	var delegate: selectMenuDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .brandcolor_bg

		tableView = UITableView(frame: CGRect(), style: .plain)
		tableView.sectionFooterHeight = MARGIN
		tableView.sectionHeaderHeight = 0
		tableView.backgroundColor = .clear
		tableView.separatorColor = .clear
		tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "reusecell")
		
        tableView.contentInset = UIEdgeInsets(top: 0.01, left: 0, bottom: MARGIN + TABBAR_HEIGHT, right: 0)
		view.addSubview(tableView)
		
		fillUI()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		fillUI()
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func fillUI() {
		
		tableView.snp.remakeConstraints { (make) in
			make.edges.equalTo(view.snp.edges)
		}
		tableView.testBorder()
		tableView.delegate = self as UITableViewDelegate
		tableView.dataSource = self as UITableViewDataSource

	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return tableData.count
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let rowInSection = (tableData[section])["cell"] as! [[String: Any]]
		return rowInSection.count
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return MARGIN
	}
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let footView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: MARGIN))
		footView.backgroundColor = .clear
		
		return footView
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 0 {
			return 132
		}
		return 50
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "reusecell", for: indexPath) as! MenuTableViewCell
		let sectionData = (tableData[indexPath.section])["cell"] as! [[String: Any]]
		let data = sectionData[indexPath.row]
		var detail: String = ""
		if Validation.dictionary(data as [String : AnyObject], with: "detail") { detail = data["detail"] as! String }
		let cellData = MenuCellModel(data["key"] as! MenuCellType, title: data["title"] as! String, imageName: data["imageName"] as! String, detail: detail)
		let cellMedel = MenuCellViewModelFromCell(withCell: cellData)
		cell.cellModel = cellMedel
		cell.isUserInteractionEnabled = true
		if DataConfig.nonUserInteraction.contains(cellData.type) {
			cell.isUserInteractionEnabled = false
        }
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        let sectionData = (tableData[indexPath.section])["cell"] as! [[String: Any]]
        let key = sectionData[indexPath.row]["key"] as! MenuCellType
        let title = sectionData[indexPath.row]["title"] as! String
        if cell.typeCell != .noti  {
			UIView.animate(withDuration: 0.25) {
				cell.backgroundColor = .white
			}
			delegate?.select(key: key, withTitle: title)
        }
	}
}
