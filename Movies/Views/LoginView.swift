//
//  LoginView.swift
//  Movies
//
//  Created by Cristian Chertes on 20.07.2023.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Login")
            TextField("Username", text: $username)
            TextField("Password", text: $password)
            Button {
                viewModel.login(username: username, password: password)
            } label: {
                Text("Login")
                    .foregroundColor(.white)
            }.frame(height: 40, alignment: .center)
                .background(Color.black)
                .cornerRadius(16)
                .buttonStyle(IconButtonDefault())
            Button {
                viewModel.loginWithGoogle()
            } label: {
                Text("Login With Google")
                    .foregroundColor(.white)
            }.frame(height: 40, alignment: .center)
                .background(Color.black)
                .cornerRadius(16)
                .buttonStyle(IconButtonDefault())
            Text(viewModel.uid ?? "")
        }
    }
}
