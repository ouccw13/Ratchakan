//
//  Character.swift
//  ratchakan
//
//  Created by JJsobtid on 30/4/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import Foundation

extension Character
{
	func unicodeScalarCodePoint() -> UInt32
	{
		let characterString = String(self)
		let scalars = characterString.unicodeScalars
		
		return scalars[scalars.startIndex].value
	}
	
}
