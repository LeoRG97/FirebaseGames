//
//  NavBar.swift
//  FirebaseGames
//
//  Created by Leonardo Rodríguez González on 16/04/24.
//

import SwiftUI
import Firebase

struct NavBar: View {
    
    var device = UIDevice.current.userInterfaceIdiom
    
    @Binding var index: String
    @Binding var menu: Bool
    
    @EnvironmentObject var firebaseAuth: FirebaseViewModel
    
    var body: some View {
        HStack {
            Text("My Games")
                .font(.title)
                .bold()
                .foregroundStyle(.white)
                .font(.system(size: device == .phone ? 25 : 35)) // tamaño variable entre dispositivos
            
            Spacer()
            
            if device == .pad {
                // menu ipad (siempre visible)
                HStack(spacing: 25) {
                    ButtonView(index: $index, menu: $menu, title: "PlayStation")
                    ButtonView(index: $index, menu: $menu, title: "Xbox")
                    ButtonView(index: $index, menu: $menu, title: "Nintendo")
                    ButtonView(index: $index, menu: $menu, title: "Agregar")
                    
                    Button(action: {
                        // cerrar sesión en Firebase
                        try! Auth.auth().signOut()
                        UserDefaults.standard.removeObject(forKey: "session")
                        firebaseAuth.show = false
                    }) {
                        Text("Cerrar sesión")
                            .font(.title)
                            .frame(width: 200)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 25)
                    }.background(
                        Capsule()
                            .stroke(.white)
                    )
                }
            } else {
                // menu iphone (desplegable)
                Button(action: {
                    index = "Agregar"
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 26))
                        .foregroundStyle(.white)
                }
                Button(action: {
                    withAnimation {
                        menu.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.system(size: 26))
                        .foregroundStyle(.white)
                }
            }
            
            
        }
        .padding(.top, 30) // alarga el tamaño del padding del lado superior
        .padding()
        .background(Color.purple)
    }
}

/*
 #Preview {
 NavBar()
 }
 */
