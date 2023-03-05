//
//  TexesCalculator.swift
//  AndreDaniloFlavioSamuel
//
//  Created by Danilo Santos on 22/02/23.
//

import Foundation

enum UserDefaulsKeys: String {
    case dollarQuotation = "dollarQuotation"
    case IOF = "IOF"
}

class TaxesCalculator {
    
    let defaults = UserDefaults.standard
   
    static let shared = TaxesCalculator()
    
    let formatter = NumberFormatter()
    
    var dollarQuotation: Double {
        get {
            return defaults.double(forKey: UserDefaulsKeys.dollarQuotation.rawValue)
        }
        
        set {
            defaults.set(newValue, forKey: UserDefaulsKeys.dollarQuotation.rawValue)
        }
    }
    
    var IOF: Double {
        get {
            return defaults.double(forKey: UserDefaulsKeys.IOF.rawValue)
        }
        
        set {
            defaults.set(newValue, forKey: UserDefaulsKeys.IOF.rawValue)
        }
    }
    
    
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
        dollarQuotation = dollarQuotation == 0  ? 3.2 : dollarQuotation
        IOF = IOF == 0  ? 6.38 : IOF
    }
}
