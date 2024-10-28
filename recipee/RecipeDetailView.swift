import SwiftUI

struct RecipeDetailView: View {
    @ObservedObject var viewModel: NewRecipeViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Display the recipe photo
                if let image = viewModel.recipe.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 414, height: 181) // Photo dimensions
                }
                
                // Display the recipe title
                Text(viewModel.recipe.name)
                    .font(.title)
                    .padding(.top, 10)
                    .padding(.leading, 8)
                
                // Display the recipe description
                if let description = viewModel.recipe.description {
                    Text(description)
                        .font(.subheadline)
                        .padding(.top, 5)
                        .padding(.leading, 8)
                }
                
                // Ingredients section
                Text("Ingredients")
                    .font(.headline)
                    .padding(.top, 10)
                    .padding(.leading, 8)
                
                // Display user-entered ingredients
                ForEach(viewModel.recipe.ingredients) { ingredient in
                    HStack {
                        Text(ingredient.name)
                        Spacer()
                        Text("\(ingredient.amount, specifier: "%.1f") \(ingredient.measurement)")
                    }
                    .padding(.horizontal, 8)
                }
                
                // Edit button
                NavigationLink(destination: NewRecipeView(viewModel: viewModel, isEditing: true)) {
                    Text("Edit Recipe")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                        .padding(.leading, 8)
                }
                
                // Delete button
                Button(action: {
                    deleteRecipe()
                }) {
                    Text("Delete Recipe")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                        .padding(.leading, 8)
                }
            }
            .padding()
        }
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func deleteRecipe() {
        viewModel.deleteRecipe {
            // Completion handler to execute after deletion
            self.presentationMode.wrappedValue.dismiss() // Go back to ContentView after deleting
        }
    }
}
