//
//  myCharitiesTableViewController.swift
//  Dime
//
//  Created by Ben Miner on 2/5/17.
//  Copyright © 2017 Noah Karman. All rights reserved.
//

import UIKit
import SwiftyJSON
class myCharitiesTableViewController: UITableViewController {
    var theCharities: JSON!
    var rowSelected:Int!
    
    @IBOutlet weak var charityName: UILabel!
    @IBOutlet weak var charityInfo: UILabel!
    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
    super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    var theCount = 20
    // theCount = theCharities["results"].count
    return theCount
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier:"oneCell", for: indexPath)
    
    
        if let charity = self.theCharities
        {
            cell.textLabel?.text = String( describing: charity["results"][indexPath.row]["name"])
            cell.detailTextLabel?.text = String( describing: charity["results"][indexPath.row]["city"])+"\n"+String( describing: charity["results"][indexPath.row]["state"])+"\n"+String( describing: charity["results"][indexPath.row]["type"])
    
        }
        return cell
    }

}
