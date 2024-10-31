import UIKit
import CoreData

class Profile: UIViewController {

    @IBOutlet weak var profileText: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var currentUser: User?
    // Core Data context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = "Username : \(currentUser!.username ?? "N/A")"
        passwordLabel.text = "Password : \(currentUser!.password ?? "N/A")"
        phoneLabel.text = "Phone : \(currentUser!.phone ?? "N/A")"
        addressLabel.text = "Address : \(currentUser!.address ?? "N/A")"
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0, green: 0, blue: 1, alpha: 0.5).cgColor,
            UIColor(red: 0, green: 1, blue: 0, alpha: 0.5).cgColor
        ]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        profileText.textColor = .white
        usernameLabel.textColor = .white
        passwordLabel.textColor = .white
        phoneLabel.textColor = .white
        addressLabel.textColor = .white
    }

    @IBAction func editProfile(_ sender: Any) {
        showEditAlert(title: "Edit Username", currentValue: currentUser?.username ?? "") { (newUsername) in
            self.currentUser?.username = newUsername
            self.updateLabels()
        }
    }

    @IBAction func editPassword(_ sender: Any) {
        showEditAlert(title: "Edit Password", currentValue: currentUser?.password ?? "") { (newPassword) in
            self.currentUser?.password = newPassword
            self.updateLabels()
        }
    }

    @IBAction func editPhone(_ sender: Any) {
        showEditAlert(title: "Edit Phone", currentValue: currentUser?.phone ?? "") { (newPhone) in
            self.currentUser?.phone = newPhone
            self.updateLabels()
        }
    }

    @IBAction func editAddress(_ sender: Any) {
        showEditAlert(title: "Edit Address", currentValue: currentUser?.address ?? "") { (newAddress) in
            self.currentUser?.address = newAddress
            self.updateLabels()
        }
    }

    func showEditAlert(title: String, currentValue: String, completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = currentValue
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            if let newValue = alert.textFields?.first?.text {
                completion(newValue)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            alert.addAction(saveAction)
            alert.addAction(cancelAction)

            present(alert, animated: true, completion: nil)
        }

    func updateLabels() {
        // Update the labels with the new values
        usernameLabel.text = "Username : \(currentUser?.username ?? "N/A")"
        passwordLabel.text = "Password : \(currentUser?.password ?? "N/A")"
        phoneLabel.text = "Phone : \(currentUser?.phone ?? "N/A")"
        addressLabel.text = "Address : \(currentUser?.address ?? "N/A")"

        // Save changes to Core Data
        do {
            try context.save()
        } catch {
            // Handle the error
            print("Error saving context: \(error)")
        }
    }
    
  

}
