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

import SwiftUI

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
                            .frame(height: 130) // Fixed height for the image picker
                    }
                    
                    Section(header: Text("Title")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .lineLimit(6)) {
                        TextField("Title", text: $viewModel.recipe.name)
                            .disabled(isEditing) // Disable title editing if in edit mode
                            .padding(.vertical, 10)
                            .frame(height: 50) // Fixed height for title input
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
                        .frame(height: 100) // Fixed height for text editor
                        .disabled(isEditing) // Disable description editing if in edit mode
                        .padding(.vertical, 10)
                    }
                    
                    Section(header: HStack {
                        Text("Add Ingredient")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                            .lineLimit(6)
                        
                        Spacer() // Push the button to the right

                        Button(action: {
                            viewModel.isShowingIngredientPopup = true // Show the popup
                        }) {
                            Image(systemName: "plus.circle") // Use only the system image
                                .foregroundColor(.blue) // Change the button color
                                .font(.title) // Optionally adjust the size of the icon
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
                        viewModel.recipe.ingredients.append(ingredient) // Add ingredient to the list
                        viewModel.isShowingIngredientPopup = false // Dismiss the popup
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
                self.presentationMode.wrappedValue.dismiss() // Return to previous view after saving
            }
        }
        .foregroundColor(Color(red: 0.985, green: 0.379, blue: 0.072)) // Color for the Save button
    }

    private var imagePickerButton: some View {
        Button(action: {
            viewModel.isImagePickerPresented = true
        }) {
            if let selectedImage = viewModel.recipe.image {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 413, height: 181) // Fixed dimensions for the selected image
                    .cornerRadius(10) // Rounded corners
                    .padding()
            } else {
                VStack {
                    Image(systemName: "photo.on.rectangle.angled")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.orange)
                    Text("Upload Photo")
                        .foregroundColor(Color(red: 251/255, green: 97/255, blue: 18/255)) // Desired color
                        .font(.system(size: 30, weight: .regular)) // Font size and weight
                        .opacity(1) // Opacity
                        .multilineTextAlignment(.center) // Center text alignment
                }
                .frame(width: 413, height: 181) // Fixed dimensions for the upload image
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10) // Rounded corners
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

            // Custom Picker with background color
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.orange.opacity(0.2)) // Background color for the picker

                Picker("Measurement", selection: $selectedMeasurement) {
                    ForEach(["Cup 🥛", "Spoon 🥄"], id: \.self) { measurement in
                        Text(measurement)
                            .foregroundColor(selectedMeasurement == measurement ? .orange : .primary) // Change text color based on selection
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(10) // Padding for the picker
            }

            HStack {
                // Minus button
                Button(action: {
                    if amount > 1 {
                        amount -= 1
                    }
                }) {
                    Text("-")
                        .font(.largeTitle)
                        .frame(width: 40, height: 40) // Button size
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                }

                // Display the amount
                Text("\(amount, specifier: "%.0f")")
                    .frame(width: 40, alignment: .center) // Fixed width for alignment
                
                // Plus button
                Button(action: {
                    if amount < 10 { // Assuming maximum is 10
                        amount += 1
                    }
                }) {
                    Text("+")
                        .font(.largeTitle)
                        .frame(width: 40, height: 40) // Button size
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                }

                // Measurement label
                Text(selectedMeasurement) // Measurement label
                    .padding(.leading, 10) // Optional padding for better spacing
            }
            
            HStack(spacing: 20) { // Add spacing between buttons
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .frame(width: 134, height: 36) // Set width and height
                        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.878)) // Background color for the Cancel button
                        .foregroundColor(.orange) // Text color
                        .cornerRadius(5) // Rounded corners
                        .padding(.leading, 10) // Optional padding
                }

                Button(action: {
                    let newIngredient = Ingredient(name: ingredientName, amount: amount, measurement: selectedMeasurement)
                    onAddIngredient(newIngredient)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add")
                        .frame(width: 134, height: 36) // Set width and height
                        .background(Color.orange) // Background color for the Add button
                        .foregroundColor(.white) // Text color
                        .cornerRadius(5) // Rounded corners
                        .padding(.trailing, 10) // Optional padding
                }
            }
            .padding(.top, 20) // Optional padding at the top for spacing
        }
        .padding()
        .frame(width: 306, height: 382) // Set the desired width and height
        .background(Color.white) // Optional: Set a background color for the popup
        .cornerRadius(10) // Optional: Add corner radius for rounded edges
        .shadow(radius: 10) // Optional: Add shadow for better visibility
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
