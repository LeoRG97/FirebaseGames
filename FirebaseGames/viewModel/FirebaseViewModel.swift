//
//  FirebaseViewModel.swift
//  FirebaseGames
//
//  Created by Leonardo Rodríguez González on 16/04/24.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseViewModel: ObservableObject {
    
    @Published var show = false
    @Published var games = [Game]()
    @Published var gameUpdate: Game!
    @Published var showEdit = false
    
    init() {
        if UserDefaults.standard.object(forKey: "session") != nil {
            self.show = true
        }
    }
    
    func sendData(item: Game) {
        gameUpdate = item
        showEdit.toggle()
    }
    
    // función para iniciar sesión en FirebaseAuth con correo y contraseña
    func login(email: String, password: String, completion: @escaping (_ done: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            
            if user != nil {
                print("Se autenticó!!!")
                UserDefaults.standard.set(true, forKey: "session")
                completion(true)
            } else {
                if let error = error?.localizedDescription {
                    print("Error de autenticación", error)
                } else {
                    print("Error en la app")
                }
            }
            
        }
        
    }
    
    // función para crear un usuario en FirebaseAuth
    func createUser(email: String, password: String, completion: @escaping (_ done: Bool) -> Void) {
      
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            
            if user != nil {
                print("Se registró!!!")
                UserDefaults.standard.set(true, forKey: "session")
                completion(true)
            } else {
                if let error = error?.localizedDescription {
                    print("Error de registro de cuenta", error)
                } else {
                    print("Error en la app")
                }
            }
            
        }
        
    }
    
    // MARK: FIRESTORE DATABASE
    
    // función para guardar un nuevo registro en Firestore
    func saveGame(title: String, desc: String, platform: String, cover: Data, completion: @escaping (_ done: Bool) -> Void) {
       
        
        // MARK: Start Firebase Storage
        let storage = Storage.storage().reference()
        let coverName = UUID()
        let directory = storage.child("images/\(coverName)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        directory.putData(cover, metadata: metadata) {data, error in
            if error == nil {
                print("Guardó la imagen")
                // GUARDAR TEXTO
                
                let db = Firestore.firestore() // habilita la conexión con la BD
                let id = UUID().uuidString
                
                // obtener el ID del usuario actual
                guard let idUser = Auth.auth().currentUser?.uid,
                      let email = Auth.auth().currentUser?.email
                else {
                    return
                }
                
                // crear un Dictionary con los atributos del objeto
                let fields: [String: Any] = [
                    "title": title,
                    "desc": desc,
                    "cover":  String(describing: directory), // asegura que la URL sea un String en Firestore
                    "idUser": idUser,
                    "email": email
                ]
                
                // guardar el documento en la colección
                db.collection(platform).document(id).setData(fields) { error in
                    
                    if let error = error?.localizedDescription {
                        print("Error al registrar el documento en Firestore")
                        completion(false)
                    } else {
                        print("Sí guardó!!!")
                        completion(true)
                    }
                    
                }
                
                
                // TERMINÓ DE GUARDAR TEXTO
            } else {
                if let error = error?.localizedDescription {
                    print("Fallo al subir la imagen", error)
                } else {
                    print("Fallo en la aplicación")
                }
            }
        }
        
        // MARK: End Firebase Storage
        
    }
    
    // función para traer los datos de storage por colección
    func getData(platform: String) {
        
        let db = Firestore.firestore() // habilita la conexión con la BD
        db.collection(platform).addSnapshotListener { querySnapshot, error in
            if let error = error?.localizedDescription {
                print("Error al leer datos", error)
            } else {
                self.games.removeAll()
                // unwrap optional "querySnapshot" (cambia ? por !)
                for doc in querySnapshot!.documents {
                    // extraer el ID y los atributos de cada documento
                    let value = doc.data()
                    let id = doc.documentID
                    let title = value["title"] as? String ?? "No title"
                    let desc = value["desc"] as? String ?? "No description"
                    let cover = value["cover"] as? String ?? "No cover"
                    DispatchQueue.main.async {
                        let gameItem = Game(id: id, title: title, desc: desc, cover: cover)
                        self.games.append(gameItem)
                    }
                }
            }
        }
        
    }
    
    // eliminar un documento de Firestore (y su imagen del Storage)
    func deleteItem(index: Game, platform: String) {
        
        // Eliminar de Firestore
        let id = index.id
        let db = Firestore.firestore()
        db.collection(platform).document(id).delete()
        
        // Eliminar de Storage
        let image = index.cover
        let deletedImage = Storage.storage().reference(forURL: image)
        deletedImage.delete(completion: nil)

        
    }
    
    // MARK: EDICIÓN DE REGISTROS
    
    // función para actualizar el título y la descripción de un documento
    func edit(title: String, desc: String, platform: String, id: String, completion: @escaping (_ done: Bool) -> Void) {
        
        let db = Firestore.firestore()
        let fields: [String: Any] = [
            "title": title,
            "desc": desc
        ]
        
        db.collection(platform).document(id).updateData(fields) { error in
            
            if let error = error?.localizedDescription {
                print("Error al actualizar datos", error)
            } else {
                print("Se editó el texto correctamente")
                completion(true)
            }
            
        }
        
    }
    
    // función para actualizar el documento con su imagen
    func editWithImage(title: String, desc: String, platform: String, id: String, index: Game, cover: Data, completion: @escaping (_ done: Bool) -> Void) {
       
        // Paso 1: Eliminar imagen
        let image = index.cover
        let deletedImage = Storage.storage().reference(forURL: image)
        deletedImage.delete(completion: nil)
        
        // Paso 2: Subir nueva imagen
        let storage = Storage.storage().reference()
        let coverName = UUID()
        let directory = storage.child("images/\(coverName)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        directory.putData(cover, metadata: metadata) {data, error in
            if error == nil {
                print("Actualizó la imagen")
                
                // Paso 3: editar propiedades del documento
                let db = Firestore.firestore()
                let fields: [String: Any] = [
                    "title": title,
                    "desc": desc,
                    "cover": String(describing: directory),
                ]
                
                db.collection(platform).document(id).updateData(fields) { error in
                    
                    if let error = error?.localizedDescription {
                        print("Error al actualizar texto y portada", error)
                    } else {
                        print("Se editó el texto correctamente")
                        completion(true)
                    }
                    
                }
                // TERMINÓ DE EDITAR TEXTO
                
            } else {
                if let error = error?.localizedDescription {
                    print("Fallo al subir la imagen", error)
                } else {
                    print("Fallo en la aplicación")
                }
            }
        }
        
        
    }
    

    
}
