//
//  LoginClass.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/10/23.
//

import Foundation

class LoginClass: ObservableObject, Encodable {
    @Published var username: String
    @Published var password: String
    
    init () {
        self.username = ""
        self.password = ""
    }
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    enum EncodingKeys: String, CodingKey {
        case username
        case password
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
    }
}

struct LoginResponseStruct:Decodable{
    let jwt: String
    let username: String
    init(jwt: String, username: String) {
        self.jwt = jwt
        self.username = username
    }
}
