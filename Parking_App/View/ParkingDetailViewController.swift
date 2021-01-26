//
//  ParkingDetailViewController.swift
//  Parking_App_Maham_Pinal_Group_1
//
//  Created by Pinal Patel on 2021-01-17.
//  Copyright © 2021 Maham Shamail. All rights reserved.
//

import UIKit

class ParkingDetailViewController: UIViewController {

    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtHours: UILabel!
    @IBOutlet weak var txtNoOfHost: UITextField!
    @IBOutlet weak var txtBlockNo: UITextField!
    @IBOutlet weak var lblCarPlateNo: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    var selectedParking:Parking?
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.lblAddress.layer.cornerRadius = 5
        self.lblAddress.layer.masksToBounds = true
        
        self.lblCarPlateNo.layer.cornerRadius = 5
        self.lblCarPlateNo.layer.masksToBounds = true
        
        guard let currentParking = selectedParking else {
            print("Parking Data is null")
            return
        }
        let newDate = dateFormatter.string(from: currentParking.parking_date!)
        txtHours.text = "You can park your car till " + String(currentParking.hours_to_park) + " Hours"
        txtNoOfHost.text = String(currentParking.no_of_hosts!)
        lblAddress.text = currentParking.street_address
        txtBlockNo.text = currentParking.building_code
       txtDate.text = newDate
        lblCarPlateNo.text = "Car Plate No : " + currentParking.car_plate_no!
        navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
