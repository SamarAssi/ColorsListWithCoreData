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
        description = CoreDataManager.shared.colors.first?.colorDescription
        backgroundColor = Color(
            red: CoreDataManager.shared.colors.first?.redValue ?? 0.0,
            green: CoreDataManager.shared.colors.first?.greenValue ?? 0.0,
            blue: CoreDataManager.shared.colors.first?.blueValue ?? 0.0,
            opacity: CoreDataManager.shared.colors.first?.alphaValue ?? 1.0
        )
    }
    
    func updateColorValuesBasedOnChanges() {
        guard !CoreDataManager.shared.colors.isEmpty else {
            setDefaultColorValues()
            description = "The list is empty..."
            return
        }
        description = CoreDataManager.shared.colors[0].colorDescription
        backgroundColor = Color(
            red: CoreDataManager.shared.colors[0].redValue,
            green: CoreDataManager.shared.colors[0].greenValue,
            blue: CoreDataManager.shared.colors[0].blueValue,
            opacity: CoreDataManager.shared.colors[0].alphaValue
        )
    }
    
    func fetchData() {
        CoreDataManager.shared.fetchColor()
        setDefaultColorValues()
    }
}
