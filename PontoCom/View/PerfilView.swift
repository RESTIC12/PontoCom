import SwiftUI
import FirebaseFirestore

struct PerfilView: View {
    
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    @ObservedObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack{
            VStack(spacing: 16) {
                Text("Foto de perfil")
                
                Button {
                    shouldShowImagePicker.toggle()
                } label: {
                    VStack{
                        if let image = self.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 128, height: 128)
                                .cornerRadius(64)
                        }else{
                            
                        }
                        Image(systemName: "person.fill")
                            .font(.system(size: 64))
                            .padding()
                            .foregroundColor(Color(.label))
                    }
                    .overlay(RoundedRectangle(cornerRadius: 64).stroke(Color.black, lineWidth: 3))
                }
              .accessibilityElement(children: .ignore)
              .accessibilityLabel(Text("Selecione para mudar sua foto de perfil"))
                Spacer()
            }
            
            NavigationLink(destination: JustificarFaltasView()) {
                Label("Justificar Faltas", systemImage: "pencil.and.list.clipboard")
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.green)
                    .cornerRadius(10)
                    .opacity(0.8)
                    .padding()
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text("Selecione para justificar suas Faltas"))
            
            NavigationLink(destination: CalendarioView(userViewModel: userViewModel)) {
                Label("Historico", systemImage: "calendar")
                    .padding()
                    .foregroundColor(.black)
                    .background(.blue)
                    .opacity(0.7)
                    .cornerRadius(10)
                    .padding()
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text("Selecione para consultar seu histórico de pontos"))
            .navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil){
                ImagePickerView(image: $image)
            }
        }
    }
}
