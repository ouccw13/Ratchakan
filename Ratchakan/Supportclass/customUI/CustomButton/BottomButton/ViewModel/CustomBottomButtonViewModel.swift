//
//  CustomBottomButtonViewModel.swift
//  ratchakan
//
//  Created by JJsobtid on 13/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation
import UIKit

protocol CustomBottomButtonViewModel {
	var title: Dynamic<String> { get }
	var color: UIColor { get }
	
	func changeTitle(_ title: String)
}
