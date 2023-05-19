//
//  ListView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/18/23.
//

import SwiftUI

struct ListView: View {
    let list: [String]
    let action: (String, Bool)->Void
    
    var body: some View {
        VStack(alignment: .leading){
            ForEach(list, id: \.self) { item in
                ListButtonView(item: item, action: action)
            }
        }
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(list: FilterOptionsStruct.sampleOptions.getGenders(), action:{(_,_) in return})
    }
}


