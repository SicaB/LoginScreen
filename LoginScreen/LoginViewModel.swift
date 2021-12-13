//
//  LoginViewModel.swift
//  LoginScreen
//  Created by Sacha Behrend on 02/11/2021.
//

import SwiftUI
import LocalAuthentication

final class LoginViewModel: ObservableObject {
    
    // Link to the user in the model.
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var emailPlaceholder: String = "Mailadresse"
    @Published var passwordPlaceholder: String = "Adgangskode"
    
    @State private var faceIdIsUnlocked = false
    
    private let context = LAContext()
    private var error: NSError?
    
    func authenticate() {

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                DispatchQueue.main.async {
                    if success {
                        self.faceIdIsUnlocked = true
                    } else {
                        // there was a problem
                        // TODO: implement error
                    }
                }
            }
        } else {
            // no biometrics
        }
    }
    
    /// checks if face id is avaiable on device
    func faceIDAvailable() -> Bool {
        if #available(iOS 11.0, *) {
            let context = LAContext()
            return (context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: nil) && context.biometryType == .faceID)
        }
        return false
    }
    
    
}
