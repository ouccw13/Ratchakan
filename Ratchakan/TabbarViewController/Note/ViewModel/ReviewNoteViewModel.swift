//
//  ReviewNoteViewModel.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 9/9/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import Foundation

class ReviewNoteViewModel {
    
    let api = API()
    
    let id: String!
    
    init(id: String) {
        self.id = id
    }
    
    func commentNote(rating: Double, comment: String, whenCommentFinished: @escaping ((Bool)->()) ) {
        let parameter: [String : Any] = [ "rating" : rating ,
                                          "comment" : (comment == "เพิ่มความคิดเห็น") ? "" : comment ]
        api.putCommentNote(withId: id, parameter: parameter) { (finished, response) in
            whenCommentFinished(finished)
        }
    }
}
