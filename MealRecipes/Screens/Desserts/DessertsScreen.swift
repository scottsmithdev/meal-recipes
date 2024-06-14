//  © 2024 | @scottsmithdev | DessertsScreen.swift

import SwiftUI

@MainActor
struct DessertsScreen: View {

    @State private var viewModel = ViewModel()

    var body: some View {
        NavigationStack {
            contentView
                .navigationBarTitleDisplayMode(.large)
                .navigationTitle("Desserts")
        }
        .tint(.black)
        .onAppear(perform: viewModel.load)
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .readyForRequest, .loading:
            ProgressView()

        case .success(let desserts):
            successView(desserts: desserts)

        case .failure(let message):
            RetryView(message: message, 
                      retryAction: viewModel.load)
        }
    }
    
    private func successView(desserts: [Meal]) -> some View {
        List(desserts) { item in
            NavigationLink(item.name,
                           destination: RecipeScreen(mealID: item.id))
        }
    }
}

#Preview {
    DessertsScreen()
}
