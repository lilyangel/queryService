//
//  QueryTableViewController.swift
//  queryService
//
//  Created by lily on 11/1/15.
//  Copyright (c) 2015 lily. All rights reserved.
//

import UIKit

class Comment {
    var comment: String!
    var tags: String!
    
    init(data : NSDictionary){
        if data["body"] != nil {
            self.comment = data["body"] as! String
        }
        if data["Tags"] != nil {
            self.tags = data["Tags"] as! String
        }
    }
}

class QueryTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    // this array will store all the result comments from query API.
    var comments = [Comment]()
    let queryPostBodyURL = "http://localhost:8984/solr/aiyoupost/select?wt=json&indent=true&q=body%3A"
    
    func queryComment(ask: String) {
        var urlPath: String = queryPostBodyURL + ask + "%0A"
        let queryURL = NSURL(string: urlPath)

        let session = NSURLSession.sharedSession()
        var task = session.dataTaskWithURL(queryURL!) {
           (data, response, error) -> Void in
            
            if error != nil {
                println(error.localizedDescription)
            } else {
                var jsonError: NSError?
                let obj = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &jsonError)
                if let resultObj = obj as? NSDictionary {
                    if let response = resultObj["response"] as? NSDictionary {
                        if let bodys = response["docs"] as? NSArray {
                           for body in bodys {
                              let body = Comment(data: body as! NSDictionary)
                              self.comments.append(body)
                           }
                        }
                    }
                }
            }
        }
        task.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        queryComment("test")
        
        self.tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return comments.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("debug")
        let cellIdentifier = "CommentTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CommentTableViewCell
        let comment = comments[indexPath.row]
        
        cell.comment.text = comment.comment
        cell.tags.text = comment.tags
    
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
