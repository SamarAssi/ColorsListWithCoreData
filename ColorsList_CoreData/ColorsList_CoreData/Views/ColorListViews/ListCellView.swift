//
//  ListCellView.swift
//  ColorsList_CoreData
//
//  Created by Samar Assi on 31/03/2024.
//

import SwiftUI

struct ListCellView: View {
    @EnvironmentObject var combinedViewModel: CombinedViewModel
    
    @State var isSelected: Bool
    @Binding var color: ColorEntity
    
    var body: some View {
        ZStack(alignment: .leading) {
            listCell
            
            HStack {
                if combinedViewModel.isEditing {
                    selectionView
                    colorTitleView
                } else {
                    colorTitleView
                }
            }
            .foregroundStyle(Color.white)
        }
        .onChange(of: combinedViewModel.isEditing) {
            updateSelectionStatus()
        }
    }
}

extension ListCellView {
    var listCell: some View {
        Rectangle()
            .fill(Color.clear)
            .contentShape(Rectangle())
    }
    
    var colorTitleView: some View {
        Text(color.colorTitle ?? "")
            .padding(.vertical, 10)
    }
    
    var selectionView: some View {
        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
            .onTapGesture {
                isSelected.toggle()
                CoreDataManager.shared.toggleSelection(
                    selectedColors: &combinedViewModel.selectedColors,
                    colorEntity: color
                )
            }
    }
    
    func updateSelectionStatus() {
        if !combinedViewModel.isEditing {
            isSelected = false
        }
    }
}

#Preview {
    ListCellView(
        isSelected: false,
        color: .constant(ColorEntity())
    )
    .environmentObject(CombinedViewModel())
}
