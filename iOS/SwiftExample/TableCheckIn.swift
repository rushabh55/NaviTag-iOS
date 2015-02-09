//
//  TableCheckIn.swift
//  SwiftExample
//
//  Created by Shashank Katkar on 2/8/15.
//  Copyright (c) 2015 Sachin Kesiraju. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class TableCheckIn :UITableViewController, NSURLConnectionDelegate {
    
    @IBOutlet weak var tableControl: UITableViewCell!
    var tableArray = []
    required override init() {
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startConnection()
        self.title = "Game"
    }
    
    override func viewDidAppear(animated: Bool)
    {
        self.tableView.reloadData()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //#pragma mark - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of rows in the section.
        return tableArray.count;
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true;
    }
    func startConnection(){
        let urlPath: String = "http://rushg.me/TreasureHunt/hunt.php?q=getNearestHunts&coord=number,number"
        var url: NSURL = NSURL(string: urlPath)!
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        connection.start()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        
    }
    
    func buttonAction(sender: UIButton!){
        startConnection()
    }
    var data = NSData()
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var err: NSError
        // throwing an error on the line below (can't figure out where the error message is)
       // var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
     //   jsonResult.copy(tableArray)
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if(editingStyle == UITableViewCellEditingStyle.Delete)
        {
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.reloadData()
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = tableArray.objectAtIndex(indexPath.row) as NSString
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.greenColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(15)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.showAlert(tableArray.objectAtIndex(indexPath.row) as NSString, rowToUseInAlert: indexPath.row)
    }
    
    //#pragma mark - UIAlertView delegate methods
    
    func alertView(alertView: UIAlertView!, didDismissWithButtonIndex buttonIndex: Int) {
        NSLog("Did dismiss button: %d", buttonIndex)
    }
    
    // Function to init a UIAlertView and show it
    func showAlert(rowTitle:NSString, rowToUseInAlert: Int) {
        var alert = UIAlertView()
        
        alert.delegate = self
        alert.title = rowTitle
        //            alert.message = "You selected row \(rowToUseInAlert)"
        alert.addButtonWithTitle("OK")
        
        alert.show()
    }


}