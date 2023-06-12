//
//  LoginStruct.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/10/23.
//

import Foundation

struct LoginStruct: Codable {
    private let username: String
    private let password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

struct LoginResponseStruct:Codable{
    let jwt: String
    let username: String
    init(jwt: String, username: String) {
        self.jwt = jwt
        self.username = username
    }
}
