//
//  ListView.swift
//  Carou
//
//  Created by Matt Groholski on 5/18/23.
//

import SwiftUI

struct ListView: View {
    let list: [String]
    let multipleSelections: Bool
    
    let selectedAction: (String, Bool) -> Void
    
    @State var selectedList: [Bool]
    @State var isSelectection: Bool = false
    
    init(list: [String], multipleSelections: Bool, selectedAction: @escaping(String, Bool)->Void) {
        self.list = list
        self.multipleSelections = multipleSelections
        self.selectedList = Array(repeating: false, count: list.count)
        self.selectedAction = selectedAction
    }
    
    var body : some View {
        GeometryReader { reader in
            VStack (alignment: .leading){
                ForEach(list.indices, id: \.self) { index in
                    if (isSelectection && selectedList[index]) || !isSelectection {
                        ListButtonView(selected: Binding<Bool>(
                            get: {self.selectedList[index]},
                            set: {value in
                                self.selectedList[index] = value
                                isSelectection = value && !multipleSelections
                            }
                        ), item: list[index]){ value, isSelected in
                            if !self.multipleSelections && isSelected {
                                for i in 0...list.count - 1 {
                                    if list[i] != value {
                                        selectedList[i] = false
                                    }
                                }
                            }
                            selectedAction(value, isSelected)
                        }
                    }
                }
            }
        }
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(list: FilterOptionsStruct.sampleOptions.getGenders(), multipleSelections: false, selectedAction: {_,_ in return})
    }
}


