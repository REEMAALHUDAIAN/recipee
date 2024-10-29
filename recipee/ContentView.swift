//
//  ContentView.swift
//  recipee
//
//  Created by Reema ALhudaian on 24/04/1446 AH.
//
import SwiftUI

struct ContentView: View {
    @StateObject var recipeStore = RecipeStore()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Show the Search Bar only if there are recipes
                if !recipeStore.recipes.isEmpty {
                    SearchBar(text: $searchText)
                        .padding()
                }
                
                // Recipe List
                if !recipeStore.recipes.isEmpty {
                    List(filteredRecipes) { recipe in
                        // Pass recipeStore to RecipeDetailView
                        NavigationLink(destination: RecipeDetailView(viewModel: NewRecipeViewModel(recipeStore: recipeStore, recipe: recipe), recipeStore: recipeStore, recipe: recipe)) {
                            VStack(alignment: .leading, spacing: 0) {
                                ZStack(alignment: .bottomLeading) {
                                    if let recipeImage = recipe.image {
                                        Image(uiImage: recipeImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 414, height: 272)
                                            .clipped()
                                            .cornerRadius(8)
                                        
                                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.5), Color.clear]),
                                                       startPoint: .bottom,
                                                       endPoint: .top)
                                            .frame(width: 414, height: 272)
                                        
                                        Text(recipe.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(Color.black.opacity(0.5))
                                            .cornerRadius(5)
                                            .padding(.bottom, 0)
                                            .padding(.horizontal, 10)
                                    }
                                }
                                
                                if let description = recipe.description {
                                    Text(description)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                        .padding(.top, 5)
                                        .padding(.horizontal, 10)
                                    
                                    Text("See all")
                                        .font(.footnote)
                                        .foregroundColor(.blue)
                                        .padding(.top, 2)
                                        .padding(.horizontal, 10)
                                }
                            }
                            .padding(.vertical, 0)
                        }
                    }
                } else {
                    noRecipesView
                }
            }
            .navigationTitle("Food Recipes")
            .navigationBarItems(trailing: addButton)
        }
    }

    private var noRecipesView: some View {
        VStack(spacing: 10) {
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 274))
                .foregroundColor(.orange)
            Text("There’s no recipe yet")
                .font(.title2)
                .foregroundColor(.primary)
            Text("Please add your recipes")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }

    private var addButton: some View {
        NavigationLink(
            destination: NewRecipeView(
                viewModel: NewRecipeViewModel(recipeStore: recipeStore, recipe: Recipe(name: "")),
                isEditing: false // Set to false for adding a new recipe
            )
        ) {

            Image(systemName: "plus")
                .font(.system(size: 25))
                .foregroundColor(.orange)
                .opacity(1)
        }
    }
    private var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return recipeStore.recipes
        } else {
            return recipeStore.recipes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

// Custom Search Bar
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search Recipes", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        if !text.isEmpty {
                            Button(action: {
                                text = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
        }
        .padding(.horizontal)
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
