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
    
    @State var sublistShowing = false
    
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
                    if !api.filterOptionsStruct.isEmpty() {
                        LazyVStack{
                            ListView(list: api.filterOptionsStruct.getGenders().sorted(), multipleSelections: false, selectedAction: genderSelectedAction)
                                .frame(height: reader.size.height * (sublistShowing ? CGFloat(1) : CGFloat(api.filterOptionsStruct.getGenders().count)) / 20)
                            if sublistShowing {
                                ListView(list: api.filterOptionsStruct.getTypes(gender: self.gender).sorted(), multipleSelections: true, selectedAction: typeSelectedAction)
                                    .frame(height: reader.size.height * Double(api.filterOptionsStruct.getTypes(gender: self.gender).count) / 20)
                                    .padding(.leading, reader.size.width * 0.025)
                            }
                        }
                    } else {
                        Spacer(minLength: reader.size.height * 0.3)
                        Text("Could not load\n filter options.")
                            .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.07, relativeTo: .body))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }.frame(height: reader.size.height * 0.85)
                NavigationButtonView(showFilter: true, showEdit: true, options: .constant(true)){ pageState in
                    api.resetFilters()
                    
                    
                    if pageState == .editing {
                        api.setGenderFitler(gender: gender)
                        for filter in typeFilter {
                            api.addTypeFilter(gender: gender, type: filter)
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
            self.sublistShowing = true
        } else {
            self.gender = ""
            self.sublistShowing = false
        }
        self.typeFilter.removeAll()
    }
    
    func typeSelectedAction(selectedValue: String, isSelected: Bool) {
        if isSelected {
            self.typeFilter.append(selectedValue)
        } else {
            self.typeFilter.removeAll {
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


