//
//  ProfileStruct.swift
//  Carou
//
//  Created by Matt Groholski on 1/15/24.
//

import Foundation


class ProfileStruct: ObservableObject, Codable {
    @Published var username: String
    @Published var email: String
    @Published var gender: String
    @Published var birthdate: Date
    @Published var privateAccount: Bool
    @Published var password: String
    @Published var dataCollectionPermission:Bool = false
    
    init(username: String, email: String, gender: String, birthdate: Date, privateAccount: Bool) {
        self.username = username
        self.email = email
        self.gender = gender
        self.birthdate = birthdate
        self.privateAccount = privateAccount
        self.password = ""
    }
    
    init(username: String, email: String, password: String, gender: String, birthdate: Date, privateAccount: Bool) {
        self.username = username
        self.email = email
        self.gender = gender
        self.birthdate = birthdate
        self.privateAccount = privateAccount
        self.password = password
    }
    
    init() {
        self.username = ""
        self.email = ""
        self.gender = ""
        self.birthdate = Date()
        self.privateAccount = false
        self.password = ""
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decode(String.self, forKey: .username)
        self.email = try container.decode(String.self, forKey: .email)
        self.gender = try container.decode(String.self, forKey: .gender)
        
        if let date =  ISO8601DateFormatter().date(from: try container.decode(String.self, forKey: .birthdate)) {
            self.birthdate = date
            self.dataCollectionPermission = true
        } else {
            self.birthdate = Date()
            self.dataCollectionPermission = false
        }
        
        self.privateAccount = try container.decode(Bool.self, forKey: .privateAccount)
        
        // Skip decoding the password key
        self.password = ""
    }
    
    func getInitials()->String {
        var initials: String = ""
        
        let substrings = self.username.split(separator: " ")
        for substring in substrings {
            initials += substring.first!.uppercased()
        }
        
        return initials
    }
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case email = "email"
        case gender = "gender"
        case birthdate = "birthdate"
        case privateAccount = "privateAccount"
        case password = "password"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.username, forKey: .username)
        try container.encode(self.password, forKey: .password)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.gender, forKey: .gender)
        try container.encode(self.birthdate, forKey: .birthdate)
        try container.encode(self.privateAccount, forKey: .privateAccount)
    }
    
}
