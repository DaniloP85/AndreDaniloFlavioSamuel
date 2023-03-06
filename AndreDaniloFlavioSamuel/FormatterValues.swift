//
//  FormatterValues.swift
//  AndreDaniloFlavioSamuel
//
//  Created by Danilo Santos on 06/03/23.
//

import Foundation

class FormatterValues {
    
    static let shared = FormatterValues()
    
    let formatter = NumberFormatter()
    
    func convertToDouble(_ string: String) -> Double{
        formatter.numberStyle = .none
        return string.isEmpty ? 0 : formatter.number(from: string.replacingOccurrences(of: ".", with: ","))!.doubleValue
    }
    
    func getString(of value: Double) -> String {
        formatter.numberStyle = .decimal
        return formatter.string(for: value)!
    }
    
    func getFormattedValue(of value: Double, withCurrency currency: String ) -> String {
        formatter.numberStyle = .currency
        formatter.currencySymbol = currency
        formatter.alwaysShowsDecimalSeparator = true
        return formatter.string(for: value)!
    }
    
    private init(){
        formatter.usesGroupingSeparator = true
    }
}
