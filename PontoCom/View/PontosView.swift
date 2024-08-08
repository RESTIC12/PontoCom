//
//  PontosView.swift
//  PontoCom
//
//  Created by Joel Lacerda on 08/08/24.
//

import SwiftUI

struct PontosView: View {
    @StateObject private var viewModel = PontosViewModel()
    let userId: String
    
    var body: some View {
        VStack {
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
            }
            
            List(viewModel.points) { point in
                VStack(alignment: .leading) {
                    Text("Tipo: \(point.tipo)")
                    Text("Horário: \(point.horario, formatter: dateFormatter)")
                }
            }
        }
        .onAppear {
            viewModel.fetchPoints(for: userId)
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
