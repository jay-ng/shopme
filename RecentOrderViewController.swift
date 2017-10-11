//
//  RecentOrderViewController.swift
//  ShopME
//
//  Created by Huy Nguyen on 3/3/16.
//  Copyright © 2016 Jay Nguyen. All rights reserved.
//

import UIKit
import CoreData

class RecentOrderViewController: UITableViewController {
    
    var RecentOrderList = [RecentOrderData]()
    var SQLList = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Orders")
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            SQLList = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        if (SQLList.count != 0) {
            for (var i=SQLList.count-1; i>=0; i--) {
                let total = SQLList[i].valueForKey("total") as! Double
                let quantity = SQLList[i].valueForKey("quantity") as! Int
                let date = SQLList[i].valueForKey("date") as! NSDate
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = .MediumStyle
                dateFormatter.timeStyle = .MediumStyle
                let dateString = dateFormatter.stringFromDate(date)
                RecentOrderList.append(RecentOrderData(order: quantity.description + " items ($" + total.description + ")", date: dateString))
            }
        }
    }
    
    
    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            let mDate = RecentOrderList[indexPath.row].date
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let fetchRequest = NSFetchRequest(entityName: "Orders")
            //fetchRequest.predicate = NSPredicate(format: "date = %@", mDate)
            
            switch editingStyle {
            case .Delete:
                self.RecentOrderList.removeAtIndex(indexPath.row)
                self.SQLList.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                do {
                    if let fetchResults =
                        try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                            let managedObject = fetchResults[0]
                            managedContext.deleteObject(managedObject)
                            try managedContext.save()
                    }
                } catch let error as NSError {
                    print("Could not fetch, or save \(error), \(error.userInfo)")
                    
                }
            default:
                return
            }
    }
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return RecentOrderList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecentCell", forIndexPath: indexPath) as! RecentOrderItem
        cell.recentOrder.text = RecentOrderList[indexPath.row].order
        cell.date.text = RecentOrderList[indexPath.row].date
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class RecentOrderData {
        var order: String
        var date: String
        init(order: String, date: String) {
            self.order = order
            self.date = date
        }
        
    }
    
}
