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
    
    var stateTax: Double = 7.0
    var shoppingValue: Double = 0
    
    let formatter = NumberFormatter()
    
    var shoppingValueInReal: Double {
        return shoppingValue * dollarQuotation
    }
    
    var stateTaxValue: Double {
        return shoppingValue * stateTax/100
    }
    
    var iofValue: Double {
        return (shoppingValue+stateTax)*IOF/100
    }
    
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
    
    func calculate(usingCreditCard: Bool) -> Double {
        var finalValue = shoppingValue + stateTaxValue
        if usingCreditCard{
            finalValue += iofValue
        }
        
        return 0
    }
    
    func convertToDouble(_ string: String) -> Double{
        formatter.numberStyle = .none
        return formatter.number(from: string.replacingOccurrences(of: ".", with: ","))!.doubleValue
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
