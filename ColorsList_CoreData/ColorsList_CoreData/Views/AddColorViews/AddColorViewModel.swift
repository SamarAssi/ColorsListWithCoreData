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
    
    // MARK: AddColor method
    func addColor() {
        let newColor = ColorEntity(context: CoreDataManager.coreDataManager.container.viewContext)
        newColor.id = UUID()
        newColor.colorTitle = colorTitle
        newColor.colorDescription = colorDescription
        newColor.redValue = color.components.red
        newColor.greenValue = color.components.green
        newColor.blueValue = color.components.blue
        newColor.alphaValue = color.components.alpha
        
        CoreDataManager.coreDataManager.saveColor()
    }
    
    // MARK: UpdateColor method
    func updateColor(colorEntity: ColorEntity?) {
        setTextFieldValues(colorEntity: colorEntity)
        CoreDataManager.coreDataManager.saveColor()
    }
    
    // MARK: SetTextFieldValues method
    func setTextFieldValues(colorEntity: ColorEntity?) {
        
        if let colorEntity = colorEntity {
            colorTitle = colorEntity.colorTitle ?? ""
            colorDescription = colorEntity.colorDescription ?? ""
            color = Color(
                red: colorEntity.redValue,
                green: colorEntity.greenValue,
                blue: colorEntity.blueValue,
                opacity: colorEntity.alphaValue
            )
        }
    }
    
    // MARK: ProcessColorEntity method
    func processColorEntity(colorEntity: ColorEntity?) {
        if colorEntity == nil {
            addingMode()
        } else {
            editMode(colorEntity: colorEntity)
        }
    }
    
    // MARK: AddingMode method
    func addingMode() {
        if isEmptyFields() {
            return
        }
        addColor()
    }
    
    // MARK: EditMode method
    func editMode(colorEntity: ColorEntity?) {
        if let colorEntity = colorEntity {
            updateColor(colorEntity: colorEntity)
        }
    }
    
    // MARK: isEmptyFields method
    func isEmptyFields() -> Bool {
        return colorTitle.isEmpty || colorDescription.isEmpty
    }
    
    func setDefaultInput() {
        colorTitle = ""
        color = Color.yellow
        colorDescription = ""
    }
}

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

