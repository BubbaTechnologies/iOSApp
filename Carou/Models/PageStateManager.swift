//
//  Pages.swift
//  Carou
//
//  Created by Matt Groholski on 1/16/24.
//

import Foundation
enum PageState{
    case likes
    case swipe
    case closet
    case auxiliary(AuxiliaryType)
    case profile
    case activity
}

extension PageState: Equatable {
    /**
        - Description: Determines equality of two PageStates.
     */
    public static func ==(lhs: PageState, rhs: PageState) -> Bool {
        switch (lhs, rhs) {
        case (.likes, .likes),
            (.swipe, .swipe),
            (.closet, .closet),
            (.profile, .profile),
            (.activity, .activity):
            return true
        case let (.auxiliary(lhsType), .auxiliary(rhsType)):
            return lhsType == rhsType
        default:
            return false
        }
    }
    
    /**
        - Description: Determines inequality of two PageStates.
     */
    public static func !=(lhs: PageState, rhs: PageState) -> Bool {
        return !(lhs == rhs)
    }
}

enum AuxiliaryType: Equatable {
    case none
    case filtering
    case editing
    case adding
    case cancel
    case confirm
}
