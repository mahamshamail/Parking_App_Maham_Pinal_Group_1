//
//  Parking.swift
//  Parking_App_Maham_Pinal_Group_1
//
//  Created by Pinal Patel on 2021-01-17.
//  Copyright © 2021 Maham Shamail. All rights reserved.
//

import Foundation
import CoreData

class ParkingData  {

      var parking_id : Int
      var user_id : Int
     var building_code: String
     var car_plate_no : String
     var hours_to_park : Int
     var no_of_hosts : String
     var street_address : String
     var latitude : Double
     var longitude : Double
     var parking_date : Date
    
    init(parking_id: Int, user_id: Int, building_code: String, car_plate_no: String, hours_to_park: Int, no_of_hosts: String, street_address: String, latitude: Double, longitude: Double, parking_date: Date) {
       self.parking_id = parking_id
       self.user_id = user_id
       self.building_code = building_code
       self.car_plate_no = car_plate_no
       self.hours_to_park = hours_to_park
       self.no_of_hosts = no_of_hosts
       self.street_address = street_address
       self.latitude = latitude
       self.longitude = longitude
       self.parking_date = parking_date
   }
    
}
