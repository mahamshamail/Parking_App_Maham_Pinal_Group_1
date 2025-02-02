// Group 1
// 101328732 - Saiyeda Maham Shamail
// 101334143 - Pinalben Patel
// Maham's code

import Foundation
import CoreData
import UIKit

class UserController {
    private var managedObjectContext : NSManagedObjectContext
    
    init() {
        self.managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveProfile(firstname: String, lastname: String, carplate: String, contact: String?, emailA: String, profilePic: String? ){
        let email = UserDefaults.standard.value(forKey: "user_email") as! String
        //let userID = UserDefaults.standard.value(forKey: "userID") as! String
        
        let profileToUpdate = self.searchProfile(email: email)
        
        if profileToUpdate != nil{
            do{
                profileToUpdate!.first_name = firstname
                profileToUpdate!.last_name = lastname
                profileToUpdate!.car_plate_no = carplate
                if let con = contact{
                    if con.count > 0 {
                        profileToUpdate!.contact_no = con
                    }
                }
                profileToUpdate!.email = emailA
                profileToUpdate?.profile_pic = profilePic
                
                try managedObjectContext.save()
                
                print(#function, "Profile updates successfully")
            }catch let error{
                print(#function, "Unable to update profile")
                print(#function, error)
            }
        }
    }
    
    func getAllProfiles(){
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        
        do{
            let result = try managedObjectContext.fetch(fetchRequest)
            let profileList = result as [User]
            
            for profile in profileList{
                print(#function, " user_id: \(profile.user_id?.uuidString) \nemail \(profile.email) \nfirstname: \(profile.first_name) \nlastname \(profile.last_name) \ncarplate: \(profile.car_plate_no) \nprofile_pic: \(profile.profile_pic) \ncontact: \(profile.contact_no)  ")
              //  managedObjectContext.delete(profile)
              //  try managedObjectContext.save()
             //   let userID = UserDefaults.standard.value(forKey: "userID") as! UUID
              //  UserDefaults.standard.setValue(profile.user_id!, forKey: "userID")


            }
            
        }catch let error{
            print(#function, "Unable to fetch profiles")
            print(#function, error)
        }
    }
    
    func searchProfile(email: String) -> User?{
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        let predicate = NSPredicate(format: "email = %@", email)
        fetchRequest.predicate = predicate
        
        do{
            let result = try managedObjectContext.fetch(fetchRequest)
            
            if let matchingUser = result.first! as? User{
                return matchingUser
            }
        }catch let error{
            print(#function, "No matching profile found")
            print(#function, error)
        }
        
        return nil
    }
    
}
