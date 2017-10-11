//
//  GroceryViewController.swift
//  ShopME
//
//  Created by Huy Nguyen on 3/1/16.
//  Copyright © 2016 Jay Nguyen. All rights reserved.
//

import UIKit
import CoreData

class GroceryViewController: UITableViewController {
 
    var GroceryList = [GroceryData]();
    var CartList = [NSManagedObject]()
    @IBOutlet weak var CartButton: CartBarButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
        
        // Do any additional setup after loading the view, typically from a nib.
        GroceryList.append(GroceryData(image: UIImage(named: "grocery-1-tomatoes.png")!, title: "  Tomato, per lb", desc: "On the vine", add: UIImage(named: "add-button.png")!, price: 2.45))
        GroceryList.append(GroceryData(image: UIImage(named: "grocery-2-bananas.png")!, title: "  Banana, per lb", desc: "Very durable", add: UIImage(named: "add-button.png")!, price: 0.49))
        GroceryList.append(GroceryData(image: UIImage(named: "grocery-3-gala.jpg")!, title: "  Apple", desc: "Gala apples", add: UIImage(named: "add-button.png")!, price: 1.47))
        GroceryList.append(GroceryData(image: UIImage(named: "grocery-4-lettuce.png")!, title: "  Lettuce", desc: "Green leaf", add: UIImage(named: "add-button.png")!, price: 3.19))
        GroceryList.append(GroceryData(image: UIImage(named: "grocery-5-broccoli.png")!, title: "  Broccoli", desc: "Bunch", add: UIImage(named: "add-button.png")!, price: 1.99))
        GroceryList.append(GroceryData(image: UIImage(named: "grocery-6-milk.png")!, title: "  Milk", desc: "One box, organic", add: UIImage(named: "add-button.png")!, price: 4.49))
        GroceryList.append(GroceryData(image: UIImage(named: "grocery-7-bread.png")!, title: "  Bread", desc: "Fresh out of the bakery", add: UIImage(named: "add-button.png")!, price: 1.99))
        GroceryList.append(GroceryData(image: UIImage(named: "grocery-8-eggs.png")!, title: "  Eggs, per dozen", desc: "Farm raised", add: UIImage(named: "add-button.png")!, price: 1.99))
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
        self.performSegueWithIdentifier("cartSegue8", sender: self)
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
        let mName = GroceryList[cellIndexPath!.row].title
        let mPrice = GroceryList[cellIndexPath!.row].price
        let mCategory = "Grocery"
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
        return GroceryList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroceryCell", forIndexPath: indexPath) as! GroceryItem
        cell.groImage.image = GroceryList[indexPath.row].image
        cell.groTitle.text = GroceryList[indexPath.row].title
        cell.groDesc.text = GroceryList[indexPath.row].desc
        cell.groAdd.setImage(GroceryList[indexPath.row].add, forState: UIControlState.Normal)
        cell.groPrice.text = "$" + GroceryList[indexPath.row].price.description
        return cell
    }
    
    class GroceryData {
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
