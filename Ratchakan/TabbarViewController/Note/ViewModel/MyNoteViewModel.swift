//
//  MyNoteViewModel.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 9/9/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import Foundation

class MyNoteViewModel {
    
    let api = API()
    
    var favorite: [Note] = []
    
    var myNote: [Note] = []
    
    init() {
        
    }
    
    func loadFavorite(whenDataCalled: @escaping (() -> ())) {
        api.getNoteViaPath(path: Path.noteFavorite) { [weak self] (finished, response) in
            self?.favorite = response?["result"] as? [Note] ?? []
            whenDataCalled()
            return
        }
    }
    
    func loadMyNote(whenDataCalled: @escaping (() -> ())) {
        api.getNoteViaPath(path: Path.getMyNote) { [weak self] (finished, response) in
            self?.myNote = response?["result"] as? [Note] ?? []
            whenDataCalled()
            return
        }
    }
    
    func loadNoteDetail(noteId: String, _ whenDataCalled: @escaping ((Note) -> ())) {
        api.getNoteDetail(withId: noteId) { (finished, resposne) in
            if finished {
                let note = resposne!["result"] as! Note
                whenDataCalled(note)
            }
        }
    }
    
    func favoriteNote(id: String) {
        api.putFavoriteNote(withId: id) { (finished, response) in

        }
    }
    
    var numberOfMyNote: Int {
        get {
            return myNote.count
        }
    }
    
    var didDataIsEmpty: Bool {
        get {
            return (favorite.isEmpty) && (myNote.isEmpty)
        }
    }
    
    func changeFavoriteStatus(note: Note) {
        if let noteS = myNote.first(where: { $0.id == note.id } ) {
            noteS.isFavorite = note.isFavorite
        }
        if let index = favorite.firstIndex(where: { $0.id == note.id }) {
            if favorite[index].id == note.id {
                favorite.remove(at: index)
            }
        } else {
            favorite.append(note)
        }
    }
    
    func purchasedNoteContainInFavorite(id: String) -> Bool {
        if let note = favorite.first(where: { $0.id == id }) {
            note.isMyNote = true
            return true
        }
        return false
    }
    
    func positionOfFavoriteFromId(id: String) -> Int! {
        if let index = favorite.firstIndex(where: { $0.id == id }) {
            return index
        } else {
            return nil
        }
    }
    
    func getNotePositionFromId(id: String) -> Int {
        if let index = myNote.firstIndex(where: { $0.id == id }) {
            myNote[index].isFavorite = false
            return index
        }
        return 0
    }
    
    func addFavorite(_ note: Note) {
        favorite.insert(note, at: 0)
    }
    
    func removeFavoriteAtPosition(_ position: Int) {
        favorite.remove(at: position)
    }
    
    func updateLike(id: String, note: Note! = nil) {
        if let index = favorite.firstIndex(where: {$0.id == id }) {
            if let note = note {
                favorite[index].isFavorite = !note.isFavorite
            }else{
                favorite[index].isFavorite = !favorite[index].isFavorite
            }
        }else{
            
        }
    }
    
    func updateLikeMyNote(id: String, note: Note! = nil) {
        if let index = myNote.firstIndex(where: {$0.id == id }) {
            if let note = note {
                myNote[index].isFavorite = note.isFavorite
            }else{
                myNote[index].isFavorite = !myNote[index].isFavorite
            }
            if let index = favorite.firstIndex(where: { $0.id == id} ) {
                if favorite[index].id == id {
                    favorite[index].isFavorite = !note.isFavorite
                }else{
                    favorite[index].isFavorite = !favorite[index].isFavorite
                }
            }
        }else{

        }
    }
    
    func isFavoriteVisible() -> Bool {
        return favorite.isEmpty ? false : true
    }
    
    func getData(indexPath: IndexPath) -> Note {
        let myNoteS = myNote.filter{$0.isMyNote == true }
        return myNoteS.count > 0 ? myNoteS[indexPath.row] : myNote[indexPath.row]
    }
    
    func getFavoriteNoteData(indexPath: IndexPath) -> Note {
        let myFavNote = favorite.filter{$0.isFavorite == true}
        return myFavNote[indexPath.row]
    }
    
    func getFavoriteNote() -> [Note] {
        let myFavNote = favorite.filter{$0.isFavorite == true}
        favorite = myFavNote
        return favorite
    }
    
}
