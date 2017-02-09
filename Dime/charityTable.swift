//
//  charityTable.swift
//  Dime
//
//  Created by Ben Miner on 2/4/17.
//  Copyright © 2017 Noah Karman. All rights reserved.
//

import UIKit
import UIKit
import Alamofire
import PromiseKit
import SwiftyJSON


class charityTable: UITableViewController {
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
        
        var theCount = 0;
        
        theCount = theCharities["results"].count
        return theCount
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"oneCell", for: indexPath)
        
        
        if let charity = self.theCharities{
            cell.textLabel?.text = String( describing: charity["results"][indexPath.row]["name"])
            cell.detailTextLabel?.text = String( describing: charity["results"][indexPath.row]["city"])+"\n"+String( describing: charity["results"][indexPath.row]["state"])+"\n"+String( describing: charity["results"][indexPath.row]["type"])

            

        }
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    self.rowSelected = indexPath.row
        
        if (self.theCharities) != nil{
            let charityId = String(describing: theCharities["results"][indexPath.row]["objectId"])
            auth().addUserCharity(updatedBalance: Float(charityId)!)
        }
        
        
    }


}
