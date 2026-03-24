import ComposableArchitecture
import SwiftUI
import Dependencies

@ViewAction(for: CreateRecipeFeature.self)
struct CreateRecipeScreen: View {
    @Bindable
    var store = StoreOf<CreateRecipeFeature>(initialState: CreateRecipeFeature.State()) {
        CreateRecipeFeature()
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField(text: $store.name) {
                    Text(.createRecipeNameLabel)
                }
                
                Section {
                    ForEach(store.ingredients.sorted()) { ingredient in
                        Text(ingredient.name)
                    }
                }
            }
            .navigationTitle(.createRecipeTitle)
            .onAppear { send(.onAppear) }
        }
    }
}

#Preview {
    CreateRecipeScreen()
}

@Reducer
struct CreateRecipeFeature: Reducer, Sendable {
    @Dependency(\.networking)
    var networking: Networking
    
    @ObservableState
    struct State {
        var name: String = ""
        var ingredients: [Ingredient] = []
    }

    enum Action: ViewAction, Sendable {
        case view(View)
        case receivedData([Ingredient])
        @CasePathable
        enum View: BindableAction, Sendable {
            case binding(BindingAction<State>)
            case onAppear
        }
    }

    var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .binding:
                    break
                case .onAppear:
                    return .run { send in
                        let fetchedIngredients = try? await networking.fetchAvailableIngredients()
                        await send(.receivedData(fetchedIngredients ?? []))
                    }
                }
            case .receivedData(let ingredients):
                state.ingredients = ingredients
            }
            return .none
        }
    }
}
