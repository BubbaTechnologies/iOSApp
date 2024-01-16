//
//  FilterOptionsStruct.swift
//  Carou
//
//  Created by Matt Groholski on 5/18/23.
//

import Foundation

struct FilterOptionsStruct {
    private var filterOptionsDict: [String: [String]]
    
    init(filterOptions: Dictionary<String, Dictionary<String, [String]>>) {
        //Initializes everything as empty
        self.init()
        //Parses filterOptions dictionary
        for gender in filterOptions.keys {
            var genderTypes: [String] = []
            for type in filterOptions[gender]!.keys {
                genderTypes.append(type)
            }
            self.filterOptionsDict[gender] = genderTypes
        }
    }
    
    init () {
        self.filterOptionsDict = [:]
    }
    
    func getGenders()->[String] {
        return self.filterOptionsDict.keys.map{String($0)}
    }
    
    func getTypes(gender: String)->[String] {
        if let typeList = self.filterOptionsDict[gender] {
            return typeList
        } else {
            return []
        }
    }
    
    func getDict()->Dictionary<String, Any> {
        return self.filterOptionsDict
    }
    
    func isEmpty()->Bool {
        return filterOptionsDict.isEmpty
    }
}


extension FilterOptionsStruct {
    static let sampleOptions: FilterOptionsStruct = FilterOptionsStruct(filterOptions: [
        "female": ["pants":[], "top": ["active"], "jacket_vest":[], "other":["active"], "set":[], "skirt":["active"],"dress":["active"]],
        "male": ["pants":[], "shirt":[], "top":[], "jacket_vest":[]],
        "unisex": ["pants":[], "shirt":[], "top":[], "jacket_vest":[]],
    ])
}
