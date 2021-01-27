//
//  ListViewController.swift
//  Parking_App_Maham_Pinal_Group_1
//
//  Created by Pinal Patel on 2021-01-16.
//  Copyright © 2021 Maham Shamail. All rights reserved.
//

import UIKit
import Foundation

class ListViewController: UIViewController {

    @IBOutlet weak var tableParking: UITableView!
    let parkingDataController = ParkingDataController()
    var row = 0
    var list = [Parking]()
    let dateFormatter = DateFormatter()
    let cellSpacingHeight: CGFloat = 7
    let userController = UserController()
    var currentUser = User()
    var islabel = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableParking.delegate = self
        tableParking.dataSource = self
        self.tableParking.rowHeight = 133
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        let email = UserDefaults.standard.value(forKey: "user_email") as! String
        self.currentUser = self.userController.searchProfile(email: email)!
        if currentUser != nil{
            self.list = self.parkingDataController.getAllParking(userID: currentUser.user_id!)!
            print("Dataaaa \(list.count)")
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        self.list = self.parkingDataController.getAllParking(userID: currentUser.user_id!)!
        self.tableParking.reloadData()
        if self.list.count > 0{
            EmptyMessage(message: " ", isLabel: false )
        }
        else{
            EmptyMessage(message: "You don't have any booked Parking!.", isLabel: true )
        }
       
        
    }

}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.list.count
    }
    
    
    func EmptyMessage(message:String,isLabel : Bool) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        if isLabel {
           
            messageLabel.text = message
            messageLabel.textColor = UIColor.blue
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
            messageLabel.sizeToFit()

         self.tableParking.backgroundView = messageLabel;
         self.tableParking.separatorStyle = .none;
        }
        else{
            if messageLabel.isHidden == false{
            messageLabel.isHidden = true
                messageLabel.text = " "
                self.tableParking.backgroundView = messageLabel;
                self.tableParking.separatorStyle = .none;
            }
        }
       }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return 1
       
        
    }
    // Set the spacing between sections
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return cellSpacingHeight
        }
    // Make the background color show through
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clear
            return headerView
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "parkingCell") as? ParkingTableViewCell
   
       
        if cell != nil {
            let newDate = dateFormatter.string(from: list[indexPath.section].parking_date!)
            cell?.txtAddress.text = list[indexPath.section].street_address
            cell?.txtHours.text = "Maximum " + String(list[indexPath.section].hours_to_park) + " Hours"
            cell?.lblCarPlateNo.text = "Car Plate No : " + list[indexPath.section].car_plate_no!
            cell?.txtDate.text = newDate
                  cell!.backgroundColor = UIColor.white
                  cell!.layer.borderColor = UIColor.gray.cgColor
                  cell!.layer.borderWidth = 1
                  cell!.layer.cornerRadius = 5
                  cell!.clipsToBounds = true
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        row = indexPath.section
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "detailsegue", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsegue"
        {
            let selectedParkingData = self.list[row]
            let vc = segue.destination as! ParkingDetailViewController
            vc.selectedParking = selectedParkingData
    }
        
    }
}


