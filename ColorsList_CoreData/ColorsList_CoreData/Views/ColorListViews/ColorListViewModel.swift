//
//  ColorListViewModel.swift
//  ColorsList_CoreData
//
//  Created by Samar Assi on 26/03/2024.
//

import Foundation
import SwiftUI

final class ColorListViewModel: ObservableObject {
    
    func deleteSelectedColors() {
        CoreDataManager.shared.deleteSelectedColors()
    }
    
    func moveColor(indices: IndexSet, newOffset: Int) {
        CoreDataManager.shared.moveColor(indices: indices, newOffset: newOffset)
    }
}
