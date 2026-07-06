//
//  MenuCellViewModelFromCell.swift
//  ratchakan
//
//  Created by JJsobtid on 4/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class MenuCellViewModelFromCell: NSObject, MenuCellViewModel {

	let cell: MenuCellModel
	
	var type: MenuCellType
	var title: String
	var imageName: String
	var detail: String?
	
	init(withCell cell: MenuCellModel) {
		self.cell = cell
		
		self.type = cell.type
		self.title = cell.title
		self.imageName = cell.imageName
		if cell.detail != nil { self.detail = cell.detail }
		
		super.init()
	}
}
