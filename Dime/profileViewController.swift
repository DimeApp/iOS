//
//  profileViewController.swift
//  Dime
//
//  Created by Ben Miner on 2/4/17.
//  Copyright © 2017 Noah Karman. All rights reserved.
//

import UIKit
import SwiftyJSON
import PromiseKit

class profileViewController: UIViewController {
    @IBAction func myCharitiesButton(_ sender: Any) {
        self.getMyCharitiea()
    }
    var theCharities:JSON!
    var theTransaction:JSON!
    var userName: String!
    var bankUsername: String!
    var bankPassword: String!
    var balance: Float!
    var theCharities2:JSON!
    

    
    
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBAction func transactionButton(_ sender: Any) {
        self.getTransactions()
    }
    @IBAction func browseCharity(_ sender: Any) {
        self.getCharities()
    }
    @IBOutlet weak var profileTableView: UITableView!
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
         auth().getBalance().then{
            
            (data) -> Void in
            //self.balanceLabel.text = String(format: "%2.f", String(describing:data["result"]["balance"]))
            print(data)
            self.balance = Float(String(describing: data["result"]["balance"]))
            self.balanceLabel.text = "$" + String(format: "%.2f", self.balance)
            self.userNameLabel.text = self.userName
            
            }.catch{_ in
                print("these teeny tiny hands!!!")
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func connectBank(_ sender: Any) {
        presentAlert()
        auth().getBankUserAccessToken().then{
            (resp) -> Void in
            print(resp)
            }.catch{_ in
                print("FACK")
        }
    }
    
    func getCharities(){
        
        auth().getCharities()
            .then{
                (charities) -> Void in
                self.theCharities = charities
                print(charities)
                
            }.then{
                self.performSegue(withIdentifier: "charityListSegue", sender: UIDevice.self)
            }
            .catch {error in
                print("oh no")
        }
    }
    
    func getMyCharitiea(){
        
        auth().getUserCharity().then{
            (charities) -> Void in
            self.theCharities2 = charities
            self.performSegue(withIdentifier: "myCharitiesSegue", sender: UIDevice.self)
            }.catch {_ in
                print("fack")
        }
    }
    
    func getTransactions(){
        auth().getTransactions()
            .then{
                (transactions) -> Void in
                self.theTransaction = transactions
//                print(transactions)
                let old_balance = self.balance
                self.balance = self.roundUp(balance: self.balance, json:transactions) + self.balance
                self.balanceLabel.text = "$" + String(format: "%.2f", self.balance)
                let x = self.balance - old_balance!
                auth().updateBalance(updatedBalance: x ).then{_ in
                    print("yes")
                    }.catch{_ in
                        print("fack")
                        
                }
                
                
                self.performSegue(withIdentifier: "transactionSegue", sender: UIDevice.self)
                
            }
            .catch {error in
                print("oh no")
        }
        
    }


    
    func roundUp(balance:Float, json:JSON)->Float{
        var pastTransactions: [String] = []
        var amt2Donate: Float = 0.0
        var amts : [Float] = []
        
        // iterate through transactions, determine if each transaction is viable for rounding up
        for n in 0...json["result"]["transactions"].count
        {
            var isPastTransaction = true
            
            // retrieve pastTransactions, if it doesn't exist in userDefaults, create it
            let defaults = UserDefaults.standard
            if (defaults.object(forKey: "pastTransactions") == nil){
                let emptyStringArray: [String] = []
                defaults.set(emptyStringArray, forKey: "pastTransactions")
            }
            else{
                pastTransactions = defaults.object(forKey: "pastTransactions") as! [String]
            }

            // check if currTransaction is in pastTransactions
            let currTransactionDate: String = String(describing: json["result"]["transactions"][n]["date"])
            let currTransctionName: String = String(describing: json["result"]["transactions"][n]["name"])
            
            let currTransaction: String = currTransctionName + currTransactionDate
            
            if pastTransactions.contains(currTransaction){
                break
            }
            // if not, append currTransaction to pastTransactions
            else{
                pastTransactions.append(currTransaction)
                isPastTransaction = false
                defaults.set(pastTransactions, forKey: "pastTransactions")
            }
            
            if let x = Float(String(describing: json["result"]["transactions"][n]["amount"])){
            print(x)
            if(x >= Float(0) && !isPastTransaction)
            {
                amts.append(x)
            }
        }
        }
        for n in amts
        {
            print(n)
            var amtUp: Float = ceil(n)
            
            amt2Donate += (amtUp-n)
        }
        print(amt2Donate)
        
        return amt2Donate
    }
    
//    func updateBalance(){
//        
//    }
//    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? charityTable {
            destinationViewController.theCharities = self.theCharities
        }
        if let destinationViewController = segue.destination as? transactionTableViewController{
            destinationViewController.theTransactions = self.theTransaction
        }
        if let destinationViewController = segue.destination as? myCharitiesTableViewController{
            destinationViewController.theCharities = self.theCharities2
        }
        
        
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Bank Account Information", message: "Please Bank Username and Password", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let usernameField = alertController.textFields?[0] {
                // store your data
                usernameField.text = self.bankUsername
                

            } else {
                // user did not fill field
            }
            if let passwordField = alertController.textFields?[1] {
                // store data
                passwordField.text = self.bankPassword
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Username"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}

