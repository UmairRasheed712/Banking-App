//
//  CurrencyTableViewCell.swift
//  Banking App
//
//  Created by User on 01/08/2024.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var codeLbl: UILabel!
    
    @IBOutlet weak var countryLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
