//
//  NoteGrade.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 3/9/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import Foundation

class NoteGrade: Codable {
    var name: String
    var id: String
    var notes: [Note]
    
    enum CodingKeys: String, CodingKey {
        case name, id
        case notes
    }
}
