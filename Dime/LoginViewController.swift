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
    
    var loggingInAlert: UIAlertView = UIAlertView(title: "Logging In", message: "Please wait...", delegate: nil, cancelButtonTitle: "Cancel");
    
    var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 10, height: 10)) as UIActivityIndicatorView
    
    func startLogInIndicator(){
    loadingIndicator.center = self.view.center;
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
    loadingIndicator.startAnimating();
        
    loggingInAlert.addSubview(loadingIndicator)
    loggingInAlert.show()
    }

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
                self.loggingInAlert.dismiss(withClickedButtonIndex: 0, animated: true)
            
            }.then{
                self.performSegue(withIdentifier: "profileSegue", sender: UIDevice.self)
            }
            .catch{_ in
                print("FACK")
        }

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? profileViewController {
            destinationViewController.userName = self.email
        }
    }
    
}

