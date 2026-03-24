import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
struct Networking: Sendable {
    var fetchAvailableIngredients: @Sendable () async throws -> [Ingredient] = { Ingredient.mockData }
}

extension DependencyValues {
    var networking: Networking {
        get { self[Networking.self] }
        set { self[Networking.self] = newValue }
    }
}

extension Networking: DependencyKey {
    public static let liveValue: Networking = {
        let manager = NetworkingManager()
        return .init {
            try await manager.fetchAvailableIngredients()
        }
    }()
}


private final class NetworkingManager: @unchecked Sendable {
    var usedIngredients: Set<Ingredient> = []
    
    func fetchAvailableIngredients() async throws -> [Ingredient] {
        let fetchedIngredients = Ingredient.mockData
        let unusedIngredients = fetchedIngredients.filter { !self.usedIngredients.contains($0) }
        self.usedIngredients.formUnion(unusedIngredients)
        return unusedIngredients
    }
}
