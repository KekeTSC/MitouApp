//
//  LoginViewController.swift
//  Mitou
//
//  Created by Kelian Daste on 04/01/2018.
//  Copyright © 2018 Kelian Daste. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signSelector: UISegmentedControl!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var signButton: UIButton!
    
    let authController = AuthController.sharedInstance
    
    var gameController: GameController? = nil
    
    var isSignIn = true
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameController = GameController.sharedInstance
        if self.authController.isThereCurrentUser() {
        self.ref.child("Gamers").child(self.authController.myUID).child("partnerUID").observe(DataEventType.value) { (snapshot) in
                if snapshot.value as! String != "" {
                    self.performSegue(withIdentifier: "Home", sender: self)
                } else {
                    self.performSegue(withIdentifier: "getPartner", sender: self)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignSelectorChanged(_ sender: UISegmentedControl) {
        
        isSignIn = !isSignIn
        
        if isSignIn {
            confirmPasswordTextField.isHidden = true
            signButton.setTitle("Se Connecter", for: .normal)
        } else {
            confirmPasswordTextField.isHidden = false
            signButton.setTitle("Créer un compte", for: .normal)
        }
    }
    
    @IBAction func callSignIn(_ sender: Any) {
        if isSignIn {
            
            if self.emailTextField.text == "" || self.passwordTextField.text == "" {
                
                //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
                
                let alertController = UIAlertController(title: "Erreur", message: "Veuillez l'email et le mot de passe", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                
                Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                    if self.authController.isThereCurrentUser() {
                        
                        //Print into the console if successfully logged in
                        print("You have successfully logged in")
                    self.ref.child("Gamers").child(self.authController.myUID).child("partnerUID").observe(DataEventType.value) { (snapshot) in
                            if snapshot.value as! String != "" {
                                self.performSegue(withIdentifier: "Home", sender: self)
                            } else {
                                self.performSegue(withIdentifier: "getPartner", sender: self)
                            }
                        }
                    } else {
                        
                        //Tells the user that there is an error and then gets firebase to tell them the error
                        let alertController = UIAlertController(title: "Erreur", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                })
            }
        } else {
            
            if self.emailTextField.text == "" || self.passwordTextField.text == "" || self.confirmPasswordTextField.text == "" {
                //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
                
                let alertController = UIAlertController(title: "Error", message: "Veuillez l'email et le mot de passe", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            } else if self.passwordTextField.text != self.confirmPasswordTextField.text {
                //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
                
                let alertController = UIAlertController(title: "Erreur", message: "Veuillez confirmer le mot de passe", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                    if self.authController.isThereCurrentUser() {
                        self.gameController!.createGamer()
                        //Print into the console if successfully logged in
                        print("You have successfully logged in")
                        self.performSegue(withIdentifier: "getPartner", sender: self)
                        
                    } else {
                        
                        //Tells the user that there is an error and then gets firebase to tell them the error
                        let alertController = UIAlertController(title: "Erreur", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.confirmPasswordTextField.resignFirstResponder()
    }
}
