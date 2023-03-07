//
//  UserDefauls.swift
//  AndreDaniloFlavioSamuel
//
//  Created by Danilo Santos on 06/03/23.
//

import Foundation

enum UserDefaulsKeys: String {
    case dollarQuotation = "dollarQuotation"
    case IOF = "IOF"
}

class UserDefauls {
    
    let defaults = UserDefaults.standard
    
    static let shared = UserDefauls()
    
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
    
    private init(){
        dollarQuotation = dollarQuotation == 0  ? 5.21 : dollarQuotation
        IOF = IOF == 0  ? 6.38 : IOF
    }
}

