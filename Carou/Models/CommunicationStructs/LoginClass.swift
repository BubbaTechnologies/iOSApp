//
//  LoginClass.swift
//  Carou
//
//  Created by Matt Groholski on 5/10/23.
//

import Foundation

class LoginClass: ObservableObject, Encodable {
    @Published var email: String
    @Published var password: String
    
    init () {
        self.email = ""
        self.password = ""
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    enum EncodingKeys: String, CodingKey {
        case email
        case password
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
    }
}

struct LoginResponseStruct:Decodable{
    let jwt: String
    let email: String
    init(jwt: String, username: String) {
        self.jwt = jwt
        self.email = username
    }
}
