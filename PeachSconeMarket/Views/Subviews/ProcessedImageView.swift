//
//  ProcessedImageView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 10/23/23.
//

import SwiftUI

struct ProcessedImageView: View {
    let image: Image

    var body: some View {
        processImage(image)
            .resizable()
            .scaledToFill()
            .clipped()
    }

    // Custom image processing function
    func processImage(_ inputImage: Image) -> Image {
        //TODO: Convert inputImage to a pixel readable format
        //TODO: Check borders (r, l, t)
        //TODO: Add borders with the same color as the top left pixel
        //TODO: Convert back to view and return
        
        
        return inputImage
    }
}



