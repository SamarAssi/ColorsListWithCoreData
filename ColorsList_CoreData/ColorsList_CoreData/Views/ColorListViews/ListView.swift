//
//  ListView.swift
//  ColorsList_CoreData
//
//  Created by Samar Assi on 26/03/2024.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var combinedViewModel: CombinedViewModel
    
    var body: some View {
        List {
            ForEach(combinedViewModel.colors) { color in
                listCellView(color: color)
                    .onTapGesture {
                        handleCellSelection(color: color)
                    }
                    .listRowBackground(
                        setListRowBackground(color: color)
                    )
            }
            .onMove(perform: moveColor)
        }
        .fullScreenCover(isPresented: $combinedViewModel.showEditingScreen) {
            AddNewColorView()
        }
        .listStyle(.inset)
        .environment(
            \.editMode,
             .constant(combinedViewModel.isEditing ? .active : .inactive)
        )
    }
}

extension ListView {
    func listCellView(color: ColorEntity) -> some View {
        ListCellView(
            isSelected: CoreDataManager.shared.isSelected(
                selectedColors: combinedViewModel.selectedColors,
                colorEntity: color
            ),
            color: Binding<ColorEntity> (
                get: { color },
                set: { _ in }
            )
        )
    }
    
    func setListRowBackground(color: ColorEntity) -> Color {
        Color(
            red: color.redValue,
            green: color.greenValue,
            blue: color.blueValue,
            opacity: color.alphaValue
        )
    }
    
    func handleCellSelection(color: ColorEntity) {
        if !combinedViewModel.isEditing {
            combinedViewModel.selectedColor = color
        } else {
            combinedViewModel.showEditingScreen.toggle()
            combinedViewModel.colorEntity = color
        }
    }
    
    func moveColor(indices: IndexSet, newOffset: Int) {
        combinedViewModel.moveColor(indices: indices, newOffset: newOffset)
        combinedViewModel.updateColorValuesBasedOnChanges()
    }
}

#Preview {
    ListView()
        .environmentObject(CombinedViewModel())
}
