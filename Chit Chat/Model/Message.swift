//
//  Message.swift
//  Chit Chat
//
//  Created by Harleen Singh on 24/12/20.
//

import Foundation

struct Message: Decodable {
    let messageId: String?
    let message: String?
    let images: [String]?
    let videos: [String]?
    let user: String?
    let isFromCurrentUser: Bool
    let date: Int?
    private enum CodingKeys: String, CodingKey {
        case messageId
        case message
        case images
        case videos
        case user
        case isFromCurrentUser
        case date
    }
    init(meID: String, m: String, i: [String], v: [String], u: String, isFromCurrent: Bool, d: Int) {
        self.messageId = meID
        self.message = m
        self.images = i
        self.videos = v
        self.user = u
        self.isFromCurrentUser = isFromCurrent
        self.date = d
        
    }
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        messageId = (try container.decodeIfPresent(String.self, forKey: .messageId)) ?? ""
        message = (try container.decodeIfPresent(String.self, forKey: .message)) ?? ""
        images = (try container.decodeIfPresent([String].self, forKey: .images)) ?? [String]()
        videos = (try container.decodeIfPresent([String].self, forKey: .videos)) ?? [String]()
        user = (try container.decodeIfPresent(String.self, forKey: .user)) ?? ""
        date = (try container.decodeIfPresent(Int.self, forKey: .date)) ?? nil
        isFromCurrentUser = (K.user == user)
    }
}

struct MessageResponse: Decodable {
    var response: [Message]
}
