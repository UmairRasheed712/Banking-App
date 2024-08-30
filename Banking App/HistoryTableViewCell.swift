//
//  HistoryTableViewCell.swift
//  Banking App
//
//  Created by Apple on 03/08/2024.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
   
    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var priceLbl: UILabel!
    
    @IBOutlet var typeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        titleLbl.layer.cornerRadius = 20
        
        titleLbl.clipsToBounds = true
       
        // Configure the view for the selected state
    }

}
