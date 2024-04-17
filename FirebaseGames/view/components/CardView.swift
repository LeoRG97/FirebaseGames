//
//  CardView.swift
//  FirebaseGames
//
//  Created by Leonardo Rodríguez González on 16/04/24.
//

import SwiftUI

struct CardView: View {
    
    var title: String
    var cover: String
    
    var index: Game
    var platform: String
    
    @StateObject var firebase = FirebaseViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            
            /*
            Image("endless_ocean_luminous")
                .resizable()
                .aspectRatio(contentMode: .fit)
            */
            
            ImageFirebase(imageUrl: cover)
            Text(title)
                .font(.title)
                .bold()
                .foregroundStyle(.black)
            
            Button(action: {
                
                firebase.deleteItem(index: index, platform: platform)
                
            }) {
                Text("Eliminar")
                    .foregroundStyle(.red)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 25)
                    .background(Capsule().stroke(.red))
            }
            
        }.padding()
        .background(.white)
        .cornerRadius(20)
    }
}

