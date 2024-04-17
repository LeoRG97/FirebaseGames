//
//  ImageFirebase.swift
//  FirebaseGames
//
//  Created by Leonardo Rodríguez González on 17/04/24.
//

import SwiftUI

struct ImageFirebase: View {
    
    let imageAlt = UIImage(systemName: "photo")
    @ObservedObject var imageLoader: CoverViewModel
    
    init(imageUrl: String) {
        imageLoader = CoverViewModel(imageUrl: imageUrl)
    }
    
    var image: UIImage? {
        // mapear todas las imágenes que se tienen en el proyecto
        imageLoader.data.flatMap(UIImage.init)
    }
    
    var body: some View {
        Image(uiImage: (image ?? imageAlt)!)
            .resizable()
            .clipShape(.rect(cornerRadius: 20)) // a partir de iOS 16, así se agrega un radio a los bordes
            .shadow(radius: 5) // añadir sombra a la imagen
            .aspectRatio(contentMode: .fit)
    }
}

