//
//  GroceryItem.swift
//  ShopME
//
//  Created by Huy Nguyen on 3/1/16.
//  Copyright © 2016 Jay Nguyen. All rights reserved.
//

import UIKit

class GroceryItem: UITableViewCell {
    
    @IBOutlet weak var groAdd: UIButton!
    @IBOutlet weak var groPrice: UILabel!
    @IBOutlet weak var groDesc: UILabel!
    @IBOutlet weak var groTitle: UILabel!
    @IBOutlet weak var groImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        groTitle.layer.cornerRadius = 8.0
        groTitle.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
