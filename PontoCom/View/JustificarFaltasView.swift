//
//  JustificationView.swift
//  PontoCom
//
//  Created by Rubens Parente on 12/08/24.
//

import SwiftUI

struct JustificarFaltasView: View {
    @StateObject private var viewModel = JustificarViewModel()
    @State private var showFilePicker = false
    @State private var reasons = ["Licença Médica", "Licença maternidade/paternidade", "Faltas Legais", "Falecimento de familiar", "Outros"]
   @State private var selectedReason = "Licença Médica"
    
    var body: some View {
        NavigationView {
            Form {
                Section{
                    Text("A justificativa de ausência deve ser utilizada caso você tenha se ausentado do trabalho por atestado.")
                        .multilineTextAlignment(.center)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(Text("A justificativa de ausência deve ser utilizada caso você tenha se ausentado do trabalho por atestado."))
                }
                Section(header: Text("Datas")) {
                    DatePicker("Data Inicial", selection: $viewModel.startDate, displayedComponents: [.date, .hourAndMinute])
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(Text("Digite a data e hora inicial do atestado"))
                    DatePicker("Data Final", selection: $viewModel.endDate, displayedComponents: [.date, .hourAndMinute])
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(Text("Digite a data e hora final do atestado"))
                }
                
               
                Section(header: Text("Motivo")) {
                    Picker("Motivo", selection: $selectedReason) {
                        ForEach(reasons, id: \.self) { reason in
                            Text(reason).tag(reason)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text("Selecione um dos motivos da falta"))
                
                Section(header: Text("Observação")) {
                    TextField("Observação", text: $viewModel.notes)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text("Digite a observação de sua falta"))
                
                Section(header: Text("Anexar Atestado Médico")) {
                    HStack{
                        Button(action: {
                            showFilePicker = true
                        }) {
                            Text("Selecionar Arquivo")
                                .multilineTextAlignment(.leading)
                        }
                       
                        Spacer()
                        
                        Image(systemName: "tray.and.arrow.down")
                            .multilineTextAlignment(.trailing)
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text("Selecione o atestado médico"))
               
                Button(action: {
                    viewModel.reason = selectedReason
                    viewModel.submitJustificar()
                    
                }) {
                    Text("Salvar")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                }.frame(maxWidth: .infinity)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text("Clique na opção salvar para justificar sua falta!"))
            }
            .navigationTitle("Justificar Falta")

            
            .fileImporter(isPresented: $showFilePicker, allowedContentTypes: [.pdf]) { result in
                switch result {
                case .success(let url):
                    viewModel.fileURL = url
                case .failure(let error):
                    print("Erro ao selecionar arquivo: \(error.localizedDescription)")
                }
            }
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(
                    title: Text(viewModel.alertType == .success ? "Sucesso" : "Erro"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}





struct JustificarFaltasView_Previews: PreviewProvider {
    static var previews: some View {
        JustificarFaltasView()
    }
}
