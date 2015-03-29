//
//  ViewController.swift
//  PhotoTagger
//
//  Created by Otávio Zabaleta on 29/03/2015.
//  Copyright (c) 2015 OZ. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    /*** IBOutlets ***/
    @IBOutlet weak var tableViewMain: UITableView!
    
    /*** CoreData ***/
    var tags = [NSManagedObject]()
    
    //========== Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "Tag")
        var error: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        if fetchedResults != nil {
            tags = fetchedResults!
        }
        else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    /*
    //1
    let appDelegate =
    UIApplication.sharedApplication().delegate as AppDelegate
    
    let managedContext = appDelegate.managedObjectContext!
    
    //2
    let fetchRequest = NSFetchRequest(entityName:"Person")
    
    //3
    var error: NSError?
    
    let fetchedResults =
    managedContext.executeFetchRequest(fetchRequest,
        error: &error) as [NSManagedObject]?
    
    if let results = fetchedResults {
        people = results
    } else {
    println("Could not fetch \(error), \(error!.userInfo)")
    }
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //========== IBAction
    @IBAction func buttonAddTag_TouchUpInside(sender: UIBarButtonItem) {
        var alert = UIAlertController(title: "New Tag", message: "Add new tag", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in }
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction!) -> Void in
            let textField = alert.textFields![0] as! UITextField
            self.saveName(textField.text)
            self.tableViewMain.reloadData()
        }
        alert.addAction(saveAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in
            
        }
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //========== Private 
    func saveName(name: String) {
        // 1 - get managed context
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        // 2 - Check if we already have it
//        let fetchRequest = NSFetchRequest(entityName: "Tag")
//        fetchRequest.predicate = NSPredicate(format: "name = \(name)")
//        
//        var error: NSError?
//        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
//        if error != nil  {
//            println("Could not fetch \(error), \(error!.userInfo)")
//        }
//        else if fetchedResults == nil {
            // 2 - Insert new
            let entity = NSEntityDescription.entityForName("Tag", inManagedObjectContext: managedContext)
            let newTag = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            
            // 3 - Set value for tag.name
            newTag.setValue(name, forKey: "name")
            
            // 4 -
            var error: NSError?
            if !managedContext.save(&error) {
                println("Could not save tag: \(error), \(error?.userInfo)")
            }
            
            tags.append(newTag)
//        }
    }
    


    
    //========== UITableViewDatasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableViewMain.dequeueReusableCellWithIdentifier("CellMainTable", forIndexPath: indexPath) as! UITableViewCell
        let tag = tags[indexPath.row]
        cell.textLabel!.text = tag.valueForKey("name") as? String
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
}

