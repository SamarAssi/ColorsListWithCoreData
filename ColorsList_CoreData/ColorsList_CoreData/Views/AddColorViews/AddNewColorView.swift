//
//  AddNewColorView.swift
//  ColorsList_CoreData
//
//  Created by Samar Assi on 26/03/2024.
//

import SwiftUI

struct AddNewColorView: View {
    
    // MARK: Properties
    
    @EnvironmentObject var combinedViewModel: CombinedViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var isEnabledButton: Bool {
        return !combinedViewModel.isEmptyFields()
    }
    
    // MARK: Body property
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 25) {
                colorTitleView
                colorPickerView
                colorDescriptionView
                Spacer()
                actionButtonView
            }
            .navigationTitle(combinedViewModel.colorEntity == nil ? "New Color" : "Change a Color")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button {
                        dismissView()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(Color.gray)
                    }
            )
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            combinedViewModel.setFieldsValues()
        }
    }
}

extension AddNewColorView {
    
    // MARK: Color Title
    
    var colorTitleView: some View {
        VStack(alignment: .leading) {
            Text("Title")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading)
            
            colorTitleFieldView
        }
    }
    
    var colorTitleFieldView: some View {
        TextFieldView(
            placeholder: "Color Title",
            text:
                combinedViewModel.colorEntity == nil ? $combinedViewModel.colorTitle : Binding<String> (
                    get: { combinedViewModel.colorEntity?.colorTitle ?? "" },
                    set: { newValue in
                        guard let entity = combinedViewModel.colorEntity else { return }
                        entity.colorTitle = newValue
                        combinedViewModel.colorTitle = newValue
                    }
                )
        )
    }
    
    // MARK: Color Picker
    
    var colorPickerView: some View {
        HStack {
            Text("Select Color")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading)
            Spacer()
            colorPicker
        }
    }
    
    var colorPicker: some View {
        ColorPicker(
            "Color",
            selection:
                combinedViewModel.colorEntity == nil ? $combinedViewModel.color : Binding<Color> (
                    get: {
                        Color(
                            red: combinedViewModel.colorEntity?.redValue ?? 0.0,
                            green: combinedViewModel.colorEntity?.greenValue ?? 0.0,
                            blue: combinedViewModel.colorEntity?.blueValue ?? 0.0,
                            opacity: combinedViewModel.colorEntity?.alphaValue ?? 1.0
                        )
                    },
                    set: { newValue in
                        guard let entity = combinedViewModel.colorEntity else { return }
                        entity.redValue = newValue.components.red
                        entity.greenValue = newValue.components.green
                        entity.blueValue = newValue.components.blue
                        entity.alphaValue = newValue.components.alpha
                        combinedViewModel.color = newValue
                    }
                )
        )
        .labelsHidden()
    }
    
    // MARK: Color Description
    
    var colorDescriptionView: some View {
        VStack(alignment: .leading) {
            Text("Description")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading)
            
            colorDescriptionEditorView
        }
    }
    
    var colorDescriptionEditorView: some View {
        TextEditor(text:
                    combinedViewModel.colorEntity == nil ? $combinedViewModel.colorDescription : Binding<String> (
                        get: { combinedViewModel.colorEntity?.colorDescription ?? "" },
                        set: { newValue in
                            guard let entity = combinedViewModel.colorEntity else { return }
                            entity.colorDescription = newValue
                            combinedViewModel.colorDescription = newValue
                        }
                    )
        )
        .padding()
        .frame(height: 200, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 25.0)
                .stroke(lineWidth: 2)
                .foregroundColor(Color("Silver"))
        )
    }
    
    // MARK: Button
    
    var actionButtonView: some View {
        Button {
            actionButton()
        } label: {
            Text(combinedViewModel.colorEntity == nil ? "Add" : "Change")
                .padding()
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .fontWeight(.bold)
                .font(.headline)
                .background(isEnabledButton ? Color.black : Color("Tungsten"))
                .foregroundStyle(Color.white)
                .cornerRadius(25)
        }
        .disabled(!isEnabledButton)
    }
    
    func actionButton() {
        combinedViewModel.processColorEntity()
        combinedViewModel.updateColorValuesBasedOnChanges()
        dismissView()
        combinedViewModel.isEditing = false
    }
    
    func dismissView() {
        presentationMode.wrappedValue.dismiss()
        combinedViewModel.clearColorEntity()
    }
}

#Preview {
    AddNewColorView()
        .environmentObject(CombinedViewModel())
}
