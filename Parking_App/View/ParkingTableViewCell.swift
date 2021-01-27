// Group 1
// 101328732 - Saiyeda Maham Shamail
// 101334143 - Pinalben Patel
// Pinal's code

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
