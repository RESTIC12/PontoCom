//
//  SplashView.swift
//  PontoCom
//
//  Created by Rubens Parente on 30/07/24.
//

import SwiftUI

struct SplashView: View {
    
    @ObservedObject var viewModel: SplashViewModel
    
    var body: some View{
        Group{
            switch viewModel.uiState {
             case .loading:
               loadingView()
             case .goToSignInScreen:
                viewModel.rootView()
                //navegar para proxima tela
             case .goToHomeScreen:
                Text("carregando tela principal")
                
                //navegar para proxima tela
             case .error(let msg):
                loadingView(error: msg)
             }
        }.onAppear(perform: viewModel.onAppear)
    }
}

extension SplashView{
    func loadingView(error: String? = nil) -> some View{
    ZStack{
            Image("logo")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: 250, maxHeight: 250)
                .padding(20)
                .background(Color.white)
                .ignoresSafeArea()
        
        if let error = error{
            Text("")
                .alert(isPresented: .constant(true)){
                    Alert(title: Text("PontoCom"), message: Text(error), dismissButton: .default(Text("OK")){
                        //Faz algo quando some o alerta
                    })
                }
        }
      }
    }
}

struct SplashView_Previews: PreviewProvider{
    static var previews: some View{
        let viewModel = SplashViewModel()
        SplashView(viewModel: viewModel)
    }
}

