//
//  MenuCellViewModel.swift
//  ratchakan
//
//  Created by JJsobtid on 4/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import Foundation

protocol MenuCellViewModel {
	var type: MenuCellType { get }
	var title: String { get }
	var imageName: String { get }
	var detail: String? { get }
	
}
