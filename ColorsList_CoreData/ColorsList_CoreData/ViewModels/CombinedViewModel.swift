//
//  CombinedViewModel.swift
//  ColorsList_CoreData
//
//  Created by Samar Assi on 26/03/2024.
//

import Foundation
import SwiftUI

final class CombinedViewModel: ObservableObject {
    
    // MARK: Published properties
    
    @Published var isEditing: Bool = false
    @Published var showAddColorScreen = false
    
    @Published var colorEntity: ColorEntity?
    @Published var showEditingScreen = false
    
    @Published var isSelected: Bool = false
    
    @Published var colorTitle = ""
    @Published var color = Color.yellow
    @Published var colorDescription = ""
    
    @Published var colors: [ColorEntity] = []
    @Published var selectedColors: [ColorEntity] = []
    
    @Published private (set) var description: String?
    @Published private (set) var backgroundColor: Color?
    @Published var selectedColor: ColorEntity? {
        didSet {
            if let selectedColor = selectedColor {
                description = selectedColor.colorDescription
                backgroundColor = Color(
                    red: selectedColor.redValue,
                    green: selectedColor.greenValue,
                    blue: selectedColor.blueValue,
                    opacity: selectedColor.alphaValue
                )
            }
        }
    }
}

// MARK: extension for shared methods

extension CombinedViewModel {
    func setDefaultColorValues() {
        description = colors.first?.colorDescription ?? "The list is empty..."
        backgroundColor = Color(
            red: colors.first?.redValue ?? 0.0,
            green: colors.first?.greenValue ?? 0.0,
            blue: colors.first?.blueValue ?? 0.0,
            opacity: colors.first?.alphaValue ?? 1.0
        )
    }
    
    func updateColorValuesBasedOnChanges() {
        if let selectedColor = selectedColor, colors.contains(selectedColor) {
            self.selectedColor = selectedColor
        } else {
            self.selectedColor = colors.first
        }
        
        if let selectedColor = selectedColor {
            description = selectedColor.colorDescription ?? ""
            backgroundColor = Color(
                red: selectedColor.redValue,
                green: selectedColor.greenValue,
                blue: selectedColor.blueValue,
                opacity: selectedColor.alphaValue
            )
        } else {
            setDefaultColorValues()
        }
    }
    
    func fetchData() {
        colors = CoreDataManager.shared.fetchColor() ?? []
        setDefaultColorValues()
    }
}

// MARK: Extension for AddColorView methods

extension CombinedViewModel {
    func addingMode() {
        if isEmptyFields() {
            return
        }
        colors = CoreDataManager.shared.addColor(
            colors: &colors,
            colorTitle: colorTitle,
            colorDescription: colorDescription,
            color: color
        ) ?? []
    }
    
    func editMode() {
        if isEmptyFields() {
            return
        }
        if let colorEntity = colorEntity {
            colors = CoreDataManager.shared.updateColor(
                colorEntity: colorEntity,
                colorTitle: &colorTitle,
                colorDescription: &colorDescription,
                color: &color
            ) ?? []
        }
    }
    
    func setFieldsValues() {
        if colorEntity != nil {
            colorTitle = colorEntity?.colorTitle ?? ""
            colorDescription = colorEntity?.colorDescription ?? ""
        } else {
            colorTitle = ""
            color = Color.yellow
            colorDescription = ""
        }
    }
    
    func processColorEntity() {
        if colorEntity == nil {
            addingMode()
        } else {
            editMode()
        }
    }
    
    func isEmptyFields() -> Bool {
        return colorTitle.isEmpty || colorDescription.isEmpty
    }
   
    
    func clearColorEntity() {
//        colorTitle = ""
//        color = Color.yellow
//        colorDescription = ""
        colorEntity = nil
    }
}

// MARK: Extension for ColorListView methods

extension CombinedViewModel {
    func deleteSelectedColors() {
        colors = CoreDataManager.shared.deleteSelectedColors(
            selectedColors: &selectedColors,
            colors: colors
        ) ?? []
    }
    
    func moveColor(indices: IndexSet, newOffset: Int) {
        colors = CoreDataManager.shared.moveColor(
            colors: &colors,
            indices: indices,
            newOffset: newOffset
        ) ?? []
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
