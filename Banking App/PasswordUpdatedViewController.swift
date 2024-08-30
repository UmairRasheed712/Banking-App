import UIKit

class PasswordUpdatedViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        // Display the confirmation message
        let successLabel = UILabel()
        successLabel.text = "Your Password is updated successfully"
        successLabel.textAlignment = .center
        successLabel.numberOfLines = 0
        successLabel.frame = CGRect(x: 20, y: 100, width: self.view.frame.width - 40, height: 100)
        self.view.addSubview(successLabel)
        
        // Back to Home Button setup
        let backToHomeButton = UIButton()
        backToHomeButton.setTitle("Back to Home", for: .normal)
        backToHomeButton.backgroundColor = .systemGreen
        backToHomeButton.layer.cornerRadius = 5
        backToHomeButton.frame = CGRect(x: 20, y: 220, width: self.view.frame.width - 40, height: 40)
        backToHomeButton.addTarget(self, action: #selector(backToHomePressed), for: .touchUpInside)
        self.view.addSubview(backToHomeButton)
    }
    
    @objc func backToHomePressed() {
        // Code to navigate back to the Home screen
        self.dismiss(animated: true, completion: nil)
    }
}
