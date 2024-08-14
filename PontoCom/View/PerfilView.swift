import SwiftUI
import FirebaseFirestore
import Foundation
import FirebaseAuth

struct PerfilView: View {
    @ObservedObject var userViewModel: UserViewModel
    
    var body: some View {
    
        NavigationView {
            VStack {
                VStack {
                    Image("2D")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .clipped()
                        .padding(.top, 44)
                    
                    Label(userViewModel.nomeUsuario, systemImage: "person")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(.blue)
                        .padding(.top, 12)
                        .cornerRadius(10)

                    Spacer()
                }

//                NavigationLink(destination: EditarInformacoesView()) {
//                    Label("Editar informacoes", systemImage: "pencil.and.list.clipboard")
//                        .padding()
//                        .foregroundColor(.black)
//                        .background(Color.green)
//                        .cornerRadius(10)
//                        .opacity(0.8)
//                }
//
//                NavigationLink(destination: JustificarFaltasView()) {
//                    Label("Justificar faltas", systemImage: "doc.questionmark")
//                        .padding()
//                        .foregroundColor(.black)
//                        .background(Color.red)
//                        .cornerRadius(10)
//                        .opacity(0.8)
//                }

                NavigationLink(destination: CalendarioView(userViewModel: userViewModel)) {
                    Label("Historico", systemImage: "calendar")
                        .padding()
                        .foregroundColor(.black)
                        .background(.blue)
                        .opacity(0.7)
                        .cornerRadius(10)
                        .padding()
                }
            }
        }
    }
}
