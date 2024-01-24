//
//  Api.swift
//  Carou
//
//  Created by Matt Groholski on 8/15/23.
//

import Foundation

class Api:ObservableObject {
    var jwt: String?
    @Published var browser: Bool = false
    @Published var filters: Dictionary<String, [String]> = [:]
    @Published var filterOptionsStruct: FilterOptionsStruct = FilterOptionsStruct.sampleOptions
    @Published var profileInformation: ProfileStruct = ProfileStruct()
    let baseUrl = "api.clothingcarou.com"
    
    init() {
        self.jwt = nil
    }
    
    func setGenderFitler(gender: String) -> Void {
        filters[gender] = []
    }
    
    func addTypeFilter(gender: String, type: String) -> Void {
        filters[gender]?.append(type)
    }
    
    func resetFilters() {
        self.filters = [:]
    }
    
    func setJwt(token: String) -> Void {
        self.jwt = token
    }

    
    //Deteremines if previous token is valid. Returns true if token is valid or else false.
    func loadToken() throws -> Bool {
        if let jwtData = KeychainHelper.standard.read(service: "access-token", account: "clothingCarou") {
            if let jwtDataUnwrapped = String(data: jwtData, encoding: .utf8) {
                if try checkToken(jwt: jwtDataUnwrapped) {
                    self.jwt = jwtDataUnwrapped
                    return true
                } else {
                    KeychainHelper.standard.delete(service: "access-token", account: "clothingCarou")
                }
            }
        }
        self.jwt = nil
        return false
    }
    
    internal func getGenderFilter() -> String {
        let filterKeys = filters.keys.map{String($0)}
        if filterKeys.count > 1 {
            fatalError("Too many gender filter options.")
        } else if filterKeys.count == 0 {
            return ""
        }
        
        return filters.keys.map{String($0)}[0]
    }
    
    internal func getTypeFilter(gender: String) -> String{
        guard let typeFilterArray = self.filters[gender] else {
            fatalError("Filtering types without a gender set.")
        }
    
        var filterString: String = ""
        
        for filter in typeFilterArray {
            filterString += filter.lowercased().replacingOccurrences(of: " & ", with: "_").replacingOccurrences(of: " ", with: "_") + ","
        }
        
        return String(filterString.dropLast());
    }
    
    internal func getQueryParameters()->[URLQueryItem] {
        var urlParameters = [URLQueryItem]()

        let genderFilterString: String = getGenderFilter()
        
        if !genderFilterString.isEmpty {
            urlParameters.append(URLQueryItem(name: "gender", value: genderFilterString))
            let typeFilterString: String = getTypeFilter(gender: genderFilterString)
            if !typeFilterString.isEmpty {
                urlParameters.append(URLQueryItem(name: "type", value: typeFilterString))
            }
        }
        
        return urlParameters
    }
    
    
    /**
     - Description: Checks if JWT string is a valid token. Returns true if server responds 200 and false if 403. Throws an error otherwise.
     */
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
                        KeychainHelper.standard.save(Data(responseData.jwt.utf8), service: "access-token", account: "clothingCarou")
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
    
