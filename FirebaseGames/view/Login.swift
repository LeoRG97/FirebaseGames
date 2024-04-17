//
//  Login.swift
//  FirebaseGames
//
//  Created by Leonardo Rodríguez González on 16/04/24.
//

import SwiftUI

struct Login: View {
    
    @State private var email = ""
    @State private var password = ""
    @StateObject var login = FirebaseViewModel() // llamar a las funciones de login
    @EnvironmentObject var firebaseAuth: FirebaseViewModel // obtener estado de auth actual
    
    var device = UIDevice.current.userInterfaceIdiom
    
    
    var body: some View {
        ZStack {
            Color.purple.edgesIgnoringSafeArea(.all)
            VStack {
                Text("DarthVinci Games")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .bold()
                
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .frame(width: device == .pad ? 400 : nil) // ajustar tamaño para iPad
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: device == .pad ? 400 : nil) // ajustar tamaño para iPad
                    .padding(.bottom, 20)
                
                
                Button(action: {
                    login.login(email: email, password: password) { done in
                        if done {
                            // muestra la pantalla Home
                            firebaseAuth.show.toggle()
                        }
                    }
                }) {
                    Text("Entrar")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .frame(width: 200)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                }.background(
                    // crear un botón con los extremos redondeados
                    Capsule()
                        .stroke(.white)
                )
                
                
                Divider()
                
                
                Button(action: {
                    login.createUser(email: email, password: password) { done in
                        if done {
                            // muestra la pantalla Home
                            firebaseAuth.show.toggle()
                        }
                    }
                }) {
                    Text("Registrarse")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .frame(width: 200)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                }.background(
                    // crear un botón con los extremos redondeados
                    Capsule()
                        .stroke(.white)
                )
                
            }.padding(.all)
        }
    }
}

#Preview {
    Login()
}
