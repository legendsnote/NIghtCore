import UIKit
import CoreData

class ViewController: UIViewController {
    var currentuser: String?
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nightcoreText: UILabel!
    @IBOutlet weak var loginText: UILabel!
    
    // Core Data context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBAction func onLoginButton(_ sender: Any) {
        // Check if username and password are not empty
        guard let enteredUsername = usernameTextField.text, !enteredUsername.isEmpty,
              let enteredPassword = passwordTextField.text, !enteredPassword.isEmpty else {
            // Display an alert or handle the case when either field is empty
            print("Username or password is empty")
            return
        }

        // Fetch user with entered credentials from Core Data
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", enteredUsername, enteredPassword)

        do {
            let users = try context.fetch(fetchRequest)
            if users.first != nil {
                // Login successful
                currentuser = users.first?.value(forKey: "username") as? String
                print("Login successful for user: \(currentuser)")

                performSegue(withIdentifier: "goToHome", sender: self)
            } else {
                // Login failed
                print("Invalid username or password")
            }
        } catch {
            // Handle fetch error
            print("Error fetching user data: \(error)")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHome", let homeViewController = segue.destination as? Home {
            homeViewController.currentUser = currentuser
        }
    }

    @IBAction func onRegisterButton(_ sender: Any) {
        performSegue(withIdentifier: "goToRegister", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0, green: 0, blue: 1, alpha: 0.5).cgColor,
            UIColor(red: 0, green: 1, blue: 0, alpha: 0.5).cgColor
        ]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        nightcoreText.textColor = .white
        loginText.textColor = .white
    }
}

