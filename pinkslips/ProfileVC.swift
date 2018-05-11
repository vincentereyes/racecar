//
//  ProfileVC.swift
//  pinkslips
//
//  Created by Vince Reyes on 3/30/18.
//  Copyright © 2018 VinceReyes. All rights reserved.
//

import UIKit
import CoreData

class ProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var carImg: UIImageView!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var modelLbl: UILabel!
    @IBOutlet weak var hpLbl: UILabel!
    @IBOutlet weak var modsLbl: UILabel!
    @IBOutlet weak var modsLbl2: UILabel!
    
    var img: UIImage?
    
    @IBAction func garageBtnP(_ sender: Any) {
        
    }
    
    
    @IBAction func addImage(_ sender: UIBarButtonItem) {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //save image persistently here
            car?.photo = UIImagePNGRepresentation(image)
            appDelegate.saveContext()
            self.dismiss(animated: true, completion: nil)
        } else {
            print("error")
        }
    }
    
    var car:Car?
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let managedObjectContent = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    var user = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchAllItems()
//        for u in user{
//            yearLbl.text = "Year: \(u.year!)"
//            makeLbl.text = "Make: \(u.make!)"
//            modelLbl.text = "Model: \(u.model!)"
//            hpLbl.text = "Horsepower: " + String(u.power)
//            weightLbl.text = "Weight: " + String(u.weight)
//            modsLbl.text = "Mods: \(u.mods!)"
//        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        yearLbl.text = (car?.year)! + " " + (car?.make)! + " " + (car?.model)!
        hpLbl.text = "HP: " + String(describing: car!.power) + " Weight: " + String(describing: car!.weight)
        modsLbl2.text = String(describing: car!.mods!)
        if let photo = car?.photo {
            carImg.image = UIImage(data: photo)
        } else {
            carImg.image = UIImage(named: "car-placeholder")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func fetchAllItems() {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
//        do {
//            let result = try managedObjectContent.fetch(request)
//            let fetcheditems = result as! [User]
//            user = fetcheditems
//        } catch {
//            print("\(error)")
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
