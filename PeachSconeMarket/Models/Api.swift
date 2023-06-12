//
//  Api.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 8/15/23.
//

import Foundation

class Api:ObservableObject {
    var jwt: String?
    @Published var genderFilter: String = ""
    @Published var typeFilters: [String] = []
    let baseUrl = "api.peachsconemarket.com"
    
    init() throws {
        if let jwtData = KeychainHelper.standard.read(service: "access-token", account: "peachSconeMarket") {
            if let jwtDataUnwrapped = String(data: jwtData, encoding: .utf8) {
                if try checkToken(jwt: jwtDataUnwrapped) {
                    self.jwt = jwtDataUnwrapped
                    return
                } else {
                    KeychainHelper.standard.delete(service: "access-token", account: "peachSconeMarket")
                }
            }
        }
        self.jwt = nil
    }
    
    func setGenderFitler(filter: String) -> Void {
        genderFilter = filter
    }
    
    func setTypeFitler(filters: [String]) -> Void {
        typeFilters = filters
    }
    
    func addTypeFilter(filter: String) -> Void {
        typeFilters.append(filter)
    }
    
    func setJwt(token: String) -> Void {
        self.jwt = token
    }
    
    internal func getGenderFilter() -> String{
        return genderFilter
    }
    
    internal func getTypeFilter() -> String{
        var filterString: String = ""
        
        for filter in typeFilters {
            filterString += filter.lowercased().replacingOccurrences(of: " ", with: "_") + ","
        }
        
        return String(filterString.dropLast());
    }
    
    internal func getQueryParameters()->[URLQueryItem] {
        var urlParameters = [URLQueryItem]()
        if !self.genderFilter.isEmpty {
            urlParameters.append(URLQueryItem(name: "gender", value: self.genderFilter))
        }
        
        if !self.typeFilters.isEmpty {
            urlParameters.append(URLQueryItem(name: "type", value: self.getTypeFilter()))
        }
        
        return urlParameters
    }
    
