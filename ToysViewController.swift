//
//  ToysViewController.swift
//  ShopME
//
//  Created by Huy Nguyen on 3/1/16.
//  Copyright © 2016 Jay Nguyen. All rights reserved.
//

import UIKit
import CoreData

class ToysViewController: UITableViewController {
    
    var ToysList = [ToysData]();
    var CartList = [NSManagedObject]()
    
    @IBOutlet weak var CartButton: CartBarButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
        ToysList.append(ToysData(image: UIImage(named: "toys-1-legobatman.jpg")!, title: "  Lego Kit 1", desc: "Batman Kit", add: UIImage(named: "add-button.png")!, price: 19.99))
        ToysList.append(ToysData(image: UIImage(named: "toys-2-legocity1.jpg")!, title: "  Lego Kit 2", desc: "City Kit - 1", add: UIImage(named: "add-button.png")!, price: 19.99))
        ToysList.append(ToysData(image: UIImage(named: "toys-3-legolotr.jpg")!, title: "  Lego Kit 3", desc: "Lord of the Rings Kit", add: UIImage(named: "add-button.png")!, price: 19.99))
        ToysList.append(ToysData(image: UIImage(named: "toys-4-legoheroes.JPG")!, title: "  Lego Kit 4", desc: "Heroes Kit", add: UIImage(named: "add-button.png")!, price: 19.99))
        ToysList.append(ToysData(image: UIImage(named: "toys-5-legocity2.JPG")!, title: "  Lego Kit 5", desc: "City Kit - 2", add: UIImage(named: "add-button.png")!, price: 19.99))
        
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
        self.performSegueWithIdentifier("cartSegue7", sender: self)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ToysList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ToysCell", forIndexPath: indexPath) as! ToysItem
        cell.toyImage.image = ToysList[indexPath.row].image
        cell.toyTitle.text = ToysList[indexPath.row].title
        cell.toyDesc.text = ToysList[indexPath.row].desc
        cell.toyAdd.setImage(ToysList[indexPath.row].add, forState: UIControlState.Normal)
        cell.toyPrice.text = "$" + ToysList[indexPath.row].price.description
        return cell
    }
    
    @IBAction func addItem(sender: AnyObject) {
        let cellIndexPath = tableView.indexPathForCell(sender.superview!!.superview as! UITableViewCell)
        let mName = ToysList[cellIndexPath!.row].title
        let mPrice = ToysList[cellIndexPath!.row].price
        let mCategory = "Toys"
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
    
    @IBAction func cartButtonClicked(sender: AnyObject) {
        
    }
    
    class ToysData {
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

