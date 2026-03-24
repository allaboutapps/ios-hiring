import Foundation

struct Ingredient: Identifiable, Comparable, Hashable {
    let name: String
    let isVegan: Bool
    let id: UUID
    
    static func < (lhs: Ingredient, rhs: Ingredient) -> Bool {
            return lhs.name < rhs.name
    }
}

extension Ingredient {
    static let mockData = [
        Ingredient(name: "Tomato", isVegan: true, id: UUID()),
        Ingredient(name: "Potato", isVegan: true, id: UUID()),
        Ingredient(name: "Cheese", isVegan: false, id: UUID()),
    ]
}
