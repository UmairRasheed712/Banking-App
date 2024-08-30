import UIKit
import FirebaseDatabase

struct Budget {
    let name: String
    let category: String // Add this field
    var currentAmount: Double
    let totalAmount: Double
}



class BudgetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var budgetTableView: UITableView!
    
    var budgets: [Budget] = []
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Firebase reference setup
        ref = Database.database().reference()
        
        // Fetch budgets from Firebase
        fetchBudgets()
        
        // Observe the budgetUpdated notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleBudgetUpdatedNotification), name: .budgetUpdated, object: nil)
    }


    @objc func handleBudgetUpdatedNotification() {
        fetchBudgets()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .budgetUpdated, object: nil)
    }

    


    
    // Fetch budgets from Firebase Realtime Database
    func fetchBudgets() {
        ref.child("budgets").observe(.value, with: { snapshot in
            var newBudgets: [Budget] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let budgetData = snapshot.value as? [String: AnyObject],
                   let name = budgetData["name"] as? String,
                   let category = budgetData["category"] as? String, // Fetch the category
                   let currentAmount = budgetData["currentAmount"] as? Double,
                   let totalAmount = budgetData["totalAmount"] as? Double {
                    
                    let budget = Budget(name: name, category: category, currentAmount: currentAmount, totalAmount: totalAmount)
                    newBudgets.append(budget)
                }
            }
            self.budgets = newBudgets
            DispatchQueue.main.async {
                self.budgetTableView.reloadData()
            }
        })
    }



    
    // Save a new budget to Firebase
    func saveBudget(_ budget: Budget) {
        let budgetRef = ref.child("budgets").childByAutoId()
        let budgetData: [String: Any] = [
            "name": budget.name,
            "category": budget.category, // Save the category
            "currentAmount": budget.currentAmount,
            "totalAmount": budget.totalAmount
        ]
        budgetRef.setValue(budgetData) { error, _ in
            if let error = error {
                print("Error saving budget: \(error.localizedDescription)")
            } else {
                print("Budget saved successfully")
                self.fetchBudgets()
            }
        }
    }



    // MARK: - TableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetCell", for: indexPath) as! BudgetTableViewCell
        let budget = budgets[indexPath.row]
        cell.configure(with: budget)
        return cell
    }

    // MARK: - Swipe Actions
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            // Delete the budget from Firebase
            let budgetToDelete = self.budgets[indexPath.row]
            self.deleteBudgetFromFirebase(budgetToDelete)

            // Remove the budget from the array and delete the row from the table view
            self.budgets.remove(at: indexPath.row)
            tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)


            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor.red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
    
    // Delete budget from Firebase
    func deleteBudgetFromFirebase(_ budget: Budget) {
        ref.child("budgets").observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let budgetData = snapshot.value as? [String: AnyObject],
                   let name = budgetData["name"] as? String,
                   name == budget.name {
                    snapshot.ref.removeValue()
                }
            }
        })
    }
    
    // MARK: - Button Actions
    
    @IBAction func addNewBudget(_ sender: UIButton) {
        let alertController = UIAlertController(title: "New Budget", message: "Enter budget details", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Budget Name"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Category"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Total Amount"
            textField.keyboardType = .decimalPad
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let budgetName = alertController.textFields?[0].text,
                  let category = alertController.textFields?[1].text,
                  let totalAmountText = alertController.textFields?[2].text,
                  let totalAmount = Double(totalAmountText) else { return }
            
            let newBudget = Budget(name: budgetName, category: category, currentAmount: 0.0, totalAmount: totalAmount)
            self?.saveBudget(newBudget)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

}




import Foundation

extension Notification.Name {
    static let budgetUpdated = Notification.Name("budgetUpdated")
}

