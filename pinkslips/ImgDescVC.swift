//
//  ImgDescVC.swift
//  pinkslips
//
//  Created by Vince Reyes on 3/26/18.
//  Copyright © 2018 VinceReyes. All rights reserved.
//

import UIKit
import CoreData

protocol ImgDescDelegate:class {

}

class ImgDescVC: UIViewController, UITextFieldDelegate {
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let managedObjectContent = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var hpTxtField: UITextField!
    
    @IBOutlet weak var weightTxtField: UITextField!
    
    @IBOutlet weak var modsTxtView: UITextView!
    
    var year:String?
    var make:String?
    var model:String?
    
    var delegate:ImgDescDelegate?
    
    @IBAction func saveBtnP(_ sender: UIButton) {
        let item = NSEntityDescription.insertNewObject(forEntityName: "Car", into: managedObjectContent) as! Car
        item.year = year!
        item.make = make!
        item.model = model!
        item.power = Int16(hpTxtField.text!)!
        item.weight = Int16(weightTxtField.text!)!
        item.mods = modsTxtView.text!
        appDelegate.saveContext()
        performSegue(withIdentifier: "unwindToChooseCar", sender: nil)
    }
    
    @IBOutlet weak var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBtn.layer.cornerRadius = 5
        saveBtn.clipsToBounds = true
        
        modsTxtView.layer.cornerRadius = 5
        modsTxtView.clipsToBounds = true
        
        hpTxtField.delegate = self
        weightTxtField.delegate = self
        
        // Do any additional setup after loading the view.
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text as! NSString).replacingCharacters(in: range, with: string)
        if let intVal = Int(text) {
            // Text field converted to an Int
            saveBtn.isEnabled = true
        } else {
            // Text field is not an Int
            saveBtn.isEnabled = false
        }
        
        // Return true so the text field will be changed
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
