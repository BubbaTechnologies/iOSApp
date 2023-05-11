//
//  LoginStruct.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/10/23.
//

import Foundation

struct LoginStruct: Codable {
    let username: String
    let password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    static func loginRequest(loginData: LoginStruct) throws ->String {
        let url = URL(string:"https://api.peachsconemarket.com/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(loginData)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("api.peachsconemarket.com", forHTTPHeaderField: "Host")
        
        var token: String = ""
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            //TODO: Handle http error
            if let data = data {
                let responseData = try! JSONDecoder().decode(LoginResponseStruct.self, from: data)
                token = responseData.jwt
            }
        }.resume()
        
        return token
    }
}

enum HttpError: Error {
    case runtimeError(String)
}

struct LoginResponseStruct:Codable{
    let jwt: String
    let name: String
    let username: String
    init(jwt: String, name: String, username: String) {
        self.jwt = jwt
        self.name = name
        self.username = username
    }
}
