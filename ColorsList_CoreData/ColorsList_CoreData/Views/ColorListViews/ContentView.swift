//
//  ContentView.swift
//  ColorsList_CoreData
//
//  Created by Samar Assi on 26/03/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var combinedViewModel: CombinedViewModel
    
    var body: some View {
        NavigationStack {
            portraitMode
            tabView
        }
        .fullScreenCover(isPresented: $combinedViewModel.showAddColorScreen) {
            AddNewColorView()
        }
        .onAppear {
            combinedViewModel.fetchData()
        }
    }
}

extension ContentView {
    var leadingTitleView: some View {
        Text("Colors")
            .font(.title)
            .fontWeight(.bold)
    }
    
    var editButton: some View {
        CustomButton(
            buttonText: combinedViewModel.isEditing ? "Done" : "Edit",
            buttonColor: Color.black,
            action: {
                combinedViewModel.isEditing.toggle()
            }
        )
    }
    
    var portraitMode: some View {
        VStack(alignment: .leading, spacing: 0) {
            ListView()
                .navigationBarItems(
                    leading: leadingTitleView,
                    trailing: !combinedViewModel.colors.isEmpty ? editButton : nil
                )
            
            descriptionView
                .padding(20)
        }
        .background(combinedViewModel.backgroundColor)
    }
    
    var descriptionView: some View {
        VStack(alignment: .leading) {
            Text("Descpription")
                .fontWeight(.bold)
                .padding(.bottom)
            Text(combinedViewModel.description ?? "The list is empty...")
            Spacer()
        }
        .foregroundStyle(Color.white)
    }

    var tabView: some View {
        VStack {
            ZStack {
                Color.white
                
                HStack {
                    if combinedViewModel.isEditing {
                        deleteColorButtonView
                    }
                    Spacer()
                    addColorButtonView
                }
                .font(.title3)
            }
        }
        .padding(.horizontal)
        .frame(height: 40)
    }
    
    var deleteColorButtonView: some View {
        CustomButton(
            buttonIcon: "trash",
            buttonColor: Color.red,
            action: {
                handleDeleteActionButton()
            }
        )
    }
    
    var addColorButtonView: some View {
        CustomButton(
            buttonIcon: "plus",
            buttonColor: Color.black,
            action: {
                combinedViewModel.showAddColorScreen.toggle()
            }
        )
    }
    
    func handleDeleteActionButton() {
        combinedViewModel.deleteSelectedColors()
        combinedViewModel.isEditing = false
        combinedViewModel.fetchData()
        combinedViewModel.updateColorValuesBasedOnChanges()
    }
}

#Preview {
    ContentView()
        .environmentObject(CombinedViewModel())
}
