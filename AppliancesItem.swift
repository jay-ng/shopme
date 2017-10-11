//
//  AppliancesItem.swift
//  ShopME
//
//  Created by Huy Nguyen on 3/1/16.
//  Copyright © 2016 Jay Nguyen. All rights reserved.
//

import UIKit

class AppliancesItem: UITableViewCell {
    
    
    @IBOutlet weak var appAdd: UIButton!
    @IBOutlet weak var appPrice: UILabel!
    @IBOutlet weak var appDesc: UILabel!
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var appImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        appTitle.layer.cornerRadius = 8.0
        appTitle.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
