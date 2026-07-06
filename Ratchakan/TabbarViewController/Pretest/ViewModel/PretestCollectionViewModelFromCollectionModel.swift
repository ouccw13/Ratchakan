//
//  PretestCollectionViewModelFromCollectionModel.swift
//  ratchakan
//
//  Created by JJsobtid on 17/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class PretestCollectionViewModelFromCollectionModel: NSObject, PretestCollectionViewModel {
	
	fileprivate let collection: PretestCollectionModel
	
	var pretestCollectionData: Dynamic<[Any]>
	var type: TypePretest
	var loaded: Dynamic<Bool>
	
	init(pretestCollection: PretestCollectionModel) {
		collection = pretestCollection
		type = collection.type
		pretestCollectionData = Dynamic(collection.pretestCollectionData)
		loaded = Dynamic(collection.loaded)
		
		super.init()
	}
	
	func loadPretestList() {
		collection.loadPretestList { () in
			self.pretestCollectionData.value = self.collection.pretestCollectionData
			self.loaded.value = self.collection.loaded
			return
		}
	}
	
}
