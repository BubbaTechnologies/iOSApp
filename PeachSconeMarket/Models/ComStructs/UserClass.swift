//
//  UserClass.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/11/23.
//

import Foundation

class UserClass: ObservableObject, Encodable {
    @Published var username: String
    @Published var password: String
    @Published var gender: String
    @Published var birthdate: Date
    @Published var dataCollectionPermission: Bool? = nil
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    init () {
        self.username = ""
        self.password = ""
        self.gender = ""
        self.birthdate = Date()
    }
    
    init(username: String, password: String, gender:String, name:String, date: Date) {
        self.username = username
        self.password = password
        self.gender = gender.lowercased()
        self.birthdate = Date()
    }
    
    enum EncodingKeys: String, CodingKey {
        case username
        case password
        case gender
        case birthdate
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
        try container.encode(gender, forKey: .gender)
        if dataCollectionPermission == true {
            try container.encode(dateFormatter.string(from: birthdate), forKey: .birthdate)
        } else {
            try container.encode("null" ,forKey: .birthdate)
        }
    }
}


