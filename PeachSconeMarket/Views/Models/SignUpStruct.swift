//
//  SignUpStruct.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/11/23.
//

import Foundation

struct SignUpStruct: Codable {
    let username: String
    let password: String
    let gender: String
    let name: String
    
    init(username: String, password: String, gender:String, name:String) {
        self.username = username
        self.password = password
        self.gender = gender.lowercased()
        self.name = name
    }
    
    static func signUpRequest(signUpData: SignUpStruct) throws -> String {
        let sem = DispatchSemaphore.init(value: 0)
        
        let url = URL(string:"https://api.peachsconemarket.com/create")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(signUpData)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("api.peachsconemarket.com", forHTTPHeaderField: "Host")
        
        var token: String = ""
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            //TODO: Handle http error
            defer{ sem.signal() }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    token = String(response.statusCode)
                    return
                }
            }
            
            if let data = data {
                let responseData = try! JSONDecoder().decode(LoginResponseStruct.self, from: data)
                token = responseData.jwt
            }
        }.resume()
        
        sem.wait()
        
        if token.count == 3 {
            switch token {
            case "400":
                throw HttpError.runtimeError("User Already Exists.")
            default:
                throw HttpError.runtimeError("Connection Error.")
            }
        }
        
        return token
    }
    
}
