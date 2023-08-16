//
//  LoginViewModel.swift
//  Movies
//
//  Created by Cristian Chertes on 20.07.2023.
//

import Foundation
import Combine
import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn

class LoginViewModel: ObservableObject {
    @Published var uid: String? = nil
    @Published var photoURL: URL? = nil
    
    func login(username: String, password: String) {
        print("username: \(username), password: \(password)")
        Auth.auth().signIn(withEmail: username, password: password) { [weak self] authResult, error in
            print(authResult?.user.displayName)
            print(authResult?.user.uid)
            print(error)
            self?.uid = authResult?.user.uid
        }
    }
    
    func loginWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        guard let rootViewController = UIWindow.getTopMostViewController() else { return }
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] result, error in
            print("Login Completed")
            guard error == nil else {
                print("Error:\(error)")
                return
            }
            
            guard let user = result?.user,
                let idToken = user.idToken?.tokenString
            else {
                print("UserInfo not available")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                             accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { authResult, error in
                guard error == nil else {
                    print(error)
                    return
                }
                
                print(authResult?.user.displayName)
                print(authResult?.user.uid)
                self.uid = authResult?.user.uid
                self.photoURL = authResult?.user.photoURL
            }
        }
    }
}
