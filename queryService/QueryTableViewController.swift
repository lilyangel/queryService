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
    
    init(str1 : String, str2 : String){
        comment = str1
        tags = str2
    }
}

class QueryTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive : Bool = false
    
    // this array will store all the result comments from query API.
    var comments = [Comment]()
    let queryPostBodyURL = "http://localhost:8984/solr/aiyoupost/select?wt=json&indent=true&q=body%3A"
    
    
    /*  example jason response
        {
            "responseHeader":{
                "status":0,
                "QTime":1,
                "params":{
                    "q":"body:winnie",
                    "indent":"true",
                    "wt":"json"}},
                    "response":{"numFound":1,"start":0,"docs":[
                        {
                            "id":"56",
                            "body":"Test Winnie",
                            "Tags":"tarceva**易瑞沙**腺癌**",
                            "_version_":1516706145671053312}]
        }}
    */
    func queryComment(queryText: String) {
        // reload empty list first
        self.comments.removeAll()
        self.tableView.reloadData()
        
        let urlPath: String = queryPostBodyURL + queryText
        let queryURL = NSURL(string: urlPath)
        
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(queryURL!) {
           (jasondata, response, error) -> Void in
            
            if error != nil {
                print(error?.localizedDescription)
            } else {
                do{
                    let obj = try NSJSONSerialization.JSONObjectWithData(jasondata!, options: NSJSONReadingOptions.AllowFragments)
                    if let resultObj = obj as? NSDictionary {
                        if let response = resultObj["response"] as? NSDictionary {
                            if response["numFound"] as! Int > 0 {
                                if let bodys = response["docs"] as? NSArray {
                                    for body in bodys {
                                        let body = Comment(data: body as! NSDictionary)
                                        self.comments.append(body)
                                    }
                                }
                            } else {
                                self.comments.insert(Comment(str1: "No result was found", str2: ""), atIndex: 0)
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
                catch {
                    print(error)
                }
            }
        }
        task.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
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
        let cellIdentifier = "CommentTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CommentTableViewCell
        let comment = comments[indexPath.row]
        cell.comment.text = comment.comment
        cell.tags.text = comment.tags
    
        return cell
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
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false
        queryComment(searchBar.text!)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        queryComment(searchText)
    }
    

}
