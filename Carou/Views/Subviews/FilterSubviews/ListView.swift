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
    
    @State var selectedListBuffer: [Bool] = Array(repeating: false, count: ListView.bufferSize)
    @State var isSelectection: Bool = false
    
    static let bufferSize: Int = 30
    
    init(list: [String], multipleSelections: Bool, selectedAction: @escaping(String, Bool)->Void) {
        self.list = list
        self.multipleSelections = multipleSelections
        self.selectedAction = selectedAction
    }
    
    var body : some View {
        GeometryReader { reader in
            VStack (alignment: .leading){
                ForEach(list.indices, id: \.self) { index in
                    if (isSelectection && selectedListBuffer[index]) || !isSelectection {
                        ListButtonView(selected: Binding<Bool>(
                            get: {
                                if index < ListView.bufferSize {
                                    self.selectedListBuffer[index]
                                } else {
                                    fatalError("Out of bounds index in get ListButtonView")
                                }
                            },
                            set: {value in
                                if index < ListView.bufferSize {
                                    self.selectedListBuffer[index] = value
                                    isSelectection = value && !multipleSelections
                                }
                            }
                        ), item: list[index]){ value, isSelected in
                            if !self.multipleSelections && isSelected {
                                for i in 0...list.count - 1 {
                                    if list[i] != value {
                                        if index < ListView.bufferSize {
                                            selectedListBuffer[i] = false
                                        } else {
                                            fatalError("Out of bounds index in set ListButtonView")
                                        }
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


