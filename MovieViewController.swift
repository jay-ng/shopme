//
//  MovieViewController.swift
//  ShopME
//
//  Created by Huy Nguyen on 3/1/16.
//  Copyright © 2016 Jay Nguyen. All rights reserved.
//

import UIKit
import CoreData

class MovieViewController: UITableViewController {
    
    var MovieList = [MovieData]();
    var CartList = [NSManagedObject]()
    @IBOutlet weak var CartButton: CartBarButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
        
        MovieList.append(MovieData(image: UIImage(named: "movies-1-shawshank.jpg")!, title: "  The Shawshank Redemption", desc: "A Classic", add: UIImage(named: "add-button.png")!, price: 14.99))
        MovieList.append(MovieData(image: UIImage(named: "movies-2-lord-of-the-rings.jpg")!, title: "  Lord of the Rings", desc: "Must watch", add: UIImage(named: "add-button.png")!, price: 14.99))
        MovieList.append(MovieData(image: UIImage(named: "movies-3-godfather.jpg")!, title: "  The Godfather", desc: "Modern classic", add: UIImage(named: "add-button.png")!, price: 14.99))
        MovieList.append(MovieData(image: UIImage(named: "movies-4-kungfu-panda-3.jpg")!, title: "  Kung Fu Panda 3", desc: "Fat is no more", add: UIImage(named: "add-button.png")!, price: 19.99))
        MovieList.append(MovieData(image: UIImage(named: "movies-5-god-of-egypt.jpg")!, title: "  God of Egypt", desc: "Overhyped", add: UIImage(named: "add-button.png")!, price: 19.99))
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
        self.performSegueWithIdentifier("cartSegue9", sender: self)
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
        let mName = MovieList[cellIndexPath!.row].title
        let mPrice = MovieList[cellIndexPath!.row].price
        let mCategory = "Movies"
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
        return MovieList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieItem
        cell.movImage.image = MovieList[indexPath.row].image
        cell.movTitle.text = MovieList[indexPath.row].title
        cell.movDesc.text = MovieList[indexPath.row].desc
        cell.movAdd.setImage(MovieList[indexPath.row].add, forState: UIControlState.Normal)
        cell.movPrice.text = "$" + MovieList[indexPath.row].price.description
        return cell
    }
    
    class MovieData {
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
