//
//  ActivityProfileStruct.swift
//  Carou
//
//  Created by Matt Groholski on 1/16/24.
//

import Foundation

struct ActivityProfileStruct: Decodable {
    var id: Int
    var username: String
    var privateAccount: Bool
    
    init(id: Int, username: String, privateAccount: Bool) {
        self.id = id
        self.username = username
        self.privateAccount = privateAccount
    }
    
    init() {
        self.id = -1
        self.username = ""
        self.privateAccount = false
    }
    
    func getInitials() -> String {
        var initials: String = ""
        
        let substrings = self.username.split(separator: " ")
        for substring in substrings {
            initials += substring.first!.uppercased()
        }
        
        return initials
    }
}
