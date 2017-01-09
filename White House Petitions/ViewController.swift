//
//  ViewController.swift
//  White House Petitions
//
//  Created by rkalvani on 10/4/16.
//  Copyright © 2016 rkalvani. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var myTableView: UITableView!
    
    //initializing empty array of dictionaries
    var petitions = [[String: String]]()
   
    override func viewDidLoad() {
        
        super.viewDidLoad()//points to white house.gov server
        
        let URLString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        //if statement check to see if URL is valid
        if let url = NSURL(string: URLString){
            //returns data from object URL. Try checks for URL connections
            if let myData = try? NSData(contentsOfURL: url, options: []) {
                //if data object was created successfully, we create  swift json structure
                let json = JSON(data: myData)
                
                if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                    print("ok to parse")
                    parse(json)
                }
            }
            
        }
    }
    //reads the results array from thw whitehouse api
    func parse(json: JSON) {
        for result in json["results"].arrayValue {
            //grabbing 3 values from three keys
            let title = result["stationName"].stringValue
            let body = result["body"].stringValue
            let sig = result["signatureCount"].stringValue
            let id = result["id"].stringValue
            
            //creates a dictionary with 3 keys and 3 values
            let object = ["title" : title, "body": body, "signatureCount": sig, "id" : id]
            // places it in array
            petitions.append(object)
        }
        myTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition["title"]
        cell.detailTextLabel?.text = petition["body"]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = myTableView.indexPathForSelectedRow {
            let petition = petitions[indexPath.row]
            let nextController = segue.destinationViewController as! DetailViewController
            nextController.detailItem = petition
        }

    }
}
