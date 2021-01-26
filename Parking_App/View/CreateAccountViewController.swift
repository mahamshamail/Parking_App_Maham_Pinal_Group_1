//
//  CreateAccountViewController.swift
//  Parking_App
//
//  Created by Maham Shamail on 26/01/2021.
//

import UIKit

class CreateAccountViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    @IBOutlet weak var carPlateNumber: UITextField!
    @IBOutlet weak var createAccount: UIButton!
    
    let accountController = AccountController()
   
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
        self.createAccount.layer.cornerRadius = 5;
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func createMyAccountButton(_ sender: Any) {
        //add data validation for inputs and check for empty fields
       //print(self.firstName.text)
        guard let pwd = self.password.text else{
            print(#function, "please enter password")
            let alert = UIAlertController(title: "Account Creation Unsuccessful", message: "Please enter a password.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard let confirmPwd = self.confirmPassword.text else{
            let alert = UIAlertController(title: "Account Creation Unsuccessful", message: "Please confirm your password.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            print(#function, "please confirm password")

            return
        }
        
        guard let firstname = self.firstName.text else{
            let alert = UIAlertController(title: "Account Creation Unsuccessful", message: "Please enter a first name.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            print(#function, "please enter first name")

            return
        }
        
        guard let lastname = self.lastName.text else{
            print(#function, "please enter last name")
            let alert = UIAlertController(title: "Account Creation Unsuccessful", message: "Please enter a last name.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard let carplate = self.carPlateNumber.text else{
            print(#function, "please enter car plate number")
            let alert = UIAlertController(title: "Account Creation Unsuccessful", message: "Please enter a car plate number.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        if (  self.email.text!.count < 1  ){
            print(#function, "please complete the form, enter email.")
            let alert = UIAlertController(title: "Account Creation Unsuccessful", message: "Please enter an email address.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        if ( !self.email.text!.contains("@") || !self.email.text!.contains(".")){
            print(#function, "please enter a valid email.")
            let alert = UIAlertController(title: "Account Creation Unsuccessful", message: "Please enter a valid email address.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        if (  pwd.count < 1 || confirmPwd.count < 1 ){
            print(#function, "please complete the form, enter password.")
            let alert = UIAlertController(title: "Account Creation Unsuccessful", message: "Please complete password fields.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        if (  firstname.count < 1 || lastname.count < 1 ){
            let alert = UIAlertController(title: "Account Creation Unsuccessful", message: "Please enter a valid first and last name.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            print(#function, "please enter a valid name")
            return
        }
        if (  carplate.count < 2 || carplate.count  > 8 ){
            let alert = UIAlertController(title: "Account Creation Unsuccessful", message: "Please enter a valid car plate number, min length = 2 and max length = 8.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            print(#function, "please enter a valid car plate number")
            return
        }
      
        
        if (pwd == confirmPwd){
            let emailAdd = self.email.text ?? "unknown"
            
            let insertionStatus = self.accountController.insertAccount(email: emailAdd, password: pwd, firstName: firstname, lastName: lastname, contact: self.contactNumber.text, carPlate: carplate, profilePic: nil)
            
            switch insertionStatus {
            case .INSERT_SUCCESS:
                print(#function, "account created")
                self.navigationController?.popViewController(animated: true)
            case .USER_EXISTS:
                //exercise: show an alert and provide the options to recover password or activate account
                print(#function, "User with same email already exists")
            case .INSERT_FAILURE:
                print(#function, "Somethign went wrong. Sorry for inconvenience")
            }
        }else{
            print(#function, "both passwords must be same.")
            let alert = UIAlertController(title: "Account Creation Unsuccessful", message: "Both passwords must match.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func addProfilePictureButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                   print("Button capture")

                   imagePicker.delegate = self
                   imagePicker.sourceType = .savedPhotosAlbum
                   imagePicker.allowsEditing = true

                   present(imagePicker, animated: true, completion: nil)
               }
    }
    
    
}
