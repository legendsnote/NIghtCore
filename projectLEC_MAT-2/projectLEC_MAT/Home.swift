//
//  Home.swift
//  projectLEC_MAT
//
//  Created by prk on 11/12/23.
//

import UIKit
import CoreData

class Home: UIViewController {

    
    @IBOutlet weak var menu: UILabel!
    @IBOutlet weak var welcomeText: UILabel!
    var user: User?
    var currentUser: String?
    
    @IBAction func onPlayList(_ sender: Any) {
        performSegue(withIdentifier: "goToPlaylist", sender: self)
    }
    
    @IBAction func onProfile(_ sender: Any) {
        performSegue(withIdentifier: "goToProfile", sender: self)
    }
    
    @IBAction func onShop(_ sender: Any) {
        performSegue(withIdentifier: "goToShop", sender: self)
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        updateWelcomeText(with: "")
        redirectToLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeText.text = "Welcome \(currentUser!)"
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0, green: 0, blue: 1, alpha: 0.5).cgColor,
            UIColor(red: 0, green: 1, blue: 0, alpha: 0.5).cgColor
        ]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        welcomeText.textColor = .white
        menu.textColor = .white
        
    }
    
    func updateWelcomeText(with username: String) {
        welcomeText.text = "Welcome \(username)"
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

       
    func redirectToLogin() {
        performSegue(withIdentifier: "backToHome", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        do{
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "username == %@", currentUser!)
            let users = try context.fetch(fetchRequest)
            if users.first != nil {
                user = users.first
            }
        }catch{
            
        }
        
        if segue.identifier == "goToProfile", let profileViewController = segue.destination as? Profile {
            profileViewController.currentUser = user
        }
        
    }
    
}
