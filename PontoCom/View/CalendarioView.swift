//
//  CalendarioView.swift
//  PontoCom
//
//  Created by Daniel Lopes da Silva on 09/08/24.
//

import UIKit
import SwiftUI
import PDFKit


import SwiftUI

struct CalendarioView: View {
    @State private var cor: Color = .gray
    @State private var data = Date()
    @State private var diaSelecionado: Int? = nil
    let diasDaSemana = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"]
    let colunas = Array(repeating: GridItem(.flexible()), count: 7)
    @State private var mostrarDatePicker = false
    @State private var diasNoMes: [Int?] = [] 
    @ObservedObject var pontosViewModel = PontosViewModel()
    @ObservedObject var userViewModel: UserViewModel
    @State private var isLoading = false

    var body: some View {
        VStack {
            Text("Histórico")
                .font(.headline)
                .fontWeight(.bold)

            HStack {
                Text(parseMesEAnoString(from: data))
                    .font(.subheadline)
                    .padding(.leading, 10)
                    .onTapGesture {
                        mostrarDatePicker.toggle()
                    }
                Spacer()

                Button(action: {
                    mudarMes(decrementar: true)
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                }
                .padding(.leading, 10)

                Button(action: {
                    mudarMes(decrementar: false)
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                }
                .padding(.trailing, 10)
            }
            .padding()

            if mostrarDatePicker {
                DatePicker(
                    "",
                    selection: $data,
                    displayedComponents: [.date]
                )
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .padding()
                .onChange(of: data) { _ in
                    calcularDiasDoMes()
                    mostrarDatePicker = false
                }
            }

            HStack {
                ForEach(diasDaSemana.indices, id: \.self) { index in
                    Text(diasDaSemana[index])
                        .fontWeight(.black)
                        .foregroundStyle(cor)
                        .frame(maxWidth: .infinity, minHeight: 40)
                }
            }

            ScrollView {
                LazyVGrid(columns: colunas, spacing: 10) {
                    ForEach(0..<diasNoMes.count, id: \.self) { index in
                        if let dia = diasNoMes[index] {
                            Text("\(dia)")
                                .fontWeight(.bold)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, minHeight: 40, alignment: .center)
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(8)
                                .onTapGesture {
                                    diaSelecionado = dia
                                    buscarPontosParaDiaSelecionado()
                                }
                        } else {
                            // Espaços vazios para alinhar os dias corretamente
                            Text("")
                                .frame(maxWidth: .infinity, minHeight: 40)
                        }
                    }
                }
                .padding()

                if isLoading {
                    ProgressView()
                        .padding(.top)
                } else if !$pontosViewModel.points.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Pontos Registrados")
                            .font(.headline)
                            .padding(.top)

                        ForEach(pontosViewModel.points) { ponto in
                            VStack(alignment: .leading) {
                                Text("Tipo: \(ponto.tipo)")
                                    .font(.subheadline)
                                    .padding(.bottom, 2)
                                Text("Horário: \(ponto.horario.formatted(date: .abbreviated, time: .shortened))")
                                    .font(.subheadline)
                                    .padding(.bottom, 2)
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.bottom, 10)
                        }
                    }
                    .padding(.horizontal)
                }

                Button(action: {
                   let url =  gerarPDF()
                    compartilharPDF(url: url)
                }) {
                    HStack {
                        Image(systemName: "arrow.down.doc")
                        Text("Baixar PDF")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.bottom)
                }
            }
        }
        .padding()
        .onAppear(perform: calcularDiasDoMes)
    }

    func buscarPontosParaDiaSelecionado() {
        guard let diaSelecionado = diaSelecionado else { return }

        var componentesDaData = Calendar.current.dateComponents([.year, .month], from: data)
        componentesDaData.day = diaSelecionado
        guard let dataSelecionada = Calendar.current.date(from: componentesDaData) else { return }

        guard let userId = userViewModel.usuarioAutenticado?.id else {
            print("Usuário não autenticado")
            return
        }

        isLoading = true

        pontosViewModel.fetchPoints(for: userId)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let pontosParaDiaSelecionado = self.pontosViewModel.points.filter { ponto in
                Calendar.current.isDate(ponto.horario, inSameDayAs: dataSelecionada)
            }

            if pontosParaDiaSelecionado.isEmpty {
                self.pontosViewModel.points.removeAll()
            } else {
                self.pontosViewModel.points = pontosParaDiaSelecionado
            }

            isLoading = false
        }
    }

    func parseMesEAnoString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    func mudarMes(decrementar: Bool) {
        var componenteData = DateComponents()
        componenteData.month = decrementar ? -1 : 1
        data = Calendar.current.date(byAdding: componenteData, to: data) ?? data
        calcularDiasDoMes()
    }

    func calcularDiasDoMes() {
        let calendario = Calendar.current
        let intervalo = calendario.range(of: .day, in: .month, for: data)!
        diasNoMes = Array(intervalo).map { Optional($0) }

        var componentes = calendario.dateComponents([.year, .month], from: data)
        componentes.day = 1

        guard let primeiroDiaDoMes = calendario.date(from: componentes),
              let diaDaSemana = calendario.dateComponents([.weekday], from: primeiroDiaDoMes).weekday else {
            return
        }

        let espacosVazios = diaDaSemana - calendario.firstWeekday
        diasNoMes = Array(repeating: nil, count: espacosVazios) + diasNoMes
    }

    func gerarPDF() -> URL {
        let pdfMetaData = [
            kCGPDFContextCreator: "PontoCom",
            kCGPDFContextAuthor: "Seu Nome",
            kCGPDFContextTitle: "Histórico de Pontos"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)

        let data = pdfRenderer.pdfData { context in
            context.beginPage()

            let titleFont = UIFont.systemFont(ofSize: 18, weight: .bold)
            let textFont = UIFont.systemFont(ofSize: 12, weight: .regular)

            let titleAttributes: [NSAttributedString.Key: Any] = [.font: titleFont]
            let textAttributes: [NSAttributedString.Key: Any] = [.font: textFont]

            let titleText = "Histórico de Pontos"
            titleText.draw(at: CGPoint(x: 20, y: 20), withAttributes: titleAttributes)

            var yOffset = 60
            for ponto in pontosViewModel.points {
                let text = """
                Tipo: \(ponto.tipo)
                Horário: \(ponto.horario.formatted(date: .abbreviated, time: .shortened))
                """
                text.draw(at: CGPoint(x: 20, y: yOffset), withAttributes: textAttributes)
                yOffset += 60
            }
        }

        let url = FileManager.default.temporaryDirectory.appendingPathComponent("HistoricoPontos.pdf")
        do {
            try data.write(to: url)
            print("PDF criado com sucesso: \(url)")
        } catch {
            print("Erro ao criar o PDF: \(error)")
        }

        return url
    }

    func compartilharPDF(url: URL) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if let topController = UIApplication.shared.windows.first?.rootViewController {
            topController.present(activityViewController, animated: true, completion: nil)
        }
    }
}


    #Preview {
        CalendarioView(userViewModel: UserViewModel())
    }

