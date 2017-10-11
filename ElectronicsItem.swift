//
//  ElectronicsItem.swift
//  ShopME
//
//  Created by Huy Nguyen on 3/1/16.
//  Copyright © 2016 Jay Nguyen. All rights reserved.
//

import UIKit

class ElectronicsItem: UITableViewCell {
    
    
    @IBOutlet weak var eleAdd: UIButton!
    @IBOutlet weak var elePrice: UILabel!
    @IBOutlet weak var eleDesc: UILabel!
    @IBOutlet weak var eleTitle: UILabel!
    @IBOutlet weak var eleImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        eleTitle.layer.cornerRadius = 8.0
        eleTitle.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}