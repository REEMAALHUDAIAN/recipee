//
//  RecipeDetailView.swift
//  recipee
//
//  Created by Reema ALhudaian on 25/04/1446 AH.
//


import SwiftUI

struct RecipeDetailView: View {
    @ObservedObject var viewModel: NewRecipeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // عرض صورة الوصفة مع تدرج
                if let image = viewModel.recipe.image {
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 414, height: 272) // أبعاد الصورة
                            .clipped()
                            .cornerRadius(8) // إضافة انحناء حواف
                        
                        // تدرج خلفية
                        LinearGradient(gradient: Gradient(colors: [
                            Color.black.opacity(0),
                            Color.black
                        ]), startPoint: .top, endPoint: .bottom)
                        .frame(width: 414, height: 272)
                    }
                }

                // عرض عنوان الوصفة
                Text(viewModel.recipe.name)
                    .font(.custom("SFPro-Bold", size: 34)) // حجم الخط
                    .foregroundColor(Color.black) // لون الخط
                    .padding(.top, 20)
                    .padding(.leading, 16)

                // عرض وصف الوصفة
                if let description = viewModel.recipe.description {
                    Text(description)
                        .font(.subheadline)
                        .padding(.top, 5)
                        .padding(.leading, 16)
                }

                // قسم المكونات
                Text("المكونات")
                    .font(.headline)
                    .padding(.top, 10)
                    .padding(.leading, 16)
                
                // عرض المكونات المدخلة من قبل المستخدم
                ForEach(viewModel.recipe.ingredients) { ingredient in
                    HStack {
                        Text(ingredient.name)
                        Spacer()
                        Text("\(ingredient.amount, specifier: "%.1f") \(ingredient.measurement)")
                    }
                    .padding(.horizontal, 16)
                }
                
                // زر تعديل الوصفة
                NavigationLink(destination: NewRecipeView(viewModel: viewModel, isEditing: true)) {
                    Text("تعديل الوصفة")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                        .padding(.leading, 16)
                }

                // زر حذف الوصفة
                Button(action: {
                    deleteRecipe()
                }) {
                    Text("حذف الوصفة")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                        .padding(.leading, 16)
                }
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("تفاصيل الوصفة") // عنوان الصفحة
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func deleteRecipe() {
        viewModel.deleteRecipe {
            // إغلاق الصفحة بعد الحذف
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

// العرض المسبق
struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // نموذج لمعاينة
        let exampleRecipe = Recipe(
            name: "مثال على الوصفة",
            description: "هذا هو وصف المثال لوصفة معينة.",
            ingredients: [
                Ingredient(name: "مكون 1", amount: 2, measurement: "كوب"),
                Ingredient(name: "مكون 2", amount: 1.5, measurement: "ملعقة")
            ]
        )
        let exampleViewModel = NewRecipeViewModel(recipeStore: RecipeStore(), recipe: exampleRecipe)

        RecipeDetailView(viewModel: exampleViewModel)
    }
}
