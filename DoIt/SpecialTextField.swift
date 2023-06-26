//
//  MaxCharTextField.swift
//  DoIt
//
//  Created by Volodymyr Semenov on 9/9/22.
//

import SwiftUI
import Combine

struct SpecialTextField: View {
    @Binding var text: String
    @FocusState var keyboardFocused: Bool
    var body: some View {
        if #available(iOS 16.0, *) {
            TextField("", text: $text, axis: .vertical)
                .lineLimit(2, reservesSpace: true)
                .focused($keyboardFocused)
                .onReceive(Just(text)) { _ in limitText() }
        }
        else {
            TextField("", text: $text)
                .focused($keyboardFocused)
                .onReceive(Just(text)) { _ in limitText() }
        }
    }

    

    //Function to remove and hide keyboard on return click
    func limitText() {
        if(text.contains("\n")){
            keyboardFocused = false
        }
        text = String(text.filter { !"\n".contains($0) })
    }
}

struct MaxCharTextField_Previews: PreviewProvider {
    static var previews: some View {
        Text("Whatever")
    }
}
