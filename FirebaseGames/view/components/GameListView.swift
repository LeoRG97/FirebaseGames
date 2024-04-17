//
//  GameListView.swift
//  FirebaseGames
//
//  Created by Leonardo Rodríguez González on 17/04/24.
//

import SwiftUI

struct GameListView: View {
    
    @Environment(\.horizontalSizeClass) var screenWidth
    @StateObject var firebase = FirebaseViewModel()
    @State private var showEditModal = false
    
    var device = UIDevice.current.userInterfaceIdiom
    var platform: String // PlayStation, Xbox or Nintendo
    
    func getColumns() -> Int {
        // obtener número de columnas con base en tamaño de dispositivo
        return (device == .pad) ? 3 : ((device == .phone && screenWidth == .regular) ? 3 : 1)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            /*
             la grid debe tener elementos que sean flexibles, 
             con un espaciado de 20 unidades entre cada uno. 
             El número de columnas se obtiene con la función definida en la parte superior.
             */
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: getColumns()), spacing: 20) {
                ForEach(firebase.games) { item in
                    CardView(
                        title: item.title,
                        cover: item.cover,
                        index: item,
                        platform: platform
                    ).padding(.all)
                        .onTapGesture {
                            firebase.sendData(item: item)
                        }.sheet(isPresented: $firebase.showEdit, content: {
                            EditView(platform: platform, initialData: firebase.gameUpdate)
                        })
                }
            }
        }.onAppear {
            firebase.getData(platform: platform)
        }
    }
}
