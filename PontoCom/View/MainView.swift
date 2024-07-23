//
//  MainView.swift
//  PontoCom
//
//  Created by Joel Lacerda on 19/07/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct MainView: View {

    var body: some View {
        VStack {
            Spacer()
            
            Text(Date.now.formatted(date: .abbreviated, time: .omitted))
                .font(.title)
            Text(Date.now.formatted(date: .omitted, time: .shortened))
                .font(.title)
            
            Spacer()
            
            HStack {
                BotaoView(numero: "1", texto: "Entrada", simbolo: "play", cor: .verde)
                BotaoView(numero: "2", texto: "Pausa", simbolo: "pause", cor: .azul)
            }
            
            HStack {
                BotaoView(numero: "3", texto: "Retorno", simbolo: "arrowshape.turn.up.backward", cor: .amarelo)
                BotaoView(numero: "4", texto: "Saída", simbolo: "stop", cor: .vermelho)
            }
        }
        .padding()
    }
    
    func registrarEntrada() {
        let now = Date()
        let db = Firestore.firestore()
        db.collection("points").addDocument(data: [
            "userId": Auth.auth().currentUser?.uid ?? "",
            "type": "entry",
            "timestamp": now
        ])
    }
    
    func registrarSaida() {
           let now = Date()
           let db = Firestore.firestore()
           db.collection("points").addDocument(data: [
               "userId": Auth.auth().currentUser?.uid ?? "",
               "type": "exit",
               "timestamp": now
           ])
       }
}

#Preview {
    MainView()
}
