//
//  AllNoteViewModel.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 3/9/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import Foundation

class AllNoteViewModel {
    
    let api = API()
    
    var grades: [NoteGrade] = []
    
    private var suggestion: [Note] = []
    
    private var popular: [Note] = []
    
    var currentId: String = ""
    var currentIndexPath: IndexPath?
    
    var loaded: Bool = false
    
    init() {
        
    }
    
    func loadSuggestion(whenDataCalled: @escaping (() -> ())) {
        api.getNoteViaPath(path: Path.noteSuggestion) { [weak self] (finished, response) in
            if finished {
                self?.suggestion = response?["result"] as? [Note] ?? []
                whenDataCalled()
                return
            } else {
                whenDataCalled()
            }
        }
    }
    
    func loadPopular(whenDataCalled: @escaping (() -> ())) {
        api.getNoteViaPath(path: Path.notePopular) { [weak self] (finished, response) in
            if finished {
                self?.popular = response?["result"] as? [Note] ?? []
                whenDataCalled()
            } else {
                whenDataCalled()
            }
        }
    }
    
    func loadGrade(whenDataCalled: @escaping ((Bool) -> ()) ) {
        api.getNoteGrades { [weak self] (finished, response) in
            if finished {
                self?.grades = response?["result"] as? [NoteGrade] ?? []
                if self?.currentId ?? "" == "" {
                    self?.currentId = self!.grades[0].id
                }
                self?.loaded = true
                whenDataCalled(finished)
                return
            } else {
                whenDataCalled(finished)
            }
        }
    }
    
    func loadNoteDetail(noteId: String, _ whenDataCalled: @escaping ((Note) -> ())) {
        api.getNoteDetail(withId: noteId) { (finished, response) in
            if finished {
                let note = response!["result"] as! Note
                whenDataCalled(note)
            }
        }
    }
    
    func favoriteNote(id: String) {
        api.putFavoriteNote(withId: id) { (finished, response) in

        }
    }
    
    var numberOfNote: Int {
        get {
            if let grade = grades.first(where: { $0.id == currentId } ) {
                return grade.notes.count
            }
            return 0
        }
    }
    
    var numberOfGrades: Int {
        get {
            return grades.count
        }
    }
    
    var noDataVisible: Int {
        get {
            return (loaded) ? ((numberOfNote == 0) ? 1 : 0) : 0
        }
    }
    
    func getNoteData(indexPath: IndexPath) -> Note! {
        
        if let grade = grades.first(where: { $0.id == currentId } ) {
            return grade.notes[indexPath.row]
        }
        return nil
        
    }
    
    func isRecommendVisible(section: Int) -> Int {
        switch section {
        case 0: return suggestion.isEmpty ? 0 : 1
        case 1: return popular.isEmpty ? 0 : 1
        default: return 0
        }
    }
    
    func getPositionFromId(id: String, section: Int) -> Int! {
        switch section {
        case 0:
            if let index = suggestion.firstIndex(where: { $0.id == id} ) {
                return index
            }
        case 1:
            if let index = popular.firstIndex(where: { $0.id == id } ) {
                return index
            }
        case 2:
            if let grade = grades.first(where: { $0.id == currentId } ) {
                if let index = grade.notes.firstIndex(where: { $0.id == id } ) {
                    return index
                }
            } else {
                return nil
            }
        default: break
        }
        return nil
    }
    
    func updatePurchasedNoteFromId(id: String) {
        if let index = suggestion.firstIndex(where: { $0.id == id }) {
            suggestion[index].isMyNote = true
        }
        if let index = popular.firstIndex(where: { $0.id == id }) {
            popular[index].isMyNote = true
        }
        for grade in grades {
            if let index = grade.notes.firstIndex(where: { $0.id == id }) {
                grade.notes[index].isMyNote = true
            }
        }
    }
    
    func updateLike(id: String, note: Note! = nil) {
        if let index = suggestion.firstIndex(where: { $0.id == id} ) {
            if let note = note {
                suggestion[index].isFavorite = !note.isFavorite 
            } else {
                suggestion[index].isFavorite = !suggestion[index].isFavorite
            }
        }
        if let index = popular.firstIndex(where: { $0.id == id } ) {
            if let note = note {
                popular[index].isFavorite = !note.isFavorite
            } else {
                popular[index].isFavorite = !popular[index].isFavorite
            }
        }
    }
    
    func updateLikeForGrade(id: String,note: Note! = nil) {
        for grade in grades {
            if let index = grade.notes.firstIndex(where: { $0.id == id } ) {
                if let note = note {
                    grade.notes[index].isFavorite = note.isFavorite
                }else{
                    grade.notes[index].isFavorite = !grade.notes[index].isFavorite
                }
                if let index = suggestion.firstIndex(where: { $0.id == id} ) {
                    if let note = note {
                        suggestion[index].isFavorite = note.isFavorite
                    } else {
                        suggestion[index].isFavorite = !suggestion[index].isFavorite
                    }
                }
            }
        }
    }
    
    func getRecommendCellData(indexPath: IndexPath) -> [Note] {
        
        let section = indexPath.section
        
        switch section {
        case 0:
            return suggestion
        case 1:
            return popular
        default:
            return []
        }
    }
    
    func getTabData() -> [NoteGrade] {
        return grades
    }
}
