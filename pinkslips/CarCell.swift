//
//  CarCell.swift
//  pinkslips
//
//  Created by Vince Reyes on 4/29/18.
//  Copyright © 2018 VinceReyes. All rights reserved.
//

import UIKit

class CarCell: UITableViewCell {

    @IBOutlet weak var carImg: UIImageView!
    
    @IBOutlet weak var carInfoLabel: UILabel!
    
    @IBOutlet weak var powerLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
