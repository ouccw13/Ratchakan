//
//  PretestCollectionViewModel.swift
//  ratchakan
//
//  Created by JJsobtid on 17/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import Foundation

protocol PretestCollectionViewModel {
	var pretestCollectionData: Dynamic<[Any]> { get }
	var type: TypePretest { get }
	var loaded: Dynamic<Bool> { get }
	
	func loadPretestList()
}
