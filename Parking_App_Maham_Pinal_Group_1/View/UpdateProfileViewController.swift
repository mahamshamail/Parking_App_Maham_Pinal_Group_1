//
//  UpdateProfileViewController.swift
//  Parking_App_Maham_Pinal_Group_1
//
//  Created by Maham Shamail on 21/01/2021.
//  Copyright © 2021 Maham Shamail. All rights reserved.
//

import UIKit

class UpdateProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    
    @IBOutlet weak var confirmNewPassword: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    @IBOutlet weak var carPlateNumber: UITextField!
    
    @IBOutlet weak var updateBtn: UIButton!
    
    @IBOutlet weak var DeleteBtn: UIButton!
    
     let userController = UserController()
     let accountController = AccountController()
    
    let emailAddress = UserDefaults.standard.value(forKey: "user_email") as! String
    
    var currentImage : UIImage!
    var imagePicker = UIImagePickerController()
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[ .editedImage ] as? UIImage else{ return  }
        dismiss(animated: true)
        currentImage = image
        profilePicture.image = currentImage
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateBtn.layer.cornerRadius = 5;
        self.DeleteBtn.layer.cornerRadius = 5;
        
        self.userController.getAllProfiles()
        self.loadInitialProfile()

    }
    
// how to make Open Photo Library button work:
    @IBAction func updateProfilePictureButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                   print("Button capture")

                   imagePicker.delegate = self
                   imagePicker.sourceType = .savedPhotosAlbum
                   imagePicker.allowsEditing = true

                   present(imagePicker, animated: true, completion: nil)
               }
       

    }
    
    @IBAction func updateProfileButton(_ sender: Any) {
        if (firstName.text != nil && lastName.text != nil && oldPassword.text != nil && carPlateNumber.text != nil && email.text != nil
        ){
            let fname = self.firstName.text!
            let lname = self.lastName.text!
            let oldPwd = self.oldPassword.text!
            let emailAdd = self.email.text!
            let newPwd = self.newPassword.text!
            let confirmNewPwd = self.confirmNewPassword.text!
            let contact = self.contactNumber.text!
            let car_plate = self.carPlateNumber.text!
            let profilePic = self.profilePicture.image!
            
//            if self.profilePicture.image != nil{
//
//
//            }
//
            if fname.count < 1 || lname.count < 1
            {
                let alert = UIAlertController(title: "Update Unsuccessful", message: "Enter valid first and last name. Try again!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                print(#function, "Enter valid first and last name.")
                return
            }
            
            if ( !self.email.text!.contains("@") || !self.email.text!.contains(".")){
                let alert = UIAlertController(title: "Update Unsuccessful", message: "Incorrect email. Try again!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                print(#function, "please enter a valid email address.")
                return
            }
            //check old password
            let currentAccount = self.accountController.searchAccount(email: emailAddress)
            if currentAccount != nil  {
                if oldPwd.count > 0 {
                    if oldPwd != currentAccount!.password {
                        let alert = UIAlertController(title: "Update Unsuccessful", message: "Incorrect password. Try again!", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                       print("incorrect password. could not save profile.")
                        return
                    }
                }else{
                    let alert = UIAlertController(title: "Update Unsuccessful", message: "Please enter current password.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    print("please enter your current password to update profile")
                    return
                }
            }
             
            //update password
                if ( newPwd.count > 0 && confirmNewPwd.count > 0){
                    if newPwd != confirmNewPwd { // new passwords dont match
                        let alert = UIAlertController(title: "Update Unsuccessful", message: "New passwords do not match. Try again!", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                       print("New passwords do not match. Could not save profile.")
                        return
                    }else{ //new passwords match
                        print("updating old password")
                        self.accountController.updateAccount(emailAA: emailAdd, pass: newPwd, dateModified: Date())
                        print("Updating emailAdd: \(emailAdd)")
                    }
            }else{
                print("emailAdd: \(emailAdd)")
                self.accountController.updateAccount(emailAA: emailAdd, pass: oldPwd, dateModified: Date())
            }
            //print("emailAdd: \(emailAdd)")
            self.accountController.updateAccount(emailAA: emailAdd, pass: oldPwd, dateModified: Date())
            
          
            // user : car_plate_no, contact_no, email, first_name, last_name, profile_pic, user_id
            self.userController.saveProfile(firstname: fname, lastname: lname, carplate: car_plate, contact: contact, emailA: emailAdd, profilePic: nil )
           
        }
    }
    @IBAction func deleteProfileButton(_ sender: Any) {
        let alert = UIAlertController(title: "Caution", message: "Are you sure want to deactivate the account?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Deactivate", style: .destructive, handler: {_ in
        
            let accountController = AccountController()
            accountController.deactivateAccount(email: self.emailAddress)
            
            UserDefaults.standard.removeObject(forKey: "user_email")
            
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    func loadInitialProfile(){
        let currentUser = self.userController.searchProfile(email: emailAddress)
        
        if currentUser != nil{
            self.firstName.text = currentUser!.first_name
            self.lastName.text = currentUser!.last_name
            self.email.text = currentUser!.email
            self.contactNumber.text = currentUser!.contact_no
            self.carPlateNumber.text = currentUser!.car_plate_no
        }
    }
}
