//
//  FirebaseGamesApp.swift
//  FirebaseGames
//
//  Created by Leonardo Rodríguez González on 16/04/24.
//

import SwiftUI

@main
struct FirebaseGamesApp: App {
    
    // importa el AppDelegate en la aplicación
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        let login = FirebaseViewModel()
        WindowGroup {
            ContentView()
                .environmentObject(login)
        }
    }
}
