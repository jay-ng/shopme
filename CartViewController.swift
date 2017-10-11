//
//  CartViewController.swift
//  ShopME
//
//  Created by Huy Nguyen on 3/1/16.
//  Copyright © 2016 Jay Nguyen. All rights reserved.
//

import UIKit
import CoreData

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var totalPrice : Double = 0.0
    var totalCount : Int = 0
    var CartList = [NSManagedObject]()
    var order = [CartData]()
    var section = [String]()
    var rowPerSection : [[Int]] = [[0],[1],[2],[3],[4],[5],[6],[7]]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var quantityTotal: UILabel!
    @IBOutlet weak var emptyButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        updateLabel()
        
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CartCell")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Items")
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            CartList = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        if (CartList.count != 0) {
            for (var i=0; i<CartList.count; i++) {
                let title = CartList[i].valueForKey("title") as! String
                let sum = (CartList[i].valueForKey("price") as! Double) * (CartList[i].valueForKey("quantity") as! Double)
                let count = CartList[i].valueForKey("quantity") as! Int
                let category = CartList[i].valueForKey("category") as! String
                order.append(CartData(title: title, sum: sum, count: count, category: category))
            }
        }
        
        updateTotal()
        getSection()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        updateTotal()
        getSection()
    }
    
    func updateLabel() -> Void {
        let button = UIButton(type: .Custom)
        button.frame = CGRectMake(0,0,30,30)
        button.addTarget(self, action: "homeSegueClicked", forControlEvents: UIControlEvents.TouchUpInside)
        button.setBackgroundImage(UIImage(named: "homeButton.png"), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func homeSegueClicked() {
        self.performSegueWithIdentifier("homeSegue", sender: self)
    }
    
    func getSection() -> Void {
        for (var i=0; i<8; i++) {
            rowPerSection[i].removeAll()
        }
        for (var i=0; i<order.count; i++) {
            if (!section.contains(order[i].category)) {
                section.append(order[i].category)
            }
                switch (order[i].category) {
                    case "Grocery": rowPerSection[0].append(i)
                        break;
                    case "Clothing": rowPerSection[1].append(i)
                        break;
                    case "Movies": rowPerSection[2].append(i)
                        break;
                    case "Garden": rowPerSection[3].append(i)
                        break;
                    case "Electronics": rowPerSection[4].append(i)
                        break;
                    case "Books": rowPerSection[5].append(i)
                        break;
                    case "Appliances": rowPerSection[6].append(i)
                        break;
                    case "Toys": rowPerSection[7].append(i)
                        break;
                    default:
                        break;
                }
        }
        section.sortInPlace()
        //print("Sections: \(section) \nRow in sections: \(rowPerSection)")

    }
    
    func updateTotal() -> Void {
        totalPrice = 0.0
        totalCount = 0
        if order.count > 0 {
            for (var i=0; i<order.count; i++) {
                totalPrice += order[i].sum
                totalCount += order[i].count
            }
            subtotal.text = "$" + totalPrice.description
            quantityTotal.text = totalCount.description
            subtotal.hidden = false
            quantityTotal.hidden = false
            buyButton.enabled = true
            emptyButton.enabled = true
        } else {
            subtotal.hidden = true
            quantityTotal.hidden = true
            buyButton.enabled = false
            emptyButton.enabled = false
        }
        
    }
    
    @IBAction func increaseButton(sender: AnyObject) {
        let cellIndexPath = tableView.indexPathForCell(sender.superview!!.superview as! UITableViewCell)
        
        var itemIndex = 0
        let sectionName = self.section[(cellIndexPath?.section)!]
        switch(sectionName) {
            case "Grocery": itemIndex = rowPerSection[0][cellIndexPath!.row]
                break;
            case "Clothing": itemIndex = rowPerSection[1][cellIndexPath!.row]
                break;
            case "Movies": itemIndex = rowPerSection[2][cellIndexPath!.row]
                break;
            case "Garden": itemIndex = rowPerSection[3][cellIndexPath!.row]
                break;
            case "Electronics": itemIndex = rowPerSection[4][cellIndexPath!.row]
                break;
            case "Books": itemIndex = rowPerSection[5][cellIndexPath!.row]
                break;
            case "Appliances": itemIndex = rowPerSection[6][cellIndexPath!.row]
                break;
            case "Toys": itemIndex = rowPerSection[7][cellIndexPath!.row]
                break;
            default:
                break;
        }
        
        order[itemIndex].count++
        order[itemIndex].sum = (CartList[itemIndex].valueForKey("price") as! Double) * Double(order[itemIndex].count)
        tableView.reloadData()
        updateTotal()
        
        let mName = order[itemIndex].title
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Items")
        fetchRequest.predicate = NSPredicate(format: "title = %@", mName)
        
        do {
            if let fetchResults =
                try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                    let managedObject = fetchResults[0]
                    managedObject.setValue(order[itemIndex].count, forKey: "quantity")
                    try managedContext.save()
            }
        } catch let error as NSError {
            print("Could not fetch, or save \(error), \(error.userInfo)")

        }
        
    }
    
    @IBAction func decreaseButton(sender: AnyObject) {
        let cellIndexPath = tableView.indexPathForCell(sender.superview!!.superview as! UITableViewCell)
        var itemIndex = 0
        let sectionName = self.section[(cellIndexPath?.section)!]
        switch(sectionName) {
            case "Grocery": itemIndex = rowPerSection[0][cellIndexPath!.row]
                break;
            case "Clothing": itemIndex = rowPerSection[1][cellIndexPath!.row]
                break;
            case "Movies": itemIndex = rowPerSection[2][cellIndexPath!.row]
                break;
            case "Garden": itemIndex = rowPerSection[3][cellIndexPath!.row]
                break;
            case "Electronics": itemIndex = rowPerSection[4][cellIndexPath!.row]
                break;
            case "Books": itemIndex = rowPerSection[5][cellIndexPath!.row]
                break;
            case "Appliances": itemIndex = rowPerSection[6][cellIndexPath!.row]
                break;
            case "Toys": itemIndex = rowPerSection[7][cellIndexPath!.row]
                break;
            default:
                break;
        }
        
        let mPrice = CartList[itemIndex].valueForKey("price") as! Double
        let mName = order[itemIndex].title
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Items")
        fetchRequest.predicate = NSPredicate(format: "title = %@", mName)
        
        if (order[itemIndex].count > 1) {
            order[itemIndex].count--
            order[itemIndex].sum = (mPrice) * Double(order[itemIndex].count)
            tableView.reloadData()
            updateTotal()
            
            do {
                if let fetchResults =
                    try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                        let managedObject = fetchResults[0]
                        managedObject.setValue(order[itemIndex].count, forKey: "quantity")
                        try managedContext.save()
                }
            } catch let error as NSError {
                print("Could not fetch, or save \(error), \(error.userInfo)")
                
            }
            
        } else if (order[itemIndex].count == 1){
            var itemTitle = order[itemIndex].title
            itemTitle = itemTitle.substringFromIndex(itemTitle.startIndex.advancedBy(2))
            let refreshAlert = UIAlertController(title: "Remove Item", message: "Item \(itemTitle) will be remove from cart. Please confirm.", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction!) in
                self.order.removeAtIndex(itemIndex)
                self.CartList.removeAtIndex(itemIndex)
                self.section.removeAtIndex(cellIndexPath!.section)
                self.getSection()
                self.updateTotal()
                self.tableView.reloadData()
                
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
                
                //print("Confirm button clicked.")
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                //print("Cancel button clicked.")
            }))
            
            presentViewController(refreshAlert, animated: true, completion: nil)

            
            
            
        }
    }
    
    @IBAction func buyButton(sender: AnyObject) {
        let refreshAlert = UIAlertController(title: "PAYMENT", message: "Your card will be charged " + self.subtotal.text!, preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            
            //let mDate = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
            
            let mToday = NSDate()
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext
            
            let fetchOrderRequest = NSFetchRequest(entityName: "Orders")
            fetchOrderRequest.predicate = NSPredicate(format: "date < %@", mToday)
            
            let entity = NSEntityDescription.entityForName("Orders", inManagedObjectContext: managedContext)
            
            let anOrder = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            
            anOrder.setValue(self.totalCount, forKey: "quantity")
            anOrder.setValue(self.totalPrice, forKey: "total")
            anOrder.setValue(mToday, forKey: "date")
            
            do {
                if let fetchResults =
                    try managedContext.executeFetchRequest(fetchOrderRequest) as? [NSManagedObject] {
                        if fetchResults.count > 9 {
                            let managedObject = fetchResults[0]
                            managedContext.deleteObject(managedObject)
                            try managedContext.save()
                        }
                }
            } catch let error as NSError {
                print("Could not fetch, or save \(error), \(error.userInfo)")
            }
            
            do {
                try managedContext.save()
                self.CartList.append(anOrder)
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }

            self.order.removeAll()
            self.CartList.removeAll()
            self.section.removeAll()
            self.getSection()
            self.tableView.reloadData()
            self.updateTotal()
            
            let fetchRequest = NSFetchRequest(entityName: "Items")
            
            do {
                if let fetchResults =
                    try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                        for (var i=0; i<fetchResults.count; i++) {
                            let managedObject = fetchResults[i]
                            managedContext.deleteObject(managedObject)
                            try managedContext.save()
                        }
                }
            } catch let error as NSError {
                print("Could not fetch, or save \(error), \(error.userInfo)")
            }
            
            //print("Confirm button clicked.")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            
            //print("Cancel button clicked.")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func emptyCartButton(sender: AnyObject) {
        let refreshAlert = UIAlertController(title: "Empty Cart", message: "All data will be lost.", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction!) in
            self.order.removeAll()
            self.CartList.removeAll()
            self.section.removeAll()
            self.getSection()
            self.tableView.reloadData()
            self.updateTotal()
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let fetchRequest = NSFetchRequest(entityName: "Items")
            
            do {
                if let fetchResults =
                    try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                        for (var i=0; i<fetchResults.count; i++) {
                            let managedObject = fetchResults[i]
                            managedContext.deleteObject(managedObject)
                            try managedContext.save()
                        }
                }
            } catch let error as NSError {
                print("Could not fetch, or save \(error), \(error.userInfo)")
            }
            //print("Confirm button clicked.")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            //print("Cancel button clicked.")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return section.count
    }
        
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            var rows = order.count
            let sectionName = self.section[section]
            switch(sectionName) {
                case "Grocery": rows = rowPerSection[0].count
                    break;
                case "Clothing": rows = rowPerSection[1].count
                    break;
                case "Movies": rows = rowPerSection[2].count
                    break;
                case "Garden": rows = rowPerSection[3].count
                    break;
                case "Electronics": rows = rowPerSection[4].count
                    break;
                case "Books": rows = rowPerSection[5].count
                    break;
                case "Appliances": rows = rowPerSection[6].count
                    break;
                case "Toys": rows = rowPerSection[7].count
                    break;
                default:
                    break;
            }
            return rows
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionName = self.section[section]
        var header = "Uncategorized"
        switch(sectionName) {
            case "Grocery": header = "Grocery"
                break;
            case "Clothing": header = "Clothing"
                break;
            case "Movies": header = "Movies"
                break;
            case "Garden": header = "Garden"
                break;
            case "Electronics": header = "Electronics"
                break;
            case "Books": header = "Books"
                break;
            case "Appliances": header = "Appliances"
                break;
            case "Toys": header = "Toys"
                break;
            default:
                break;
        }
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CartCell", forIndexPath: indexPath) as! CartItem
        let row = indexPath.row
        let sectionNum = indexPath.section
        let sectionName = self.section[sectionNum]
        switch (sectionName) {
            case "Grocery":
                cell.itemTitle.text = order[rowPerSection[0][row]].title
                cell.itemSum.text = "$" + order[rowPerSection[0][row]].sum.description
                cell.itemCount.text = order[rowPerSection[0][row]].count.description
                break;
            case "Clothing":
                cell.itemTitle.text = order[rowPerSection[1][row]].title
                cell.itemSum.text = "$" + order[rowPerSection[1][row]].sum.description
                cell.itemCount.text = order[rowPerSection[1][row]].count.description
                break;
            case "Movies":
                cell.itemTitle.text = order[rowPerSection[2][row]].title
                cell.itemSum.text = "$" + order[rowPerSection[2][row]].sum.description
                cell.itemCount.text = order[rowPerSection[2][row]].count.description
                break;
            case "Garden":
                cell.itemTitle.text = order[rowPerSection[3][row]].title
                cell.itemSum.text = "$" + order[rowPerSection[3][row]].sum.description
                cell.itemCount.text = order[rowPerSection[3][row]].count.description
                break;
            case "Electronics":
                cell.itemTitle.text = order[rowPerSection[4][row]].title
                cell.itemSum.text = "$" + order[rowPerSection[4][row]].sum.description
                cell.itemCount.text = order[rowPerSection[4][row]].count.description
                break;
            case "Books":
                cell.itemTitle.text = order[rowPerSection[5][row]].title
                cell.itemSum.text = "$" + order[rowPerSection[5][row]].sum.description
                cell.itemCount.text = order[rowPerSection[5][row]].count.description
                break;
            case "Appliances":
                cell.itemTitle.text = order[rowPerSection[6][row]].title
                cell.itemSum.text = "$" + order[rowPerSection[6][row]].sum.description
                cell.itemCount.text = order[rowPerSection[6][row]].count.description
                break;
            case "Toys":
                cell.itemTitle.text = order[rowPerSection[7][row]].title
                cell.itemSum.text = "$" + order[rowPerSection[7][row]].sum.description
                cell.itemCount.text = order[rowPerSection[7][row]].count.description
                break;
            default:
                break;
        }
        return cell
    }
        
    class CartData {
        var title: String
        var sum: Double
        var count: Int
        var category: String
        init(title: String, sum: Double, count: Int, category: String) {
            self.title = title
            self.sum = sum
            self.count = count
            self.category = category
        }
    }
    
}
