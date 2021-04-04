//
//  RegisterViewController.swift
//  Flash Chat iOS13
//


import UIKit
import Firebase
class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        //if pass and email not nil do auth process
        //authResult -> this object has auth data
        if let email = emailTextfield.text , let password = passwordTextfield.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    //show elert to user
                    print(e.localizedDescription)
                }else{
                    //if error = nil OR no error
                    //navigate to chatViewContoller
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
        
    }
    
}
