//
//  CoreDataManager.swift
//  ColorsList_CoreData
//
//  Created by Samar Assi on 26/03/2024.
//

import Foundation
import CoreData

final class CoreDataManager: ObservableObject {
    static let coreDataManager = CoreDataManager()
    @Published var colors: [ColorEntity] = []
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
        fetchColor()
    }
    
    func fetchColor() {
        let request = NSFetchRequest<ColorEntity>(entityName: "ColorEntity")
        
        do {
            colors = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    func saveColor() {
        do {
            try container.viewContext.save()
            fetchColor()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
}
