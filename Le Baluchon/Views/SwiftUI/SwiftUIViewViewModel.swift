//
//  SwiftUIViewViewModel.swift
//  Le Baluchon
//
//  Created by Maxime Point on 09/02/2024.
//

import Foundation

class SwiftUIViewViewModel: ObservableObject {
    
    @Published var title: String = ""
    
    func fetchTitle() {
        title = "Hello, SwiftUI !!! :)"
    }
    
}
