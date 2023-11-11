//
//  DatePickerView.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 11/10/23.
//

import SwiftUI

struct DatePickerView: View {
    var placeholder: String
    @Binding var birthdate: Date
    
    var body: some View {
        GeometryReader { reader in
            SuperDatePicker(placeholder: placeholder, selection: $birthdate)
            .frame(width: reader.size.width * 0.8)
            .background(Color("LightBackgroundColor"))
            .border(Color("DarkFontColor"))
            .cornerRadius(2.5)
            .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.05, relativeTo: .body))
            .position(x: reader.frame(in: .local).midX, y: reader.frame(in: .local).midY)
        }
    }
}


struct SuperDatePicker: View {
    
    var placeholder: String
    @Binding var selection: Date
    @State var selected: Bool = false
    @State var selectedOnce: Bool = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .center) {
                if !selected {
                    Text(selectedOnce ? dateFormatter.string(from: selection) : placeholder)
                        .background(Color.clear)
                } else {
                    DatePicker("Birthdate" ,selection: $selection, in: ...Calendar.current.date(byAdding: .year, value: -13, to: Date())!, displayedComponents: .date)
                        .font(CustomFontFactory.getFont(style: "Regular", size: reader.size.width * 0.05, relativeTo: .body))
                        .preferredColorScheme(.light)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                }
            }
            .onTapGesture(coordinateSpace: .global) { location in
                if !reader.frame(in: .global).contains(location) {
                    selected = false
                } else {
                    selected = true
                    selectedOnce = true
                }
            }
            .foregroundColor(Color("DarkFontColor"))
            .position(x: reader.frame(in: .local).midX, y: reader.frame(in: .local).midY)
        }
    }
}


#Preview {
    DatePickerView(placeholder: "Birthdate", birthdate: .constant(Date()))
}
