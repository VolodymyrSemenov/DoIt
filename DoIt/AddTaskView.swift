//
//  AddTask.swift
//  DoIt
//
//  Created by Volodymyr Semenov on 8/24/22.
//

import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var Tasks: TaskStorage
    @State var datePicker: Date = Date(timeIntervalSinceNow: 86400)
    @State var subtaskPicker = ""
    @State var urgencyPicker = "0"
    @State var text = ""
    @FocusState var keyboardFocused: Bool
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.teal, .cyan]), startPoint: .trailing, endPoint: .leading )
                .ignoresSafeArea()
            VStack {
                Spacer()
                Form {
                    Group {
                        Section(header: Text("Task Description (REQUIRED)")){
                            SpecialTextField(text: $text)
                        }
                        Section("Subtask of") {
                            Picker("Task", selection: $subtaskPicker) {
                                Text("None").tag("")
                                ForEach(Tasks.Tasks, content: { Task in
                                    Text(Task.description).tag(Task.id.uuidString)
                                })
                            }
                        }
                        if(subtaskPicker == ""){
                            Section("Urgency"){
                                Picker(selection: $urgencyPicker, label: Text("Picker")) {
                                    Text("").tag("0")
                                    Text("!").tag("1")
                                    Text("!!").tag("2")
                                    Text("!!!").tag("3")
                                }.pickerStyle(SegmentedPickerStyle())
                            }
                            Section("Due On"){
                                DatePicker("", selection: $datePicker, in: Date()..., displayedComponents: [.date])
                                    .datePickerStyle(.graphical)
                            }
                        }
                    }
                    .listRowBackground(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.2, opacity: 0.08))
                }
                .scrollContentBackground(.hidden)
                if(text != ""){
                    NavigationLink("+ Add New Task") {ContentView(){
                        Tasks.save(TaskStore: Tasks.Tasks) { result in
                            if case .failure(let error) = result {
                                fatalError(error.localizedDescription)
                            }
                        }
                    }
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                    }.simultaneousGesture(TapGesture().onEnded{
                        Tasks.addTask(description: text, dueDate: datePicker, urgency: Int(urgencyPicker) ?? 0, parent: subtaskPicker)
                    })
                    .padding(20)
                }
            }
        }
        .foregroundColor(.white)
    }
}


struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
