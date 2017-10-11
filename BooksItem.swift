//
//  BooksItem.swift
//  ShopME
//
//  Created by Huy Nguyen on 3/1/16.
//  Copyright © 2016 Jay Nguyen. All rights reserved.
//

import UIKit

class BooksItem: UITableViewCell {
    
    
    @IBOutlet weak var bokAdd: UIButton!
    @IBOutlet weak var bokPrice: UILabel!
    @IBOutlet weak var bokDesc: UILabel!
    @IBOutlet weak var bokTitle: UILabel!
    @IBOutlet weak var bokImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bokTitle.layer.cornerRadius = 8.0
        bokTitle.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
