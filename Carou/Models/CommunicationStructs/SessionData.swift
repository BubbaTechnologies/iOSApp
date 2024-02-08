//
//  SessionData.swift
//  Carou
//
//  Created by Matt Groholski on 2/7/24.
//

import Foundation

class SessionData: ObservableObject, Encodable {
    @Published var startTime: Date
    
    @Published private var totalActiveTime: TimeInterval = 0
    @Published private var totalInactiveTime: TimeInterval = 0
    @Published private var active: Bool = true
    
    init() {
        self.startTime = Date()
    }
    
    func switchActiveState() {
        if self.active {
            totalActiveTime += Date().timeIntervalSince(startTime)
        } else {
            totalInactiveTime += Date().timeIntervalSince(startTime)
        }
        
        active.toggle()
        self.startTime = Date()
    }
    
    enum EncodingKeys: String, CodingKey {
        case sessionLength = "sessionLength"
    }
    
    func getTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return timeIntervalToString(interval: self.totalActiveTime)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        try container.encode(timeIntervalToString(interval: self.totalActiveTime), forKey: .sessionLength)
    }
    
    func timeIntervalToString(interval: TimeInterval)->String {
        let hours = Int(interval / 3600)
        let minutes = Int((interval.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(interval.truncatingRemainder(dividingBy: 60))
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
