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
    
    
    /**
            - Description: Sets the gender to filter by.
            - Parameters: gender: The string representing the gender to filter by.
     */
    func setGenderFitler(gender: String) -> Void {
        filters[gender] = []
    }
    
    /**
            - Description: Sets the type to filter by.
            - Parameters: 
                gender: The string representing the gender to filter by.
                type: The string representing the type to filter by.
     */
    func addTypeFilter(gender: String, type: String) -> Void {
        filters[gender]?.append(type)
    }
    
    /**
        - Description: Resets the filters.
     */
    func resetFilters() {
        self.filters = [:]
    }
    
    /**
        - Description: Sets the JWT string.
     */
    func setJwt(token: String) -> Void {
        self.jwt = token
    }

    
    /**
        - Description: Deteremines if previous token is valid. Returns true if token is valid or else false.
        - Throws:ApiError if checkToken does not see a 200 or 403 response.
     */
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
    
    /**
            - Description: Returns gender filters as string.
     */
    internal func getGenderFilter() -> String {
        let filterKeys = filters.keys.map{String($0)}
        if filterKeys.count > 1 {
            fatalError("Too many gender filter options.")
        } else if filterKeys.count == 0 {
            return ""
        }
        
        return filters.keys.map{String($0)}[0]
    }
    
    /**
            - Description: Returns type filters as string.
     */
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
    
    /**
            - Description: Returns URLQueryParameters from existing type and gender filters.
     */
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
                - Description: Sends request to request.
                - Parameters: request: A URLRequest containing the request information.
     */
    internal func sendRequest(request: URLRequest) -> Int {
        return sendRequest(request: request, completion: {_ in})
    }
    
    /**
                - Description: Sends request to request and passes the data to the completion.
                - Parameters:
                    request: A URLRequest containing the request information.
                    completion: Decode the data and store within requesting function.
     */
    internal func sendRequest(request: URLRequest, completion: @escaping (Data) throws -> Void) -> Int {
        var responseStatusCode: Int = 0
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request){ data, response, error in
            if let response = response as? HTTPURLResponse {
                responseStatusCode = response.statusCode
            } else {
                responseStatusCode = -1
                semaphore.signal()
                return
            }
            
            if responseStatusCode == 200 {
                if let data = data {
                    do {
                        try completion(data)
                    } catch {
                        responseStatusCode = -2
                    }
                }
            }
            
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        return responseStatusCode;
    }
    
    /**
                - Description: Sends request to request async.
                - Parameters: request: A URLRequest containing the request information.
     */
    internal func sendRequestAsync(request: URLRequest) -> Int {
        return sendRequestAsync(request: request, completion: {_ in})
    }
    
    /**
                - Description: Sends request to `request.url` async and passes the data to the completion.
                - Parameters:
                    request: A URLRequest containing the request information.
                    completion: Decode the data and store within requesting function.
     */
    internal func sendRequestAsync(request: URLRequest, completion: @escaping (Data) throws -> Void) -> Int {
        var responseStatusCode: Int = 0
        URLSession.shared.dataTask(with: request){ data, response, error in
            if let response = response as? HTTPURLResponse {
                responseStatusCode = response.statusCode
            } else {
                responseStatusCode = -1
                return
            }
            
            if responseStatusCode == 200 {
                if let data = data {
                    do {
                        try completion(data)
                    } catch {
                        responseStatusCode = -2
                    }
                }
            }
        }.resume()
        
        return responseStatusCode;
    }
    
    /**
     - Description: Checks if JWT string is a valid token.
     - Parameters:
            jwt: A string representing the JWT being checked.
     - Throws: ApiError that covers unexpected return values.
     - Returns: True if server responds 200 and false if 403.
     */
    internal func checkToken(jwt: String) throws -> Bool {
        let url = URL(string: "https://" + baseUrl  + "/app/checkToken")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + jwt, forHTTPHeaderField: "Authorization")
        
        let responseStatusCode: Int = sendRequest(request: request)
        
        if responseStatusCode == 200 {
            return true
        } else if responseStatusCode == 403 {
            return false;
        }
        
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    /**
        - Description: Returns headers for each ``HttpRequestType``.
        - Parameters:
                - requestType: ``HttpRequestType`` for request.
                - jwt: The `jwt` string for auth requests.
        - Returns: Dictionary of headers
     */
    internal func getHeaders(requestType: HttpRequestType, jwt: String?) -> [String:String] {
        switch requestType {
        case .get_no_auth:
            return [
                "Host": baseUrl
            ]
        case .get_auth:
            return [
                "Authorization": "Bearer " + jwt!,
                "Host":baseUrl
            ]
        case .post_auth:
            return [
                "Authorization" : "Bearer " + jwt!,
                "Content-Type": "application/json",
                "Host": baseUrl
            ]
        case .post_no_auth:
            return [
                "Content-Type": "application/json",
                "Host": baseUrl
            ]
        case .delete:
            return [
                "Host": baseUrl,
                "Authorization": "Bearer" + jwt!
            ]
        }
    }
    
    /**
            - Description: Sends login data to API.
            - Parameters:
                    loginClass: Information representing the users login credentials (email and password).
            - Throws: ApiError that covers unexpected return values.
            - Returns: True if server responds valid login and false if invalid login.
     */
    func sendLogin(loginClass: LoginClass) throws -> Bool {
        let url = URL(string: "https://" + baseUrl + "/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = getHeaders(requestType: .post_no_auth, jwt: nil)
        request.httpBody = try JSONEncoder().encode(loginClass)

        var responseStatusCode: Int = sendRequest(request: request){ data in
            let responseData = try JSONDecoder().decode(LoginResponseStruct.self, from: data)
            self.jwt = responseData.jwt
            KeychainHelper.standard.save(Data(responseData.jwt.utf8), service: "access-token", account: "clothingCarou")
        }
        
        if responseStatusCode == 200 {
            return true
        } else if responseStatusCode == 400 {
            return false
        } else if responseStatusCode == 403 {
            responseStatusCode = -3
        }
        
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    /**
            - Description: Sends sign up data to API.
            - Parameters:
                    userClass: Information representing the users information.
                    verificationCode: String representing the users verification code.
            - Throws: ApiError that covers unexpected return values.
            - Returns: True if server responds valid sign up and false if invalid sign up.
     */
    func sendSignUp(userClass: UserClass, verificationCode: String) throws -> Bool {
        let url = URL(string: "https://" + baseUrl + "/create?code=" + verificationCode)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(userClass)
        request.allHTTPHeaderFields = getHeaders(requestType: .post_no_auth, jwt: nil)
        
        var responseStatusCode: Int = sendRequest(request: request) { data in
            let responseData = try JSONDecoder().decode(LoginResponseStruct.self, from: data)
            self.jwt = responseData.jwt
            KeychainHelper.standard.save(Data(responseData.jwt.utf8), service: "access-token", account: "clothingCarou")
        }
        
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
    
    /**
         - Description: Sends delete request to API.
         - Throws: ApiError that covers unexpected return values.
         - Returns: True if server responds valid delete and false if invalid delete.
     */
    func deleteAccount() throws -> Bool {
        var responseStatusCode: Int = -4
        if let jwt = jwt {
            let url = URL(string: "https://" + baseUrl + "/delete")!
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.allHTTPHeaderFields = getHeaders(requestType: .delete, jwt: jwt)
            
            responseStatusCode = sendRequest(request: request)
            
            if responseStatusCode == 200 {
                self.jwt = ""
                return true
            } else if responseStatusCode == 400 {
                return false
            } else if responseStatusCode == 403 {
                //Too many attempts
                responseStatusCode = -3
            }
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
        
        if let jwt = self.jwt {
            var request = URLRequest(url: URL(string: "https://" + baseUrl + "/app/" + likeStruct.likeType.rawValue)!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = getHeaders(requestType: .post_auth, jwt: jwt)
            
            request.httpBody = try JSONEncoder().encode(likeStruct)
            
            responseStatusCode = sendRequest(request: request)
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
            request.allHTTPHeaderFields = getHeaders(requestType: .get_auth, jwt: jwt)
            
            var responseData: ClothingItem? = nil
            responseStatusCode = sendRequest(request: request) { data in
                responseData = try JSONDecoder().decode(ClothingItem.self, from: data)
            }
            
            DispatchQueue.main.async {
                if let responseData = responseData {
                    completion(.success(responseData))
                } else {
                    completion(.failure(Api.getApiError(statusCode: responseStatusCode)))
                }
            }
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
        //Urls
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseUrl
        urlComponents.path = "/app/activity"
        
        //Parameters
        var parameters:[URLQueryItem] = getQueryParameters()
        if let pageNumber = pageNumber {
            parameters.append(URLQueryItem(name: "page", value: String(pageNumber)))
        }
        urlComponents.queryItems = parameters
        
        var responseStatusCode = -4
        if let jwt = self.jwt {
            //Request
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = getHeaders(requestType: .get_auth, jwt: jwt)
            
            var responseData: [ActivityObject]?
            var pageAmount: Int?
            
            responseStatusCode = sendRequest(request: request) { data in
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
            }
            
            if responseStatusCode == 200 && responseData == nil {
                responseStatusCode = -5
            }
            
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
        
        if collectionType == CollectionStruct.CollectionRequestType.none {
            print("Requesting Clothing Page without collectionType no defined")
            return
        }
        
        //Builds URL
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseUrl
        urlComponents.path = "/app/" + collectionType.rawValue
        
        //Parameters
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
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        //Adds jwt
        var responseStatusCode: Int = -4
        if let jwt = self.jwt {
            request.allHTTPHeaderFields = getHeaders(requestType: .get_auth, jwt: jwt)
        } else if collectionType == .preview {
            request.allHTTPHeaderFields = getHeaders(requestType: .get_no_auth, jwt: nil)
        } else {
            throw Api.getApiError(statusCode: responseStatusCode)
        }
        
        
        //Sends request
        var responseData:CollectionStruct?
        responseStatusCode = sendRequest(request: request) { data in
            responseData = Optional.some(try JSONDecoder().decode(CollectionStruct.self, from: data))
        }

        //Configures data for completion
        if responseStatusCode == 200 {
            if let responseData = responseData {
                var itemCollection = responseData.getItems()
                if (collectionType == CollectionStruct.CollectionRequestType.cardList) {
                    itemCollection.reverse()
                }
                DispatchQueue.main.async {
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
        var responseStatusCode = -4
        if let jwt = self.jwt {
            //URL
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
            request.allHTTPHeaderFields = getHeaders(requestType: .get_auth, jwt: jwt)
            
            var responseData: FilterOptionsStruct?
            responseStatusCode = sendRequest(request: request) { data in
                let filterData = try JSONDecoder().decode([String : [String : [String : [String]]]].self, from: data)
                responseData = FilterOptionsStruct(filterOptions: filterData["genders"]!)
            }
            
            if responseStatusCode == 200, let responseData = responseData {
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
        
        if let jwt = self.jwt {
            var request = URLRequest(url: URL(string: "https://" + baseUrl + "/app/updateLocation")!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = getHeaders(requestType: .post_auth, jwt: jwt)
            
            var locationData: [String: Double] = [:]
            locationData["latitude"] = latitude
            locationData["longitude"] = longitude
            
            request.httpBody = try JSONEncoder().encode(locationData)
            
            responseStatusCode = sendRequest(request: request)
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
        
        if let jwt = self.jwt {
            var request = URLRequest(url: URL(string: "https://" + baseUrl + "/app/userInfo")!)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = getHeaders(requestType: .get_auth, jwt: jwt)
            
            var responseData: ProfileStruct? = nil
            responseStatusCode = sendRequest(request: request) { data in
                responseData = try JSONDecoder().decode(ProfileStruct.self, from: data)
            }
            
            if responseStatusCode == 200, let responseData = responseData {
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
        if let jwt = self.jwt {
            var request = URLRequest(url: URL(string: "https://" + baseUrl + "/app/updateDeviceId")!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = getHeaders(requestType: .post_auth, jwt: jwt)
            
            var locationData: [String: String] = [:]
            locationData["deviceId"] = deviceId
            
        
            request.httpBody = try JSONEncoder().encode(locationData)
            
            responseStatusCode = sendRequest(request: request)
            
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
        var responseStatusCode = -4
        
        if let jwt = self.jwt {
            //Url
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = baseUrl
            urlComponents.path = "/app/searchProfiles"
            
            //Parameters
            var urlParameters = [URLQueryItem]()
            urlParameters.append(URLQueryItem(name: "query", value: query))
            urlComponents.queryItems = urlParameters
            
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = getHeaders(requestType: .get_auth, jwt: jwt)
            
            var responseData: [ActivityProfileStruct]?
            responseStatusCode = sendRequest(request: request) { data in
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
            }
            
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
        var responseStatusCode = -4
        
        if let jwt = self.jwt {
            //URL
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = baseUrl
            urlComponents.path = "/app/followRequests"
            
            //Request
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = getHeaders(requestType: .get_auth, jwt: jwt)
            
            var responseData: [ActivityProfileStruct]?
            responseStatusCode = sendRequest(request: request){ data in
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
            }
            
            if responseStatusCode == 200, let responseData = responseData {
                DispatchQueue.main.async {
                    completion(responseData)
                }
                return
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
        if let jwt = self.jwt {
            var request = URLRequest(url: URL(string: "https://" + baseUrl + "/app/followRequestAction")!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = getHeaders(requestType: .post_auth, jwt: jwt)
            
            var userInformation: [String: Any] = [:]
            userInformation["userId"] = userId
            userInformation["approve"] = approved
            
            let jsonData = try JSONSerialization.data(withJSONObject: userInformation, options: [])
            request.httpBody = jsonData
            
            responseStatusCode = sendRequest(request: request)
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
        if let jwt = self.jwt {
            var pathString = ""
            if newFollowingStatus == .following || newFollowingStatus == .requested {
                pathString = "/follow"
            } else {
                pathString = "/unfollow"
            }
            
            var request = URLRequest(url: URL(string: "https://" + baseUrl + "/app" + pathString)!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = getHeaders(requestType: .post_auth, jwt: jwt)
            
            var userInformation: [String: Int] = [:]
            userInformation["userId"] = userId
            
            request.httpBody = try JSONEncoder().encode(userInformation)
            
            responseStatusCode = sendRequest(request: request)
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
        
        var request = URLRequest(url: URL(string: "https://" + baseUrl + "/verify")!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Host": baseUrl,
            "Content-Type":"application/json"
        ]
        
        var requestData: [String: String] = [:]
        requestData["email"] = userEmail
        
        request.httpBody = try JSONEncoder().encode(requestData)
        responseStatusCode = sendRequest(request: request)
        
        if responseStatusCode == 200 {
            return true
        } else if responseStatusCode == 400 {
            return false
        }
        
        
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    func loadBrowsing() throws {
        var request = URLRequest(url: URL(string: "https://" + baseUrl + "/browsing")!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = getHeaders(requestType: .get_no_auth, jwt: nil)
        
        let responseStatusCode = sendRequest(request: request)
        DispatchQueue.main.sync {
            if responseStatusCode == 200 {
                self.browser = true
            } else if responseStatusCode == 400 {
                self.browser = false
            }
        }
        
        //If statement within DispatchQueue.main.sync will only return the closure.
        if responseStatusCode == 200 || responseStatusCode == 400 {
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
        
        if let jwt = jwt {
            let url = URL(string: "https://" + baseUrl + "/app/updateUserInfo")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try JSONEncoder().encode(profileStruct)
            request.allHTTPHeaderFields = getHeaders(requestType: .post_auth, jwt: jwt)
            
            responseStatusCode = sendRequest(request: request) {data in
                let responseData = try JSONDecoder().decode(LoginResponseStruct.self, from: data)
                self.jwt = responseData.jwt
                KeychainHelper.standard.save(Data(responseData.jwt.utf8), service: "access-token", account: "clothingCarou")
            }
            
            if responseStatusCode == 200 {
                return
            } 
        }
        
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    /**
        - Description: Sends session data to API.
        - Parameters:
            - sessionData: Structure holding the sesssion data to be sent.
        - Throws: `ApiError.httpError` if the return value is not 200. Check README.md for clarification on codes.
     */
    func sendSessionData(sessionData: SessionData) throws {
        var responseStatusCode = -4
        
        if let jwt = jwt {
            let url = URL(string: "https://" + baseUrl + "/app/sessionData")!
            
            //Creates request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try JSONEncoder().encode(sessionData)
            request.allHTTPHeaderFields = getHeaders(requestType: .post_auth, jwt: jwt)
            
            responseStatusCode = sendRequest(request: request)
            
            if responseStatusCode == 200 {
                return
            }
        }
        
        throw Api.getApiError(statusCode: responseStatusCode)
    }
    
    /**
        - Description: Sends image loading error data to API.
        - Parameters:
                - clothingId : A int representing the api's id for the clothing.
        - Throws: `ApiError.httpError` if the return value is not 200. Check README.md for clarification on codes.
     */
    func sendImageError(clothingId: Int) throws {
        var responseStatusCode = -3
        
        if let jwt = jwt {
            let url = URL(string: "https://" + baseUrl + "/app/imageError")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try JSONEncoder().encode([
                "clothingId" : clothingId
            ])
            request.allHTTPHeaderFields = getHeaders(requestType: .post_auth, jwt: jwt)
            
            responseStatusCode = sendRequest(request: request)
            
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
    
    enum HttpRequestType {
        case delete
        case post_auth
        case post_no_auth
        case get_auth
        case get_no_auth
        
    }
    
    static func getApiError(statusCode: Int) -> ApiError{
        switch statusCode {
        case 403:
            return ApiError.httpError("Authentication error.")
        case let code where code >= 500 && code < 600:
            return ApiError.httpError("Server Error. Status Code: \(statusCode)")
        case -2:
            return ApiError.httpError("Communication structure error. Status Code: \(statusCode)")
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
