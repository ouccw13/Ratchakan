//
//  ReadNoteViewModel.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 2/9/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import Foundation

class ReadNoteViewModel: NSObject {
    
    var selectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    var note: Note!
    var noteId: String!
    
    let api = API()
    
    init(note: Note, selectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)) {
        self.note = note
        self.selectedIndexPath = selectedIndexPath
    }
    
    
    func callNoteDetail(_ whenDataCalled: @escaping (()->())) {
        if let id = noteId {
            api.getNoteDetail(withId: id) { (finished, response) in
                if finished {
                    self.note = response!["result"] as? Note ?? nil
                    whenDataCalled()
                }
            }
        } else {
            whenDataCalled()
        }
    }
    
    var titleText: String {
        return note.name
    }
    
    var getNumberOfImage: Int {
        return note.noteImages!.count
    }
    
    func getData(atIndexPath indexPath: IndexPath) -> NoteImage {
        return note.noteImages![indexPath.row]
    }
}
