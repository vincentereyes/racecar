//
//  EditProfileVC.swift
//  pinkslips
//
//  Created by Vince Reyes on 3/26/18.
//  Copyright © 2018 VinceReyes. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class AddCarVC: UIViewController, ImgDescDelegate {
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let managedObjectContent = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var audioPlayer:AVAudioPlayer!
    
    var items = [Any]()
    var item:String?
    
//    var user = [User]()
    
    var current = "year"
    var year = 0
    var make = ""
    var model = ""
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var chooseLbl: UILabel!
    
    @IBOutlet weak var yearLbl: UILabel!
    
    @IBOutlet weak var makeLbl: UILabel!
    
    @IBOutlet weak var modelLbl: UILabel!
    
    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet weak var resetBtn: UIButton!
    
    @IBAction func resetBtnP(_ sender: UIButton) {
        viewDidLoad()
    }
    
    
    @IBAction func selectBtnP(_ sender: UIButton) {
        if sender.titleLabel?.text == "confirm" {
            let url = Bundle.main.url(forResource: "carstart", withExtension: "mp3")
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url!)
                audioPlayer.prepareToPlay()
            } catch let error as NSError {
                print(error.debugDescription)
            }
            audioPlayer.play()
            performSegue(withIdentifier: "addInfoSegue", sender: nil)
        }
        else {
            if current == "year" {
                yearLbl?.text = item!
                yearLbl.isHidden = false
                year = Int(item!)!
                picker.isHidden = true
                car(cheese: "https://www.carqueryapi.com/api/0.3/?&cmd=getMakes&year=\(year)")
                current = "make"
                chooseLbl?.text = "choose make"
            }
            else if current == "make" {
                makeLbl?.text = item!
                makeLbl.isHidden = false
                make = item!
                let urlMake = make.replacingOccurrences(of: " ", with: "-")
                items = []
                picker.isHidden = true
                car(cheese: "https://www.carqueryapi.com/api/0.3/?&cmd=getModels&make=\(urlMake)&year=\(year)")
                current = "model"
                chooseLbl?.text = "choose model"
            }
            else {
                modelLbl?.text = item!
                modelLbl.isHidden = false
                model = item!
                selectBtn.setTitle("confirm", for: .normal)
            }
        }
    }
    
    func car(cheese: String){
        var minyear = 0
        var maxyear = 0
        var allmakes:[[String:Any]] = []
        let url = URL(string: cheese)
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {
            data, response, error in
            do {

                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options:
                    JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if self.current == "year" {
                        if let years = jsonResult["Years"] as? NSDictionary{
                            
                            if let max = years["max_year"] as? String{
                                maxyear = Int(max)!
                            }
                            if let min = years["min_year"] as? String{
                                minyear = Int(min)!
                            }
                        }
                    }
                    if self.current == "make" {
                        for (_, value) in jsonResult {
                            if let makes = value as? [[String:Any]] {
                                allmakes = makes
                            }
                        }
                    }
                    else {
                        for (_, value) in jsonResult {
                            if let models = value as? [[String:Any]] {
                                var allmodels:[Any] = []
                                for model in models {
                                    if let modelname = model["model_name"]{
                                        allmodels.append(modelname)
                                    }
                                }
                                self.items = allmodels
                                self.item = String(describing: self.items[0])
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        if self.current == "year"{
                            for i in stride(from: maxyear, to: minyear, by: -1) {
                                self.items.append(i)
                                
                            }
                            self.item = String(describing: self.items[0])
                        }
                        else if self.current == "make"{
                            var finalMakes = [Any]()
                            for i in 0..<allmakes.count{
                                let dict = allmakes[i] as NSDictionary
                                if let make = dict["make_display"] as? String {
                                    finalMakes.append(make)
                                }
                            }
                            self.items = finalMakes
                            self.item = String(describing: self.items[0])
                        }
                        self.picker.isHidden = false
                        self.picker.reloadAllComponents()
                        self.picker.selectRow(0, inComponent: 0, animated: true)
                    }
                }
            } catch {
                print(error)
            }
        })
        task.resume()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        yearLbl.isHidden = true
        makeLbl.isHidden = true
        modelLbl.isHidden = true
        selectBtn.setTitle("select", for: .normal)
        selectBtn.layer.cornerRadius = 5
        selectBtn.clipsToBounds = true
        resetBtn.layer.cornerRadius = 5
        selectBtn.clipsToBounds = true
        current = "year"
        items = []
        chooseLbl?.text = "choose year"
        car(cheese: "https://www.carqueryapi.com/api/0.3/?&cmd=getYears")
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        fetchAllItems()
//        if user.count > 0 {
//            print("user exists")
//            performSegue(withIdentifier: "userExistsSegue", sender: nil)
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier != "userExistsSegue"{
            let destination = segue.destination as! ImgDescVC
            destination.delegate = self
            destination.year = String(year)
            destination.make = make
            destination.model = model
        } else {
            print("userExistsSegue")
        }
        
    }

}

extension AddCarVC: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: items[row])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        item = String(describing: items[row])
    }
    

}

