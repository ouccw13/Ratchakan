//
//  CustomViewModel.swift
//  ratchakan
//
//  Created by JJsobtid on 6/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation
import UIKit

protocol CustomNavViewModel {
	var titleName: String { get }
	var left: Bool { get }
	var right: Bool { get }
	var imageRight: String? { get }
	var color: UIColor { get }
	
}
