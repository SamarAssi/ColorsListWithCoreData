//
//  ColorsList_CoreDataApp.swift
//  ColorsList_CoreData
//
//  Created by Samar Assi on 26/03/2024.
//

import SwiftUI

@main
struct ColorsList_CoreDataApp: App {
    let combinedViewModel = CombinedViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(combinedViewModel)
        }
    }
}
