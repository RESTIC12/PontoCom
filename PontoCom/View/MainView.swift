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
    @State private var horarioEntrada: Date? = nil
    @State private var horarioSaida: Date? = nil
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(Date.now, format: .dateTime)
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
        horarioEntrada = now
        // Salvar no Firestore
        let db = Firestore.firestore()
        db.collection("points").addDocument(data: [
            "userId": Auth.auth().currentUser?.uid ?? "",
            "type": "entry",
            "timestamp": now
        ])
    }
    
    func registrarSaida() {
           let now = Date()
           horarioSaida = now
           // Salvar no Firestore
           let db = Firestore.firestore()
           db.collection("points").addDocument(data: [
               "userId": Auth.auth().currentUser?.uid ?? "",
               "type": "exit",
               "timestamp": now
           ])
       }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    MainView()
}
