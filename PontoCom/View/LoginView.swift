//
//  LoginView.swift
//  PontoCom
//
//  Created by Joel Lacerda on 19/07/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isLoading = false
    @Binding var isAuthenticated: Bool
    let fu = FirebaseUtils.shared
    
    var body: some View {
        VStack {
            Group {
                Text("PontoC") + Text("o").foregroundStyle(.yellow) + Text("m.")
            }
            .font(.title)
            
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled(true)
                .padding(.vertical, 10)
                        
            SecureField("Senha", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 20)
            
            if isLoading {
                ProgressView()
                    .padding()
            } else {
                Button {
                    login()
                } label: {
                    Text("Login")
                        .padding()
                        .background(.azul)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            Text(errorMessage)
                .foregroundColor(.red)
                .padding(.top, 10)
        }
        .padding()
    }
    
    private func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Por favor, insira email e senha."
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        fu.login(email: email, password: password) { result in
            isLoading = false
            switch result {
            case .success(let user):
                print("Logged in as \(user.email ?? "")")
                isAuthenticated = true
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}


#Preview {
    LoginView(isAuthenticated: .constant(false))
}
