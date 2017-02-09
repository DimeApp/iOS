//
//  ViewController.swift
//  Dime
//
//  Created by Noah Karman on 2/3/17.
//  Copyright © 2017 Noah Karman. All rights reserved.
//
//  Added a comment WHOOOOO
import UIKit
import PromiseKit
import Alamofire
import SwiftyJSON


class LoginViewController: UIViewController {
    let defaults = UserDefaults.standard
    var theSessionToken: String!
    var email: String!
    var passWord: String!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passWordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.removeObject(forKey: "sessionToken")
        // Do any additional setup after loading the view, typically from a nib.
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  when login button is pressed.
    @IBAction func loginButtonPress(_ sender: Any) {
        email = emailField.text
        passWord = passWordField.text
        
        auth().login(email: email, passWord: passWord)
            .then
        {
            (sessionToken) -> Void in
            self.theSessionToken = sessionToken
            print(self.theSessionToken)
           
            self.defaults.setValue(self.theSessionToken, forKey: "sessionToken")
        
            
            }.then{
                self.performSegue(withIdentifier: "profileSegue", sender: UIDevice.self)
            }
            .catch{_ in
                print("FACK")
        }

        
    }
    
}

