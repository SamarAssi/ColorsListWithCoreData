//
//  CustomButton.swift
//  ColorsList_CoreData
//
//  Created by Samar Assi on 26/03/2024.
//

import SwiftUI

struct CustomButton: View {
    var buttonIcon: String?
    var buttonText: String?
    var buttonColor: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            if let buttonIcon = buttonIcon {
                Image(systemName: buttonIcon)
            }
            if let buttonText = buttonText {
                Text(buttonText)
                    .fontWeight(.bold)
            }
        }
        .foregroundStyle(buttonColor)
    }
}

#Preview {
    CustomButton(
        buttonColor: Color.black,
        action: {}
    )
}
