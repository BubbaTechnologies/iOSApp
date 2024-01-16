//
//  ProfileStruct.swift
//  Carou
//
//  Created by Matt Groholski on 1/15/24.
//

import Foundation


struct ProfileStruct: Decodable {
    var username: String
    var email: String
    var gender: String
    var birthdate: String
    var privateAccount: Bool
    
    init(username: String, email: String, gender: String, birthdate: String, privateAccount: Bool) {
        self.username = username
        self.email = email
        self.gender = gender
        self.birthdate = birthdate
        self.privateAccount = privateAccount
    }
    
    init() {
        self.username = ""
        self.email = ""
        self.gender = ""
        self.birthdate = ""
        self.privateAccount = false
    }
    
    func getInitials()->String {
        var initials: String = ""
        
        let substrings = self.username.split(separator: " ")
        for substring in substrings {
            initials += substring.first!.uppercased()
        }
        
        return initials
    }
}
