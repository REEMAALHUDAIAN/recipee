# Recipe App 🍲📱

 Overview
Welcome to the Recipe App! This is an iOS app built with the magic of SwiftUI. It lets you create, view, edit, and delete all your favorite recipes (with images and ingredients, of course). Whether you're a master chef or a beginner in the kitchen, this app is designed to make your recipe management super easy and fun! Plus, it's all powered by the MVVM (Model-View-ViewModel) design pattern to keep things neat and organized.

 Features ✨
- **Add Recipes**: Got a new culinary masterpiece in mind? Add it by providing a title, description, ingredients, and even a mouth-watering image!
- **Edit Recipes**: Made a mistake or want to add a new twist? No problem! Edit existing recipes anytime.
- **Delete Recipes**: Say goodbye to those not-so-great recipes and keep only the ones you love.
- **Ingredient Management**: Add, edit, or remove ingredients with just a few taps.
- **Image Picker**: Make your recipes shine by adding pictures from your photo library!

 Project Structure 🏗️
The app is organized into SwiftUI files and view models, making it easy to understand and maintain:

1. Models
   - `Recipe`: Represents your delicious creations with properties like name, description, ingredients, and image.
   - `Ingredient`: Represents each ingredient with details like name, amount, and measurement.

2. Views
   - `ContentView`: The main view where all your recipes are listed.
   - `RecipeDetailView`: Get all the details of each recipe here, and make edits or delete them if needed.
   - `NewRecipeView`: A form to create a brand new recipe or update an existing one.
   - `IngredientPopup`: A fun pop-up for adding new ingredients.
   - `IngredientEditPopup`: A form to edit existing ingredients.
   - `ImagePicker`: Helps you pick the perfect picture to go with your recipe.

3. ViewModels
   - `NewRecipeViewModel`: Takes care of all the actions related to creating or editing recipes, including selecting images and adding ingredients.
   - `RecipeStore`: Your recipe library! Manages adding, editing, and deleting your recipes.

 Getting Started 🚀
Want to run the Recipe App locally? Here’s how:

1. Clone the Repository
   ```sh
   git clone <repository-url>
   cd RecipeApp
   ```

2. Open in Xcode
   - Open the `RecipeApp.xcodeproj` file using Xcode.

3. Run the Application
   - Make sure your simulator or connected device is ready.
   - Hit the `Run` button (or press `Cmd + R`) and watch the magic happen!

 Dependencies 📦
- **SwiftUI**: The whole app is built with SwiftUI, making it modern, fast, and fun to use.
- **UIKit**: Some features, like the `ImagePicker`, use `UIKit` for that classic touch.

 Usage 🍴
- **Add Recipe**: Tap the `+` button in the top-right corner to add a new recipe. Fill in all the details and hit `Save`!
- **Search Recipes**: Use the search bar to find a specific recipe. No more digging through endless lists!
- **Edit/Delete Recipe**: Tap on a recipe to see all the details, then use the `Edit` or `Delete` buttons to make changes.
- **Add Ingredients**: While creating or editing a recipe, tap the `Add Ingredient` button to include all the ingredients you need.

 Known Issues 🐛
- Currently, the image picker only supports accessing your photo library.
- Once you delete a recipe, it's gone for good (no undo option yet!).

 Contributing 🤝
We’d love to have you contribute! Fork the repository, make your improvements, and submit a pull request. Just make sure your code follows our standards and includes tests so we can keep everything tidy.

 License 📜
This project is licensed under the MIT License. See the `LICENSE` file for more details.

 Contact 📧
Have questions, suggestions, or just want to say hi? Reach out at [Your Name/Email].

Happy cooking and coding! 🍳👨‍🍳👩‍🍳

