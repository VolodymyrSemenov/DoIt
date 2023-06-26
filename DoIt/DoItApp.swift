//
//  DoItApp.swift
//  DoIt
//
//  Created by Volodymyr Semenov on 8/23/22.
//

import SwiftUI


@main
struct DoItApp: App {
    @StateObject var Tasks = TaskStorage()
    var body: some Scene {
        WindowGroup {
            ContentView(){
                Tasks.save(TaskStore: Tasks.Tasks) { result in
                    if case .failure(let error) = result {
                        fatalError(error.localizedDescription)
                    }
                }
            }
                .environmentObject(Tasks)
                .onAppear {
                    Tasks.load { result in
                        switch result {
                        case .failure:
                            Tasks.Tasks = []
                        case .success(let taskList):
                            Tasks.Tasks = taskList
                    }
                }
            }
        }
    }
}
