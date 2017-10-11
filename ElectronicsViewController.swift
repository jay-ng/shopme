//
//  ElectronicsViewController.swift
//  ShopME
//
//  Created by Huy Nguyen on 3/1/16.
//  Copyright © 2016 Jay Nguyen. All rights reserved.
//

import UIKit
import CoreData

class ElectronicsViewController: UITableViewController {
    
    var ElectronicsList = [ElectronicsData]();
    var CartList = [NSManagedObject]()
    @IBOutlet weak var CartButton: CartBarButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
        ElectronicsList.append(ElectronicsData(image: UIImage(named: "electronics-1-iphone6splus.jpg")!, title: "  Apple iPhone 6s Plus", desc: "Black/White\nDifferent Storage Available", add: UIImage(named: "add-button.png")!, price: 799.99))
        ElectronicsList.append(ElectronicsData(image: UIImage(named: "electronics-2-iphone6plus.jpg")!, title: "  Apple iPhone 6 Plus", desc: "Black/White\nDifferent Storage May or May not be available", add: UIImage(named: "add-button.png")!, price: 699.99))
        ElectronicsList.append(ElectronicsData(image: UIImage(named: "electronics-3-macbookpro.jpg")!, title: "  Apple Macbook Pro Retina", desc: "Different screen size available\nContact for more options", add: UIImage(named: "add-button.png")!, price: 1799.99))
        ElectronicsList.append(ElectronicsData(image: UIImage(named: "electronics-4-ipadpro.jpg")!, title: "  Apple iPad Pro", desc: "Grey\nDifferent Storage Available", add: UIImage(named: "add-button.png")!, price: 899.99))
        ElectronicsList.append(ElectronicsData(image: UIImage(named: "electronics-5-ipadair.png")!, title: "  Apple iPad Air", desc: "Black/White\nDifferent Storage Available", add: UIImage(named: "add-button.png")!, price: 599.99))
        
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
        self.performSegueWithIdentifier("cartSegue5", sender: self)
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
        let mName = ElectronicsList[cellIndexPath!.row].title
        let mPrice = ElectronicsList[cellIndexPath!.row].price
        let mCategory = "Electronics"
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
        return ElectronicsList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ElectronicsCell", forIndexPath: indexPath) as! ElectronicsItem
        cell.eleImage.image = ElectronicsList[indexPath.row].image
        cell.eleTitle.text = ElectronicsList[indexPath.row].title
        cell.eleDesc.text = ElectronicsList[indexPath.row].desc
        cell.eleAdd.setImage(ElectronicsList[indexPath.row].add, forState: UIControlState.Normal)
        cell.elePrice.text = "$" + ElectronicsList[indexPath.row].price.description
        return cell
    }
    
    class ElectronicsData {
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

