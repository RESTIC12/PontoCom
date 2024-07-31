//
//  BotaoView.swift
//  PontoCom
//
//  Created by Joel Lacerda on 22/07/24.
//

import SwiftUI

struct BotaoView: View {
    var texto: String
    var simbolo: String
    var cor: Color
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .center) {
                HStack{
                    Text("")
                }
                Text(texto)
                    .font(.title)
//                    .bold()
                    .foregroundStyle(.black)
                    .padding(.vertical, 50)
                HStack {
                    Spacer()
                    Image(systemName: simbolo)
                        .font(.title)
                        .foregroundStyle(.black)
                }
                
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(cor)
            )
                
        }
    }
}

enum PontoStatus {
    case none
    case entrada
    case pausa
    case retorno
    case saida
}

#Preview {
    HStack {
        BotaoView(texto: "Entrada", simbolo: "play", cor: .verde) {
            
        }
        BotaoView(texto: "Saída", simbolo: "stop", cor: .vermelho) {
            
        }
    }.padding()
}
