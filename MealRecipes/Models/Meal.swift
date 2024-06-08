//  © 2024 | @scottsmithdev | Meals.swift

import Foundation

struct Meal: Identifiable, Decodable {
    let id: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
    }
}
