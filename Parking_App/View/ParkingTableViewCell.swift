//
//  ParkingTableViewCell.swift
//  Parking_App_Maham_Pinal_Group_1
//
//  Created by Pinal Patel on 2021-01-16.
//  Copyright © 2021 Maham Shamail. All rights reserved.
//

import UIKit

class ParkingTableViewCell: UITableViewCell {

    @IBOutlet weak var txtDate: UILabel!
    
    @IBOutlet weak var txtHours: UILabel!
    @IBOutlet weak var txtAddress: UILabel!
    
    @IBOutlet weak var lblCarPlateNo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
