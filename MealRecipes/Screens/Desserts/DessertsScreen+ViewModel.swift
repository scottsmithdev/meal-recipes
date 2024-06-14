//  © 2024 | @scottsmithdev | DessertsScreen+ViewModel.swift

import Foundation

extension DessertsScreen {
    
    @Observable
    @MainActor
    class ViewModel {
        
        enum DataState {
            case readyForRequest
            case loading
            case success([Meal])
            case failure(message: String)
        }
        
        private(set) var state = DataState.readyForRequest
        
        private let modelProvider: MealsModelProviding
        
        init(modelProvider: MealsModelProviding = MealsModelProvider()) {
            self.modelProvider = modelProvider
        }
        
        func load() {
            Task {
                state = .loading
                if let result = await modelProvider.fetchAllDesserts() {
                    state = .success(result)
                } else {
                    state = .failure(message: "We couldn't load the desserts.")
                }
            }
        }
    }
}

