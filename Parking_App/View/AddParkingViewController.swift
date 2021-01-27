//
//  AddParkingViewController.swift
//  Parking_App_Maham_Pinal_Group_1
//
//  Created by Pinal Patel on 2021-01-16.
//  Copyright © 2021 Maham Shamail. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class AddParkingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate{
    
    let geocoder = CLGeocoder()
    let locationManager = CLLocationManager()
    @IBOutlet weak var txtStreetAdd: UITextView!
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var txtNoOfHost: UITextField!
    @IBOutlet weak var txtCarPlateNo: UITextField!
    @IBOutlet weak var txtBuildingCode: UITextField!
    @IBOutlet weak var hoursPicker: UIPickerView!
    var selectedHours :  Int = 0
    let hours = ["1-hour or less", "4-hour", "12-hour", " 24-hour"]
    var isCurrentLocation = false
    let parkingDataController = ParkingDataController()
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var parkingId : Int = 1
    let userController = UserController()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hoursPicker.dataSource = self
        self.hoursPicker.delegate = self
        self.txtStreetAdd.delegate = self
        txtStreetAdd.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        txtStreetAdd.layer.borderWidth = 1.0;
        txtStreetAdd.layer.cornerRadius = 5.0;
        txtStreetAdd.text = "Add your Parking street address."
        txtStreetAdd.textColor = UIColor.lightGray
        
        //self.parkingDataController.getParkingID()
        textViewDidEndEditing(txtStreetAdd)
        textViewDidEndEditing(txtStreetAdd)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add your Parking street address."
            textView.textColor = UIColor.lightGray
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hours.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0{
            selectedHours = 1}
        if row == 1{
            selectedHours = 4}
        if row == 2{
            selectedHours = 12}
        if row == 3{
            selectedHours = 24}
       // print("pos \(row) selectedHours \(selectedHours)")
        
        return hours[row]
    }
    
    @IBAction func btnAddParking(_ sender: Any) {
        
        if checkValidations() && isCurrentLocation == false {
            print("Validate true")
            self.getLocation(address: "\(txtStreetAdd.text ?? "Toronto")")
        }
        if checkValidations() && isCurrentLocation == true {
            self.insertParkingData(lat: self.latitude, long: self.longitude)
        }
    }
    
    func checkValidations() -> Bool{
        var isValidate = false
     
        if txtCarPlateNo.text!.count < 2 || txtCarPlateNo.text!.count > 8 || txtCarPlateNo.text?.isEmpty == true{
            isValidate = false
            displayDialog(strtitle: "Error!", strMsg: "Please enter mininum 2 and maximum 8 character for car plate number.")
        }
      else  if txtBuildingCode.text?.count != 5{
            isValidate = false
            displayDialog(strtitle: "Error!", strMsg: "Please enter exactly 5 character into Building Code.")
        }
      else if (txtNoOfHost.text!.count < 2 || txtNoOfHost.text!.count > 5 || txtNoOfHost.text?.isEmpty == true){
            isValidate = false
            displayDialog(strtitle: "Error!", strMsg: "Please enter mininum 2 and maximum 5 character for Suit number of Host.")
        }
        else if (txtStreetAdd.text == nil && txtStreetAdd.text?.isEmpty == true){
            isValidate = false
            displayDialog(strtitle: "Error!", strMsg: "Please enter street address.")
        } else {
          isValidate = true
        }
        
        return isValidate
    }
    
    @IBAction func btnCurrentLocationClick(_ sender: Any) {
        isCurrentLocation = true
       print("btn current location click")
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func displayDialog(strtitle:String, strMsg: String){
        let alert = UIAlertController(title: strtitle, message: strMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func parkingAddDialog(strtitle:String, strMsg: String){
        let alert = UIAlertController(title: strtitle, message: strMsg, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            self.tabBarController!.selectedIndex = 0;
            
               }
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func insertParkingData(lat:Double, long:Double){
      isCurrentLocation = false
        if UserDefaults.standard.integer(forKey: "parkingId") != 0{
            parkingId = UserDefaults.standard.integer(forKey: "parkingId") + 1
        }
        
        let email = UserDefaults.standard.value(forKey: "user_email") as! String
        let currentUser = self.userController.searchProfile(email: email)
        if currentUser != nil{
           // print("Dataaaa \(currentUser?.user_id!)")
            
            let insertionStatus = self.parkingDataController.insertAccount(parkingId: parkingId, userId: (currentUser?.user_id)!, buildingCode: txtBuildingCode.text!, carPlateNo: txtCarPlateNo.text!, hoursToPark: selectedHours, noOFHosts: txtNoOfHost.text!, streetAddress: txtStreetAdd.text!, latitude: self.latitude, longitude: self.longitude, parkingDate: Date())
                    switch insertionStatus {
                    case .INSERT_SUCCESS:
                        UserDefaults.standard.set(parkingId, forKey: "parkingId")
                        print(#function, "account created")
                        parkingAddDialog(strtitle: "Hello  \(currentUser?.first_name! ?? "")", strMsg: "Your Parking Booked Successfully.")

                        self.navigationController?.popViewController(animated: true)
                    case .INSERT_FAILURE:
                        print(#function, "Somethign went wrong. Sorry for inconvenience")
                    }
        }
        
       
    }
}

extension AddParkingViewController : CLLocationManagerDelegate{
    
    func getLocation(address: String)
     {
       self.geocoder.geocodeAddressString(address) { (placemark, error) in
         self.processGeoResponse(withPlacemarks: placemark, error: error)
       }
     }
    
     func processGeoResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?)
     {
       if (error != nil)
       {
         print(#function, error?.localizedDescription)
       }
       else
       {
         var myLocation: CLLocation?
         if let placemark = placemarks, placemarks!.count > 0
         {
           myLocation = placemark.first?.location
         }
         if let myLocation = myLocation
         {
            print("latitude : \(myLocation.coordinate.latitude)")
            print("longitude : \(myLocation.coordinate.longitude)")
            
            self.latitude = myLocation.coordinate.latitude
            self.longitude = myLocation.coordinate.longitude
            
            if isCurrentLocation {
                if error != nil{
                    self.txtStreetAdd.text = "Unable to find the address."
                    self.txtStreetAdd.textColor = .black
                }else{
                    
                    if let placemarks = placemarks, let placemark = placemarks.first{
                        let address = (placemark.locality! + ", " + placemark.administrativeArea! + ", " + placemark.country!)
                        self.txtStreetAdd.text = address
                        self.txtStreetAdd.textColor = .black
                        self.latitude = myLocation.coordinate.latitude
                        self.longitude = myLocation.coordinate.longitude
                    }else{
                        displayDialog(strtitle: "Error", strMsg: "Address is not found. Please enter valid address")
                    }
                }
            }
            else{
                self.insertParkingData(lat: self.latitude, long: self.longitude)
            }
            }
         else
         {
            print("Error")
         }
       }
     }
    //methods for to get current location geoCoding
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let myLocation : CLLocationCoordinate2D = manager.location?.coordinate
        else{ return }
        
//        print("\(myLocation.latitude)")
//        print("\(myLocation.longitude)")
        
        self.getAddress(location: CLLocation(latitude: myLocation.latitude, longitude: myLocation.longitude))
}
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    //to find address from geocoding(lat n long)
    
    func getAddress(location : CLLocation){
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemark, error) in
            self.processGeoResponse(withPlacemarks: placemark, error: error)
        })
    }
}


