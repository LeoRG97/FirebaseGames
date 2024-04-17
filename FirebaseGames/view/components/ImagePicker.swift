//
//  ImagePicker.swift
//  FirebaseGames
//
//  Created by Leonardo Rodríguez González on 16/04/24.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var show: Bool
    @Binding var image: Data
    
    // definir si el origen es la cámara o la galería
    var source: UIImagePickerController.SourceType
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        // crea el coordinator para abrir la galería de imágenes o la cámara
        return ImagePicker.Coordinator(connection: self)
    }
    
    func makeUIViewController(context: Context) -> some UIImagePickerController {
        
        let controller = UIImagePickerController()
        controller.sourceType = source
        controller.allowsEditing = true // permite editar la fotografía
        controller.delegate = context.coordinator
        
        return controller
        
    }
    
    func updateUIViewController(_ uiView: UIViewControllerType, context: Context) {
        
    }
    
    // clase que nos ayudará a abrir la ventana para seleccionar una foto o tomar una con la cámara
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var connection: ImagePicker
        
        init(connection: ImagePicker) {
            self.connection = connection
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // se ejecuta cuando se cancela la acción de tomar una foto
            print("Se canceló la captura de la foto")
            self.connection.show = false
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // se ejecuta cuando se selecciona o se toma la foto
            let image = info[.originalImage] as! UIImage // extraer la imagen del Dictionary obtenido
            let data = image.jpegData(compressionQuality: 0.100) // comprimir la imagen para que su peso sea menor
            self.connection.image = data! // asigna la imagen a la propiedad "image" de la clase ImagePicker
            self.connection.show = false
        }
            
    }
    
    
}

