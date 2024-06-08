//  © 2024 | @scottsmithdev | Recipe.swift

import Foundation

struct Recipe: Decodable {
    
    struct Ingredient: Identifiable, Decodable {
        var id = UUID().uuidString
        let name: String
        let measurement: String
    }
    
    private enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case instructions = "strInstructions"
    }
    
    private struct CustomCodingKey: CodingKey {
        var stringValue: String
        var intValue: Int? { return nil }
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        init?(intValue: Int) {
            return nil
        }
    }

    let name: String
    let instructions: String
    let ingredients: [Ingredient]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        instructions = try container.decode(String.self, forKey: .instructions).replacingOccurrences(of: "\n", with: "\n\n")
        
        let customContainer = try decoder.container(keyedBy: CustomCodingKey.self)
        
        ingredients = (1...20).compactMap { index in
            guard
                let ingredientKey = CustomCodingKey(stringValue: "strIngredient\(index)"),
                let measurementKey = CustomCodingKey(stringValue: "strMeasure\(index)"),
                let ingredient = try? customContainer.decodeIfPresent(String.self, forKey: ingredientKey),
                !ingredient.isEmpty,
                let measurement = try? customContainer.decodeIfPresent(String.self, forKey: measurementKey),
                !measurement.isEmpty
            else {
                return nil
            }
    
            return Ingredient(name: ingredient, measurement: measurement)
        }
    }
}
