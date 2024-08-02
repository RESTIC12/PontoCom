//
//  SplashViewModel.swift
//  PontoCom
//
//  Created by Rubens Parente on 31/07/24.
//

import Foundation
import SwiftUI

class SplashViewModel: ObservableObject{
    
    @Published var uiState: SplashUIState = .loading
    
    func onAppear(){
        //Faz algo assincrono e muda o estado da uiState
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            //Aqui e chamado depois de 3 segundo
            //self.uiState = .error("erro na resposta do servidor")
            self.uiState = .goToSignInScreen
        }
    }
}

extension SplashViewModel{
    //func signInView() -> some View{
    func rootView() -> some View{
        return SplashViewRouter.makeSignInView()
    }
}