    func sendSignUp(userClass: UserClass, verificationCode: String) throws -> Bool {
        let url = URL(string: "https://" + baseUrl + "/create?code=" + verificationCode)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(userClass)
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
                        KeychainHelper.standard.save(Data(responseData.jwt.utf8), service: "access-token", account: "clothingCarou")
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
    
    func deleteAccount() throws -> Bool {
        let url = URL(string: "https://" + baseUrl + "/delete")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = [
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
            
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        if responseStatusCode == 200 {
            self.jwt = ""
            return true
        } else if responseStatusCode == 400 {
            return false
        } else if responseStatusCode == 403 {
            //Too many attempts
            responseStatusCode = -3
        }
        
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    /**
        - Description: Sends like data to API.
        - Parameters:
            - likeStruct: A likeStruct representing the data being sent.
        - Throws: Throws an api error if a 200 response is not received.
     */
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
            
            throw Api.getApiError(statusCode: responseStatusCode)
        }
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
    
    /**
        - Description: Requests a activity page from the server.
        - Parameters:
                - pageNumber: An optional integer representing the page requested.
                - completion: A function of the form `[ActivityObject])->()` that deals with the clothing queried
        - Throws: `ApiError.httpError` if the return value is not 200. Check README.md for clarification on codes.
     */
    func loadActivityPage(pageNumber: Int?, completion: @escaping ([ActivityObject], Int)->()) throws {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseUrl
        
        urlComponents.path = "/app/activity"
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var parameters:[URLQueryItem] = getQueryParameters()
        if let pageNumber = pageNumber {
            parameters.append(URLQueryItem(name: "page", value: String(pageNumber)))
        }
        urlComponents.queryItems = parameters
        
        var responseStatusCode = -4
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
    
        if let jwt = self.jwt {
            request.allHTTPHeaderFields = [
                "Host":baseUrl,
                "Authorization": "Bearer " + jwt
            ]
            
            var responseData: [ActivityObject]?
            var pageAmount: Int?
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
                        //Decode data to pass to activity manager
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let activityList = jsonObject["activityList"] as? [[String:Any]], let totalPages = jsonObject["totalPages"] as? Int {
                                pageAmount = totalPages
                                
                                //Iterates over activityList and creates ActivityObject
                                responseData = []
                                for activityItem in activityList {
                                    if let clothingInformation = activityItem["clothingDTO"] as? [String: Any], let profileInformation = activityItem["userProfile"] as? [String: Any] {
                                        //Deals with clothing info
                                        if let clothingInfoAsData = try? JSONSerialization.data(withJSONObject: clothingInformation), let profileInfoAsData = try? JSONSerialization.data(withJSONObject: profileInformation) {
                                            let clothingInfo = try JSONDecoder().decode(ClothingItem.self, from: clothingInfoAsData)
                                            let profileInfo = try JSONDecoder().decode(ActivityProfileStruct.self, from: profileInfoAsData)
                                            responseData?.append(ActivityObject(profile: profileInfo, clothingItem: clothingInfo))
                                        }
                                    }
                                }
                            }
                        }
                    } catch {
                        print("\(error)")
                        if responseStatusCode == 200 {
                            responseStatusCode = -5
                        }
                    }
                }
                semaphore.signal()
            }.resume()
            
            _ = semaphore.wait(timeout: .distantFuture)
            
