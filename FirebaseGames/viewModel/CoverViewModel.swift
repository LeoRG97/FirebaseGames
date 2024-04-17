//
//  CoverViewModel.swift
//  FirebaseGames
//
//  Created by Leonardo Rodríguez González on 17/04/24.
//

import Foundation
import FirebaseStorage

// clase para recuperar una imagen de FirebaseStorage y convertirla a Data
class CoverViewModel: ObservableObject {
    
    @Published var data: Data? = nil
    
    init(imageUrl: String) {
        print("IMAGE URL", imageUrl)
        if imageUrl != ""{
            let storageImage = Storage.storage().reference(forURL: imageUrl)
            storageImage.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error?.localizedDescription {
                    print("Error al leer la imagen", error)
                } else {
                    DispatchQueue.main.async {
                        self.data = data
                    }
                }
                
            }
        }
       
    }
    
}
