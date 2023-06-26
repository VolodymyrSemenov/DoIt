//
//  Subtask.swift
//  DoIt
//
//  Created by Volodymyr Semenov on 8/24/22.
//

import Foundation

struct SubTask{
    var dateCreated: Date = Date.now
    var description: String = ""
    var children: [Task] = []
    var id: UUID = UUID()
}
