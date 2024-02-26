//
//  LoginViewController.swift
//  Post_Testing
//
//  Created by MACPC on 23/02/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    var userID : Int?
    
    var login = [LoginModel]()

    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        let url = "http://192.168.1.3:8000/api/login-user"
        
        let parameters : [String : Any] = [
            "email" : emailTextField.text!,
            "password" : passwordTextField.text!
        ]
        
        
        guard let apiUrl = URL(string: url) else{
            print("Url can not be created")
            return
        }
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("Error Found", error)
                return
            }

            guard let data = data else {
                print("Data not Found")
                return
            }

            guard let response = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }

            print("HTTP Status Code:", response.statusCode)

            if (200 ..< 299) ~= response.statusCode {
                do{
                
                    if let jsonResponse = try JSONSerialization.jsonObject(with : data , options: []) as? [String : Any],
                       let userData = jsonResponse["data"] as? [String : Any],
                       let userId = userData["id"] as? Int{
                        
                        
                        UserDefaults.standard.set(userId, forKey: "userId")
                        print(userId)
                // Navigate to WelcomeViewController
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let welcomeViewController = storyboard.instantiateViewController(withIdentifier: "welcome") as? WelcomeViewController {
                        // Set any necessary properties on welcomeViewController before presenting it
                        self.navigationController?.pushViewController(welcomeViewController, animated: true)
                    }
                }
                    }
                } catch {
                    print("Error", error)
                }
            } else {
                // Handle unsuccessful response
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response - Error:", responseString)
                }
            }
        }.resume()
    }
    
}
