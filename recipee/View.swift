//
//  View.swift
//  recipee
//
//  Created by Reema ALhudaian on 25/04/1446 AH.
//

import SwiftUI
import PhotosUI
import UIKit

// MARK: - ImagePicker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage // Update the binding
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

// MARK: - NewRecipeView

//import SwiftUI

//import SwiftUI
//
//import SwiftUI

//struct NewRecipeView: View import SwiftUI

struct NewRecipeView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: NewRecipeViewModel
    var isEditing: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Form {
                    Section {
                        imagePickerButton
                            .frame(height: 130)
                    }
                    
                    Section(header: Text("Title")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .lineLimit(6)) {
                        TextField("Title", text: $viewModel.recipe.name)
                            .padding(.vertical, 10)
                            .frame(height: 50)
                    }
                    
                    Section(header: Text("Description")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .lineLimit(6)) {
                        TextEditor(text: Binding(
                            get: { viewModel.recipe.description ?? "" },
                            set: { viewModel.recipe.description = $0.isEmpty ? nil : $0 }
                        ))
                        .frame(height: 100)
                        .padding(.vertical, 10)
                    }
                    
                    Section(header: HStack {
                        Text("Add Ingredient")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                            .lineLimit(6)
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.isShowingIngredientPopup = true
                        }) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.blue)
                                .font(.title)
                        }
                    }) {
                        ForEach(viewModel.recipe.ingredients) { ingredient in
                            HStack {
                                Text(ingredient.name)
                                Spacer()
                                Text("\(ingredient.amount, specifier: "%.1f") \(ingredient.measurement)")
                            }
                        }
                    }
                }
                .navigationTitle(isEditing ? "Edit Recipe" : "New Recipe")
                .navigationBarItems(trailing: saveButton)
                .sheet(isPresented: $viewModel.isShowingIngredientPopup) {
                    IngredientPopup { ingredient in
                        viewModel.recipe.ingredients.append(ingredient)
                        viewModel.isShowingIngredientPopup = false
                    }
                }
                .sheet(isPresented: $viewModel.isImagePickerPresented) {
                    ImagePicker(image: $viewModel.recipe.image)
                }
            }
        }
    }

    private var saveButton: some View {
        Button("Save") {
            viewModel.saveRecipe {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .foregroundColor(Color(red: 0.985, green: 0.379, blue: 0.072))
    }

    private var imagePickerButton: some View {
        Button(action: {
            viewModel.isImagePickerPresented = true
        }) {
            if let selectedImage = viewModel.recipe.image {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 413, height: 181)
                    .cornerRadius(10)
                    .padding()
            } else {
                VStack {
                    Image(systemName: "photo.on.rectangle.angled")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.orange)
                    Text("Upload Photo")
                        .foregroundColor(Color(red: 251/255, green: 97/255, blue: 18/255))
                        .font(.system(size: 30, weight: .regular))
                        .opacity(1)
                        .multilineTextAlignment(.center)
                }
                .frame(width: 413, height: 181)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding()
            }
        }
    }
}


// MARK: - IngredientPopup
struct IngredientPopup: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var ingredientName: String = ""
    @State private var selectedMeasurement = "Cup"
    @State private var amount: Double = 1.0
    var onAddIngredient: (Ingredient) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Add Ingredient").font(.headline)
            TextField("Ingredient Name", text: $ingredientName)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.orange.opacity(0.2))

                Picker("Measurement", selection: $selectedMeasurement) {
                    ForEach(["Cup 🥛", "Spoon 🥄"], id: \.self) { measurement in
                        Text(measurement)
                            .foregroundColor(selectedMeasurement == measurement ? .orange : .primary)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(10)
            }

            HStack {
                Button(action: {
                    if amount > 1 {
                        amount -= 1
                    }
                }) {
                    Text("-")
                        .font(.largeTitle)
                        .frame(width: 40, height: 40)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                }

                Text("\(amount, specifier: "%.0f")")
                    .frame(width: 40, alignment: .center)
                
                Button(action: {
                    if amount < 10 {
                        amount += 1
                    }
                }) {
                    Text("+")
                        .font(.largeTitle)
                        .frame(width: 40, height: 40)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                }

                Text(selectedMeasurement)
                    .padding(.leading, 10)
            }
            
            HStack(spacing: 20) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .frame(width: 134, height: 36)
                        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.878))
                        .foregroundColor(.orange)
                        .cornerRadius(5)
                        .padding(.leading, 10)
                }

                Button(action: {
                    let newIngredient = Ingredient(name: ingredientName, amount: amount, measurement: selectedMeasurement)
                    onAddIngredient(newIngredient)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add")
                        .frame(width: 134, height: 36)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .padding(.trailing, 10)
                }
            }
            .padding(.top, 20)
        }
        .padding()
        .frame(width: 306, height: 382)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}










// MARK: - NewRecipeView_Previews
struct NewRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        let mockRecipeStore = RecipeStore()
        let recipe = Recipe(name: "New Recipe", ingredients: [])
        
        return NewRecipeView(viewModel: NewRecipeViewModel(recipeStore: mockRecipeStore, recipe: recipe), isEditing: false)
    }
}
