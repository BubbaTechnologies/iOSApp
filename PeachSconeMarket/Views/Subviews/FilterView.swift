//
//  FilterView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 5/18/23.
//

import SwiftUI

struct FilterView: View {
    @Binding var typeFilter: [String]
    @Binding var genderFilter: String
    @State var filterOptions: FilterOptionsStruct? = nil
    @State var errorMessage: String = ""
    
    private let bottomPaddingFactor: Double = 0.001
    private let outsidePaddingFactor: Double = 0.001
    var body: some View {
        ZStack{
            VStack {
                VStack(alignment: .center){
                    ScrollView(showsIndicators: false) {
                        InlineTitleView()
                            .frame(alignment: .top)
                            .padding(.bottom, UIScreen.main.bounds.height * bottomPaddingFactor)
                        Text("Filters")
                            .font(CustomFontFactory.getFont(style: "Bold", size: UIScreen.main.bounds.width * 0.075, relativeTo: .title3))
                            .foregroundColor(Color("DarkText"))
                            .padding(.bottom, UIScreen.main.bounds.height * bottomPaddingFactor)
                        
                        //Display error message
                        if (!errorMessage.isEmpty) {
                            Text("\(errorMessage)")
                                .font(CustomFontFactory.getFont(style: "Bold", size: UIScreen.main.bounds.width * 0.04, relativeTo: .caption))
                                .foregroundColor(.red)
                        }
                        
                        //If filterOptions are loaded properly
                        if (filterOptions != nil) {
                            VStack{
                                Text("Gender")
                                    .font(CustomFontFactory.getFont(style: "Bold", size: UIScreen.main.bounds.width * 0.07, relativeTo: .subheadline))
                                    .foregroundColor(Color("DarkText"))
                                    .padding(.bottom, UIScreen.main.bounds.height * bottomPaddingFactor)
                                HStack{
                                    Spacer()
                                    if (genderFilter == "") {
                                        ListView(list: filterOptions!.getGenders().sorted(), action: genderSelect)
                                    } else {
                                        VStack{
                                            ListButtonView(selected: true, item: genderFilter.capitalized, action: singleGenderButton)
                                            Text("Type")
                                                .font(CustomFontFactory.getFont(style: "Bold", size: UIScreen.main.bounds.width * 0.07, relativeTo: .subheadline))
                                                .foregroundColor(Color("DarkText"))
                                            ListView(list: filterOptions!.getTypes(gender: genderFilter.lowercased()).sorted(), action: typeSelect)
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
            VStack{
                Spacer()
                if (filterOptions == nil && errorMessage == "") {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("DarkText")))
                        .scaleEffect(3)
                        .onAppear{
                            do {
                                filterOptions = try FilterOptionsStruct.getFilterOptions()
                            } catch {
                                errorMessage = "\(error)"
                            }
                        }
                }
                Spacer()
            }
        }
    }
}

extension FilterView {
    func genderSelect(gender: String, selected: Bool)->Void {
        if selected {
            genderFilter = ""
        } else {
            genderFilter = gender.lowercased()
        }
    }
    
    func typeSelect(item: String, selected: Bool)->Void{
        if !selected {
            typeFilter.append(item.lowercased())
        } else {
            typeFilter = typeFilter.filter{
                $0 != item
            }
        }
    }
    
    func singleGenderButton(_ :String, _:Bool)->Void{
        genderFilter = ""
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(typeFilter: .constant([]), genderFilter: .constant(""), filterOptions: FilterOptionsStruct.sampleOptions)
    }
}



