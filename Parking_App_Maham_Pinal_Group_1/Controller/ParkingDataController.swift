//
//  ParkingDataController.swift
//  Parking_App_Maham_Pinal_Group_1
//
//  Created by Pinal Patel on 2021-01-17.
//  Copyright © 2021 Maham Shamail. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ParkingDataController{
    enum ParkingStatus{
        case INSERT_SUCCESS
        case INSERT_FAILURE
    }
    private var moc : NSManagedObjectContext
    
    init() {
        self.moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    func insertAccount(parkingData : ParkingData) -> ParkingStatus{
        do{
            let newParking = NSEntityDescription.insertNewObject(forEntityName: "Parking", into: moc) as! Parking
            newParking.parking_date = parkingData.parking_date
            newParking.building_code = parkingData.building_code
            newParking.car_plate_no = parkingData.car_plate_no
            newParking.hours_to_park = (Int16(parkingData.hours_to_park))
            newParking.no_of_hosts = parkingData.no_of_hosts
            newParking.latitude = parkingData.latitude
            newParking.longitude = parkingData.longitude
            newParking.parking_id = Int16(Int((Int16(parkingData.parking_id))))
            newParking.user_id = Int16(Int((Int16(parkingData.user_id))))
            newParking.street_address = parkingData.street_address
            
            try moc.save()
            
            print(#function, "Parking added successfully")
            return ParkingStatus.INSERT_SUCCESS
            
        }catch let error as NSError{
                print(#function, "Something went wrong. Couldn't add parking")
                print(#function, error, error.localizedDescription)
                return ParkingStatus.INSERT_FAILURE
            
        }
    }
    
    func getAllParking() -> [Parking]?{
    
        let fetchRequest = NSFetchRequest<Parking>(entityName: "Parking")
        let sortDescriptors = NSSortDescriptor(key: "parking_date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptors]
        do{
            let result = try moc.fetch(fetchRequest)
            let parkingList = result as [Parking]
            
//            for parking in parkingList{
//                print("carPlateNo : \(parking.car_plate_no!) UserId : \(parking.user_id) parkingId : \(parking.parking_id) Street add : \(parking.street_address!) \n Lat : \(parking.latitude) \n Long : \(parking.longitude) \n Date : \(parking.parking_date!)")
//            }
            
            return parkingList
            
        }catch let error{
            print(#function, "Couldn't fetch records", error.localizedDescription)
        }
        return nil
    }
}

