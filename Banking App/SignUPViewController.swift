import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

class SignUPViewController: UIViewController {
    
    // Define the password text field and the show/hide password button as class properties
    let passwordTextField = UITextField()
    let showPasswordButton = UIButton(type: .custom)
    
    // Add email and fullName text fields as properties for easy access in the sign-up method
    let emailTextField = UITextField()
    let fullNameTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        // Setup Full Name Text Field
        fullNameTextField.frame = CGRect(x: 10, y: 200, width: 375, height: 60)
        fullNameTextField.backgroundColor = .init(displayP3Red: 0, green: 0, blue: 0, alpha: 0.1)
        
        // Create container view for images
        let fullNameLeftView = UIView()
        fullNameLeftView.frame = CGRect(x: 0, y: 0, width: 60, height: 50)
        
        // Create first image view
        let fullNameFirstImageView = UIImageView(image: UIImage(named: "me"))
        fullNameFirstImageView.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        fullNameFirstImageView.contentMode = .scaleAspectFit
        fullNameLeftView.addSubview(fullNameFirstImageView)
        
        // Create second image view
        let fullNameSecondImageView = UIImageView(image: UIImage(named: "Line"))
        fullNameSecondImageView.frame = CGRect(x: 35, y: 10, width: 30, height: 30)
        fullNameSecondImageView.contentMode = .scaleAspectFit
        fullNameLeftView.addSubview(fullNameSecondImageView)
        
        // Set left view of the full name text field
        fullNameTextField.leftView = fullNameLeftView
        fullNameTextField.leftViewMode = .always
        
        // Set placeholder and other properties
        fullNameTextField.textAlignment = .left
        fullNameTextField.attributedPlaceholder = NSAttributedString(
            string: "FullName",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)
            ]
        )
        
        // Set rounded corners
        fullNameTextField.layer.cornerRadius = fullNameTextField.frame.height / 2
        fullNameTextField.layer.masksToBounds = true
        fullNameTextField.layer.borderColor = UIColor.gray.cgColor
        fullNameTextField.layer.borderWidth = 1.0
        
        // Add full name text field to the view
        self.view.addSubview(fullNameTextField)
        
        // Setup Email Text Field
        emailTextField.frame = CGRect(x: 10, y: 270, width: 375, height: 60)
        emailTextField.backgroundColor = .init(displayP3Red: 0, green: 0, blue: 0, alpha: 0.1)
        
        // Create container view for images
        let emailLeftView = UIView()
        emailLeftView.frame = CGRect(x: 0, y: 0, width: 60, height: 50)
        
        // Create first image view
        let emailFirstImageView = UIImageView(image: UIImage(named: "at-sign"))
        emailFirstImageView.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        emailFirstImageView.contentMode = .scaleAspectFit
        emailLeftView.addSubview(emailFirstImageView)
        
        // Create second image view
        let emailSecondImageView = UIImageView(image: UIImage(named: "Line"))
        emailSecondImageView.frame = CGRect(x: 35, y: 10, width: 30, height: 30)
        emailSecondImageView.contentMode = .scaleAspectFit
        emailLeftView.addSubview(emailSecondImageView)
        
        // Set left view of the email text field
        emailTextField.leftView = emailLeftView
        emailTextField.leftViewMode = .always
        
        // Set placeholder and other properties
        emailTextField.textAlignment = .left
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)
            ]
        )
        
        // Set rounded corners
        emailTextField.layer.cornerRadius = emailTextField.frame.height / 2
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.borderColor = UIColor.gray.cgColor
        emailTextField.layer.borderWidth = 1.0
        
        // Add email text field to the view
        self.view.addSubview(emailTextField)
        
        // Setup Password Text Field
        passwordTextField.frame = CGRect(x: 10, y: 340, width: 375, height: 62)
        passwordTextField.backgroundColor = .init(displayP3Red: 0, green: 0, blue: 0, alpha: 0.1)
        
        // Create container view for images
        let passwordLeftView = UIView()
        passwordLeftView.frame = CGRect(x: 0, y: 0, width: 60, height: 50)
        
        // Create first image view
        let firstImage = UIImageView(image: UIImage(named: "shield-keyhole-line"))
        firstImage.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        firstImage.contentMode = .scaleAspectFit
        passwordLeftView.addSubview(firstImage)
        
        // Create second image view
        let secondImage = UIImageView(image: UIImage(named: "Line"))
        secondImage.frame = CGRect(x: 35, y: 10, width: 30, height: 30)
        secondImage.contentMode = .scaleAspectFit
        passwordLeftView.addSubview(secondImage)
        
        // Set left view of the password text field
        passwordTextField.leftView = passwordLeftView
        passwordTextField.leftViewMode = .always
        
        // Set placeholder and other properties
        passwordTextField.textAlignment = .left
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)
            ]
        )
        
        // Set rounded corners
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height / 2
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        passwordTextField.layer.borderWidth = 1.0
        
        // Set the text field to secure entry (for password input)
        passwordTextField.isSecureTextEntry = true
        
        // Create a container view for the show/hide password button
        let rightViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 30)) // Adjust width for more left shift
        rightViewContainer.backgroundColor = .clear
        
        // Create a button for showing/hiding password
        showPasswordButton.setImage(UIImage(named: "custom.eye"), for: .normal) // "eye" icon for show password
        showPasswordButton.setImage(UIImage(named: "eye-slash"), for: .selected) // "eye-slash" icon for hide password
        showPasswordButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30) // Adjust size as needed
        showPasswordButton.contentMode = .scaleAspectFit
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        // Add the button to the container view
        rightViewContainer.addSubview(showPasswordButton)
        showPasswordButton.center = CGPoint(x: rightViewContainer.bounds.midX - 5, y: rightViewContainer.bounds.midY) // Adjust x value for more left alignment
        
        // Set the container as the right view of the text field
        passwordTextField.rightView = rightViewContainer
        passwordTextField.rightViewMode = .always
        
        // Add password text field to the view
        self.view.addSubview(passwordTextField)
    }
    
    // MARK: - Toggle Password Visibility
    @objc func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        showPasswordButton.isSelected.toggle()
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let fullName = fullNameTextField.text, !fullName.isEmpty else {
            showAlert(title: "Missing Information", message: "Please fill in all fields.")
            return
        }
        
        // Firebase sign-up process
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlert(title: "Sign Up Error", message: error.localizedDescription)
            } else {
                // Successful sign-up
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = fullName
                changeRequest?.commitChanges(completion: { error in
                    if let error = error {
                        self.showAlert(title: "Profile Update Error", message: error.localizedDescription)
                    } else {
                        // Successfully set display name
                        // Navigate to HomeViewController or desired screen
                        self.performSegue(withIdentifier: "signUpToHome", sender: nil)
                    }
                })
            }
        }
    }
    
    // MARK: - Helper Methods
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
