//
//  TimerVC.swift
//  pinkslips
//
//  Created by Vince Reyes on 3/27/18.
//  Copyright © 2018 VinceReyes. All rights reserved.
//

import UIKit
import CoreLocation

protocol TimerVCDelegate: class {
    func saveAccelTime(start: String, end: String)
}

class TimerVC: UIViewController, MapVCDelegate, UITextFieldDelegate {
    
    //DO TEXT FIELD VALIDATIONS

    @IBOutlet weak var startTxtF: UITextField!
    
    @IBOutlet weak var endTxtF: UITextField!
    
    @IBOutlet weak var startBtn: UIButton!
    
    weak var delegate: TimerVCDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func startBtnP(_ sender: UIButton) {
//        performSegue(withIdentifier: "TtoMSegue", sender: nil)
        delegate?.saveAccelTime(start: startTxtF.text!, end: endTxtF.text!)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! MapVC
        destination.startSpeed = Int(startTxtF.text!)
        destination.endSpeed = Int(endTxtF.text!)
        destination.timer_enabled = true
        destination.delegate = self
    }
    
    func doneBtnP() {
        dismiss(animated: true, completion: nil)
    }
    
    func saveLoc(sender: Int, location: CLLocationCoordinate2D
        ) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startBtn.layer.cornerRadius = 5
        startBtn.clipsToBounds = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

}
