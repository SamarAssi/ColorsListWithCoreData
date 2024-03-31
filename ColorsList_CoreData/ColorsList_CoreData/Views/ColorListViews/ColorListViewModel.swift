//
//  ColorListViewModel.swift
//  ColorsList_CoreData
//
//  Created by Samar Assi on 26/03/2024.
//

import Foundation
import SwiftUI

final class ColorListViewModel: ObservableObject {
    @Published var selectedColors: [ColorEntity] = []
    
    func deleteColorEntityAtIndex(index: Int) {
        let color = CoreDataManager.coreDataManager.colors[index]
        CoreDataManager.coreDataManager.container.viewContext.delete(color)
    }
    
    func deleteColor(at index: Int) {
        guard index < CoreDataManager.coreDataManager.colors.count else { return }
        deleteColorEntityAtIndex(index: index)
    }

    func deleteSelectedColors() {
        for color in selectedColors {
            if let index = CoreDataManager.coreDataManager.colors.firstIndex(of: color) {
                deleteColor(at: index)
            }
        }
        selectedColors.removeAll()
        
        CoreDataManager.coreDataManager.saveColor()
    }
    
    func toggleSelection(colorEntity: ColorEntity) {
          if let index = selectedColors.firstIndex(of: colorEntity) {
              selectedColors.remove(at: index)
          } else {
              selectedColors.append(colorEntity)
          }
      }

    func isSelected(colorEntity: ColorEntity) -> Bool {
        selectedColors.contains(colorEntity)
    }
    
    func moveColor(indices: IndexSet, newOffset: Int) {
        CoreDataManager.coreDataManager.colors.move(fromOffsets: indices, toOffset: newOffset)
        CoreDataManager.coreDataManager.saveColor()
    }
}
