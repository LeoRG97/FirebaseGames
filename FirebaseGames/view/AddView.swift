//
//  AddView.swift
//  FirebaseGames
//
//  Created by Leonardo Rodríguez González on 16/04/24.
//

import SwiftUI

struct AddView: View {
    
    @State private var title = ""
    @State private var desc = ""
    @State private var platform = "playstation"
    @State private var imageData: Data = .init(capacity: 0)
    @State private var showMenu = false
    @State private var imagePicker = false
    @State private var source: UIImagePickerController.SourceType = .camera
    @State private var progress = false
    
    @StateObject var firebase = FirebaseViewModel()
    
    var consoles = ["PlayStation", "Xbox", "Nintendo"]

    
    var body: some View {
       
        NavigationStack {
            ZStack {
                
                Color.yellow.ignoresSafeArea(edges: .all)
                VStack {
                   
                    /*
                     // MARK: crear una navegación hacia la cámara (pre-iOS 16)
                    NavigationLink(destination: ImagePicker(show: $imagePicker, image: $imageData, source: source), isActive: $imagePicker) {
                        EmptyView()
                    }.toolbar(.hidden) // oculta el toolbar de la navegación (sustituye al navigationBarHidden)
                     */
                    
                    TextField("Título", text: $title)
                        .textFieldStyle(.roundedBorder)
                    
                    TextEditor(text: $desc)
                        .frame(height: 200)
                    
                    Picker(selection: $platform) {
                        ForEach(consoles, id: \.self) { item in
                            Text(item)
                                .foregroundStyle(.black)
                        }
                    } label: {
                        Text("Consolas")
                    }.pickerStyle(.wheel)
                    
                    Button(action: {
                        showMenu.toggle()
                    }) {
                        Text("Cargar imagen")
                            .foregroundStyle(.black)
                            .bold()
                            .font(.largeTitle)
                    }.actionSheet(isPresented: $showMenu, content: {
                        
                        ActionSheet(
                            title: Text("Menú"),
                            message: Text("Selecciona una opción"),
                            buttons: [
                                .default(Text("Cámara"), action: {
                                    source = .camera
                                    imagePicker.toggle() // ejecutar el navigationLink hacia la cámara
                                }),
                                .default(Text("Galería de fotos"), action: {
                                    source = .photoLibrary
                                    imagePicker.toggle() // ejecutar el navigationLink hacia la cámara
                                }),
                                .default(Text("Cancelar"))
                            ]
                        )
                    }).disabled(progress)
                    
                    if imageData.count != 0 {
                        // mostrar la imagen seleccionada en un componente
                        Image(uiImage: UIImage(data: imageData)!)
                            .resizable()
                            .frame(width: 250, height: 250)
                            .cornerRadius(15) // cornerRadius is deprecated
                        
                        Button(action: {
                            
                            progress = true
                            firebase.saveGame(title: title, desc: desc, platform: platform.lowercased(), cover: imageData) { done in
                                if done {
                                    title = ""
                                    desc = ""
                                    imageData = .init(capacity: 0) // limpiar ImageData
                                    progress = false
                                }
                            }
                            
                        }) {
                            Text("Guardar")
                                .foregroundStyle(.black)
                                .bold()
                                .font(.largeTitle)
                        }.disabled(progress)
                        
                        if progress == true {
                            Text("Espere un momento, por favor")
                                .foregroundStyle(.black)
                            ProgressView().progressViewStyle(.circular)
                        }
                        
                    }
                    Spacer()

                    
                }.padding(.all)
                // MARK: forma nueva para controlar un Link desde otro componente (a partir de iOS 16
                    .navigationDestination(isPresented: $imagePicker) {
                        ImagePicker(show: $imagePicker, image: $imageData, source: source)
                    }.toolbar(.hidden)
            }
        }
        
    }
}

/*
#Preview {
    AddView()
}
 */

