//
//  Note.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 3/9/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import Foundation

class Note: Codable {
    var soldCount: Int?
    var createdAt: Int?
    var name: String
    var description: String?
    var gradeId:String?
    var id: String
    var thumbnail: String?
    var isFavorite: Bool
    var isMyNote: Bool
    var publisher: Publisher
    var noteImages: [NoteImage]?
    var rating: Rating
    var priceTier: PriceTier
    var tags: [SearchTag]?
    var myComment: Comment?
    var comments: [Comment]?
    
    enum CodingKeys: String, CodingKey {
        case soldCount, createdAt
        case name, description,gradeId, id, thumbnail
        case isFavorite, isMyNote
        case publisher
        case noteImages
        case rating
        case priceTier
        case tags
        case myComment, comments
    }
    
}

struct Publisher: Codable {
    var name: String
    var logo: String?
}

struct NoteImage: Codable {
    var url: String
    var isPreview: Bool
}

struct PriceTier: Codable {
    var cash: Cash
    
    struct Cash: Codable {
        var price: Int
        var inAppId: String?
    }
}

struct Rating: Codable {
    var count: Int
    var point: Double
}

struct SearchTag: Codable {
    var name: String
    var type: String
    var id: String
}

struct Comment: Codable {
    var user: User
    var rating: Double
    var comment: String
    var createdAt: Int
}

struct User: Codable {
    var displayName: String
    var gender: String?
}
