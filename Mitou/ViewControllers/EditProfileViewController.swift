//
//  EditProfileViewController.swift
//  Mitou
//
//  Created by Kelian Daste on 05/01/2018.
//  Copyright © 2018 Kelian Daste. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController {
    

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    let authController = AuthController.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func setProfile(_ sender: Any) {
        let ref: DatabaseReference = Database.database().reference()
        ref.child("Gamers").child(authController.myUID).child("lastName").setValue(lastNameTextField.text!)
        ref.child("Gamers").child(authController.myUID).child("firstName").setValue(firstNameTextField.text!) { (error, ref) in
            if error ==  nil {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
}
