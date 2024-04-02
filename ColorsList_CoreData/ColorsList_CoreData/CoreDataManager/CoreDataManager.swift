//
//  CoreDataManager.swift
//  ColorsList_CoreData
//
//  Created by Samar Assi on 26/03/2024.
//

import Foundation
import CoreData
import SwiftUI

final class CoreDataManager: ObservableObject {
    
    // MARK: Properties
    
    static let shared = CoreDataManager()
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "ColorsContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading core data. \(error)")
            } else {
                print("Successfully loaded core data")
            }
        }
    }
    
    // MARK: Methods
    
    func fetchColor() -> [ColorEntity]? {
        let request = NSFetchRequest<ColorEntity>(entityName: "ColorEntity")
        
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
            return nil
        }
    }
    
    func saveColor() -> [ColorEntity]? {
        do {
            try container.viewContext.save()
            return fetchColor()
        } catch let error {
            print("Error saving. \(error)")
            return nil
        }
    }
    
    func moveColor(
        colors: inout [ColorEntity],
        indices: IndexSet,
        newOffset: Int
    ) -> [ColorEntity]? {
        
        colors.move(fromOffsets: indices, toOffset: newOffset)
        for (index, color) in colors.enumerated() {
            color.order = Int64(index)
        }
        
        return saveColor()
    }
    
    func addColor(
        colors: inout [ColorEntity],
        colorTitle: String,
        colorDescription: String,
        color: Color
    ) -> [ColorEntity]? {
        
        let newColor = ColorEntity(context: CoreDataManager.shared.container.viewContext)
        newColor.id = UUID()
        newColor.colorTitle = colorTitle
        newColor.colorDescription = colorDescription
        newColor.redValue = color.components.red
        newColor.greenValue = color.components.green
        newColor.blueValue = color.components.blue
        newColor.alphaValue = color.components.alpha

        let maxOrder = colors.max(by: { $0.order < $1.order })?.order ?? 0
        newColor.order = maxOrder + 1
        
        return saveColor()
    }
    
    func updateColor(
        colorEntity: ColorEntity?,
        colorTitle: inout String,
        colorDescription: inout String,
        color: inout Color
    ) -> [ColorEntity]? {
        
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
        
        return saveColor()
    }
    
    func deleteColor(colors: [ColorEntity], at index: Int) {
        guard index < colors.count else { return }
        let color = colors[index]
        container.viewContext.delete(color)
    }

    func deleteSelectedColors(
        selectedColors: inout [ColorEntity],
        colors: [ColorEntity]
    ) -> [ColorEntity]? {
        
        for color in selectedColors {
            if let index = colors.firstIndex(of: color) {
                deleteColor(colors: colors, at: index)
            }
        }
        selectedColors.removeAll()
        
        return saveColor()
    }
    
    func toggleSelection(selectedColors: inout [ColorEntity], colorEntity: ColorEntity) {
          if let index = selectedColors.firstIndex(of: colorEntity) {
              selectedColors.remove(at: index)
          } else {
              selectedColors.append(colorEntity)
          }
      }

    func isSelected(selectedColors: [ColorEntity], colorEntity: ColorEntity) -> Bool {
        selectedColors.contains(colorEntity)
    }
}
