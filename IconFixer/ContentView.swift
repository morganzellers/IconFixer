//
//  ContentView.swift
//  IconFixer
//
//  Created by Morgan Zellers on 1/7/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var imageData: Data?
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .green, .orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                .opacity(0.8)
                .ignoresSafeArea()
            
            VStack {
                if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
                
                PhotosPicker(
                    selection: $selectedPhotoItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        Image(systemName: "plus")
                            .font(Font.largeTitle)
                            .foregroundColor(.white)
                    }
                    .onChange(of: selectedPhotoItem) { newItem in
                        if let newItem = newItem {
                            Task {
                                imageData = try? await newItem.loadTransferable(type: Data.self)
                            }
                        }
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
