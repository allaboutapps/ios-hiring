import ComposableArchitecture
import SwiftUI
import Dependencies

@ViewAction(for: CreateRecipeFeature.self)
struct CreateRecipeScreen: View {
    @Bindable
    var store = StoreOf<CreateRecipeFeature>(initialState: CreateRecipeFeature.State()) {
        CreateRecipeFeature()
    }
    @State private var selectedIngredient: Ingredient? = nil
    
    
    var body: some View {
        NavigationStack {
            Form {
                TextField(text: $store.name) {
                    Text(.createRecipeNameLabel)
                }
                
                Picker("Select your Ingredient", selection: $selectedIngredient) {
                    ForEach(store.ingredients.sorted()) { ingredient in
                        IngredientRow(ingredient: ingredient)
                            .tag(ingredient)
                    }
                }
                .pickerStyle(.inline)
            }
            .navigationTitle(.createRecipeTitle)
            .onAppear { send(.onAppear) }
        }
    }
}

struct IngredientRow: View {
    let ingredient: Ingredient
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(ingredient.name)
                .foregroundStyle(Color.black)
            Text(ingredient.isVegan ? "Is Vegan" : "Is not vegan")
                .foregroundStyle(Color.gray)
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
