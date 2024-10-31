//
//  Register.swift
//  projectLEC_MAT
//
//  Created by prk on 11/12/23.
//

import UIKit
import CoreData

class Register: UIViewController {
    
    @IBOutlet weak var Username: UITextField!
    
    @IBOutlet weak var Password: UITextField!
    
    @IBOutlet weak var ConfirmPassword: UITextField!
    
    @IBOutlet weak var Phone: UITextField!
    
    @IBOutlet weak var Address: UITextField!
    
    @IBOutlet weak var nightcoreText: UILabel!
    
    @IBOutlet weak var registerText: UILabel!
    
    
    @IBAction func onRegister(_ sender: Any) {
        guard let username = Username.text, !username.isEmpty else {
            showAlert(message: "Please enter a username")
            return
        }

        guard let password = Password.text, !password.isEmpty else {
            showAlert(message: "Please enter a password")
            return
        }

        guard let confirmPassword = ConfirmPassword.text, !confirmPassword.isEmpty else {
            showAlert(message: "Please confirm your password")
            return
        }

        guard password == confirmPassword else {
            showAlert(message: "Passwords do not match")
            return
        }

        guard let phone = Phone.text, !phone.isEmpty else {
            showAlert(message: "Please enter a phone number")
            return
        }

        guard let address = Address.text, !address.isEmpty else {
            showAlert(message: "Please enter an address")
            return
        }

        // Check if the username already exists in Core Data
        if userExists(username: username) {
            showAlert(message: "Username already exists. Please choose another username.")
        } else {
            // Proceed with registration
            registerUser(username: username, password: password, phone: phone, address: address)
            showAlert(message: "Registration successful!")
        }
    }

    // Function to check if a user with the given username already exists in Core Data
    func userExists(username: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)

        do {
            let count = try managedContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking user existence: \(error)")
            return false
        }
    }

    // Function to register a new user in Core Data
    func registerUser(username: String, password: String, phone: String, address: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!

        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(username, forKey: "username")
        user.setValue(password, forKey: "password")
        user.setValue(phone, forKey: "phone")
        user.setValue(address, forKey: "address")

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            showAlert(message: "Failed to save registration data.")
        }
    }

    
    @IBAction func goToLogin(_ sender: Any) {
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        registerText.textColor = .white
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
