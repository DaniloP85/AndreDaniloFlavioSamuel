//
//  ProductTableViewCell.swift
//  AndreDaniloFlavioSamuel
//
//  Created by Danilo Santos on 25/02/23.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var ivCover: UIImageView!

    // MARK: - Super Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Methods
    func prepare(with product: Product){
        lbTitle.text = product.name ?? ""
        lbValue.text = formatterValues.getFormattedValue(of: product.value, withCurrency: "U$")
        if let image = product.cover as? UIImage {
            ivCover.image = image
        }else{
            ivCover.image = UIImage(named: "gift")
        }
    }
}
