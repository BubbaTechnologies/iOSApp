//
//  FilterOptionsStruct.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/18/23.
//

import Foundation

struct FilterOptionsStruct {
    private let genders: [String]
    private let types: [[String]]
    private var typePerGenderDict: [String: [String]]
    private var uniqueTypes: Set<String>
    private var longestTypeArray: Int = 0
    
    init(filterOptions: FilterOptions) {
        self.genders = filterOptions.getGenders()
        self.types = filterOptions.getTypes()
        self.typePerGenderDict = [:]
        self.uniqueTypes = []
        
        for i in 0..<genders.count {
            if (self.types[i].count > longestTypeArray) {
                longestTypeArray = self.types[i].count
            }
            self.typePerGenderDict[genders[i].lowercased()] = self.types[i].sorted()
            for type in self.types[i] {
                self.uniqueTypes.insert(type)
            }
        }
    }
    
    init(genders: [String], types:[[String]]) {
        self.genders = genders
        self.types = types
        self.typePerGenderDict = [:]
        self.uniqueTypes = []
        
        for i in 0..<genders.count {
            if (self.types[i].count > longestTypeArray) {
                longestTypeArray = self.types[i].count
            }
            self.typePerGenderDict[genders[i].lowercased()] = self.types[i].sorted()
            for type in self.types[i] {
                self.uniqueTypes.insert(type)
            }
        }
    }
    
    init () {
        self.genders = []
        self.types = []
        self.typePerGenderDict = [:]
        self.uniqueTypes = []
    }
    
    //Returns genders
    func getGenders()->[String] {
        return self.genders
    }
    
    //Gets the type array of a specific gender.
    func getTypes(gender:String)->[String] {
        return typePerGenderDict[gender.lowercased()]!
    }
    
    //Returns an array with corresponding indexes to self.genders of the types for the gender.
    func getTypes()->[[String]] {
        return types
    }
    
    //Returns the amount of types within the longest type list.
    func getLongestTypesArrayCount()->Int {
        return longestTypeArray
    }
    
    //Returns unique types
    func getUniqueTypes()->Set<String> {
        return self.uniqueTypes
    }
}

struct FilterOptions: Codable {
    private let genders: [String]
    private let types: [[String]]
    
    init(genders:[String], types:[[String]]) {
        self.genders = genders
        self.types = types
    }
    
    func getGenders()->[String] {
        return self.genders
    }
    
    func getTypes()->[[String]] {
        return self.types
    }
}

extension FilterOptionsStruct {
    static let sampleOptions: FilterOptionsStruct = FilterOptionsStruct(genders: ["FEMALE", "MALE","BOY","GIRL","KIDS","UNISEX"]
                                                                        , types: [
                                                                            ["TOP","BOTTOM","SHOES","UNDERCLOTHING","JACKET","ONE_PIECE","SKIRT","ACCESSORY","SWIMWEAR","DRESS","SLEEPWEAR"],
                                                                            ["TOP","BOTTOM","SHOES","UNDERCLOTHING","JACKET","ACCESSORY","SWIMWEAR","SLEEPWEAR"],
                                                                            ["TOP","BOTTOM","SHOES","UNDERCLOTHING","JACKET","ACCESSORY","SWIMWEAR","SLEEPWEAR"],
                                                                            ["TOP","BOTTOM","SHOES","UNDERCLOTHING","JACKET","ONE_PIECE","SKIRT","ACCESSORY","SWIMWEAR","DRESS","SLEEPWEAR"],
                                                                            ["TOP","BOTTOM","SHOES","UNDERCLOTHING","JACKET","ONE_PIECE","SKIRT","ACCESSORY","SWIMWEAR","DRESS","SLEEPWEAR"],
                                                                            ["TOP","BOTTOM","SHOES","UNDERCLOTHING","JACKET","ONE_PIECE","SKIRT","ACCESSORY","SWIMWEAR","DRESS","SLEEPWEAR"]
                                                                        ])
}
