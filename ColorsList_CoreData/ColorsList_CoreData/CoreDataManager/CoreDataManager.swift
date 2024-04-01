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
    @Published var colors: [ColorEntity] = []
    @Published var selectedColors: [ColorEntity] = []
    let container: NSPersistentContainer
    
    // MARK: Loading core data
    init() {
        container = NSPersistentContainer(name: "ColorsContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading core data. \(error)")
            } else {
                print("Successfully loaded core data")
            }
        }
        fetchColor()
    }
    // MARK: Methods
    
    
    
    // MARK: fetchColor
    func fetchColor() {
        let request = NSFetchRequest<ColorEntity>(entityName: "ColorEntity")
        
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            colors = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    // MARK: saveColor
    func saveColor() {
        do {
            try container.viewContext.save()
            fetchColor()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
    
    // MARK: moveColor
    func moveColor(indices: IndexSet, newOffset: Int) {
        colors.move(fromOffsets: indices, toOffset: newOffset)
        for (index, color) in colors.enumerated() {
            color.order = Int64(index)
        }
        
        saveColor()
    }
    
    // MARK: addColor
    func addColor(colorTitle: String, colorDescription: String, color: Color) {
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
        
        saveColor()
    }
    
    // MARK: updateColor
    func updateColor(
        colorEntity: ColorEntity?,
        colorTitle: inout String,
        colorDescription: inout String,
        color: inout Color
    ) {
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
        saveColor()
    }
    
    // MARK: deleteColor
    func deleteColor(at index: Int) {
        guard index < colors.count else { return }
        let color = colors[index]
        container.viewContext.delete(color)
    }

    // MARK: deleteSelectedColors
    func deleteSelectedColors() {
        for color in selectedColors {
            if let index = colors.firstIndex(of: color) {
                deleteColor(at: index)
            }
        }
        selectedColors.removeAll()
        
        saveColor()
    }
    
    // MARK: toggleSelection
    func toggleSelection(colorEntity: ColorEntity) {
          if let index = selectedColors.firstIndex(of: colorEntity) {
              selectedColors.remove(at: index)
          } else {
              selectedColors.append(colorEntity)
          }
      }

    // MARK: isSelected
    func isSelected(colorEntity: ColorEntity) -> Bool {
        selectedColors.contains(colorEntity)
    }
}
