//
//  ViewController.swift
//  Parking_App_Maham_Pinal_Group_1
//
//  Created by Maham Shamail on 19/01/2021.
//  Copyright © 2021 Maham Shamail. All rights reserved.
//

/*
 
 To do
 */

import UIKit

class SignInViewController: UIViewController {
    @IBOutlet weak var signInBtn: UIButton!
    
    @IBOutlet weak var createAccBtn: UIButton!
    @IBOutlet weak var email: UITextField!
   
    let accountController = AccountController()
    let users = UserController()
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signInBtn.layer.cornerRadius = 5;
        self.createAccBtn.layer.cornerRadius = 5;
        accountController.getAllAccounts()
        users.getAllProfiles()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signIn(_ sender: Any) {
        print(#function, "Sign in clicked")
        if (email.text != nil && password.text != nil){
            if (self.accountController.validateAccount(email: email.text!, password: password.text!)){
                print(#function, "Login successful")
                self.loginSuccessful()
                
            }else{
                let alert = UIAlertController(title: "Login Unsuccessful", message: "Incorrect email and/or password. Try again!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func createNewAccount(_ sender: Any) {
    }
    func loginSuccessful(){
        UserDefaults.standard.setValue(email.text!, forKey: "user_email")
        

        let alert = UIAlertController(title: "Login successful", message: "You have successfully logged in.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "default action"), style: .default, handler: {_ in
            print(#function, "Navigating to the home screen")
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let tabContainer = storyboard.instantiateViewController(withIdentifier: "TabContainer")
            
            tabContainer.navigationItem.hidesBackButton = true
            tabContainer.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SignOut", style: .plain, target: self, action: #selector(self.signout))
            
            self.navigationController?.pushViewController(tabContainer, animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    func signout(){

        
        
        let alert = UIAlertController(title: "Caution", message: "Are you sure want to sign out of your account?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: {_ in
        
           // let accountController = AccountController()
          //  accountController.deactivateAccount(email: self.emailAddress)
            
            //UserDefaults.standard.removeObject(forKey: "user_email")
            
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
}
