//  © 2024 | @scottsmithdev | RecipeScreen.swift

import SwiftUI

@MainActor
struct RecipeScreen: View {
    @State private var viewModel = ViewModel()
    
    let mealID: String
        
    var body: some View {
        contentView
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .onAppear { viewModel.load(mealID: mealID) }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .readyForRequest, .loading:
            ProgressView()
            
        case .success(let receipe):
            successView(receipe: receipe)
            
        case .failure(let message):
            RetryView(message: message, 
                      retryAction: { viewModel.load(mealID: mealID) })
        }
    }
    
    private func successView(receipe: Recipe) -> some View {
        List {
            Section {
                sectionTitleView(title: "Ingredients")
                
                ForEach(receipe.ingredients) { item in
                    Text("• \(item.name.localizedCapitalized) (\(Text(item.measurement).font(.callout.italic())))")
                }
                
            }
            .listRowSeparator(.hidden)
            
            Section {
                sectionTitleView(title: "Instructions")
                
                Text(receipe.instructions)
                
            }
            .listRowSeparator(.hidden)
        }
        .contentMargins(.vertical, .zero, for: .scrollContent)
        .listSectionSpacing(20)
        .scrollBounceBehavior(.basedOnSize)
        .safeAreaInset(edge: .top) {
            VStack(alignment: .leading, spacing: 0) {
                Text(receipe.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title.bold())
                
                Text("\(receipe.ingredients.count) ingredients")
                    .font(.headline.bold())
                    .padding(.bottom, 8)
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
            .background(
                LinearGradient(
                    colors: [.mint, .blue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
    }
    
    private func sectionTitleView(title: String) -> some View {
        Text(title)
            .font(.title3.bold())
    }
}

#Preview {
    RecipeScreen(mealID: "52787")
}


