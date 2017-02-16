//
//  createAccountViewController.swift
//  
//
//  Created by Noah Karman on 2/4/17.
//
//

import Foundation
import UIKit

class createAccountViewController: UIViewController {
    //  initialize alert for password errors
//    let instructionsAlert = UIAlertController(title: "instructions", message: "Passwords must be at least 8 character long, contain no special characters, and must contain at least one Uppercase letter, one Lowercase letter, and one digit", preferredStyle: .alert)
//    let pwAlert = UIAlertController(title: "Password Error!",
//                                  message: "Please verify that password meets the listed requirements",
//                                  preferredStyle: .alert)
//    
//    //  button to dismiss alert
//    let dismissAlert = UIAlertAction(title: "Okay!", style: .destructive, handler: { (action) -> Void in })
    
    var theSessionToken: String!
    
    let defaults = UserDefaults.standard

    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var passWordField: UITextField!
    
    @IBOutlet weak var confirmPWField: UITextField!
    
    // called when create account is pressed
    @IBAction func createAccount(_ sender: Any) {
        let email = emailField.text!
        let userName = userNameField.text!
        let passWord = passWordField.text!
        let confirmPW = confirmPWField.text!
        let name = "tempName"
        // add abiity to dismiss password error alert
        // pwAlert.addAction(dismissAlert)
        
        // if password meets requirements & password is same in both fields
        //if (passWord == confirmPW) && checkPassword(passWord: passWord) {
            auth().signUp(userName: userName, passWord: passWord, name: name, email: email)
            .then
            {
                (sessionToken) -> Void in
                self.theSessionToken = sessionToken
                print(sessionToken)
                self.defaults.setValue(self.theSessionToken, forKey: "sessionToken")
                self.performSegue(withIdentifier: "profileSegue", sender: UIDevice.self)
        }

        //}
        //  if either Password does not meet requirements OR/AND password fields do not match, raise alert
//        else{
//            present(pwAlert, animated: true, completion: nil)
//        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func checkPassword(passWord:String) -> Bool{
//        let symbols = CharacterSet.symbols
//        let digits = CharacterSet.decimalDigits
//        var charLength: Bool = false
//        var containsLowerCase: Bool = false
//        var containsUpperCase: Bool = false
//        var notcontainsSymbol: Bool = true
//        var containsDigit: Bool = false
//        
//        // check password length
//        if passWord.characters.count >= 8{
//            charLength = true
//        }
//        // check for contains uppercase
//        if passWord.lowercased() != passWord{
//            containsUpperCase = true
//        }
//        // check for contains lowercase
//        if passWord.uppercased() != passWord{
//            containsLowerCase = true
//        }
//        // check if contains digit or symbol
//        for uni in passWord.unicodeScalars{
//            if digits.contains(uni){
//                containsDigit = true
//                break
//            }
//            if symbols.contains(uni){
//                notcontainsSymbol = false
//                break
//            }
//        }
//        
//        // if password meets requirements, this statement is true
//        return (charLength && containsLowerCase && notcontainsSymbol && containsUpperCase && containsDigit)
//    }
    
    
    
    
}
