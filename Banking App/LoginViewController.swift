import UIKit
import FirebaseAuth
import Firebase
import FirebaseCore
import GoogleSignIn

class LoginViewController: UIViewController {
    
    let passwordTextField = UITextField()
    let showPasswordButton = UIButton(type: .custom)
    let emailTextField = UITextField() // This is your programmatically created emailTextField

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        // Setup emailTextField
        emailTextField.frame = CGRect(x: 10, y: 200, width: 375, height: 60)
        emailTextField.backgroundColor = .init(displayP3Red: 0, green: 0, blue: 0, alpha: 0.1)
        
        let emailLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
        let emailFirstImageView = UIImageView(image: UIImage(named: "at-sign"))
        emailFirstImageView.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        emailFirstImageView.contentMode = .scaleAspectFit
        emailLeftView.addSubview(emailFirstImageView)
        let emailSecondImageView = UIImageView(image: UIImage(named: "Line"))
        emailSecondImageView.frame = CGRect(x: 35, y: 10, width: 30, height: 30)
        emailSecondImageView.contentMode = .scaleAspectFit
        emailLeftView.addSubview(emailSecondImageView)
        emailTextField.leftView = emailLeftView
        emailTextField.leftViewMode = .always
        emailTextField.textAlignment = .left
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter Email",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)
            ]
        )
        emailTextField.layer.cornerRadius = emailTextField.frame.height / 2
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.borderColor = UIColor.gray.cgColor
        emailTextField.layer.borderWidth = 1.0
        self.view.addSubview(emailTextField)
        
        // Setup passwordTextField
        passwordTextField.frame = CGRect(x: 10, y: 300, width: 375, height: 62)
        passwordTextField.backgroundColor = .init(displayP3Red: 0, green: 0, blue: 0, alpha: 0.1)
        let passwordLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
        let firstImage = UIImageView(image: UIImage(named: "shield-keyhole-line"))
        firstImage.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        firstImage.contentMode = .scaleAspectFit
        passwordLeftView.addSubview(firstImage)
        let secondImage = UIImageView(image: UIImage(named: "Line"))
        secondImage.frame = CGRect(x: 35, y: 10, width: 30, height: 30)
        secondImage.contentMode = .scaleAspectFit
        passwordLeftView.addSubview(secondImage)
        passwordTextField.leftView = passwordLeftView
        passwordTextField.leftViewMode = .always
        passwordTextField.textAlignment = .left
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter Password",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)
            ]
        )
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height / 2
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.isSecureTextEntry = true
        let rightViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
        rightViewContainer.backgroundColor = .clear
        showPasswordButton.setImage(UIImage(named: "custom.eye"), for: .normal)
        showPasswordButton.setImage(UIImage(named: "eye-slash"), for: .selected)
        showPasswordButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        showPasswordButton.contentMode = .scaleAspectFit
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        rightViewContainer.addSubview(showPasswordButton)
        showPasswordButton.center = CGPoint(x: rightViewContainer.bounds.midX - 5, y: rightViewContainer.bounds.midY)
        passwordTextField.rightView = rightViewContainer
        passwordTextField.rightViewMode = .always
        self.view.addSubview(passwordTextField)
    }

    @objc func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        showPasswordButton.isSelected.toggle()
    }

    @IBAction func signInPressed(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter both email and password.")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.showAlert(title: "Sign In Failed", message: error.localizedDescription)
            } else {
                strongSelf.performSegue(withIdentifier: "selectCurrency", sender: strongSelf)
            }
        }
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func GoogleLoginPressed(_ sender: Any) {
        signInWithGoogle()
    }
    private func signInWithGoogle() {
            
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }

            let config = GIDConfiguration(clientID: clientID)

            GIDSignIn.sharedInstance.configuration = config
            GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
                guard let strongSelf = self else { return }
                if let error = error {
                    strongSelf.showAlert(title: "Error", message: "Failed to sign in with Google: \(error.localizedDescription)")
                    return
                }

                guard let user = result?.user else {
                    strongSelf.showAlert(title: "Error" ,message: "Google authentication failed")
                    return
                }

                let idToken = user.idToken!.tokenString
                let accessToken = user.accessToken.tokenString

                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

                FirebaseAuth.Auth.auth().signIn(with: credential) { userGD, error in
                    guard userGD != nil, error == nil else {
                        if let error = error {
                            strongSelf.showAlert(title: "Error", message: "Firebase authentication error: \(error.localizedDescription)")
                        }
                        return
                    }
                    // Navigate to the main screen
                    self!.performSegue(withIdentifier: "selectCurrency", sender: Any?.self)
                }
            }
            
        }
}
