
//
//  AccountController.swift
//  Parking_App_Maham_Pinal_Group_1
//
//  Created by Maham Shamail on 21/01/2021.
//  Copyright © 2021 Maham Shamail. All rights reserved.
// account: date-created, date_modified, email, is_active, password
// user : car_plate_no, contact_no, email, first_name, last_name, profile_pic, user_id

import Foundation
import CoreData
import UIKit

class AccountController{
    private var managedObjectContext: NSManagedObjectContext
    init(){
        self.managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    }
    func insertAccount(email : String, password : String, firstName: String, lastName: String, contact: String?, carPlate: String, profilePic: String?) -> AccountStatus{
        do{
            let newAccount = NSEntityDescription.insertNewObject(forEntityName: "Account", into: managedObjectContext) as! Account
            newAccount.date_created = Date()
            newAccount.is_active = true
            newAccount.email = email
            newAccount.password = password
            
            
            
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedObjectContext) as! User
            newUser.email = email
            newUser.first_name = firstName
            newUser.last_name = lastName
            newUser.car_plate_no = carPlate
            newUser.user_id = UUID()
            
            print("user uuid: \(newUser.user_id!.uuidString)")
            if let cont = contact {
                if cont.count > 0 {
                    newUser.contact_no = contact
                }
            }else{
                print(#function, "no contact number")
            }
            if let pic = profilePic {
                newUser.profile_pic = profilePic
            }else{
                print(#function, "no profile picture set")

            }
            
            try managedObjectContext.save()
            
            print(#function, "Account successfully created")
            return AccountStatus.INSERT_SUCCESS
        
        }catch let error as NSError{
            if error.code == 133021{
                print(#function, "This account already exists.")
                return AccountStatus.USER_EXISTS
            }else{
                print(#function, "Opps! Something went wrong. Could not create account.")
                print(#function, error, error.localizedDescription)
                return AccountStatus.INSERT_FAILURE
            }
        }
    }
    func getAllAccounts(){
        let fetchRequest = NSFetchRequest<Account>(entityName: "Account")
        
        do{
            let result = try managedObjectContext.fetch(fetchRequest)
            let accountList = result as [Account]
            
            for account in accountList{
                print("Email : \(account.email) Password \(account.password) date_created \(account.date_created) is_active \(account.is_active)")
              //  managedObjectContext.delete(account)
              //  try managedObjectContext.save()
            }
            
        }catch let error{
            print(#function, "Couldn't fetch records", error.localizedDescription)
        }
    }
    
    func validateAccount(email: String, password: String) -> Bool{
        //search for record
        //check if the account is active
        
        let accountToValidate = self.searchAccount(email: email)
        
        if accountToValidate != nil{
            if (accountToValidate!.password == password && accountToValidate!.is_active){
                return true
            }
        }
        
        return false
    }
    
    func searchAccount(email: String) -> Account?{
        let fetchRequest = NSFetchRequest<Account>(entityName: "Account")
        
        let predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.predicate = predicate
        
        do{
            let result = try managedObjectContext.fetch(fetchRequest).first
            
            if result != nil{
                print(#function, "Matching account found with email \(email)")
                
                let account = result as! Account
                return account
            }
        }catch let error{
            print(#function, error.localizedDescription)
        }
        
        print(#function, "No Account found with \(email)")
        return nil
    }
    
    func deactivateAccount(email: String){
        let accountToDelete = self.searchAccount(email: email)
        
        if accountToDelete != nil{
            do{
              //  to delete the record from database
             //  managedObjectContext.delete(accountToDelete!)
                
              //  updating the record
                accountToDelete?.is_active = false
                
                try managedObjectContext.save()
            }catch let error{
                print(#function, "Cannot delete account" ,error)
            }
        }
    }
    
    func updateAccount( emailAA: String, pass: String, dateModified: Date ){
        let email = UserDefaults.standard.value(forKey: "user_email") as! String
        
        let accountToUpdate = self.searchAccount(email: email)
        
        if accountToUpdate != nil{
            do{
                accountToUpdate!.email = emailAA
                accountToUpdate!.password = pass
                accountToUpdate!.date_modified = dateModified
                
                try managedObjectContext.save()
                print(#function, "account updates successfully")
            }catch let error{
                print(#function, "Unable to update account")
                print(#function, error)
            }
        }
    }
}
enum AccountStatus{
    case INSERT_SUCCESS
    case USER_EXISTS
    case INSERT_FAILURE
}
