//
//  Home.swift
//  FirebaseGames
//
//  Created by Leonardo Rodríguez González on 16/04/24.
//

import SwiftUI
import Firebase

struct Home: View {
    
    @State private var index = "PlayStation"
    @State private var menu = false
    @State private var menuWidth = UIScreen.main.bounds.width
    
    @EnvironmentObject var firebaseAuth: FirebaseViewModel

    // recuerda que .regular es tamaño normal y grande, y .compact es tamaño pequeño (pero no todos los dispositivos lo tienen=
    
    var body: some View {
        ZStack {
            VStack {
                
                NavBar(index: $index, menu: $menu)
                ZStack {
                    if index == "PlayStation" {
                        GameListView(platform: "playstation")
                    } else if index == "Xbox" {
                        GameListView(platform: "xbox")
                    } else if index == "Nintendo" {
                        GameListView(platform: "nintendo")
                    } else {
                        AddView()
                    }
                }
                
            }
            
            // termina navbar ipad, prosigue navbar iphone
            if menu {
                HStack {
                    Spacer()
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    menu.toggle()
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                        }.padding()
                            .padding(.top, 40)
                        
                        VStack(alignment: .trailing) {
                            ButtonView(index: $index, menu: $menu, title: "PlayStation")
                            ButtonView(index: $index, menu: $menu, title: "Xbox")
                            ButtonView(index: $index, menu: $menu, title: "Nintendo")
                            
                            Button(action: {
                                // cerrar sesión en Firebase
                                try! Auth.auth().signOut()
                                UserDefaults.standard.removeObject(forKey: "session")
                                firebaseAuth.show = false
                            }) {
                                Text("Cerrar sesión")
                                    .font(.title3)
                                    .foregroundStyle(.white)
                                    
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                            }.background(
                                Capsule()
                                    .stroke(.white)
                            )
                        }
                        
                        Spacer()
                        
                        
                    }
                    .frame(width: menuWidth - 150)
                    .background(Color.purple)
                }
            }
        }.background(Color.background)
    }
    
}

#Preview {
    Home()
}
