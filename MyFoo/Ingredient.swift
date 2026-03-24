import Foundation

struct Ingredient: Identifiable, Comparable {
    let name: String
    let id: UUID
    
    static func < (lhs: Ingredient, rhs: Ingredient) -> Bool {
            return lhs.name < rhs.name
    }
}

extension Ingredient {
    static let mockData = [
        Ingredient(name: "Tomato", id: UUID()),
        Ingredient(name: "Potato", id: UUID()),
        Ingredient(name: "Cheese", id: UUID()),
    ]
}
