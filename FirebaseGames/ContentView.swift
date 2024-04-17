//
//  ContentView.swift
//  FirebaseGames
//
//  Created by Leonardo Rodríguez González on 16/04/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var firebaseAuth: FirebaseViewModel
    
    var body: some View {
        return Group {
            if firebaseAuth.show {
                Home()
                     .ignoresSafeArea(.all)
            } else {
                Login()
            }
        }
    }
}

#Preview {
    ContentView()
}
