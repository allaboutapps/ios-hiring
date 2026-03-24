import Foundation

struct Ingredient: Identifiable {
    let name: String
    let id: UUID
}

extension Ingredient {
    static let mockData = [
        Ingredient(name: "Tomato", id: UUID()),
        Ingredient(name: "Potato", id: UUID()),
        Ingredient(name: "Cheese", id: UUID()),
    ]
}
