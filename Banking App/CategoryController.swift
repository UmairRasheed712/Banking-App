import UIKit
import FirebaseDatabase

class CategoryController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var amountField: UITextField!
    @IBOutlet var typeButton: UIButton! // Connect this to your pull-down button
    
    let categories = [
        "Food", "Mobile", "Electricity", "Gas", "Transport", "Fuel", "Education", "Internet", "House Rent", "Gaming", "Gym", "Health"
    ]
    
    var selectedCategory: String?
    var selectedType: String?
    var databaseRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.backgroundColor = .clear
        
        // Initialize the Firebase Database reference
        databaseRef = Database.database().reference()
    }

    @IBAction func typeSelection(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Type", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Income", style: .default, handler: { _ in
            self.selectedType = "Income"
            self.typeButton.setTitle("Income", for: .normal)
        }))
        
        alertController.addAction(UIAlertAction(title: "Expense", style: .default, handler: { _ in
            self.selectedType = "Expense"
            self.typeButton.setTitle("Expense", for: .normal)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category = categories[indexPath.item]
        
        // Calculate the size of the label based on the text content
        let textAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
        let textSize = (category as NSString).size(withAttributes: textAttributes)
        
        // Increase the padding and minimum width for larger labels
        let padding: CGFloat = 40
        let minWidth: CGFloat = 100 // Increase the minimum width further
        let width = max(textSize.width + padding, minWidth)
        let height = textSize.height + 30 // Increase the height as well
        
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category = categories[indexPath.item]
        cell.configure(with: category, isSelected: false)
        
        // Adjust the corner radius for the increased height
        cell.layer.cornerRadius = cell.bounds.height / 2
        cell.layer.masksToBounds = true
        
        return cell
    }




    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }



    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        print("Selected category: \(selectedCategory ?? "None")")
        
        guard let selectedType = selectedType else {
            print("Error: Type not selected")
            return
        }
        
        if let amountText = amountField.text, !amountText.isEmpty, let amount = Double(amountText) {
            let transaction: [String: String] = [
                "type": selectedType,
                "title": selectedCategory ?? "Unknown",
                "price": amountText
            ]
            saveTransactionToFirebase(transaction, amount: amount)
            
            if selectedType == "Income" {
                updateGoalsWithIncome(amount)
            }
        }

        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showNextScreen", sender: self)
        }
    }


    func saveTransactionToFirebase(_ transaction: [String: String], amount: Double) {
        guard let key = databaseRef.child("transactions").childByAutoId().key else { return }
        databaseRef.child("transactions/\(key)").setValue(transaction) { (error, ref) in
            if let error = error {
                print("Error saving to Firebase: \(error)")
            } else {
                print("Successfully saved to Firebase")
                
                if self.selectedType == "Expense" {
                    self.updateBudgetWithExpense(amount, forCategory: transaction["title"]!)
                    
                    // Post notification to update BudgetViewController
                    NotificationCenter.default.post(name: .budgetUpdated, object: nil)
                }
            }
        }
    }

    func updateBudgetWithExpense(_ amount: Double, forCategory category: String) {
        databaseRef.child("budgets").observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let budgetData = snapshot.value as? [String: AnyObject],
                   let name = budgetData["name"] as? String,
                   let budgetCategory = budgetData["category"] as? String, // Get the category
                   budgetCategory == category, // Match the category
                   let currentAmount = budgetData["currentAmount"] as? Double,
                   let targetAmount = budgetData["totalAmount"] as? Double {

                    let newAmount = min(currentAmount + amount, targetAmount)
                    snapshot.ref.child("currentAmount").setValue(newAmount) { error, ref in
                        if let error = error {
                            print("Error updating budget: \(error.localizedDescription)")
                        } else {
                            print("Budget successfully updated")
                            NotificationCenter.default.post(name: .budgetUpdated, object: nil)
                        }
                    }
                    
                    // Remove budget if complete
                    if newAmount >= targetAmount {
                        snapshot.ref.removeValue()
                    }
                }
            }
        }) { error in
            print("Error updating budget: \(error.localizedDescription)")
        }
    }







    func updateGoalsWithIncome(_ amount: Double) {
        databaseRef.child("goals").observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let goalData = snapshot.value as? [String: AnyObject],
                   let currentAmount = goalData["currentAmount"] as? Double,
                   let targetAmount = goalData["targetAmount"] as? Double,
                   let percentage = goalData["percentage"] as? Double {
                    
                    let amountToAdd = (amount * percentage) / 100.0
                    let newAmount = min(currentAmount + amountToAdd, targetAmount)
                    snapshot.ref.child("currentAmount").setValue(newAmount)
                    
                    // Ensure the progress view in GoalsViewController is updated
                    NotificationCenter.default.post(name: .goalUpdated, object: nil)
                }
            }
        })
    }



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNextScreen" {
            if let destinationVC = segue.destination as? HomeViewController {
                destinationVC.loadTransactionsFromFirebase()
            }
        }
    }
}
