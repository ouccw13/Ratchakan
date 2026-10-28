//
//  Package.swift
//  ratchakan
//
//  Created by JJsobtid on 23/3/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import Foundation

class Package: NSObject {
	
	var id: String!
	var name: String!
	var imageURL: String!
	var detail: String!
	var duration: Int!
	var examGroups: [String]!
	var price: Price!

	init(withDictionary data: dictStringAny) {
		id = Validation.anyIsString(data, with: "packageId")
		name = Validation.anyIsString(data, with: "name")
		imageURL = Validation.anyIsString(data, with: "image")
		detail = Validation.anyIsArrayString(data, with: "details").first ?? ""
		duration = Validation.anyIsNumber(data, with: "duration")
		examGroups = Validation.anyIsArrayString(data, with: "examGroups")
		price = Price(priceData: Validation.anyIsDictionary(data, with: "price"), discountData: Validation.anyIsDictionary(data, with: "discountPrice"))
	}
	
}

class PackageBundle: NSObject {
	var name: String!
	var imageURL: String!
	var details: [String]!
	var packageId: String!
	var examGroups: [String]!
	var price: Price!
	
	init(withDictionary data: dictStringAny) {
		packageId = Validation.anyIsString(data, with: "packageId")
		examGroups = Validation.anyIsArrayString(data, with: "examGroups")
		name = Validation.anyIsString(data, with: "name")
		imageURL = Validation.anyIsString(data, with: "image")
		details = Validation.anyIsArrayString(data, with: "details")
		price = Price(priceData: Validation.anyIsDictionary(data, with: "price"), discountData: Validation.anyIsDictionary(data, with: "discountPrice"))
	}
	
	func checkBundle(_ bundle: [String]) -> Bool {
		if packageId.count == bundle.count {
			for package in bundle {
				if packageId.contains(package) {
					
				} else {
					return false
				}
			}
			return true
		}
		return false
	}
}
