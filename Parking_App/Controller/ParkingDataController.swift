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
    func insertAccount(parkingId : Int, userId: UUID, buildingCode: String, carPlateNo : String, hoursToPark : Int, noOFHosts : String, streetAddress : String, latitude : Double, longitude:Double, parkingDate : Date) -> ParkingStatus{
        do{
            let newParking = NSEntityDescription.insertNewObject(forEntityName: "Parking", into: moc) as! Parking

            newParking.parking_date = parkingDate
            newParking.building_code = buildingCode
            newParking.car_plate_no = carPlateNo
            newParking.hours_to_park = Int16(hoursToPark)
            newParking.no_of_hosts = noOFHosts
            newParking.latitude = latitude
            newParking.longitude = longitude
            newParking.parking_id = Int16(Int((Int16(parkingId))))
            newParking.user_id = userId
            newParking.street_address = streetAddress

            try moc.save()

            print(#function, "Parking added successfully")
            return ParkingStatus.INSERT_SUCCESS

        }catch let error as NSError{
                print(#function, "Something went wrong. Couldn't add parking")
                print(#function, error, error.localizedDescription)
                return ParkingStatus.INSERT_FAILURE
        }
    }
    
    func getAllParking(userID : UUID) -> [Parking]?{

        let fetchRequest = NSFetchRequest<Parking>(entityName: "Parking")

        let predicate = NSPredicate(format: "user_id == %@", userID as CVarArg)
        fetchRequest.predicate = predicate

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

