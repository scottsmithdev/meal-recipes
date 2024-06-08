//  © 2024 | @scottsmithdev | ReceipeScreen+ViewModel.swift

import Foundation

extension RecipeScreen {
    
    @Observable
    class ViewModel {
        
        enum DataState {
            case readyForRequest
            case loading
            case success(Recipe)
            case failure(message: String)
        }
        
        private(set) var state = DataState.readyForRequest
        
        private let modelProvider: MealsModelProviding
        
        init(modelProvider: MealsModelProviding = MealsModelProvider()) {
            self.modelProvider = modelProvider
        }
        
        func load(mealID: String) {
            Task {
                state = .loading
                if let result = await modelProvider.fetchRecipe(forID: mealID) {
                    state = .success(result)
                } else {
                    state = .failure(message: "We couldn't load the recipe.")
                }
            }
        }
    }
}
