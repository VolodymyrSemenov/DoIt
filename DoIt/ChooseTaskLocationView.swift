//
//  ChooseTaskLocationView.swift
//  DoIt
//
//  Created by Volodymyr Semenov on 9/8/22.
//

import SwiftUI

struct ChooseTaskLocationView: View {
    @State var collapse = true
    @State var sort: SortBy = SortBy.DateCreated
    @State var exam = Task(description: "Do Math Homework")
    @State var deleteConfirmationShown = false
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.teal, .cyan]), startPoint: .trailing, endPoint: .leading )
                    .ignoresSafeArea()
                ScrollView {
                    TaskItemView(ex: exam)
                    TaskItemView(ex: exam)
                    TaskItemView(ex: exam)
                    
                    NavigationLink("+ Add New Task") {AddTaskView().navigationTitle("New Task")}
                        .foregroundColor(.black)
                        .padding([.horizontal, .top])
                }
            }
            .navigationTitle("To Do List")
            
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    Button(action: {print("Pressed")},
                        label: {Image(systemName: "gearshape.fill")
                                .foregroundColor(.black)
                        }
                    )
                }
                
                ToolbarItem(placement: ToolbarItemPlacement.bottomBar) {
                    Button(role: .destructive,
                        action: {deleteConfirmationShown = true},
                        label: {Text("Delete Finished Tasks")
                                .foregroundColor(Color(.sRGB, red: 1, green: 0.2, blue: 0.2, opacity: 100))
                        }
                    )
                    .buttonStyle(.bordered)
                    .tint(.white)
                    .buttonBorderShape(.roundedRectangle)
                    .confirmationDialog("Are you sure?", isPresented: $deleteConfirmationShown, titleVisibility: .visible) {
                        Button("Yes", role: .destructive) {
                            withAnimation {
                                print("delete")
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                    Button(action: {sort.increment()},
                        label: {Text("Sort By: \(sort.rawValue)")}
                    )
                    .foregroundColor(.black)
                    .buttonStyle(.bordered)
                    .tint(.white)
                    .buttonBorderShape(.roundedRectangle)
                }
                
                ToolbarItem(placement: ToolbarItemPlacement.bottomBar) {
                    Button(action: {collapse = !collapse},
                        label: {Text(collapse ? "Expand All" : "Collapse All")
                        }
                    )
                    .foregroundColor(.black)
                    .buttonStyle(.bordered)
                    .tint(.white)
                    .buttonBorderShape(.roundedRectangle)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ChooseTaskLocationView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseTaskLocationView()
    }
}
