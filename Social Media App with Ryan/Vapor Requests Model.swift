//
//  Vapor Requests Model.swift
//  Social Media App with Ryan
//
//  Created by Brayton Lordianto on 3/30/23.
//

import Foundation

struct StatusRequest: Encodable {
    let status: String
    let uuid: UUID = UUID()
}

struct OnlineResponse: Decodable, Identifiable {
    // for now send back names of user online
    let id: UUID
    let onlineUsers: [String]
}
