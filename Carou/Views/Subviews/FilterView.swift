//
//  FilterView.swift
//  Carou
//
//  Created by Matt Groholski on 5/18/23.
//

import SwiftUI

struct FilterView: View {
    @ObservedObject var api: Api
    var changeFunction: (PageState)->Void
    
    @State var gender: String = ""
    @State var typeFilter: [String] = []
    
    var body: some View {
        GeometryReader { reader in
            Color("BackgroundColor").ignoresSafeArea()
            VStack {
                InlineTitleView()
                    .frame(width: reader.size.width, height: reader.size.height * 0.07)
                    .padding(.top, reader.size.height * 0.025)
                    .padding(.bottom, reader.size.height * 0.01)
                ScrollView(showsIndicators: true) {
                    Text("Filters")
                        .font(CustomFontFactory.getFont(style: "Bold", size: reader.size.width * 0.075, relativeTo: .title3))
                        .foregroundColor(Color("DarkFontColor"))
                    LazyVStack{
                        ListView(list: api.filterOptionsStruct.getGenders(), selectedAction: genderSelectedAction, multipleSelections: false, subList: true, subListValues: api.filterOptionsStruct.getTypes(), subListMultipleSelections: true, subListSelectedAction: typeSelectedAction)
                            .frame(height: reader.size.height * (gender.isEmpty ? Double(api.filterOptionsStruct.getGenders().count) : Double(api.filterOptionsStruct.getGenders().count + api.filterOptionsStruct.getLongestTypesArrayCount()))/20.0)
                    }
                }.frame(height: reader.size.height * 0.85)
                NavigationButtonView(showFilter: true, showEdit: true, options: .constant(true)){ pageState in
                    api.resetTypeFilters()
                    api.resetGenderFilter()
                    
                    
                    if pageState == .editing {
                        api.setGenderFitler(filter: gender)
                        for filter in typeFilter {
                            api.addTypeFilter(filter: filter)
                        }
                    }
                    
                    changeFunction(pageState)
                }
                    .frame(height: reader.size.height * NavigationViewDesignVariables.frameHeightFactor)
                    .padding(.bottom, reader.size.height * 0.005)
            }
            .frame(width: reader.size.width, height: reader.size.height)
        }
    }
}

extension FilterView {
    func genderSelectedAction(selectedValue: String, isSelected: Bool) {
        if isSelected {
            self.gender = selectedValue
        } else {
            self.gender = ""
        }
        self.typeFilter.removeAll()
    }
    
    func typeSelectedAction(selectedValue: String, isSelected: Bool) {
        if isSelected {
            self.typeFilter.append(selectedValue)
        } else {
            self.typeFilter.removeAll{
                $0 == selectedValue
            }
        }
        
    }
}


struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(api: Api(), changeFunction: {_ in return})
    }
}


