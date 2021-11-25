//
//  LoginViewModel.swift
//  LoginScreen
//
//  Created by Sacha Behrend on 02/11/2021.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    
    // Link to the user in the model.
    // @Published var user(email: "", password, "")
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var emailPlaceholder: String = "Mailadresse"
    @Published var passwordPlaceholder: String = "Adgangskode"
    @Published var editing = false
        
    
}
