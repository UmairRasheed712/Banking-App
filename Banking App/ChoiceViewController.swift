
import UIKit

class ChoiceViewController: UIViewController {


    @IBOutlet weak var accountTypeLabel: UILabel!
    
    @IBOutlet weak var currencyLabel: UILabel!
    
//    var strCurrencylbl : String!
 
    @IBOutlet var amountLbl: UILabel!
    
    @IBOutlet weak var cashButton: UIButton!
    @IBOutlet weak var bankButton: UIButton!
    @IBOutlet weak var addNewButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var strCurrencylbl : String!
    var lastButtonYPosition: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial setup
        updateSelectedAccountType(accountType: "Bank") // Default selection
        
        currencyLabel.text = strCurrencylbl
        
        // Adding actions to buttons
        cashButton.addTarget(self, action: #selector(cashButtonTapped), for: .touchUpInside)
        bankButton.addTarget(self, action: #selector(bankButtonTapped), for: .touchUpInside)
        addNewButton.addTarget(self, action: #selector(addNewButtonTapped), for: .touchUpInside)
        
        // Set initial button Y position
        lastButtonYPosition = addNewButton.frame.maxY + 105 // Adjust starting position below the "Add New" button
    }
    
    // MARK: - Button Actions
    
    @objc func cashButtonTapped() {
        updateSelectedAccountType(accountType: "Cash")
    }
    
    @objc func bankButtonTapped() {
        updateSelectedAccountType(accountType: "Bank")
    }
    
    @objc func addNewButtonTapped() {
        let alertController = UIAlertController(title: "Add New", message: "Enter the name of the new account type(not more than 20 alphabets):", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Account Type"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self, let newAccountType = alertController.textFields?.first?.text, !newAccountType.isEmpty else {
                print("Invalid or empty account type")
                return
            }
            
            // Update UI with new account type
            self.updateSelectedAccountType(accountType: newAccountType)
            
            // Create a new button for the custom account type
            self.createCustomButton(withTitle: newAccountType)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    @objc func customButtonTapped(_ sender: UIButton) {
        if let customType = sender.titleLabel?.text {
            updateSelectedAccountType(accountType: customType)
        }
    }
    
    // MARK: - Update UI
    
    func updateSelectedAccountType(accountType: String) {
        accountTypeLabel.text = accountType
        amountLbl.text = "0.00"
        currencyLabel.text = strCurrencylbl
    }
    
    // MARK: - Create Custom Button
    
    func createCustomButton(withTitle title: String) {
        let customButton = UIButton(type: .system)
        customButton.setTitle(title, for: .normal)
        customButton.backgroundColor = UIColor(red: 0.0, green: 120/255, blue: 0.0, alpha: 1.0)
        customButton.setTitleColor(.white, for: .normal)
        customButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        customButton.layer.cornerRadius = 25 // Half of button height for capsule shape
        customButton.clipsToBounds = true
        customButton.frame = CGRect(x: 29, y: lastButtonYPosition, width: self.view.frame.width - 150, height: 50)
        // Assuming you have the image in SF Symbols or your asset catalog
        let image = UIImage(systemName: "plus.circle.dashed")?.withRenderingMode(.alwaysTemplate)
        customButton.setImage(image, for: .normal)

        // Set the tint color of the image
        customButton.tintColor = .white // Change this to your desired color


        // Adjust the image position if needed
        customButton.imageView?.contentMode = .scaleAspectFit
        customButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10) // Adjust as needed
        
        customButton.addTarget(self, action: #selector(customButtonTapped(_:)), for: .touchUpInside)
        
        // Debug: Check button frame and title
        print("Adding button with title: \(title) at position: \(customButton.frame)")
        
        // Add the new button directly to the main view
        self.view.addSubview(customButton)
        
        // Update the last Y position for the next button
        lastButtonYPosition += 54 // Button height (44) + spacing (10)
    }
    
    
    @IBAction func nextPressed(_ sender: Any) {
        let strAmount : String!
        strAmount = amountLbl.text
        UserDefaults.standard.set(strAmount, forKey: "amounttt")
    }
}
