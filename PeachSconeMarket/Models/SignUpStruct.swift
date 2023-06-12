//
//  SignUpStruct.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/11/23.
//

import Foundation

struct SignUpStruct: Codable {
    private let username: String
    private let password: String
    private let gender: String
    private let name: String
    
    init(username: String, password: String, gender:String, name:String) {
        self.username = username
        self.password = password
        self.gender = gender.lowercased()
        self.name = name
    }
}
