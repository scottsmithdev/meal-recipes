//  © 2024 | @scottsmithdev | RetryView.swift

import SwiftUI

struct RetryView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text(message)
                .font(.headline)
            
            Button(action: retryAction,
                   label: {
                
                Text("Try again")
                    .padding()
                    .foregroundStyle(.background)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [.mint, .blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
            })
        }
    }
}

#Preview {
    RetryView(message: "Hi there, hello!", retryAction: {})
}
