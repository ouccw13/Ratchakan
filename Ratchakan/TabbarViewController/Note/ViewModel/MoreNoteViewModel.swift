//
//  MoreNoteViewModel.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 4/9/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import Foundation

class MoreNoteViewModel {
    
    let api = API()
    
    var dataSource: [Note] = []
    
    var pageType: PageType!
    
    var searchParam: String!
    
    var noteTag: NoteTag!
    
    var tag: SearchTag!
    
    init(type: PageType, noteTag: NoteTag = .none, tag: SearchTag! = nil, searchParam: String = "") {
        self.pageType = type
        self.searchParam = searchParam
        self.noteTag = noteTag
        self.tag = tag
    }
    
    func loadNote(whenDataCalled: @escaping ((Bool) -> ())) {
        switch pageType {
        case .tag:
            let queryParam = "?\(tag.type)=\(tag.id)"
            api.getNote(tagParam: queryParam) { (finished, response) in
                if finished {
                    self.dataSource = response!["result"] as? [Note] ?? []
                    whenDataCalled(finished)
                }
            }
        case .search:
            guard let encodedParam = searchParam.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
            api.getNote(searchParam: encodedParam) { (finished, response) in
                if finished {
                    self.dataSource = response!["result"] as? [Note] ?? []
                    whenDataCalled(finished)
                }
            }
        case .more:
            var path = ""
            switch noteTag {
            case .recommend: path = Path.noteSuggestion
            case .popular: path = Path.notePopular
            case .love: path = Path.noteFavorite
            default: break
            }
            api.getNoteViaPath(path: path) { (finished, response) in
                if finished {
                    self.dataSource = response!["result"] as? [Note] ?? []
                    whenDataCalled(finished)
                }
            }
        default: break
        }
    }
    
    func favoriteNote(indexPath: IndexPath) {
        let note = dataSource[indexPath.row]
        
        api.putFavoriteNote(withId: note.id) { (finished, response) in

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
    
    func updateLike(id: String) {
        if let index = dataSource.firstIndex(where: { $0.id == id }) {
            dataSource[index].isFavorite = !dataSource[index].isFavorite
        }
    }
    
    var numberOfItem: Int {
        get {
            if noteTag == .love {
                let favMoreNote = dataSource.filter{$0.isFavorite == true }.count
                return favMoreNote > 0 ? favMoreNote : 0
            }else{
                return dataSource.count
            }
            
        }
    }
    
    var dataIsEmpty: Bool {
        get {
            return dataSource.isEmpty
        }
    }
    
    var titleText: String {
        get {
            switch pageType {
            case .tag: return tag.name
            case .search: return "\"\(searchParam ?? "")\""
            case .more: return noteTag.rawValue
            default: return ""
            }
        }
    }
    
    func updatePurchasedNoteFromId(id: String) {
        if let index = dataSource.firstIndex(where: { $0.id == id }) {
            dataSource[index].isMyNote = true
        }
    }
    
    func getData(atIndexPath indexPath: IndexPath) -> Note {
        if noteTag == .love {
            let favMoreNote = dataSource.filter{$0.isFavorite == true }
            return favMoreNote.count > 0 ? favMoreNote[indexPath.row] : dataSource[indexPath.row]
        }else{
            return dataSource[indexPath.row]
        }
       
    }
    
    func getNoteId(atIndexPath indexPath: IndexPath) -> String {
        return dataSource[indexPath.row].id
    }
    
    enum PageType {
        case tag
        case search
        case more
    }
}
