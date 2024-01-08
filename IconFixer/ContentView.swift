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
    @State private var image: UIImage?
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .green, .orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                .opacity(0.8)
                .ignoresSafeArea()
            
            VStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
                
                Spacer()
                
                PhotosPicker(
                    selection: $selectedPhotoItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        Image(systemName: "plus")
                            .font(Font.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                    }
                    .onChange(of: selectedPhotoItem) { newItem in
                        if let newItem = newItem {
                            Task {
                                guard let imageData = try? await newItem.loadTransferable(type: Data.self),
                                      let uiImage = UIImage(data: imageData),
                                      let resizedImage = ImageProcessor.resize(from: uiImage),
                                      let noAlphaImage = ImageProcessor.removeAlphaChannel(from: resizedImage) else {
                                    return
                                }
                                
                                image = noAlphaImage
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
