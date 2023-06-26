//
//  TaskStorage.swift
//  DoIt
//
//  Created by Volodymyr Semenov on 9/9/22.
//

import Foundation
import SwiftUI


enum SortBy: String, Codable {
    case Urgency
    case DateCreated = "Date Created"
    case DueDate = "Due Date"
    case Alphabetical
    
    mutating func increment() {
        if self == .Urgency {
            self = .DateCreated
        } else if self == .DateCreated {
            self = .DueDate
        } else if self == .DueDate {
            self = .Alphabetical
        }
        else if self == .Alphabetical {
            self = .Urgency
        }
    }
}


class TaskStorage: ObservableObject {
    @Published var Tasks: [Task]
    @Published var Sorting: SortBy
    
    init() {
        Tasks = []
        Sorting = SortBy.DateCreated
    }
    
    func addTask(description: String, dueDate: Date, urgency: Int, parent: String){
        let newTask: Task = Task(description: description, dueDate: dueDate, urgency: urgency)
        if(parent == ""){
            Tasks.append(newTask)
        } else {
            for task in Tasks{
                if(task.id == UUID(uuidString: parent)){
                    task.children.append(newTask)
                    break
                }
            }
        }
    }
    
    func deleteTasks(){
        var indecies: [Int] = [] // Indecies of completed tasks
            for (index, task) in Tasks.enumerated(){
                if(task.completed) {
                    indecies.append(index)
                } else {
                var childIndecies: [Int] = []
                    for (index2, child) in task.children.enumerated(){
                        if(child.completed){
                            childIndecies.append(index2)
                        }
                    }
                    childIndecies.reverse()
                    for index2 in childIndecies{
                        task.children.remove(at: index2)
                    }
                }
            }
        indecies.reverse() // Remove from back of List
        for index in indecies{
            Tasks.remove(at: index)
        }
    }
    
    func incrementSorting(){
        Sorting.increment()
        sortTasks()
    }
    
    func sortTasks(){
        if(Sorting == SortBy.Urgency){
            Tasks.sort(by: {(t1: Task, t2: Task) -> Bool in
                return t1.urgency > t2.urgency
            })
        } else if(Sorting == SortBy.DateCreated) {
            Tasks.sort(by: {(t1: Task, t2: Task) -> Bool in
                return t1.dateCreated < t2.dateCreated
            })
        } else if(Sorting == SortBy.DueDate){
            Tasks.sort(by: {(t1: Task, t2: Task) -> Bool in
                return t1.dueDate < t2.dueDate
            })
        } else {
            Tasks.sort(by: {(t1: Task, t2: Task) -> Bool in
                return t1.description < t2.description
            })
        }
    }
    
    func collapseExpand(collapsed: Bool){
        if(collapsed){
            for task in Tasks{
                task.collapsed = true
            }
                        
        } else {
            for task in Tasks{
                task.collapsed = false
            }
        }
    }
    
    // To Load Data
    func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Tasks.data")
    }
    
    func load(completion: @escaping (Result<[Task], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try self.fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let TaskList = try JSONDecoder().decode([Task].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(TaskList))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func save(TaskStore: [Task], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(TaskStore)
                let outfile = try self.fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(TaskStore.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
