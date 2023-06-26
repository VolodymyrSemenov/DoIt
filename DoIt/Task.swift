//
//  Task.swift
//  DoIt
//
//  Created by Volodymyr Semenov on 8/24/22.
//

import Foundation
import SwiftUI

class Task: Identifiable, ObservableObject, Codable {
    var dateCreated: Date = Date.now
    var dueDate: Date = Date(timeIntervalSinceNow: 86400)
    var description: String = ""
    var urgency: Int = 0
    var id: UUID = UUID()
    @Published var children: [Task] = []
    @Published var completed: Bool = false
    @Published var collapsed: Bool = false
    
    
    init(description: String, dueDate: Date = Date.now, urgency: Int = 0) {
        self.description = description
        self.dueDate = dueDate
        self.urgency = urgency
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        children = try container.decode([Task].self, forKey: .children)
        completed = try container.decode(Bool.self, forKey: .completed)
        collapsed = try container.decode(Bool.self, forKey: .collapsed)
        dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        dueDate = try container.decode(Date.self, forKey: .dueDate)
        description = try container.decode(String.self, forKey: .description)
        urgency = try container.decode(Int.self, forKey: .urgency)
        id = try container.decode(UUID.self, forKey: .id)
    }
    
    func complete(){
        completed = !completed
    }
    
    func collapse(){
        collapsed = !collapsed
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(children, forKey: .children)
        try container.encode(completed, forKey: .completed)
        try container.encode(collapsed, forKey: .collapsed)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(dueDate, forKey: .dueDate)
        try container.encode(description, forKey: .description)
        try container.encode(urgency, forKey: .urgency)
        try container.encode(id, forKey: .id)
    }
    
    enum CodingKeys: CodingKey{
        case children
        case completed
        case collapsed
        case dateCreated
        case dueDate
        case description
        case urgency
        case id
    }
}
