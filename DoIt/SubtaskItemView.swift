//
//  SubtaskItemView.swift
//  DoIt
//
//  Created by Volodymyr Semenov on 10/17/22.
//

import SwiftUI

struct SubtaskItemView: View {
    @ObservedObject var ex: Task
    var body: some View {
        VStack {
            HStack {
                Button(action: {ex.complete()}, label: {Image(systemName: ex.completed ?  "checkmark.circle": "circle")
                })
                .foregroundColor(.white)
                
                Button(action: {print("edit task todo")}, label: {Text(ex.description).multilineTextAlignment(.leading)
                })
                .foregroundColor(.white)
                Spacer()
            }
        }
        .padding([.top], 3)
        .padding([.horizontal], 25)
    }
}

struct SubtaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hi")
    }
}
