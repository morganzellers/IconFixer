//
//  ImageProcessor.swift
//  IconFixer
//
//  Created by Morgan Zellers on 1/7/24.
//

import Foundation
import UIKit

class ImageProcessor {
    
    static func resize(from original: UIImage) -> UIImage? {
        let newSize = CGSize(width: 1024, height: 1024)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        original.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    static func removeAlphaChannel(from image: UIImage) -> UIImage? {
            guard let cgImage = image.cgImage else {
                return nil
            }
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let width = cgImage.width
            let height = cgImage.height
            let bytesPerPixel = 3 // RGB channels without alpha
            let bytesPerRow = bytesPerPixel * width
            let bitsPerComponent = 8
            
            guard let context = CGContext(data: nil,
                                          width: width,
                                          height: height,
                                          bitsPerComponent: bitsPerComponent,
                                          bytesPerRow: bytesPerRow,
                                          space: colorSpace,
                                          bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else {
                return nil
            }
            
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
            
            if let newCGImage = context.makeImage() {
                return UIImage(cgImage: newCGImage)
            }
            
            return nil
        }
}