            if responseStatusCode == 200 {
                if let responseData = responseData, let pageAmount = pageAmount{
                    DispatchQueue.main.async {
                        completion(responseData, pageAmount)
                    }
                    return
                }
            }
        }
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    /**
        - Description: Requests a clothing page from the server. 
        - Parameters:
                - collectionType: `CollectionStruct.CollectionRequestType` representing the request type.
                - pageNumber: An optional integer representing the page requested.
                - userId: I
                - completion: A function of the form `[ClothingItem])->()` that deals with the clothing queried
        - Throws: `ApiError.httpError` if the return value is not 200. Check README.md for clarification on codes.
     */
    
    func loadClothingPage(collectionType: CollectionStruct.CollectionRequestType, pageNumber: Int?, userId: Int?, completion:@escaping ([ClothingItem], Int)->()) throws {
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
        
        if collectionType == .activity {
            if let userId {
                parameters.append(URLQueryItem(name: "userId", value: String(userId)))
            } else {
                throw Api.getApiError(statusCode: -8)
            }
        }
        
        urlComponents.queryItems = parameters
        
        //Sends request
        var responseStatusCode: Int = -4
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        if let jwt = self.jwt {
            request.allHTTPHeaderFields = [
                "Host": baseUrl,
                "Authorization":"Bearer " + jwt
            ]
        } else if collectionType == .preview {
            request.allHTTPHeaderFields = [
                "Host": baseUrl
            ]
        } else {
            throw Api.getApiError(statusCode: responseStatusCode)
        }
        
        var responseData:CollectionStruct?
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
//                    print(String(data: data, encoding: .utf8)!)
                    responseData = Optional.some(try JSONDecoder().decode(CollectionStruct.self, from: data))
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
            if let responseData = responseData {
                DispatchQueue.main.async {
                    var itemCollection = responseData.getItems()
                    if (collectionType == CollectionStruct.CollectionRequestType.cardList) {
                        itemCollection.reverse()
                    }
                    completion(itemCollection, responseData.getTotalPageCount())
                }
                return
            }
        }
        
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    
    /**
        - Description: Loads the filter options from the API.
        - Throws: `ApiError.httpError` if the return value is not 200. Check README.md for clarification on codes.
     */
    func loadFilterOptions(type: FilterType) throws {
        let semaphore = DispatchSemaphore(value: 0)
        
        var responseStatusCode: Int = 0
        let urlString = "https://" + baseUrl + "/app/filterOptions"
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "type", value: type.rawValue)
        ]
        guard let finalUrl = urlComponents?.url else {
            fatalError("Invalid URL in loadFilterOptions.")
        }
        
        var request = URLRequest(url: finalUrl)
        request.httpMethod = "GET"
        if let jwt = self.jwt {
            request.allHTTPHeaderFields = [
                "Host": baseUrl,
                "Authorization": "Bearer " + jwt
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
                        let filterData = try JSONDecoder().decode([String : [String : [String : [String]]]].self, from: data)
                        responseData = FilterOptionsStruct(filterOptions: filterData["genders"]!)
                    } catch {
                        if String(data: data, encoding: .utf8) != Optional("") {
                            print("Error in Filter Options: \(error)")
                            responseStatusCode = -2
                        } else {
                            responseStatusCode = 200
                        }
                    }
                }
                semaphore.signal()
            }.resume()
            
            _ = semaphore.wait(timeout: .distantFuture)
            if responseStatusCode == 200 {
                DispatchQueue.main.sync {
                    self.filterOptionsStruct = responseData
                }
                return
            }
        }
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    /**
        - Parameters:
            - latitude: A double representing the users latitude.
            - longitude: A double representing the users longitude.
        - Throws: `ApiError.httpError` if the return value is not 200. Check README.md for clarification on codes.
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
    
    /**
        - Description: Loads profile information and stores within API class.
     */
    func loadProfile() throws {
        var responseStatusCode: Int = -4
        let semaphore = DispatchSemaphore(value: 0)
        if let jwt = self.jwt {
            var request = URLRequest(url: URL(string: "https://" + baseUrl + "/app/userInfo")!)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = [
                "Authorization":"Bearer " + jwt,
                "Host": baseUrl
            ]
            
            var responseData: ProfileStruct = ProfileStruct()
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let response = response as? HTTPURLResponse {
                    responseStatusCode = response.statusCode
                } else {
                    responseStatusCode = -1
                }
                
                if let data = data  {
                    do {
                        responseData = try JSONDecoder().decode(ProfileStruct.self, from: data)
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
                DispatchQueue.main.sync{
                    self.profileInformation = responseData
                }
                return
            }
        }
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    /**
        - Parameters:
            - deviceId: A string representing the device's ARN token.
        - Throws: `ApiError.httpError` if the return value is not 200. Check README.md for clarification on codes.
     */
    func updateDeviceId(deviceId: String) throws {
        var responseStatusCode: Int = -4
        let semaphore = DispatchSemaphore(value: 0)
        if let jwt = self.jwt {
            var request = URLRequest(url: URL(string: "https://" + baseUrl + "/app/updateDeviceId")!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = [
                "Authorization":"Bearer " + jwt,
                "Host": baseUrl,
                "Content-Type":"application/json"
            ]
            
            var locationData: [String: String] = [:]
            locationData["deviceId"] = deviceId
            
            
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
    
    /**
        - Description: Sends a search query to the API.
        -  Parameters:
                - query: String
        - Throws: `ApiError.httpError` if the return value is not 200. Check README.md for clarification on codes.
     */
    func searchUsers(query: String, completion:@escaping ([ActivityProfileStruct])->()) throws {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseUrl
        
        urlComponents.path = "/app/searchProfiles"
        var urlParameters = [URLQueryItem]()
        urlParameters.append(URLQueryItem(name: "query", value: query))
        urlComponents.queryItems = urlParameters
        
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var responseStatusCode = -4
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
    
        if let jwt = self.jwt {
            request.allHTTPHeaderFields = [
                "Host":baseUrl,
                "Authorization": "Bearer " + jwt
            ]
            
            var responseData: [ActivityProfileStruct]?
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
                        //Decode data to pass to activity manager
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let profileList = jsonObject["profiles"] as? [[String:Any]] {
                                //Iterates over activityList
                                responseData = []
                                for profile in profileList {
                                    if let profile = try? JSONSerialization.data(withJSONObject: profile) {
                                        responseData!.append(try JSONDecoder().decode(ActivityProfileStruct.self, from: profile))
                                    }
                                }
                            }
                        }
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
                if let responseData = responseData {
                    DispatchQueue.main.async {
                        completion(responseData)
                    }
                    return
                }
            }
        }
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    /**
        - Description: Gets requested user infromation.
        - Throws: `ApiError.httpError` if the return value is not 200. Check README.md for clarification on codes.
     */
    func loadRequested(completion:@escaping ([ActivityProfileStruct])->()) throws {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseUrl
        
        urlComponents.path = "/app/followRequests"
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var responseStatusCode = -4
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
    
        if let jwt = self.jwt {
            request.allHTTPHeaderFields = [
                "Host":baseUrl,
                "Authorization": "Bearer " + jwt
            ]
            
            var responseData: [ActivityProfileStruct]?
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
                        //Decode data to pass to activity manager
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let profileList = jsonObject["profiles"] as? [[String:Any]] {
                                //Iterates over activityList
                                responseData = []
                                for profile in profileList {
                                    if let profile = try? JSONSerialization.data(withJSONObject: profile) {
                                        responseData!.append(try JSONDecoder().decode(ActivityProfileStruct.self, from: profile))
                                    }
                                }
                            }
                        }
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
                if let responseData = responseData {
                    DispatchQueue.main.async {
                        completion(responseData)
                    }
                    return
                }
            }
        }
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    
    /**
        - Description: Sends a request action.
        - Parameters:
            - userId: The userId of the user being accepted/denied.
            - approved: A boolean representing if the user is approved or denied.
        - Throws: `ApiError.httpError` if the return value is not 200. Check README.md for clarification on codes.
     */
    func requestAction(userId: Int, approved: Bool) throws {
        var responseStatusCode: Int = -4
        let semaphore = DispatchSemaphore(value: 0)
        if let jwt = self.jwt {
            var request = URLRequest(url: URL(string: "https://" + baseUrl + "/app/followRequestAction")!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = [
                "Authorization":"Bearer " + jwt,
                "Host": baseUrl,
                "Content-Type":"application/json"
            ]
            
            var userInformation: [String: Any] = [:]
            userInformation["userId"] = userId
            userInformation["approve"] = approved
            
            let jsonData = try JSONSerialization.data(withJSONObject: userInformation, options: [])
            request.httpBody = jsonData
            
            
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
    
    
    /**
        - Description: Sends follow request to API.
        - Parameters:
            - newFollowingStatus: The following status that the api should update to.
            - userId: The userId of the user being followed/requested.
        - Throws: `ApiError.httpError` if the return value is not 200. Check README.md for clarification on codes.
     */
    func sendFollowRequest(newFollowingStatus: ActivityProfileStruct.FollowingStatus, userId: Int) throws {
        var responseStatusCode: Int = -4
        let semaphore = DispatchSemaphore(value: 0)
        if let jwt = self.jwt {
            var pathString = ""
            if newFollowingStatus == .following || newFollowingStatus == .requested {
                pathString = "/follow"
            } else {
                pathString = "/unfollow"
            }
            
            var request = URLRequest(url: URL(string: "https://" + baseUrl + "/app" + pathString)!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = [
                "Authorization":"Bearer " + jwt,
                "Host": baseUrl,
                "Content-Type":"application/json"
            ]
            
            var userInformation: [String: Int] = [:]
            userInformation["userId"] = userId
            
            request.httpBody = try JSONEncoder().encode(userInformation)
            
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
    
    /**
        - Parameters:
            - userEmail:  A string representing the users email.
        - Returns:
            - A bool that represents if the email verification was sent.
        - Throws:
            - `ApiError.httpError` if the return value is not 200. Check README.md for clarification on codes.
     */
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
    
    func loadBrowsing() throws {
        var responseStatusCode: Int = -4
        let semaphore = DispatchSemaphore(value: 0)
        var request = URLRequest(url: URL(string: "https://" + baseUrl + "/browsing")!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Host": baseUrl
        ]
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse {
                responseStatusCode = response.statusCode
            } else {
                responseStatusCode = -1
            }
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        DispatchQueue.main.sync {
            if responseStatusCode == 200 {
                self.browser = true
            } else if responseStatusCode == 400 {
                self.browser = false
            }
        }
        
        if responseStatusCode == 400 || responseStatusCode == 200 {
            return
        }
        
        
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    /**
        - Parameters:
            - userClass: The class holding the updated information.
        - Throws: `ApiError.httpError` if the return value is not 200. Check README.md for clarification on codes.
     */
    func sendUpdate(profileStruct: ProfileStruct) throws {
        var responseStatusCode: Int = -4
        let semaphore = DispatchSemaphore(value: 0)
        
        let url = URL(string: "https://" + baseUrl + "/updateUserInfo")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //TODO: Properly encode
        request.httpBody = try JSONEncoder().encode(profileStruct)
        if let jwt = jwt {
            request.allHTTPHeaderFields = [
                "Authorization" : "Bearer " + jwt,
                "Content-Type": "application/json",
                "Host": baseUrl
            ]
            
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
                            KeychainHelper.standard.save(Data(responseData.jwt.utf8), service: "access-token", account: "clothingCarou")
                        } catch {
                            responseStatusCode = -2
                        }
                    }
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
    
    enum ApiError: Error {
        case httpError(String)
    }
    
    enum FilterType: String {
        case likes = "likes"
        case activity = "activity"
        case general = "general"
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
        case -8:
            return ApiError.httpError("Invalid query parameters.")
        default:
            return ApiError.httpError("It's not you it's us. Status Code: \(statusCode)")
        }
    }

}
