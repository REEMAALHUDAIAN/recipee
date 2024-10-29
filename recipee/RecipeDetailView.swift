//
//  RecipeDetailView.swift
//  recipee
//
//  Created by Reema ALhudaian on 25/04/1446 AH.
//
import SwiftUI

struct RecipeDetailView: View {
    @ObservedObject var viewModel: NewRecipeViewModel
    @ObservedObject var recipeStore: RecipeStore
    @Environment(\.presentationMode) var presentationMode
    var recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Display the selected recipe image if available
                if let image = viewModel.recipe.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 414, height: 181)
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, Color.black.opacity(0.6)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                } else {
                    // Placeholder image if no image is selected
                    Image(systemName: "photo.on.rectangle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 414, height: 181)
                        .foregroundColor(.gray)
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, Color.black.opacity(0.6)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }

                // Edit Button
                HStack {
                    Spacer() // Push the button to the right
                    NavigationLink(
                        destination: NewRecipeView(
                            viewModel: viewModel,
                            isEditing: true // Enable editing mode
                        )
                    ) {
                        Text("Edit")
                            .font(.system(size: 17, weight: .bold)) // Bold font
                            .foregroundColor(Color(red: 0.988, green: 0.397, blue: 0.094)) // Set text color
                    }
                    .padding(.trailing, 40)
                }
                .padding(.top, -200) // Adjust top padding to move it up above the photo

                // Recipe Title
                Text(viewModel.recipe.name)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(Color.black)
                    .padding(.top, 10)
                    .padding(.leading, 16)

                // Recipe Description
                if let description = viewModel.recipe.description {
                    Text(description)
                        .font(.subheadline)
                        .padding(.top, 5)
                        .padding(.leading, 16)
                }

                // Ingredients Section
                Text("Ingredients")
                    .font(.headline)
                    .padding(.top, 10)
                    .padding(.leading, 16)

                ForEach(viewModel.recipe.ingredients) { ingredient in
                    HStack {
                        // Rectangle for the ingredient background
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 358, height: 52)
                            .cornerRadius(8) // Rounded corners
                            .shadow(radius: 2) // Optional shadow for depth
                            .overlay(
                                HStack {
                                    // Quantity Text
                                    Text("\(ingredient.amount, specifier: "%.0f")") // Assuming amount is an Int or can be formatted
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color(red: 252/255, green: 101/255, blue: 24/255)) // #FC6518
                                        .frame(width: 12, height: 24)
                                        .padding(.leading, 10)

                                    // Ingredient Name Text
                                    Text(ingredient.name.uppercased())
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color(red: 252/255, green: 101/255, blue: 24/255)) // #FC6518
                                        .frame(maxWidth: .infinity, alignment: .leading) // Align left
                                        .padding(.leading, 10)

                                    // Measurement Box
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.gray.opacity(0.2)) // Change to desired color
                                        .frame(width: 90, height: 29)
                                        .overlay(
                                            HStack {
                                                Text(ingredient.measurement) // Measurement text
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.black)
                                            }
                                        )
                                        .padding(.trailing, 10) // Add some space from the right edge
                                }
                                .padding(.vertical, 10) // Center the content vertically
                            )
                    }
                    .padding(.horizontal, 16)
                }

                // Spacer to center the Delete Button vertically
                Spacer()
                
                // Delete Button
                HStack {
                    Spacer()
                    Button("Delete Recipe") {
                        deleteRecipe()
                    }
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(Color(red: 0.988, green: 0.397, blue: 0.094))
                    .padding()
                    .frame(width: 387, height: 52) // Set specific dimensions
                    .background(Color(hue: 1.0, saturation: 0.041, brightness: 0.918)) // Set background color
                    .cornerRadius(8)
                    Spacer() // Push button to center
                }
                .padding(.top, 200) // Adjust top padding for spacing
                .padding(.horizontal, 16) // Align with other elements
            }
            .padding(.bottom, 20) // Add padding to the bottom of the VStack
        }
    }

    private func deleteRecipe() {
        recipeStore.deleteRecipe(recipe)
    }
}

// Preview for RecipeDetailView
struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleRecipe = Recipe(
            name: "HALOMI SALAD",
            description: "A refreshing and delicious salad perfect for any meal.",
            ingredients: [
                Ingredient(name: "Ingredient 1", amount: 2, measurement: "cups"),
                Ingredient(name: "Ingredient 2", amount: 1.5, measurement: "tbsp")
            ]
        )
        let exampleViewModel = NewRecipeViewModel(recipeStore: RecipeStore(), recipe: exampleRecipe)
        
        RecipeDetailView(viewModel: exampleViewModel, recipeStore: RecipeStore(), recipe: exampleRecipe)
    }
}
