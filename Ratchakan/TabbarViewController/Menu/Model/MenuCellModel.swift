//
//  MenuCellModel.swift
//  ratchakan
//
//  Created by JJsobtid on 4/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class MenuCellModel: NSObject {
	var type: MenuCellType
	var title: String
	var imageName: String
	var detail: String?
	
	init(_ type: MenuCellType, title: String, imageName: String, detail: String?) {
		self.type = type
		self.title = title
        self.imageName = imageName
		if detail != nil {
            self.detail = detail
        }
		
	}
}
