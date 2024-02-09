//
//  SwiftUITestView.swift
//  Le Baluchon
//
//  Created by Maxime Point on 09/02/2024.
//

import SwiftUI

struct SwiftUITestView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: SwiftUIViewViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.title)
                .font(.title)
            Button("Dismiss") {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .onAppear {
            viewModel.fetchTitle()
        }
        .navigationTitle("SwiftUI")
        
    }
}

#Preview {
    SwiftUITestView(viewModel: SwiftUIViewViewModel())
}
