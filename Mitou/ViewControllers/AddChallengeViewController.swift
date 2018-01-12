//
//  AddChallengeViewController.swift
//  Mitou
//
//  Created by Kelian Daste on 11/01/2018.
//  Copyright © 2018 Kelian Daste. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class AddChallengeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var challengeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var inputCategorie: UITextField!
    
    let listOfCategories = ["Selectionner une catégorie", "Normal", "Avancé", "Extreme", "Hot"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        inputCategorie.inputView = pickerView
        
        // Do any additional setup after loading the view.
    }
    @IBAction func addChallenge(_ sender: Any) {
        if challengeTextField.text!.isEmpty {
            
            let alertController = UIAlertController(title: "Erreur", message: "Veuillez remplir le défi", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        } else if locationTextField.text!.isEmpty {
            
            let alertController = UIAlertController(title: "Erreur", message: "Veuillez remplir le lieu du défi", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        } else if inputCategorie.text!.isEmpty {
            
            let alertController = UIAlertController(title: "Erreur", message: "Veuillez donner la catégorie du défi", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            let hud = JGProgressHUD(style: .dark)
            hud.show(in: self.view)
            let ref: DatabaseReference = Database.database().reference()
            let id = ref.child("Challenges").childByAutoId().key
            ref.child("Challenges").child(id).setValue(["challenge": challengeTextField.text!,               "location": locationTextField.text!, "categorie": inputCategorie.text!, "id": id]) { (error, ref) in
                if error == nil {
                    UIView.animate(withDuration: 0.1, animations: {
                        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    })
                    hud.dismiss()
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Erreur", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    @IBAction func cancelAdd(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listOfCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listOfCategories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row > 0 {
            inputCategorie.text = listOfCategories[row]
        } else {
            inputCategorie.text = ""
        }
    }
}
