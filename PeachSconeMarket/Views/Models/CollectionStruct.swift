//
//  CollectionStruct.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/12/23.
//

import Foundation

struct embeddedStruct: Codable {
    private let _embedded: CollectionStruct
    
    init(_embedded: CollectionStruct) {
        self._embedded = _embedded
    }
    
    func getItems()->[ClothingItem]{
        return self._embedded.getItems()
    }
}

struct CollectionStruct: Codable {
    private let clothingDTOList: [ClothingItem]
    
    init(clothingDTOList: [ClothingItem]) {
        self.clothingDTOList = clothingDTOList
    }
    
    func getItems()->[ClothingItem]{
        return self.clothingDTOList
    }
    
    
    
    
    static func collectionRequest(type: String, clothingType: [String], gender:String) throws -> [ClothingItem] {
        var clothingType: [String] = clothingType
        for i in 0..<clothingType.count {
            clothingType[i] = clothingType[i].lowercased().replacingOccurrences(of: " ", with: "_")
        }
        
        if (gender == "" && clothingType == []) {
            return try collectionRequest(type: type)
        } else if (gender == "") {
            return try collectionRequest(type: type, clothingType: clothingType)
        } else if (clothingType == []) {
            return try collectionRequest(type: type, gender: gender)
        }
        
        var filterString:String = ""
        for i in clothingType {
            filterString += i + ","
        }
        
        return try getCollectionRequest(url: URL(string: getUrlByType(type: type) + "?gender=\(gender)&type=\(filterString.dropLast())")!)
    }
    
    private static func collectionRequest(type: String) throws -> [ClothingItem] {
        return try getCollectionRequest(url: URL(string: getUrlByType(type: type))!)
    }
    
    private static func collectionRequest(type: String, clothingType: [String]) throws -> [ClothingItem] {
        var filterString:String = ""
        for i in clothingType {
            filterString += i + ","
        }
        return try getCollectionRequest(url: URL(string: getUrlByType(type: type) + "?type=\(filterString.dropLast())")!)
    }
    
    private static func collectionRequest(type: String, gender: String) throws -> [ClothingItem] {
        return try getCollectionRequest(url: URL(string: getUrlByType(type: type) + "?gender=\(gender)")!)
    }
    
    private static func getUrlByType(type: String) throws -> String {
        if type.lowercased() == "likes" {
            return "https://api.peachsconemarket.com/app/likes"
        } else if type.lowercased() == "collection" {
                return "https://api.peachsconemarket.com/app/collection"
        } else {
            throw HttpError.runtimeError("Invalid type.")
        }
    }
    
    private static func getCollectionRequest(url: URL) throws -> [ClothingItem] {
        let token: String = String(data: KeychainHelper.standard.read(service: "access-token", account: "peachSconeMarket")!,encoding: .utf8)!
        let sem = DispatchSemaphore.init(value: 0)
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Host":"api.peachsconemarket.com",
            "Authorization":"Bearer " + token
        ]
        
        var statusCode:String = ""
        var returnList:[ClothingItem] = []
        var errorMessage: String = ""
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            defer{ sem.signal() }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    statusCode = String(response.statusCode)
                    return
                }
            }
            
            if let data = data {
                do {
                    let responseData = try JSONDecoder().decode(embeddedStruct.self, from: data)
                    returnList = responseData.getItems()
                } catch {
                    errorMessage = "\(error)"
                    return
                }
            }
        }.resume()
        
        sem.wait()
        
        if !statusCode.isEmpty {
            throw HttpError.runtimeError("Connection Error: Status Code " + statusCode)
        } else if returnList.isEmpty {
            throw HttpError.runtimeError("Connection Error: \(errorMessage).")
        }
        
        return returnList
    }
}
