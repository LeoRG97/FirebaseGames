//
//  AppDelegate.swift
//  FirebaseGames
//
//  Created by Leonardo Rodríguez González on 16/04/24.
// CÓDIGO DE INICIALIZACIÓN DE FIREBASE

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


// recuerda quitar la anotación @main, ya que el archivo App.swift es el principal
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
      }
    }
  }
}
