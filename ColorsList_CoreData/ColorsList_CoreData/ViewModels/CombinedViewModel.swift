//
//  CombinedViewModel.swift
//  ColorsList_CoreData
//
//  Created by Samar Assi on 26/03/2024.
//

import Foundation
import SwiftUI

final class CombinedViewModel: ObservableObject {
    @ObservedObject var colorListViewModel = ColorListViewModel()
    @ObservedObject var addColorViewModel = AddColorViewModel()
    
    @Published var isEditing: Bool = false
    
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
    
    func setDefaultColorValues() {
        description = CoreDataManager.coreDataManager.colors.first?.colorDescription
        backgroundColor = Color(
            red: CoreDataManager.coreDataManager.colors.first?.redValue ?? 0.0,
            green: CoreDataManager.coreDataManager.colors.first?.greenValue ?? 0.0,
            blue: CoreDataManager.coreDataManager.colors.first?.blueValue ?? 0.0,
            opacity: CoreDataManager.coreDataManager.colors.first?.alphaValue ?? 1.0
        )
    }
    
    func updateColorValuesBasedOnChanges() {
        guard !CoreDataManager.coreDataManager.colors.isEmpty else {
            setDefaultColorValues()
            description = "The list is empty..."
            return
        }
        description = CoreDataManager.coreDataManager.colors[0].colorDescription
        backgroundColor = Color(
            red: CoreDataManager.coreDataManager.colors[0].redValue,
            green: CoreDataManager.coreDataManager.colors[0].greenValue,
            blue: CoreDataManager.coreDataManager.colors[0].blueValue,
            opacity: CoreDataManager.coreDataManager.colors[0].alphaValue
        )
    }
    
    func fetchData() {
        CoreDataManager.coreDataManager.fetchColor()
        setDefaultColorValues()
    }
}
