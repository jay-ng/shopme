//
//  CategoryViewController.swift
//  ShopME
//
//  Created by Huy Nguyen on 3/1/16.
//  Copyright © 2016 Jay Nguyen. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController : UICollectionViewController {

    @IBOutlet var categoryView: UICollectionView!
    var catList = [CategoryData]()
    var CartList = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let banner = UIImage(named: "logo.png")
        let imageView = UIImageView(image:banner)
        imageView.frame = CGRectMake(0, 0, 30, 30)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.navigationItem.titleView = imageView
        
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
        
        
        catList.append(CategoryData(image: UIImage(named: "category-1-recent.png")!, title: "Recent Order"))
        catList.append(CategoryData(image: UIImage(named: "category-2-cart.png")!, title: "Cart (" + mQuantity.description + ")"))
        catList.append(CategoryData(image: UIImage(named: "category-3-grocery.png")!, title: "Grocery"))
        catList.append(CategoryData(image: UIImage(named: "category-4-clothing.png")!, title: "Clothing"))
        catList.append(CategoryData(image: UIImage(named: "category-5-movies.png")!, title: "Movies"))
        catList.append(CategoryData(image: UIImage(named: "category-6-garden.png")!, title: "Garden"))
        catList.append(CategoryData(image: UIImage(named: "category-7-electronics.png")!, title: "Electronics"))
        catList.append(CategoryData(image: UIImage(named: "category-8-books.png")!, title: "Books"))
        catList.append(CategoryData(image: UIImage(named: "category-9-appliances.png")!, title: "Appliances"))
        catList.append(CategoryData(image: UIImage(named: "category-10-toys.png")!, title: "Toys"))
        collectionView!.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
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
        var mQuantity = 0
        if (CartList.count>0) {
            for (var i=0; i<CartList.count; i++) {
                mQuantity += CartList[i].valueForKey("quantity") as! Int
            }
        }
        catList[1].title = "Cart (" + mQuantity.description + ")"
        collectionView!.reloadItemsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catList.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("categoryCell", forIndexPath: indexPath) as! categoryItem
        cell.title.text = catList[indexPath.row].title
        cell.imgView.image = catList[indexPath.row].image
        return cell;
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.row) {
            case 0: self.performSegueWithIdentifier("recentSegue", sender: self)
                    break;
            case 1: self.performSegueWithIdentifier("cartSegue1", sender: self)
                    break;
            case 2: self.performSegueWithIdentifier("grocerySegue", sender: self)
                    break;
            case 3: self.performSegueWithIdentifier("clothingSegue", sender: self)
                    break;
            case 4: self.performSegueWithIdentifier("movieSegue", sender: self)
                    break;
            case 5: self.performSegueWithIdentifier("gardenSegue", sender: self)
                    break;
            case 6: self.performSegueWithIdentifier("electronicsSegue", sender: self)
                    break;
            case 7: self.performSegueWithIdentifier("booksSegue", sender: self)
                    break;
            case 8: self.performSegueWithIdentifier("appSegue", sender: self)
                    break;
            case 9: self.performSegueWithIdentifier("toysSegue", sender: self)
                    break;
            default:
                    break;
        }
    }
    
    @IBAction func backToHome(segue:UIStoryboardSegue) {
    
    }
    
    class CategoryData {
        var image: UIImage
        var title: String
        init(image: UIImage, title: String) {
            self.image = image
            self.title = title
        }
    }
}

