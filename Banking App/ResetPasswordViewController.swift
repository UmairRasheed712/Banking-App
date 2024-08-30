import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController {
    
    let emailTextField = UITextField()
    let sendLinkButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        // Email TextField setup
        emailTextField.placeholder = "Enter your email"
        emailTextField.keyboardType = .emailAddress
        emailTextField.borderStyle = .roundedRect
        emailTextField.autocapitalizationType = .none
        emailTextField.frame = CGRect(x: 20, y: 100, width: self.view.frame.width - 40, height: 40)
        self.view.addSubview(emailTextField)
        
        // Send Link Button setup
        sendLinkButton.setTitle("Send Link", for: .normal)
        sendLinkButton.backgroundColor = .systemGreen
        sendLinkButton.layer.cornerRadius = 5
        sendLinkButton.frame = CGRect(x: 20, y: 160, width: self.view.frame.width - 40, height: 40)
        sendLinkButton.addTarget(self, action: #selector(sendLinkPressed), for: .touchUpInside)
        self.view.addSubview(sendLinkButton)
    }
    
    @objc func sendLinkPressed() {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Error", message: "Please enter your email address.")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                self.showAlert(title: "Success", message: "A password reset link has been sent to your email address.")
                
            }
        }
        self.performSegue(withIdentifier: "updated", sender: Any?.self)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
