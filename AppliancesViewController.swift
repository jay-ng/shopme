//
//  AppliancesViewController.swift
//  ShopME
//
//  Created by Huy Nguyen on 3/1/16.
//  Copyright © 2016 Jay Nguyen. All rights reserved.
//

import UIKit
import CoreData

class AppliancesViewController: UITableViewController {
    
    var AppliancesList = [AppliancesData]();
    var CartList = [NSManagedObject]()
    @IBOutlet weak var CartButton: CartBarButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
        AppliancesList.append(AppliancesData(image: UIImage(named: "appliances-1-refrig.jpeg")!, title: "  Refrigerator", desc: "Silver - 2 Doors", add: UIImage(named: "add-button.png")!, price: 1499.99))
        AppliancesList.append(AppliancesData(image: UIImage(named: "appliances-2-refrig-2.jpg")!, title: "  Refrigerator", desc: "Matte Silver - 2 Doors", add: UIImage(named: "add-button.png")!, price: 1499.99))
        AppliancesList.append(AppliancesData(image: UIImage(named: "appliances-3-refrig-3.jpeg")!, title: "  Refrigerator", desc: "Black - 4 Doors", add: UIImage(named: "add-button.png")!, price: 1499.99))
        AppliancesList.append(AppliancesData(image: UIImage(named: "appliances-4-refrig-4.jpeg")!, title: "  Refrigerator", desc: "Black - 3 Doors", add: UIImage(named: "add-button.png")!, price: 1499.99))
        AppliancesList.append(AppliancesData(image: UIImage(named: "appliances-5-refrig-5.jpg")!, title: "  Refrigerator", desc: "Red - 1 Door", add: UIImage(named: "add-button.png")!, price: 1099.99))
        
    }
    
    override func viewDidAppear(animated: Bool) {
        updateLabel()
    }
    
    func updateLabel() -> Void {
        let button = UIButton(type: .Custom)
        button.frame = CGRectMake(0,0,30,30)
        button.addTarget(self, action: "cartSegueClicked", forControlEvents: UIControlEvents.TouchUpInside)
        button.setBackgroundImage(UIImage(named: "cart.png"), forState: UIControlState.Normal)
        button.setTitle(getQuantity().description, forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func cartSegueClicked() {
        self.performSegueWithIdentifier("cartSegue6", sender: self)
    }
    
    func getQuantity() -> Int {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Items")
        
        var mQuantity = 0
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            CartList = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        for (var i=0; i<CartList.count; i++) {
            mQuantity += CartList[i].valueForKey("quantity") as! Int
        }
        return mQuantity
    }
    
    @IBAction func addButton(sender: AnyObject) {
        let cellIndexPath = tableView.indexPathForCell(sender.superview!!.superview as! UITableViewCell)
        let mName = AppliancesList[cellIndexPath!.row].title
        let mPrice = AppliancesList[cellIndexPath!.row].price
        let mCategory = "Appliances"
        var mQuantity = 1
        //print(mName + " " + mPrice.description + " " + mCategory)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Items")
        fetchRequest.predicate = NSPredicate(format: "title = %@", mName)
        
        do {
            if let
                fetchResults =
                try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                    if fetchResults.count != 0 {
                        
                        let managedObject = fetchResults[0]
                        mQuantity = managedObject.valueForKey("quantity") as! Int
                        managedObject.setValue(mQuantity+1, forKey: "quantity")
                        try managedContext.save()
                        
                    } else {
                        
                        let entity =  NSEntityDescription.entityForName("Items",
                            inManagedObjectContext:managedContext)
                        
                        let anItem = NSManagedObject(entity: entity!,
                            insertIntoManagedObjectContext: managedContext)
                        
                        anItem.setValue(mName, forKey: "title")
                        anItem.setValue(mPrice, forKey: "price")
                        anItem.setValue(mCategory, forKey: "category")
                        anItem.setValue(mQuantity, forKey: "quantity")
                        anItem.setValue(0.0, forKey: "sum")
                        
                        do {
                            try managedContext.save()
                            CartList.append(anItem)
                        } catch let error as NSError  {
                            print("Could not save \(error), \(error.userInfo)")
                        }
                        
                    }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        updateLabel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppliancesList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AppliancesCell", forIndexPath: indexPath) as! AppliancesItem
        cell.appImage.image = AppliancesList[indexPath.row].image
        cell.appTitle.text = AppliancesList[indexPath.row].title
        cell.appDesc.text = AppliancesList[indexPath.row].desc
        cell.appAdd.setImage(AppliancesList[indexPath.row].add, forState: UIControlState.Normal)
        cell.appPrice.text = "$" + AppliancesList[indexPath.row].price.description
        return cell
    }
    
    class AppliancesData {
        var image: UIImage
        var title: String
        var desc: String
        var add: UIImage
        var price: Double
        init(image: UIImage, title: String, desc: String, add: UIImage, price: Double) {
            self.image = image
            self.title = title
            self.desc = desc
            self.add = add
            self.price = price
        }
    }
}
