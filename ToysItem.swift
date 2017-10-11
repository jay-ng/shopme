//
//  ToysItem.swift
//  ShopME
//
//  Created by Huy Nguyen on 3/1/16.
//  Copyright © 2016 Jay Nguyen. All rights reserved.
//

import UIKit

class ToysItem: UITableViewCell {
    
    
    @IBOutlet weak var toyAdd: UIButton!
    @IBOutlet weak var toyPrice: UILabel!
    @IBOutlet weak var toyDesc: UILabel!
    @IBOutlet weak var toyTitle: UILabel!
    @IBOutlet weak var toyImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        toyTitle.layer.cornerRadius = 8.0
        toyTitle.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
