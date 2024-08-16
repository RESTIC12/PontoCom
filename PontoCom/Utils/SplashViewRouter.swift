//
//  SplashViewRouter.swift
//  PontoCom
//
//  Created by Rubens Parente on 31/07/24.
//

import SwiftUI

enum SplashViewRouter{
    
    static func makeSignInView() -> some View{
        let viewModel = LoginViewModel()
        return RootView(viewModel: viewModel)
    }
}
