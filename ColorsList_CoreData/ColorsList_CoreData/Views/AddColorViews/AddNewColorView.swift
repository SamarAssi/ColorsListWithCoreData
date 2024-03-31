//
//  AddNewColorView.swift
//  ColorsList_CoreData
//
//  Created by Samar Assi on 26/03/2024.
//

import SwiftUI

struct AddNewColorView: View {
    // MARK: Properties
    @ObservedObject var combinedViewModel: CombinedViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var colorEntity: ColorEntity?
    
    // MARK: Body property
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 25) {
                colorTitleFieldView
                colorPickerView
                colorDescriptionView
                Spacer()
                actionButtonView
            }
            .navigationTitle(colorEntity == nil ? "New Color" : "Change a Color")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        combinedViewModel.addColorViewModel.setDefaultInput()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(Color.gray)
                    }
            )
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .navigationBarBackButtonHidden(true)
    }
}

extension AddNewColorView {
    // MARK: ColorTitleFieldView
    var colorTitleFieldView: some View {
        VStack(alignment: .leading) {
            Text("Title")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading)
            
            TextFieldView(
                placeholder: "Color Title",
                height: 55,
                text:
                    colorEntity == nil ? $combinedViewModel.addColorViewModel.colorTitle : Binding<String> (
                        get: { colorEntity?.colorTitle ?? "" },
                        set: { newValue in
                            guard let entity = colorEntity else { return }
                            entity.colorTitle = newValue
                        }
                    )
            )
        }
    }
    
    // MARK: colorPickerView
    var colorPickerView: some View {
        HStack {
            Text("Select Color")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading)
            Spacer()
            ColorPicker(
                "Color",
                selection: 
                    colorEntity == nil ? $combinedViewModel.addColorViewModel.color : Binding<Color> (
                        get: {
                            Color(
                                red: colorEntity?.redValue ?? 0.0,
                                green: colorEntity?.greenValue ?? 0.0,
                                blue: colorEntity?.blueValue ?? 0.0,
                                opacity: colorEntity?.alphaValue ?? 1.0
                            )
                        },
                        set: { newValue in
                            guard let entity = colorEntity else { return }
                            entity.redValue = newValue.components.red
                            entity.greenValue = newValue.components.green
                            entity.blueValue = newValue.components.blue
                            entity.alphaValue = newValue.components.alpha
                        }
                    )
            )
                .labelsHidden()
        }
    }
    
    // MARK: ColorDescriptionView
    var colorDescriptionView: some View {
        VStack(alignment: .leading) {
            Text("Description")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading)
            
            TextFieldView(
                placeholder: "",
                height: 200,
                text:
                    colorEntity == nil ? $combinedViewModel.addColorViewModel.colorDescription : Binding<String> (
                        get: { colorEntity?.colorDescription ?? "" },
                        set: { newValue in
                            guard let entity = colorEntity else { return }
                            entity.colorDescription = newValue
                        }
                    )
            )
        }
    }
    
    // MARK: ActionButtonView
    var actionButtonView: some View {
        Button {
            actionButton()
        } label: {
            Text(colorEntity == nil ? "Add" : "Change")
                .padding()
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .fontWeight(.bold)
                .font(.headline)
                .background(Color.black)
                .foregroundStyle(Color.white)
                .cornerRadius(25)
        }
    }
    
    // MARK: ActionButton function
    func actionButton() {
        combinedViewModel.addColorViewModel.processColorEntity(colorEntity: colorEntity)
        combinedViewModel.updateColorValuesBasedOnChanges()
        presentationMode.wrappedValue.dismiss()
        combinedViewModel.addColorViewModel.setDefaultInput()
        combinedViewModel.isEditing = false
    }
}

#Preview {
    AddNewColorView(
        combinedViewModel: CombinedViewModel(),
        colorEntity: .constant(nil)
    )
}
