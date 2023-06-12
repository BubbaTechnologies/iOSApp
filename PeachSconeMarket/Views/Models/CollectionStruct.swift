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
    
    
    static func collectionRequest(type: CollectionRequestType, clothingType: [String], gender:String, pageNumber: Int?) throws -> [ClothingItem] {
        var clothingType: [String] = clothingType
        for i in 0..<clothingType.count {
            clothingType[i] = clothingType[i].lowercased().replacingOccurrences(of: " ", with: "_")
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.peachsconemarket.com"
        urlComponents.path = "/app/" + type.rawValue
        
        var urlParameters = [URLQueryItem]()
        
        if let pageNumber = pageNumber {
            urlParameters.append(URLQueryItem(name: "page", value: String(pageNumber)))
        }
        
        if (gender != "") {
            urlParameters.append(URLQueryItem(name: "gender", value: gender))
        }
        
        if (clothingType != []) {
            var filterString:String = ""
            for i in clothingType {
                filterString += i + ","
            }
            urlParameters.append(URLQueryItem(name: "type", value: String(filterString.dropLast())))
        }
        urlComponents.queryItems = urlParameters
    
        return try getCollectionRequest(url: urlComponents.url!)
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
    
    enum CollectionRequestType:String {
        case likes = "likes"
        case collection = "collection"
        case cardList = "cardList"
    }
}
