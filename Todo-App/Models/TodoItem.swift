//
//  Task.swift
//  Todo-App
//
//  Created by Lê Tiến Đạt on 21/12/2024.
//

import Foundation

struct TodoItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var status: StatusTask
    var timeCreated: Date
    var timeUpdated: Date
    var timeCompleted: Date?

    init(
        id: UUID = UUID(),
        title: String,
        content: String,
        status: StatusTask,
        timeCreated: Date,
        timeUpdated: Date,
        timeCompleted: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.status = status
        self.timeCreated = timeCreated
        self.timeUpdated = timeUpdated
        self.timeCompleted = timeCompleted
    }

    enum CodingKeys: String, CodingKey {
        case id, title, content, status, timeCreated, timeUpdated, timeCompleted
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.title = try container.decode(String.self, forKey: .title)
        self.content = try container.decode(String.self, forKey: .content)
        self.status = try container.decode(StatusTask.self, forKey: .status)
        self.timeCreated = try container.decode(Date.self, forKey: .timeCreated)
        self.timeUpdated = try container.decode(Date.self, forKey: .timeUpdated)
        self.timeCompleted = try container.decodeIfPresent(Date.self, forKey: .timeCompleted)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)
        try container.encode(status, forKey: .status)
        try container.encode(timeCreated, forKey: .timeCreated)
        try container.encode(timeUpdated, forKey: .timeUpdated)
        try container.encodeIfPresent(timeCompleted, forKey: .timeCompleted)
    }
}

enum StatusTask: String, Codable {
    case pending = "Pending"
    case completed = "Completed"
}
