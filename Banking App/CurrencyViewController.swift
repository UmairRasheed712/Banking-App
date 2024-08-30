import UIKit

class CurrencyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    let uniqueCurrencyCodes = [
        "AFN", "ALL", "DZD", "EUR", "AOA", "XCD", "ARS", "AMD", "AUD", "AZN", "BSD", "BHD", "BDT", "BBD",
        "BYN", "BZD", "XOF", "BTN", "BOB", "BAM", "BWP", "BRL", "BND", "BGN", "BIF", "CVE", "KHR", "XAF",
        "CAD", "CDF", "CRC", "HRK", "CUP", "CUC", "CZK", "DKK", "DJF", "DOP", "USD", "EGP", "SVC", "ERN",
        "SZL", "ETB", "FJD", "GMD", "GEL", "GHS", "GTQ", "GNF", "GYD", "HTG", "HNL", "HUF", "ISK", "INR",
        "IDR", "IRR", "IQD", "ILS", "JMD", "JPY", "JOD", "KZT", "KES", "KWD", "KGS", "LAK", "LBP", "LSL",
        "LYD", "CHF", "MGA", "MWK", "MYR", "MVR", "MRU", "MUR", "MXN", "MDL", "MNT", "MAD", "MZN", "MMK",
        "NAD", "NPR", "NIO", "NGN", "MKD", "NOK", "OMR", "PKR", "PAB", "PGK", "PYG", "PEN", "PHP", "PLN",
        "QAR", "RON", "RUB", "RWF", "WST", "STN", "SAR", "RSD", "SCR", "SLL", "SGD", "SOS", "ZAR", "KRW",
        "SSP", "LKR", "SDG", "SRD", "SEK", "SYP", "TWD", "TJS", "TZS", "THB", "TOP", "TTD", "TND", "TRY",
        "TMT", "UGX", "UAH", "AED", "GBP", "UYU", "UZS", "VUV", "VES", "VND", "YER", "ZMW", "XDR"
    ]
    
    let sortedUniqueCountries = [
        "Afghanistan", "Albania", "Algeria", "Eurozone", "Angola", "Antigua and Barbuda", "Argentina",
        "Armenia", "Australia", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus",
        "Belize", "West African CFA Franc", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana",
        "Brazil", "Brunei", "Bulgaria", "Burundi", "Cabo Verde", "Cambodia", "Central African CFA Franc",
        "Canada", "Democratic Republic of the Congo", "Costa Rica", "Croatia", "Cuba", "Cuba", "Czech Republic",
        "Denmark", "Djibouti", "Dominican Republic", "United States", "Egypt", "El Salvador", "Eritrea",
        "Eswatini", "Ethiopia", "Fiji", "Gambia", "Georgia", "Ghana", "Guatemala", "Guinea", "Guyana",
        "Haiti", "Honduras", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Israel",
        "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kuwait", "Kyrgyzstan", "Laos", "Lebanon",
        "Lesotho", "Libya", "Switzerland", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mauritania",
        "Mauritius", "Mexico", "Moldova", "Mongolia", "Morocco", "Mozambique", "Myanmar", "Namibia",
        "Nepal", "Nicaragua", "Nigeria", "North Macedonia", "Norway", "Oman", "Pakistan", "Panama",
        "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Qatar", "Romania", "Russia",
        "Rwanda", "Samoa", "São Tomé and Príncipe", "Saudi Arabia", "Serbia", "Seychelles", "Sierra Leone",
        "Singapore", "Somalia", "South Africa", "South Korea", "South Sudan", "Sri Lanka", "Sudan",
        "Suriname", "Sweden", "Syria", "Taiwan", "Tajikistan", "Tanzania", "Thailand", "Tonga",
        "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Uganda", "Ukraine", "United Arab Emirates",
        "United Kingdom", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "Yemen", "Zambia",
        "Special Drawing Rights"
    ]

    var filteredCurrencyCodes: [String] = []
    var filteredCountries: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        filteredCurrencyCodes = uniqueCurrencyCodes
        filteredCountries = sortedUniqueCountries
        
        // Add tap gesture recognizer to dismiss keyboard
        hideKeyboardWhenReturnKeyTapped()
    }

    // MARK: - Table View Data Source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCurrencyCodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CurrencyTableViewCell else {
            return UITableViewCell()
        }
        
        cell.codeLbl.text = filteredCurrencyCodes[indexPath.row]
        cell.countryLbl.text = filteredCountries[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "ChoiceViewController") as! ChoiceViewController
        detail.strCurrencylbl = filteredCurrencyCodes[indexPath.row]
        print(detail.strCurrencylbl ?? "no data")
        UserDefaults.standard.set(detail.strCurrencylbl, forKey: "currency")
        self.navigationController?.pushViewController(detail, animated: true)
    }

    // MARK: - UISearchBar Delegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCurrencyCodes = uniqueCurrencyCodes
            filteredCountries = sortedUniqueCountries
        } else {
            filteredCurrencyCodes = []
            filteredCountries = []
            
            for (index, currency) in uniqueCurrencyCodes.enumerated() {
                let country = sortedUniqueCountries[index]
                if currency.lowercased().contains(searchText.lowercased()) || country.lowercased().contains(searchText.lowercased()) {
                    filteredCurrencyCodes.append(currency)
                    filteredCountries.append(country)
                }
            }
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
 
}

extension UIViewController: UITextFieldDelegate {

    // Call this method in viewDidLoad
    func hideKeyboardWhenReturnKeyTapped() {
        // For all text fields in the view controller's view hierarchy
        for view in self.view.subviews {
            if let textField = view as? UITextField {
                textField.delegate = self
            }
        }
    }

    // UITextFieldDelegate method
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard
        textField.resignFirstResponder()
        return true
    }
}
