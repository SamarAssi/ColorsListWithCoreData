//
//  ListView.swift
//  ColorsList_CoreData
//
//  Created by Samar Assi on 26/03/2024.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var combinedViewModel: CombinedViewModel
    
    @State var newColor: ColorEntity?
    @State var showEditingScreen = false
    
    var body: some View {
        List {
            ForEach(CoreDataManager.shared.colors) { color in
                listCellView(color: color)
                    .listRowBackground(
                        setListRowBackground(color: color)
                    )
                    .onTapGesture {
                        handleCellSelection(color: color)
                    }
            }
            .onMove(perform: moveColor)
        }
        .fullScreenCover(isPresented: $showEditingScreen) {
            AddNewColorView(
                combinedViewModel: combinedViewModel,
                colorEntity: $newColor
            )
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
            combinedViewModel: combinedViewModel,
            isSelected: CoreDataManager.shared.isSelected(colorEntity: color),
            colorTitle: Binding<String> (
                get: { color.colorTitle ?? "" },
                set: { _ in }
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
            showEditingScreen.toggle()
            newColor = color
        }
    }
    
    func moveColor(indices: IndexSet, newOffset: Int) {
        combinedViewModel.colorListViewModel.moveColor(indices: indices, newOffset: newOffset)
        combinedViewModel.updateColorValuesBasedOnChanges()
    }
}

#Preview {
    ListView(
        combinedViewModel: CombinedViewModel()
    )
}
