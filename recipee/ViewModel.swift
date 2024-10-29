//
//  ViewModel.swift
//  recipee
//
//  Created by Reema ALhudaian on 25/04/1446 AH.
//

import Foundation
import Combine
import SwiftUI

//class NewRecipeViewModel: ObservableObject {
//    @Published var recipe: Recipe
//    var recipeStore: RecipeStore
//
//    init(recipeStore: RecipeStore, recipe: Recipe) {
//        self.recipeStore = recipeStore
//        self.recipe = recipe
//    }
//
//
//}



class NewRecipeViewModel: ObservableObject {
    @Published var recipe: Recipe
    @Published var isShowingIngredientPopup = false
    @Published var isImagePickerPresented = false
    private var recipeStore: RecipeStore

    init(recipeStore: RecipeStore, recipe: Recipe) {
        self.recipeStore = recipeStore
        self.recipe = recipe
    }

    func saveRecipe(completion: @escaping () -> Void) {
        // Add recipe to the store or update existing recipe
        if let index = recipeStore.recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipeStore.recipes[index] = recipe // Update existing recipe
        } else {
            recipeStore.recipes.append(recipe) // Add new recipe
        }
        completion() // Call the completion handler after saving
    }

    func editRecipe(completion: @escaping () -> Void) {
        recipeStore.editRecipe(recipe)
        completion()
    }
    func deleteRecipe(completion: @escaping () -> Void) {
           // Logic to delete the recipe from your data source
           // For example, remove from a list, database, etc.

           // Call the completion handler after deletion
           completion()
       }
}

class RecipeStore: ObservableObject {
    @Published var recipes: [Recipe] = []

    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
    }

    func editRecipe(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index] = recipe
        }
    }
    func deleteRecipe(_ recipe: Recipe) {
           if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
               recipes.remove(at: index)
           }
       }
}



struct IngredientEditPopup: View {
    @Binding var ingredient: Ingredient
    var onSave: () -> Void

    var body: some View {
        Form {
            Section(header: Text("Edit Ingredient")) {
                TextField("Ingredient Name", text: $ingredient.name)
                TextField("Amount", value: $ingredient.amount, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                TextField("Measurement", text: $ingredient.measurement)
            }
            Button("Save") {
                onSave() // Call the save closure
            }
        }
    }
}





