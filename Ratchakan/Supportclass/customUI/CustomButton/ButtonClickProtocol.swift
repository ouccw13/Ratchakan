//
//  ButtonClickProtocol.swift
//  ratchakan
//
//  Created by JJsobtid on 13/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation

protocol CustomButtonClick {
	func next(tag: Int)
}

protocol GenderSelectDelegate {
	func select(gender: String)
}
