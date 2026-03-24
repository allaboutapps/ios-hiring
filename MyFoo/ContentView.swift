import ComposableArchitecture
import SwiftUI

struct CreateRecipeScreen: View {
    @Bindable
    var store = StoreOf<CreateRecipeFeature>(initialState: CreateRecipeFeature.State(ingredients: Ingredient.mockData)) {
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
        }
    }
}

#Preview {
    CreateRecipeScreen()
}

@Reducer
struct CreateRecipeFeature: Reducer, Sendable {

    @ObservableState
    struct State {
        var name: String = ""
        var ingredients: [Ingredient] = []
    }

    enum Action: ViewAction, Sendable {
        case view(View)

        @CasePathable
        enum View: BindableAction, Sendable {
            case binding(BindingAction<State>)
        }
    }

    var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        Reduce { _, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .binding:
                    break
                }
            }
            return .none
        }
    }
}
