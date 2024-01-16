//
//  UserClass.swift
//  Carou
//
//  Created by Matt Groholski on 5/11/23.
//

import Foundation

/**
        -Description: Used to send sign up data.
 */
class UserClass: ObservableObject, Encodable {
    @Published var username: String
    @Published var email: String
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
        self.email = ""
        self.birthdate = Date()
    }
    
    init(username: String, email: String ,password: String, gender:String, name:String, date: Date) {
        self.username = username
        self.password = password
        self.email = email
        self.gender = gender.lowercased()
        self.birthdate = Date()
    }
    
    init(from profileStruct: ProfileStruct) {
        self.username = profileStruct.username
        self.email = profileStruct.email
        self.password = ""
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: profileStruct.birthdate){
            self.birthdate = date
            self.dataCollectionPermission = true
        } else {
            self.birthdate = Date()
            self.dataCollectionPermission = false
        }
        self.gender = profileStruct.gender
    }
    
    enum EncodingKeys: String, CodingKey {
        case username
        case password
        case gender
        case birthdate
        case email
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
        try container.encode(email, forKey: .email)
        try container.encode(gender, forKey: .gender)
        if dataCollectionPermission == true {
            try container.encode(dateFormatter.string(from: birthdate), forKey: .birthdate)
        } else {
            try container.encodeNil(forKey: .birthdate)
        }
    }
}


