//
//  MovieItem.swift
//  ShopME
//
//  Created by Huy Nguyen on 3/1/16.
//  Copyright © 2016 Jay Nguyen. All rights reserved.
//

import UIKit

class MovieItem: UITableViewCell {
    

    @IBOutlet weak var movAdd: UIButton!
    @IBOutlet weak var movPrice: UILabel!
    @IBOutlet weak var movDesc: UILabel!
    @IBOutlet weak var movTitle: UILabel!
    @IBOutlet weak var movImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        movTitle.layer.cornerRadius = 8.0
        movTitle.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}