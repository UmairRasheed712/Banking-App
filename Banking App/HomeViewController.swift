import UIKit
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var incCurrencyLbl: UILabel!
    @IBOutlet var incomeLabel: UILabel!
    @IBOutlet var expenseCurrencyLbl: UILabel!
    @IBOutlet var expenseLabel: UILabel!
    
    var totalAmount: Double = 0.0
    var transactions: [[String: String]] = []
    var databaseRef: DatabaseReference!

    let strCurrency = UserDefaults.standard.string(forKey: "currency") ?? ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        // Initialize the Firebase Database reference
        databaseRef = Database.database().reference()
        
        loadTransactionsFromFirebase()
        currencyLbl.text = strCurrency
        incCurrencyLbl.text = strCurrency
        expenseCurrencyLbl.text = strCurrency
    }

    func loadTransactionsFromFirebase() {
        databaseRef.child("transactions").observeSingleEvent(of: .value) { (snapshot) in
            guard let transactionsDict = snapshot.value as? [String: [String: String]] else {
                print("Error: No data found")
                return
            }
            
            self.transactions = Array(transactionsDict.values)
            self.updateLabels()
            self.tableView.reloadData()
        }
    }

    func updateLabels() {
        var incomeAmount: Double = 0.0
        var expenseAmount: Double = 0.0
        
        for transaction in transactions {
            if let type = transaction["type"], let amountStr = transaction["price"], let amount = Double(amountStr) {
                if type == "Income" {
                    incomeAmount += amount
                } else if type == "Expense" {
                    expenseAmount += amount
                }
            }
        }
        
        incomeLabel.text = String(format: "%.2f", incomeAmount)
        expenseLabel.text = String(format: "%.2f", expenseAmount)
        
        totalAmount = incomeAmount - expenseAmount
        amountLbl.text = String(format: "%.2f", totalAmount)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryTableViewCell
        let transaction = transactions[indexPath.row]
        
        cell.titleLbl.text = transaction["title"]
        cell.typeLbl.text = transaction["type"]
        cell.priceLbl.text = transaction["price"]
        
        return cell
    }
}
