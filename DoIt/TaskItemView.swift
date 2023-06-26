//
//  TaskItemView.swift
//  DoIt
//
//  Created by Volodymyr Semenov on 8/24/22.
//

import SwiftUI

struct datePickersStore {
    
}

struct TaskItemView: View {
    @ObservedObject var ex: Task
    var dateFormatter = DateFormatter()
    var body: some View {
        VStack {
            HStack {
                Button(action: {ex.complete()}, label: {Image(systemName: ex.completed ?  "checkmark.circle": "circle")
                })
                .foregroundColor(.white)
                
                Button(action: {print("edit task todo")}, label: {Text(ex.description).multilineTextAlignment(.leading)}
                )
                .foregroundColor(.white)
                
                Spacer()
                
                if (ex.urgency == 1) {
                    Text("!")
                } else if(ex.urgency == 2){
                    Text("!!")
                } else if(ex.urgency == 3){
                    Text("!!!")
                }
                
                Button(action: {ex.collapse()}, label: {
                    if (!ex.children.isEmpty) {
                        Image(systemName: ex.collapsed ? "chevron.down" : "chevron.up")
                        .foregroundColor(.white)
                    } else {
                        Image(systemName: "chevron.down")
                        .foregroundColor(.clear)
                    }
                })
                .padding(.trailing)
            }
            
            HStack{
                Text(dateFormatter.string(from:ex.dueDate))
                Spacer()
            }
            
            if(!ex.collapsed){
                ForEach(ex.children){ child in
                    SubtaskItemView(ex: child)
                }
            }
        }
        .padding([.top], 3)
        .padding([.leading])
    }
    
    init(task: Task){
        dateFormatter.dateStyle = .medium
        ex = task
    }
}

struct TaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hi")
    }
}