    internal func checkToken(jwt: String) throws -> Bool {
        let url = URL(string: "https://" + baseUrl  + "/app/checkToken")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
        
        
        var responseStatusCode: Int
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                responseStatusCode = response.statusCode
                if responseStatusCode != 200 {
                    return
                }
            } else {
                responseStatusCode = -1
                return
            }
        }.resume()
        
        
        if responseStatusCode == 200 {
            return true
        } else if responseStatusCode == 403 {
            return false;
        }
        
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    func sendLogin(loginStruct: LoginStruct) throws -> Bool {
        let url = URL(string: "https://" + baseUrl + "/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Host": baseUrl
        ]
        request.httpBody = try JSONEncoder().encode(loginStruct)

        var responseStatusCode: Int
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                responseStatusCode = response.statusCode
                if responseStatusCode != 200 {
                    return
                }
            } else {
                responseStatusCode = -1
                return
            }
            
            if let data = data {
                do {
                    let responseData = try JSONDecoder().decode(LoginResponseStruct.self, from: data)
                    self.jwt = responseData.jwt
                } catch {
                    responseStatusCode = -2
                }
            }
        }.resume()
        
        if responseStatusCode == 200 {
            return true
        } else if responseStatusCode == 400 {
            return false
        } else if responseStatusCode == 403 {
            throw APIError.tooManyAttemptsError
        }
        
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    func sendSignUp(signUpStruct: SignUpStruct) throws -> Bool {
        let url = URL(string: "https://" + baseUrl + "/create")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(signUpStruct)
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Host": baseUrl
        ]
        
        
        var responseStatusCode: Int
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                responseStatusCode = response.statusCode
                if responseStatusCode != 200 {
                    return
                }
            } else {
                responseStatusCode = -1
                return
            }
            
            if let data = data {
                do {
                    let responseData = try JSONDecoder().decode(LoginResponseStruct.self, from: data)
                    self.jwt = responseData.jwt
                } catch {
                    responseStatusCode = -2
                }
            }
        }.resume()
        
        if responseStatusCode == 200 {
            return true
        } else if responseStatusCode == 400 {
            return false
        } else if responseStatusCode == 403 {
            throw APIError.tooManyAttemptsError
        }
        
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    func sendLike(likeStruct: LikeStruct) throws -> Bool {
        if let jwt = self.jwt {
            var request = URLRequest(url: URL(string: "https://" + baseUrl + "/app/" + likeStruct.likeType.rawValue)!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = [
                "Authorization":"Bearer " + jwt,
                "Host":baseUrl,
                "Content-Type":"application/json"
            ]
            
            request.httpBody = try JSONEncoder().encode(likeStruct)
            
            var responseStatusCode: Int
            URLSession.shared.dataTask(with: request) { _, response, error in
                if let response = response as? HTTPURLResponse {
                    responseStatusCode = responseStatusCode
                } else {
                    responseStatusCode = -1
                }
            }.resume()
            
            if responseStatusCode == 200 {
                return true
            }
            
            throw Api.getApiError(statusCode: responseStatusCode)
        }
    }
    
    func loadClothing(completion:@escaping (ClothingItem)->()) throws {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseUrl
        urlComponents.path = "/app/card"
        urlComponents.queryItems = getQueryParameters()
        
        //Starts url request
        if let jwt = self.jwt {
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = [
                "Authorization": "Bearer " + jwt,
                "Host":baseUrl
            ]
            
            
            var responseStatusCode: Int
            var responseData: ClothingItem
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let response=response as? HTTPURLResponse {
                    responseStatusCode = response.statusCode
                } else {
                    responseStatusCode = -1
                    return
                }
                
                if let data = data {
                    do {
                        let responseData = try JSONDecoder().decode(ClothingItem.self, from: data)
                    } catch {
                        responseStatusCode = -2
                    }
                }
            }.resume()
            
            if responseStatusCode == 200 {
                DispatchQueue.main.async {
                    completion(responseData)
                }
            }
            
            throw Api.getApiError(statusCode: responseStatusCode)
        }
        
        throw APIError.invalidToken
     }
    
    func loadClothingPage(collectionType: CollectionStruct.CollectionRequestType, pageNumber: Int?, completion:@escaping ([ClothingItem])->()) throws {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseUrl
        
        if collectionType == CollectionStruct.CollectionRequestType.none {
            throw APIError.generalError
        }
        
        urlComponents.path = "/app/" + collectionType.rawValue
        var parameters:[URLQueryItem] = getQueryParameters()
        if let pageNumber = pageNumber {
            parameters.append(URLQueryItem(name: "page", value: String(pageNumber)))
        }
        urlComponents.queryItems = parameters
        
        //Sends request
        if let jwt = self.jwt {
            var request = URLRequest(url: urlComponents.url!)
            
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = [
                "Host":baseUrl,
                "Authorization":"Bearer " + jwt
            ]
            
            
            var responseStatusCode: Int
            var responseData:CollectionStruct
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let response = response as? HTTPURLResponse {
                    responseStatusCode = response.statusCode
                } else {
                    responseStatusCode = -1
                    return
                }
                
                if let data = data {
                    do {
                        responseData = try JSONDecoder().decode(embeddedStruct.self, from: data).getCollectionStruct()
                    } catch {
                        responseStatusCode = -2
                    }
                }
            }.resume()
            
            if responseStatusCode == 200 {
                DispatchQueue.main.async {
                    completion(responseData.getItems())
                }
            }
            
            throw Api.getApiError(statusCode: responseStatusCode)
        }
        
        throw APIError.invalidToken
    }
    
    func getFilterOptions()->FilterOptionsStruct?{
        //TODO: Get type filters dynamically
        return nil;
    }
    
    
    enum APIError: Error {
        case invalidToken
        case networkError
        case serverError
        case jsonError
        case generalError
        case tooManyAttemptsError
    }
    
    static func getApiError(statusCode: Int)->APIError{
        switch statusCode {
        case let code where code >= 500 && code < 600:
            return APIError.serverError
        case 403:
            return APIError.invalidToken
        case -1:
            return APIError.networkError
        case -2:
            return APIError.jsonError
        default:
            return APIError.generalError
        }
        
    }

}
