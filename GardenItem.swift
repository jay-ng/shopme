//
//  GardenItem.swift
//  ShopME
//
//  Created by Huy Nguyen on 3/1/16.
//  Copyright © 2016 Jay Nguyen. All rights reserved.
//

import UIKit

class GardenItem: UITableViewCell {
    
    @IBOutlet weak var garAdd: UIButton!
    @IBOutlet weak var garPrice: UILabel!
    @IBOutlet weak var garDesc: UILabel!
    @IBOutlet weak var garTitle: UILabel!
    @IBOutlet weak var garImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        garTitle.layer.cornerRadius = 8.0
        garTitle.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
