//
//  InstanceDataStore.swift
//  Carou
//
//  Created by Matt Groholski on 2/7/24.
//

import Foundation

@MainActor
class InstanceDataStore: ObservableObject {
    @Published var displayInstructions: Bool = true
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("carouInstance.data")
    }
    
    init() {
        self.displayInstructions = true
    }
    
    init(displayInstructions: Bool) {
        self.displayInstructions = displayInstructions
    }
    
    func load()  {
        do {
            let fileURL = try Self.fileURL()
            let data = try Data(contentsOf: fileURL)
            
            self.displayInstructions = try JSONDecoder().decode(Bool.self, from: data)

        } catch {
            // Handle any errors that occur during file loading or decoding
            print("Error loading or decoding data: \(error)")
            self.displayInstructions = true
        }
    }
    
    func save()  {
        do {
            let data = try JSONEncoder().encode(displayInstructions)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        } catch {
            // Handle any errors that occur during encoding or writing to file
            print("Error saving or encoding data: \(error)")
            self.displayInstructions = false
        }
    }

}
