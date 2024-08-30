import UIKit

class GoalsTableViewCell: UITableViewCell {

    @IBOutlet weak var goalNameLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var currentAmountLabel: UILabel!
    @IBOutlet weak var targetAmountLabel: UILabel!

    func configure(with goal: Goal) {
        goalNameLabel.text = goal.name
        currentAmountLabel.text = "\(goal.currentAmount)"
        targetAmountLabel.text = "\(goal.targetAmount)"
        
        let progress = goal.currentAmount / goal.targetAmount
        progressView.progress = Float(progress)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        goalNameLabel.layer.cornerRadius = 20
        
        goalNameLabel.clipsToBounds = true
       
        // Configure the view for the selected state
    }
}
