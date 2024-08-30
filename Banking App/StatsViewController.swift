import UIKit
import Charts
import FirebaseDatabase

class StatsViewController: UIViewController {

    var databaseRef: DatabaseReference!
    var expensesByCategory: [String: Double] = [:]
    var totalExpenses: Double = 0.0
    
    let pieChartView = PieChartView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

        // Initialize Firebase Database reference
        databaseRef = Database.database().reference()

        pieChartView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        pieChartView.center = self.view.center
        self.view.addSubview(pieChartView)

        fetchExpensesData()
    }

    func fetchExpensesData() {
        databaseRef.child("transactions").observe(.value) { snapshot in
            self.expensesByCategory.removeAll()
            self.totalExpenses = 0.0

            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let transaction = childSnapshot.value as? [String: String],
                   let type = transaction["type"], type == "Expense",
                   let category = transaction["title"],
                   let priceStr = transaction["price"], let price = Double(priceStr) {

                    self.expensesByCategory[category, default: 0.0] += price
                    self.totalExpenses += price
                }
            }

            self.updatePieChart()
        }
    }

    func updatePieChart() {
        var entries: [PieChartDataEntry] = []

        for (category, totalAmount) in expensesByCategory {
            let percentage = (totalAmount / totalExpenses) * 100.0
            let entry = PieChartDataEntry(value: percentage, label: category)
            entries.append(entry)
        }

        let dataSet = PieChartDataSet(entries: entries, label: "Expenses")
        dataSet.colors = ChartColorTemplates.material()
        dataSet.sliceSpace = 2.0
        dataSet.valueTextColor = UIColor.black
        dataSet.valueFont = UIFont.systemFont(ofSize: 12)

        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        pieChartView.centerText = "Expenses"
        pieChartView.holeRadiusPercent = 0.5
        pieChartView.notifyDataSetChanged()
    }
}
