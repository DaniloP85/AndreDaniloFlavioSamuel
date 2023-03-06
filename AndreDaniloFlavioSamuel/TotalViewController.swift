//
//  TotalViewController.swift
//  AndreDaniloFlavioSamuel
//
//  Created by Danilo Santos on 21/02/23.
//

import UIKit

class TotalViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var lbTotalReal: UILabel!
    @IBOutlet weak var lbTotalDollar: UILabel!
    
    // MARK: - Properties
    var productManager = ProductManager.shared
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadState()
    }
    
    // MARK: - Methods
    func loadState() {
        productManager.loadProduct(with: context, key: "name")
        var totalDollar: Double = 0
        var totalReal: Double = 0
        
        for product in productManager.products {
            let dolarPlusTax = ((product.value * (product.state!.tax/100)) + product.value)
            totalDollar = totalDollar + dolarPlusTax
            let conversionToReal = (dolarPlusTax * userDefauls.dollarQuotation)
            totalReal = totalReal + conversionToReal
            if (product.creditCard) {
                let realPlusIOF = (conversionToReal * (userDefauls.IOF/100))
                totalReal = totalReal + realPlusIOF
            }
        }
        
        lbTotalReal.text = formatterValues.getFormattedValue(of: totalReal, withCurrency: "")
        lbTotalDollar.text = formatterValues.getFormattedValue(of: totalDollar, withCurrency: "")
    }
}
