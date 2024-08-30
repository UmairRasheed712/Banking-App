import UIKit
import FirebaseDatabase

struct Goal {
    let name: String
    var currentAmount: Double
    let targetAmount: Double
    let percentage: Double // New field for percentage allocation
}


class GoalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var myTableView: UITableView!
    
    var goals: [Goal] = []
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        fetchGoals()
        
        // Listen for updates to goals
        NotificationCenter.default.addObserver(self, selector: #selector(fetchGoals), name: .goalUpdated, object: nil)
    }

    // Fetch goals from Firebase Realtime Database
    @objc func fetchGoals() {
        ref.child("goals").observe(.value, with: { snapshot in
            var newGoals: [Goal] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let goalData = snapshot.value as? [String: AnyObject],
                   let name = goalData["name"] as? String,
                   let currentAmount = goalData["currentAmount"] as? Double,
                   let targetAmount = goalData["targetAmount"] as? Double,
                   let percentage = goalData["percentage"] as? Double {
                    let goal = Goal(name: name, currentAmount: currentAmount, targetAmount: targetAmount, percentage: percentage)
                    newGoals.append(goal)
                }
            }
            self.goals = newGoals
            self.myTableView.reloadData()
        })
    }

    
    // Save a new goal to Firebase
    func saveGoal(_ goal: Goal) {
        let goalRef = ref.child("goals").childByAutoId()
        let goalData: [String: Any] = [
            "name": goal.name,
            "currentAmount": goal.currentAmount,
            "targetAmount": goal.targetAmount,
            "percentage": goal.percentage // Saving percentage to Firebase
        ]
        goalRef.setValue(goalData)
    }

    // MARK: - TableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath) as! GoalsTableViewCell
        let goal = goals[indexPath.row]
        cell.configure(with: goal)
        return cell
    }

    // MARK: - Swipe Actions
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            // Delete the goal from Firebase
            let goalToDelete = self.goals[indexPath.row]
            self.deleteGoalFromFirebase(goalToDelete)

            // Remove the goal from the array and delete the row from the table view
            self.goals.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)

            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
    
    // Delete goal from Firebase
    func deleteGoalFromFirebase(_ goal: Goal) {
        ref.child("goals").observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let goalData = snapshot.value as? [String: AnyObject],
                   let name = goalData["name"] as? String,
                   name == goal.name {
                    snapshot.ref.removeValue()
                }
            }
        })
    }
    
    // MARK: - Button Actions
    
    @IBAction func addNewGoal(_ sender: UIButton) {
        let alertController = UIAlertController(title: "New Goal", message: "Enter goal details", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Goal Name"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Target Amount"
            textField.keyboardType = .decimalPad
        }
        alertController.addTextField { textField in
            textField.placeholder = "Percentage of Income (%)"
            textField.keyboardType = .decimalPad
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let goalName = alertController.textFields?[0].text,
                  let targetAmountText = alertController.textFields?[1].text,
                  let targetAmount = Double(targetAmountText),
                  let percentageText = alertController.textFields?[2].text,
                  let percentage = Double(percentageText) else { return }
            
            let newGoal = Goal(name: goalName, currentAmount: 0.0, targetAmount: targetAmount, percentage: percentage)
            self?.saveGoal(newGoal)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension Notification.Name {
    static let goalUpdated = Notification.Name("goalUpdated")
}


