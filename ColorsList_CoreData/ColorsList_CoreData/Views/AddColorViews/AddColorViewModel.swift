//
//  AddColorViewModel.swift
//  ColorsList_CoreData
//
//  Created by Samar Assi on 26/03/2024.
//

import Foundation
import SwiftUI

final class AddColorViewModel: ObservableObject {
    // MARK: Published Properties
    @Published var colorTitle = ""
    @Published var color = Color.yellow
    @Published var colorDescription = ""
    
    // MARK: Methods
    
    
    
    // MARK: addingMode
    func addingMode() {
        if isEmptyFields() {
            return
        }
        CoreDataManager.shared.addColor(
            colorTitle: colorTitle,
            colorDescription: colorDescription,
            color: color
        )
    }
    
    // MARK: editMode
    func editMode(colorEntity: ColorEntity?) {
        if let colorEntity = colorEntity {
            CoreDataManager.shared.updateColor(
                colorEntity: colorEntity,
                colorTitle: &colorTitle,
                colorDescription: &colorDescription,
                color: &color
            )
        }
    }
    
    // MARK: ProcessColorEntity
    func processColorEntity(colorEntity: ColorEntity?) {
        if colorEntity == nil {
            addingMode()
        } else {
            editMode(colorEntity: colorEntity)
        }
    }
    
    // MARK: isEmptyFields
    func isEmptyFields() -> Bool {
        return colorTitle.isEmpty || colorDescription.isEmpty
    }
    
    // MARK: clearInputFields
    func clearInputFields() {
        colorTitle = ""
        color = Color.yellow
        colorDescription = ""
    }
}

// MARK: Extension of Color struct
extension Color {
    var components: (red: Double, green: Double, blue: Double, alpha: Double) {
        get {
            let uiColor = UIColor(self)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            return (Double(red), Double(green), Double(blue), Double(alpha))
        }
    }
}

