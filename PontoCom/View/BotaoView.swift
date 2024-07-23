//
//  BotaoView.swift
//  PontoCom
//
//  Created by Joel Lacerda on 22/07/24.
//

import SwiftUI

struct BotaoView: View {
    var numero: String
    var texto: String
    var simbolo: String
    var cor: Color
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .center) {
                HStack {
                    Text(numero)
                        .foregroundStyle(.black)
                        .font(.title)
                    Spacer()
                }
                Text(texto)
                    .font(.title)
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

#Preview {
    HStack {
        BotaoView(numero: "1", texto: "Entrada", simbolo: "play", cor: .verde) {
            
        }
        BotaoView(numero: "2", texto: "Saída", simbolo: "stop", cor: .vermelho) {
            
        }
    }.padding()
}
