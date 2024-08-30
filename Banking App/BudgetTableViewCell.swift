//
//  BudgetTableViewCell.swift
//  
//
//  Created by Apple on 09/08/2024.
//

import UIKit

class BudgetTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var currentAmountLabel: UILabel!
    @IBOutlet var totalAmountLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!

    func configure(with budget: Budget) {
        titleLabel.text = budget.name
        currentAmountLabel.text = String(budget.currentAmount)
        totalAmountLabel.text = String(budget.totalAmount)
        
        let progress = budget.currentAmount / budget.totalAmount
        progressView.progress = Float(progress)
    }



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        titleLabel.layer.cornerRadius = 20
        titleLabel.clipsToBounds = true
        // Configure the view for the selected state
    }

}
