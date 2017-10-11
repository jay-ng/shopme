//
//  ClothingItem.swift
//  ShopME
//
//  Created by Huy Nguyen on 3/1/16.
//  Copyright © 2016 Jay Nguyen. All rights reserved.
//

import UIKit

class ClothingItem: UITableViewCell {
    
    
    @IBOutlet weak var cloAdd: UIButton!
    @IBOutlet weak var cloPrice: UILabel!
    @IBOutlet weak var cloDesc: UILabel!
    @IBOutlet weak var cloTitle: UILabel!
    @IBOutlet weak var cloImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cloTitle.layer.cornerRadius = 8.0
        cloTitle.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
