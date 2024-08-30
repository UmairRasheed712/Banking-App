import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    func configure(with category: String, isSelected: Bool) {
        titleLabel.text = category
        contentView.layer.cornerRadius = 25 // Rounded corners
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = isSelected ? .black : .lightGray // Customize as needed
        titleLabel.textColor = isSelected ? .white : .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16) // Set font size
    }
}
