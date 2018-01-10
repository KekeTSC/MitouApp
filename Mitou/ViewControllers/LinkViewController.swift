//
//  LinkViewController.swift
//  Mitou
//
//  Created by Kelian Daste on 05/01/2018.
//  Copyright © 2018 Kelian Daste. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LinkViewController: UIViewController {
    
    let authController = AuthController.sharedInstance
    let gameController = GameController.sharedInstance
    let ref: DatabaseReference = Database.database().reference()
    
    
    @IBOutlet weak var partnerUidLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref.child("Gamers").child(authController.myUID).child("partnerUID").observe(DataEventType.value) { (snapshot) in
            if snapshot.value as! String != "" {
                self.performSegue(withIdentifier: "GotoMain", sender: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareMyUid(_ sender: Any) {
        // text to share
        let text = "Deviens mon partenaire, mon code est: \(authController.myUID)"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func addButton(_ sender: Any) {
        ref.child("Gamers").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
        
            if snapshot.hasChild(self.partnerUidLabel.text!) {
            
                self.ref.child("Gamers").child(self.authController.myUID).child("partnerUID").setValue(self.partnerUidLabel.text!, withCompletionBlock: { (error, ref) in
                    if error == nil {
                        self.ref.child("Gamers").child(self.partnerUidLabel.text!).child("partnerUID").setValue(self.authController.myUID, withCompletionBlock: { (error, ref) in
                            if error == nil {
                                print("YEYEYEYEY")
                                self.performSegue(withIdentifier: "GotoMain", sender: self)
                            } else {
                                print(error!.localizedDescription)
                            }
                        })
                    } else {
                        print(error!.localizedDescription)
                    }
                })
            } else {
                let alertController = UIAlertController(title: "Erreur", message: "Votre partenaire n'existe pas :(", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "Réessayer", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    
}
