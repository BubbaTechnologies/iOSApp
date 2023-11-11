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
    @Published var typeFilters: [String:Bool] = [:]
    @Published var filterOptionsStruct: FilterOptionsStruct = FilterOptionsStruct.sampleOptions
    let baseUrl = "api.peachsconemarket.com"
    
    init() {
        self.jwt = nil
    }
    
    func setGenderFitler(filter: String) -> Void {
        genderFilter = filter.lowercased()
    }
    
    func addTypeFilter(filter: String) -> Void {
        typeFilters[filter] = true
    }
    
    func resetTypeFilters() {
        for filter in self.typeFilters.keys {
            self.typeFilters[filter] = false
        }
    }
    
    func resetGenderFilter() {
        self.genderFilter = ""
    }
    
    func setJwt(token: String) -> Void {
        self.jwt = token
    }
    
    //Deteremines if previous token is valid. Returns true if token is valid or else false.
    func loadToken() throws -> Bool {
        if let jwtData = KeychainHelper.standard.read(service: "access-token", account: "peachSconeMarket") {
            if let jwtDataUnwrapped = String(data: jwtData, encoding: .utf8) {
                if try checkToken(jwt: jwtDataUnwrapped) {
                    self.jwt = jwtDataUnwrapped
                    return true
                } else {
                    KeychainHelper.standard.delete(service: "access-token", account: "peachSconeMarket")
                }
            }
        }
        self.jwt = nil
        return false
    }
    
    internal func getGenderFilter() -> String{
        return genderFilter
    }
    
    internal func getTypeFilter() -> String{
        var filterString: String = ""
        
        for filter in typeFilters {
            if filter.value {
                filterString += filter.key.lowercased().replacingOccurrences(of: " & ", with: "_").replacingOccurrences(of: " ", with: "_") + ","
            }
        }
        
        return String(filterString.dropLast());
    }
    
    internal func getQueryParameters()->[URLQueryItem] {
        var urlParameters = [URLQueryItem]()

        let genderFilterString: String = getGenderFilter()
        if !genderFilterString.isEmpty {
            urlParameters.append(URLQueryItem(name: "gender", value: genderFilterString))
        }
        
        let typeFilterString: String = getTypeFilter()
        if !typeFilterString.isEmpty {
            urlParameters.append(URLQueryItem(name: "type", value: typeFilterString))
        }
        
        return urlParameters
    }
    
    
    // Description: Checks if JWT string is a valid token. Returns true if server responds 200 and false if 403. Throws an error otherwise.
    internal func checkToken(jwt: String) throws -> Bool {
        let url = URL(string: "https://" + baseUrl  + "/app/checkToken")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
        
        
        var responseStatusCode: Int = 0
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                responseStatusCode = response.statusCode
            } else {
                responseStatusCode = -1
            }
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        if responseStatusCode == 200 {
            return true
        } else if responseStatusCode == 403 {
            return false;
        }
        
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    func sendLogin(loginClass: LoginClass) throws -> Bool {
        let url = URL(string: "https://" + baseUrl + "/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Host": baseUrl
        ]
        request.httpBody = try JSONEncoder().encode(loginClass)

        var responseStatusCode: Int = 0
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                responseStatusCode = response.statusCode
            } else {
                responseStatusCode = -1
            }
            if responseStatusCode == 200 {
                if let data = data {
                    do {
                        let responseData = try JSONDecoder().decode(LoginResponseStruct.self, from: data)
                        self.jwt = responseData.jwt
                        KeychainHelper.standard.save(Data(responseData.jwt.utf8), service: "access-token", account: "peachSconeMarket")
                    } catch {
                        responseStatusCode = -2
                    }
                }
            }
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        if responseStatusCode == 200 {
            return true
        } else if responseStatusCode == 400 {
            return false
        } else if responseStatusCode == 403 {
            responseStatusCode = -3
        }
        
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    func sendSignUp(signUpClass: SignUpClass, verificationCode: String) throws -> Bool {
        let url = URL(string: "https://" + baseUrl + "/create?code=" + verificationCode)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(signUpClass)
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Host": baseUrl
        ]
        
        
        var responseStatusCode: Int = 0
        let semaphore = DispatchSemaphore(value: 0)
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
            if responseStatusCode == 200 {
                if let data = data {
                    do {
                        let responseData = try JSONDecoder().decode(LoginResponseStruct.self, from: data)
                        self.jwt = responseData.jwt
                        KeychainHelper.standard.save(Data(responseData.jwt.utf8), service: "access-token", account: "peachSconeMarket")
                    } catch {
                        responseStatusCode = -2
                    }
                }
            }
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        if responseStatusCode == 200 {
            return true
        } else if responseStatusCode == 400 {
            return false
        } else if responseStatusCode == 403 {
            //Too many attempts
            responseStatusCode = -3
        }
        
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    func sendLike(likeStruct: LikeStruct) throws -> Void {
        var responseStatusCode: Int = -4
        let semaphore = DispatchSemaphore(value: 0)
        if let jwt = self.jwt {
            var request = URLRequest(url: URL(string: "https://" + baseUrl + "/app/" + likeStruct.likeType.rawValue)!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = [
                "Authorization":"Bearer " + jwt,
                "Host": baseUrl,
                "Content-Type":"application/json"
            ]
            
            request.httpBody = try JSONEncoder().encode(likeStruct)
            
            URLSession.shared.dataTask(with: request) { _, response, error in
                if let response = response as? HTTPURLResponse {
                    responseStatusCode = response.statusCode
                } else {
                    responseStatusCode = -1
                }
                semaphore.signal()
            }.resume()
            
            _ = semaphore.wait(timeout: .distantFuture)
            if responseStatusCode == 200 {
                return
            }
        }
        
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    func loadClothing(completion:@escaping (Result<ClothingItem, Error>)->()) throws {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseUrl
        urlComponents.path = "/app/card"
        urlComponents.queryItems = getQueryParameters()
        
        //Starts url request
        var responseStatusCode: Int = -4
        if let jwt = self.jwt {
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = [
                "Authorization": "Bearer " + jwt,
                "Host":baseUrl
            ]
            
            URLSession.shared.dataTask(with: request){ data, response, error in
                if let response=response as? HTTPURLResponse {
                    responseStatusCode = response.statusCode
                } else {
                    responseStatusCode = -1
                    return
                }
                
                if let data = data {
                    do {
                        let responseData = try JSONDecoder().decode(ClothingItem.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(responseData))
                        }
                    } catch {
                        responseStatusCode = -2
                    }
                }
                DispatchQueue.main.async {
                    completion(.failure(Api.getApiError(statusCode: responseStatusCode)))
                }
            }.resume()
        }
     }
    
    func loadClothingPage(collectionType: CollectionStruct.CollectionRequestType, pageNumber: Int?, completion:@escaping ([ClothingItem])->()) throws {
        //Builds URL
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseUrl
        
        if collectionType == CollectionStruct.CollectionRequestType.none {
            return
        }

        urlComponents.path = "/app/" + collectionType.rawValue
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var parameters:[URLQueryItem] = getQueryParameters()
        if let pageNumber = pageNumber {
            parameters.append(URLQueryItem(name: "page", value: String(pageNumber)))
        }
        urlComponents.queryItems = parameters
        
        //Sends request
        var responseStatusCode: Int = -4
        if let jwt = self.jwt {
            var request = URLRequest(url: urlComponents.url!)
            
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = [
                "Host": baseUrl,
                "Authorization":"Bearer " + jwt
            ]
            
            var responseData:CollectionStruct = CollectionStruct()
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let response = response as? HTTPURLResponse {
                    responseStatusCode = response.statusCode
                } else {
                    responseStatusCode = -1
                    semaphore.signal()
                    return
                }
                
                if let data = data {
                    do {
//                        print(String(data: data, encoding: .utf8)!)
                        responseData = try JSONDecoder().decode(embeddedStruct.self, from: data).getCollectionStruct()
                    } catch {
                        if responseStatusCode == 200 {
                            responseStatusCode = -5
                        }
                    }
                }
                semaphore.signal()
            }.resume()
            
            _ = semaphore.wait(timeout: .distantFuture)
            if responseStatusCode == 200 {
                DispatchQueue.main.async {
                    var itemCollection = responseData.getItems()
                    if (collectionType == CollectionStruct.CollectionRequestType.cardList) {
                        itemCollection.reverse()
                    }
                    completion(itemCollection)
                }
                return
            }
        }
        
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    
    //Loads the filter options from the API
    func loadFilterOptions() throws {
        let semaphore = DispatchSemaphore(value: 0)
        
        var responseStatusCode: Int = 0
        var request = URLRequest(url: URL(string: "https://" + baseUrl + "/app/filterOptions")!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Host": baseUrl
        ]

        var responseData: FilterOptionsStruct = FilterOptionsStruct()
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                responseStatusCode = response.statusCode
            } else {
                responseStatusCode = -1
                return
            }

            if let data = data {
                do {
                    let filterOptions = try JSONDecoder().decode(FilterOptions.self, from: data)
                    responseData = FilterOptionsStruct(filterOptions: filterOptions)
                } catch {
                    responseStatusCode = -2
                }
            }
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        if responseStatusCode == 200 {
            DispatchQueue.main.sync {
                for type in responseData.getUniqueTypes() {
                    self.typeFilters[type] = false
                }
                
                self.filterOptionsStruct = responseData
            }
            return
        }
        
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    /**
                - Parameters:
                    - latitude: A double representing the users latitude.
                    - longitude: A double representing the users longitude.
                - Throws: `ApiError.httpError` if the return value is not 200. Check documentation for clarification on codes.
     */
    func updateLocation(latitude: Double, longitude: Double) throws {
        var responseStatusCode: Int = -4
        let semaphore = DispatchSemaphore(value: 0)
        if let jwt = self.jwt {
            var request = URLRequest(url: URL(string: "https://" + baseUrl + "/app/updateLocation")!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = [
                "Authorization":"Bearer " + jwt,
                "Host": baseUrl,
                "Content-Type":"application/json"
            ]
            
            var locationData: [String: Double] = [:]
            locationData["latitude"] = latitude
            locationData["longitude"] = longitude
            
            request.httpBody = try JSONEncoder().encode(locationData)
            
            URLSession.shared.dataTask(with: request) { _, response, error in
                if let response = response as? HTTPURLResponse {
                    responseStatusCode = response.statusCode
                } else {
                    responseStatusCode = -1
                }
                semaphore.signal()
            }.resume()
            
            _ = semaphore.wait(timeout: .distantFuture)
            if responseStatusCode == 200 {
                return
            }
        }
        
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    func requestVerification(userEmail: String) throws -> Bool {
        var responseStatusCode: Int = -4
        let semaphore = DispatchSemaphore(value: 0)
        var request = URLRequest(url: URL(string: "https://" + baseUrl + "/verify")!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Host": baseUrl,
            "Content-Type":"application/json"
        ]
        
        var requestData: [String: String] = [:]
        requestData["email"] = userEmail
        
        request.httpBody = try JSONEncoder().encode(requestData)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse {
                responseStatusCode = response.statusCode
            } else {
                responseStatusCode = -1
            }
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        if responseStatusCode == 200 {
            return true
        } else if responseStatusCode == 400 {
            return false
        }
        
        
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    enum ApiError: Error {
        case httpError(String)
    }
    
    static func getApiError(statusCode: Int) -> ApiError{
        switch statusCode {
        case 403:
            return ApiError.httpError("Authentication error.")
        case let code where code >= 500 && code < 600:
            return ApiError.httpError("Server Error. Status Code: \(statusCode)")
        case -3:
            return ApiError.httpError("Please wait an hour before attempting to authenticate again.")
        case -4:
            return ApiError.httpError("Invalid token.")
        default:
            return ApiError.httpError("It's not you it's us. Status Code: \(statusCode)")
        }
    }

}
