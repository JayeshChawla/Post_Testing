// OtpViewController.swift

import UIKit

class OtpViewController: UIViewController {
    var otp: String?
    var userID: Int?

    @IBOutlet var tf1: UITextField!
    @IBOutlet var tf2: UITextField!
    @IBOutlet var tf3: UITextField!
    @IBOutlet var tf4: UITextField!
    @IBOutlet var tf5: UITextField!
    @IBOutlet var tf6: UITextField!

    // ... existing code ...

    override func viewDidLoad() {
            super.viewDidLoad()

            tf1.addTarget(self, action: #selector(self.textdidChange(textfield:)), for: UIControl.Event.editingChanged)
            tf2.addTarget(self, action: #selector(self.textdidChange(textfield:)), for: UIControl.Event.editingChanged)
            tf3.addTarget(self, action: #selector(self.textdidChange(textfield:)), for: UIControl.Event.editingChanged)
            tf4.addTarget(self, action: #selector(self.textdidChange(textfield:)), for: UIControl.Event.editingChanged)
            tf1.addTarget(self, action: #selector(self.textdidChange(textfield:)), for: UIControl.Event.editingChanged)
            tf5.addTarget(self, action: #selector(self.textdidChange(textfield:)), for: UIControl.Event.editingChanged)
            tf6.addTarget(self, action: #selector(self.textdidChange(textfield:)), for: UIControl.Event.editingChanged)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            tf1.becomeFirstResponder()
        }
        
        @objc func textdidChange(textfield : UITextField){
            let text = textfield.text
            
            if text?.utf16.count == 1{
                switch textfield{
                    
                case tf1:
                    tf2.becomeFirstResponder()
                    break
                    
                case tf2:
                    tf3.becomeFirstResponder()
                    break
                    
                case tf3:
                    tf4.becomeFirstResponder()
                    break
                    
                case tf4:
                    tf5.becomeFirstResponder()
                    break
                    
                case tf5:
                    tf6.becomeFirstResponder()
                    break
                    
                case tf6:
                    tf6.becomeFirstResponder()
                    break
                    
                default:
                    break
                }
            }
        }
        func concatenateEnteredOTP() -> String? {
            let otpArray = [tf1.text, tf2.text, tf3.text, tf4.text, tf5.text, tf6.text]
            let concatenatedOTP = otpArray.compactMap { $0 }.joined()
            return concatenatedOTP.isEmpty ? nil : concatenatedOTP
        }


    @IBAction func verify(_ sender: Any) {
        guard let enteredOTP = concatenateEnteredOTP() else {
            // Handle the case where the entered OTP is incomplete
            return
        }

        let url = "http://192.168.1.3:8000/api/verify-user"

        let parameter: [String: Any] = [
            "otp": enteredOTP,
            "id": userID // The "id" value from your OTPModel
        ]

        guard let apiUrl = URL(string: url) else {
            print("Url can not be created")
            return
        }

        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: [])
        else {
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
                // Navigate to WelcomeViewController
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let welcomeViewController = storyboard.instantiateViewController(withIdentifier: "welcome") as? WelcomeViewController {
                        // Set any necessary properties on welcomeViewController before presenting it
                        self.navigationController?.pushViewController(welcomeViewController, animated: true)
                    }
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
