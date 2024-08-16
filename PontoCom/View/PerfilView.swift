import SwiftUI
import FirebaseFirestore

    struct PerfilView: View {
        
        @State var shouldShowImagePicker = false
        @State var image: UIImage?
        @ObservedObject var userViewModel: UserViewModel
        
        var body: some View {
            
            VStack{
                
                //                NavigationStack {
                //
                //
                //                }
                VStack(spacing: 16){
                    //                    Image("2D")
                    //                        .resizable()
                    //                        .aspectRatio(contentMode: .fill)
                    //                        .frame(width: 200, height: 200)
                    //                        .clipShape(Circle())
                    //                        .clipped()
                    //                        .padding(.top, 44)
                    //                    Label("Levi Soares", systemImage: "person").font(.system(size: 20)).bold().foregroundColor(.blue)
                    //                        .padding(.top, 12)
                    //                        .cornerRadius(10)
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
                    .navigationViewStyle(StackNavigationViewStyle())
                    .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil){
                        ImagePickerView(image: $image)
                    }
                }
            }
        }


