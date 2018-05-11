//
//  TrackTimeCell.swift
//  pinkslips
//
//  Created by Vince Reyes on 5/3/18.
//  Copyright © 2018 VinceReyes. All rights reserved.
//

import UIKit

class TrackTimeCell: UITableViewCell {

    @IBOutlet weak var carLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
