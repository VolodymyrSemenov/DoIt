//
//  ContentView.swift
//  DoIt
//
//  Created by Volodymyr Semenov on 8/23/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var Tasks: TaskStorage
    @State var collapse = true
    @State var deleteConfirmationShown = false
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.purple, .blue, .blue, .purple]), startPoint: .topTrailing, endPoint: .bottomLeading )
                    .ignoresSafeArea()
                ScrollView {
                    ForEach(Tasks.Tasks, id: \.id) { task in
                        TaskItemView(task: task)
                    }
                NavigationLink("+ Add New Task") {AddTaskView().navigationTitle("New Task")}
                    .foregroundColor(.white)
                    .padding([.horizontal, .top])
                }
            }
            .navigationTitle("To Do List                       ‍ ")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.bottomBar) {
                    Button(action: {deleteConfirmationShown = true},
                        label: {Text("Delete Finished")
                        }
                    )
                    .buttonStyle(.bordered)
                    .tint(.white)
                    .buttonBorderShape(.roundedRectangle)
                    .confirmationDialog("Are you sure?", isPresented: $deleteConfirmationShown, titleVisibility: .visible) {
                        Button("Yes", role: .destructive) {
                            withAnimation {
                                Tasks.deleteTasks()
                                for task in Tasks.Tasks {
                                    print(task.completed)
                                }
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    Button(action: {Tasks.incrementSorting()},
                           label: {Text("Sort By: \(Tasks.Sorting.rawValue)")}
                    )
                    .buttonStyle(.bordered)
                    .tint(.white)
                    .buttonBorderShape(.roundedRectangle)
                }
                
                ToolbarItem(placement: ToolbarItemPlacement.bottomBar) {
                    Button(action: {
                        collapse = !collapse
                        Tasks.collapseExpand(collapsed: collapse)
                    },
                        label: {Text(collapse ? "Expand" : "Collapse")
                        }
                    )
                    .buttonStyle(.bordered)
                    .tint(.white)
                    .buttonBorderShape(.roundedRectangle)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onChange(of: scenePhase) { phase in
                    if phase == .inactive { saveAction() }
                }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hi")
    }
}
