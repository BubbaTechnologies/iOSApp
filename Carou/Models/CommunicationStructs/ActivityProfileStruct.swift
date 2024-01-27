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
    var followingStatus: FollowingStatus
    
    init(id: Int, username: String, privateAccount: Bool, followingStatus: Int) {
        self.id = id
        self.username = username
        self.privateAccount = privateAccount
        self.followingStatus = FollowingStatus.intToFollowingStatus(followingStatus)
    }
    
    init(id: Int, username: String, privateAccount: Bool, followingStatus: FollowingStatus) {
        self.id = id
        self.username = username
        self.privateAccount = privateAccount
        self.followingStatus = followingStatus
    }
    
    init() {
        self.id = -1
        self.username = ""
        self.privateAccount = false
        self.followingStatus = .none
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.username = try container.decode(String.self, forKey: .username)
        self.privateAccount = try container.decode(Bool.self, forKey: .privateAccount)
        
        let followingStatusInt = try container.decode(Int.self, forKey: .followingStatus)
        self.followingStatus = FollowingStatus.intToFollowingStatus(followingStatusInt)
        
        print("\(self.id), status: \(self.followingStatus)")
    }
    
    func getInitials() -> String {
        var initials: String = ""
        
        let substrings = self.username.split(separator: " ")
        for substring in substrings {
            initials += substring.first!.uppercased()
        }
        
        return initials
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case privateAccount
        case followingStatus = "followingStatus"
    }
    
    enum FollowingStatus: Int {
        case following = 2
        case requested = 1
        case none = 0
        
        static func intToFollowingStatus(_ followingStatusInt: Int)->FollowingStatus {
            switch followingStatusInt {
            case 1:
                return .requested
            case 2:
                return .following
            default:
                return .none
            }
        }
        
        static func followingStatusToString(_ followingStatus: FollowingStatus) -> String {
            switch followingStatus {
            case .following:
            return "Following"
            case .requested:
            return "Requested"
            case .none:
            return "Follow"
            }
        }
    }
}
