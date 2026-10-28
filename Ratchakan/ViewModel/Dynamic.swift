//
//  Dynamic.swift
//  ratchakan
//
//  Created by JJsobtid on 12/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation

class Dynamic<T> {
	
	typealias Listener = (T) -> ()
	var listener : Listener?
	
	func bind(_ listener: Listener?) {
		self.listener = listener
	}
	
	func bindAndFire(_ listener: Listener?) {
		self.listener = listener
		listener?(value)
	}
	
	var value: T {
		didSet {
			listener?(value)
		}
	}
	
	init(_ v:T) {
		value = v
	}
}
