//
//  ProductTableViewCell.swift
//  AndreDaniloFlavioSamuel
//
//  Created by Danilo Santos on 25/02/23.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var lbStateName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(with product: Product){
        lbTitle.text = product.name ?? ""
//        lbStateName.text = product.state?.state
        lbValue.text = tc.getFormattedValue(of: product.value, withCurrency: "U$")
        if let image = product.cover as? UIImage {
            ivCover.image = image
        }else{
            ivCover.image = UIImage(named: "gift")
        }
    }
}
