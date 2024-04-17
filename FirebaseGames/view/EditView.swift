//
//  AddView.swift
//  FirebaseGames
//
//  Created by Leonardo Rodríguez González on 16/04/24.
//

import SwiftUI

struct EditView: View {
    
    @State private var title = ""
    @State private var desc = ""
    @State private var imageData: Data = .init(capacity: 0)
    @State private var showMenu = false
    @State private var imagePicker = false
    @State private var source: UIImagePickerController.SourceType = .camera
    @State private var progress = false
    
    @StateObject var firebase = FirebaseViewModel()
    @Environment(\.dismiss) var dismiss
    
    var platform: String
    var initialData: Game
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                
                Color.yellow.ignoresSafeArea(edges: .all)
                VStack {
                    
                    TextField("Título", text: $title)
                        .textFieldStyle(.roundedBorder)
                        .onAppear{
                           
                        }
                    
                    TextEditor(text: $desc)
                        .frame(height: 200)
                        .onAppear {

                        }
                    
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
                        
                    }
                    
                    Button(action: {
                        progress = true
                        if imageData.isEmpty {
                            firebase.edit(
                                title: title,
                                desc: desc,
                                platform: platform,
                                id: initialData.id
                            ) { done in
                                if (done) {
                                    // cierra la vista de edición
                                    dismiss()
                                }
                            }
                        } else {
                            firebase.editWithImage(
                                title: title,
                                desc: desc,
                                platform: platform,
                                id: initialData.id,
                                index: initialData,
                                cover: imageData
                            ) { done in
                                if (done) {
                                   dismiss()
                                }
                            }
                        }
                        
                    }) {
                        Text("Actualizar")
                            .foregroundStyle(.black)
                            .bold()
                            .font(.largeTitle)
                    }.disabled(progress)
                    
                    if progress == true {
                        Text("Espere un momento, por favor")
                            .foregroundStyle(.black)
                        ProgressView().progressViewStyle(.circular)
                    }
                    
                    Spacer()
                    
                    
                }.padding(.all)
                // MARK: forma nueva para controlar un Link desde otro componente (a partir de iOS 16
                    .navigationDestination(isPresented: $imagePicker) {
                        ImagePicker(show: $imagePicker, image: $imageData, source: source)
                    }.toolbar(.hidden)
            }
        }.onAppear {
            print(initialData)
            title = initialData.title
            desc = initialData.desc
        }
        
    }
}

/*
 #Preview {
 AddView()
 }
 */

