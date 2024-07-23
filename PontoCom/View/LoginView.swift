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
    
    let fu = FirebaseUtils.shared
    
    var body: some View {
        VStack {
            Group {
                Text("PontoC") + Text("o").foregroundStyle(.yellow) + Text("m.")
            }
            .font(.title)
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled(true)
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom)
            
            Button(action: {
                fu.login(email: email, password: password) { result in
                    switch result {
                    case .success(let user):
                        print("Logged in as \(user.email ?? "")")
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
                
            }) {
                Text("Login")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            Text(errorMessage)
                .foregroundColor(.red)
        }
        .padding()
    }
}


#Preview {
    LoginView()
}
