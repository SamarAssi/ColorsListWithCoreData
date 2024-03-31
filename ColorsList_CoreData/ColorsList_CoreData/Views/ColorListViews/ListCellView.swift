//
//  ListCellView.swift
//  ColorsList_CoreData
//
//  Created by Samar Assi on 31/03/2024.
//

import SwiftUI

struct ListCellView: View {
    @ObservedObject var combinedViewModel: CombinedViewModel
    
    @State var isSelected: Bool
    
    @Binding var colorTitle: String
    @Binding var color: ColorEntity
    
    var body: some View {
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
}

extension ListCellView {
    var colorTitleView: some View {
        Text(colorTitle)
            .padding(.vertical, 10)
    }
    
    var selectionView: some View {
        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
            .onTapGesture {
                isSelected.toggle()
                combinedViewModel.colorListViewModel.toggleSelection(colorEntity: color)
            }
    }
}

#Preview {
    ListCellView(
        combinedViewModel: CombinedViewModel(),
        isSelected: false,
        colorTitle: .constant(""),
        color: .constant(ColorEntity())
    )
}
