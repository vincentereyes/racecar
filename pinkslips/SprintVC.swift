//
//  SprintVC.swift
//  pinkslips
//
//  Created by Vince Reyes on 3/27/18.
//  Copyright © 2018 VinceReyes. All rights reserved.
//

import UIKit
import CoreLocation

protocol SprintVCDelegate: class {
    func addTrack(pointA: CLLocationCoordinate2D, pointB: CLLocationCoordinate2D, name: String)
}

class SprintVC: UIViewController, MapVCDelegate {
    

    weak var delegate:SprintVCDelegate?
    
    var startPt:CLLocationCoordinate2D?
    
    var endPt:CLLocationCoordinate2D?

    var count = 0
    var enableStart = false
    
    @IBOutlet weak var startPtBtn: UIButton!
    
    @IBOutlet weak var endPtBtn: UIButton!
    
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var check1Lbl: UILabel!
    
    @IBOutlet weak var check2Lbl: UILabel!
    
    @IBOutlet weak var flagLbl1: UILabel!
    
    @IBOutlet weak var flagLbl2: UILabel!
    
    @IBOutlet weak var nameTxtField: UITextField!
    
    
    @IBAction func startPtBtnP(_ sender: UIButton) {
        count += 1
        if count == 1 {
            endPtBtn.isEnabled = true
        }
        performSegue(withIdentifier: "StoMSegue", sender: sender)
    }
    
    @IBAction func endPtBtnP(_ sender: UIButton) {
        count += 1
        if count == 2 {
            startBtn.isEnabled = true
        }
        performSegue(withIdentifier: "StoMSegue", sender: sender)
    }
    
    @IBAction func startBtnP(_ sender: UIButton) {
        delegate?.addTrack(pointA: startPt!, pointB: endPt!, name: nameTxtField.text!)
        performSegue(withIdentifier: "unwindToSpringTVCSegue", sender: nil)
//        performSegue(withIdentifier: "StoMSegue", sender: sender)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StoMSegue" {
            let destination = segue.destination as! MapVC
            destination.delegate = self
            if let btn = sender as? UIButton {
                destination.tag = btn.tag
                if btn.tag == 1 {
                    destination.dropPin = true
                }
                else if btn.tag == 2 {
                    destination.dropPin = true
                    destination.startPin = startPt
                }
                if btn.tag == 3 {
                    destination.dropPin = false
                    destination.startPin = startPt
                    destination.endPin = endPt
                    destination.tmeatk = true
                }
            }
        }
    }
    

    func doneBtnP() {
        dismiss(animated: true, completion: nil)
        viewDidLoad()
    }
    
    func saveLoc(sender: Int, location: CLLocationCoordinate2D) {
        if sender == 1 {
            check1Lbl.isHidden = false
            startPt = location
        }
        else {
            check2Lbl.isHidden = false
            flagLbl1.isHidden = false
            flagLbl2.isHidden = false
            endPt = location
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        count = 0
        enableStart = false
        startPtBtn.layer.cornerRadius = 5
        startPtBtn.clipsToBounds = true
        endPtBtn.layer.cornerRadius = 5
        endPtBtn.clipsToBounds = true
        endPtBtn.isEnabled = false
        startBtn.layer.cornerRadius = 5
        startBtn.clipsToBounds = true
        startBtn.isEnabled = false
        check1Lbl.isHidden = true
        check2Lbl.isHidden = true
        flagLbl1.isHidden = true
        flagLbl2.isHidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

}
