//
//  TextFieldView.swift
//  ColorsList_CoreData
//
//  Created by Samar Assi on 26/03/2024.
//

import SwiftUI

struct TextFieldView: View {
    var placeholder: String
    @Binding var text: String
   
    var body: some View {
        TextField(placeholder, text: $text, axis: .vertical)
            .padding()
            .frame(height: 60, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 25.0)
                    .stroke(lineWidth: 2)
                    .foregroundColor(Color("Silver"))
            )
    }
}

#Preview {
    TextFieldView(
        placeholder: "Enter your info",
        text: .constant("")
    )
}
