//
//  SignUpClass.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/11/23.
//

import Foundation

class SignUpClass: ObservableObject, Encodable {
    @Published var username: String
    @Published var password: String
    @Published var gender: String
    
    init () {
        self.username = ""
        self.password = ""
        self.gender = ""
    }
    
    init(username: String, password: String, gender:String, name:String) {
        self.username = username
        self.password = password
        self.gender = gender.lowercased()
    }
    
    enum EncodingKeys: String, CodingKey {
        case username
        case password
        case gender
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
        try container.encode(gender, forKey: .gender)
    }
}


