//
//  ListView.swift
//  Carou
//
//  Created by Matt Groholski on 5/18/23.
//

import SwiftUI

struct ListView: View {
    let list: [String]
    let selectedAction: (String, Bool) -> Void
    
    let multipleSelections: Bool
    @State var selectedList: [Bool]
    
    let subList: Bool
    let subListValues: [[String]]
    let subListSelectedAction: (String, Bool) -> Void
    let subListMultipleSelections: Bool
    
    var longestList: Int = 0
    @State var subListSelected: [Bool]
    
    init (list: [String], selectedAction: @escaping (String, Bool)->Void, multipleSelections: Bool, subList: Bool, subListValues: [[String]], subListMultipleSelections: Bool, subListSelectedAction: @escaping (String, Bool)->Void) {
        self.list = list
        self.selectedAction = selectedAction
        self.multipleSelections = multipleSelections
        self.selectedList = Array(repeating: false, count: list.count)
        self.subList = subList
        self.subListValues = subListValues
        self.subListSelectedAction = subListSelectedAction
        
        for i in subListValues {
            if i.count > longestList {
                self.longestList = i.count
            }
        }
        
        self.subListSelected = Array(repeating: false, count: longestList)
        self.subListMultipleSelections = subListMultipleSelections
    }
    
    init (list: [String], selectedAction: @escaping (String, Bool)->Void, multipleSelections: Bool) {
        self.list = list
        self.selectedAction = selectedAction
        self.multipleSelections = multipleSelections
        self.selectedList = Array(repeating: false, count: list.count)
        self.subList = false
        self.subListValues = []
        self.subListSelected = []
        self.subListSelectedAction = {_,_ in return}
        self.subListMultipleSelections = false
    }
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .leading){
                ForEach(list.indices, id: \.self) { index in
                    ListButtonView(selected: Binding<Bool>(
                        get: { self.selectedList[index] },
                        set: { value in self.selectedList[index] = value }
                    ), item: list[index]) { gender, isSelected in
                        //If multiple selections is turned off, unselect all others
                        if !multipleSelections && isSelected {
                            for i in 0...list.count - 1 {
                                if list[i] != gender {
                                    selectedList[i] = false
                                    self.subListSelected = Array(repeating: false, count: longestList)
                                }
                            }
                        }
                        selectedAction(gender, isSelected)
                    }
                    
                    if subList && selectedList[index] {
                        ForEach(subListValues[index].indices, id: \.self) { j in
                            ListButtonView(selected: Binding<Bool>(
                                get: { self.subListSelected[j] },
                                set: { value in self.subListSelected[j] = value }
                            ), item: subListValues[index][j]) { type, isSelected in
                                if !subListMultipleSelections && isSelected {
                                    for i in 0...subListValues[index].count - 1 {
                                        if subListValues[index][i] != type {
                                            subListSelected[i] = false
                                        }
                                    }
                                }
                                subListSelectedAction(type, isSelected)
                            }
                            .padding(.leading, reader.size.width * 0.05)
                        }
                    }
                }
            }
        }
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(list: FilterOptionsStruct.sampleOptions.getGenders(), selectedAction: {_,_ in return}, multipleSelections: false, subList: true, subListValues: FilterOptionsStruct.sampleOptions.getTypes(), subListMultipleSelections: true, subListSelectedAction: {_,_ in return})
    }
}


