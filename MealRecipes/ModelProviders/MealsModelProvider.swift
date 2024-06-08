//  © 2024 | @scottsmithdev | MealsModelProvider.swift

import Foundation

protocol MealsModelProviding {
    func fetchAllDesserts() async -> [Meal]?
    func fetchRecipe(forID id: String) async -> Recipe?
}

final class MealsModelProvider: MealsModelProviding {
    
    private struct MealsResponse: Decodable {
        let meals: [Meal]
    }
    
    private struct RecipesResponse: Decodable {
        let recipes: [Recipe]
        
        enum CodingKeys: String, CodingKey {
            case recipes = "meals"
        }
    }
    
    func fetchAllDesserts() async -> [Meal]? {
        let dessertsEndpoint = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
        let response = await fetch(type: MealsResponse.self, fromEndpoint: dessertsEndpoint)
        return response?.meals.sorted(by: { $0.name < $1.name })
    }
    
    func fetchRecipe(forID id: String) async -> Recipe? {
        let mealDeatilsEndpoint = "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)"
        let response = await fetch(type: RecipesResponse.self, fromEndpoint: mealDeatilsEndpoint)
        return response?.recipes.first
    }
    
    private func fetch<T: Decodable>(type: T.Type, fromEndpoint endpoint: String) async -> T? {
        guard
            let url = URL(string: endpoint)
        else {
            logError(description: "Invalid endpoint")
            return nil
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard
                let httpResponse = response as? HTTPURLResponse
            else {
                logError(description: "Failed to cast URLSession response to HTTPURLResponse")
                return nil
            }
            
            guard
                (200...299).contains(httpResponse.statusCode)
            else {
                logError(description: "Non success status code: \(httpResponse.statusCode)")
                return nil
            }
            
            return try JSONDecoder().decode(type, from: data)
            
        } catch {
            logError(description: "Caught error while fetching: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func logError(description: String) {
        // Send error through analytics service
    }
}
