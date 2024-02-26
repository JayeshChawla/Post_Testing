//
//  ViewController.swift
//  Post_Testing
//
//  Created by MACPC on 22/02/24.
//

import UIKit

class ViewController: UIViewController {
    
    var userID : Int?

    @IBOutlet var username: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confoirmPassword: UITextField!
    
    var modelUser = [Model]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        let url = "http://192.168.1.3:8000/api/register-user"
        
        let parameters : [String : Any] = [
            "name" : username.text!,
            "email" : email.text!,
            "password" : password.text!,
            "password_confirmation" : confoirmPassword.text
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
                    print("Error Found:", error!)
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
                print(data)
                
                print("HTTP Status Code:", response.statusCode)
                
            if (200 ..< 299) ~= response.statusCode {
                            do {
                                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                                   let userData = jsonResponse["data"] as? [String: Any],
                                   let userId = userData["id"] as? Int {
                                    self.userID = userId
                                    
                                    
                                    UserDefaults.standard.set(userId, forKey: "id")
                                    print(userId)

                                    // Navigate to OTPViewController
                                    DispatchQueue.main.async {
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        if let otpViewController = storyboard.instantiateViewController(withIdentifier: "otp") as? OtpViewController {
                                            // Pass user ID to OtpViewController
                                            otpViewController.userID = self.userID
                                            self.navigationController?.pushViewController(otpViewController, animated: true)
                                        }
                                    }
                                }
                            } catch {
                                print("Error parsing response:", error)
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

