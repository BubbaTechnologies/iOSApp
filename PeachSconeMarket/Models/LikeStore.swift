//
//  LikeStore.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 10/2/23.
//

import Foundation

@MainActor
class LikeStore: ObservableObject {
    @Published var likes: [LikeStruct] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("likes.data")
    }
    
    func load() async throws {
        let task = Task<[LikeStruct], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            
            let likes = try JSONDecoder().decode([LikeStruct].self, from: data)
            return likes
        }
        
        let likes = try await task.value
        self.likes = likes
    }
    
    func save() async throws {
        let task = Task {
            let data = try JSONEncoder().encode(likes)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        
        _ = try await task.value
    }
}
