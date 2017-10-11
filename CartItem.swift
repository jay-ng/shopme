//
//  CartItem.swift
//  ShopME
//
//  Created by Huy Nguyen on 3/1/16.
//  Copyright © 2016 Jay Nguyen. All rights reserved.
//

import UIKit

class CartItem: UITableViewCell {
    
    
    @IBOutlet weak var itemIncrease: UIButton!
    @IBOutlet weak var itemDecrease: UIButton!
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var itemSum: UILabel!
    @IBOutlet weak var itemTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        itemTitle.layer.cornerRadius = 5.0
        itemTitle.clipsToBounds = true
    }
}
