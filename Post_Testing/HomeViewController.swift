//
//  HomeViewController.swift
//  Post_Testing
//
//  Created by MACPC on 23/02/24.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true

        if ((UserDefaults.standard.value(forKey: "userId") as? Int) != nil) {
//            print("User ID:", userId)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let welcomeVc = storyboard.instantiateViewController(withIdentifier: "welcome") as? WelcomeViewController{
                self.navigationController?.pushViewController(welcomeVc, animated: true)
            }
        }
    }
    
    @IBAction func loinClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVc = storyboard.instantiateViewController(withIdentifier: "login") as? LoginViewController{
            // Pass user ID to OtpViewController
            self.navigationController?.pushViewController(loginVc, animated: true)
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let signupVc = storyboard.instantiateViewController(withIdentifier: "signup") as? ViewController{
            // Pass user ID to OtpViewController
            self.navigationController?.pushViewController(signupVc, animated: true)
        }
    }
    

}
