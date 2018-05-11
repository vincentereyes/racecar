//
//  MapVC.swift
//  pinkslips
//
//  Created by Vince Reyes on 3/27/18.
//  Copyright © 2018 VinceReyes. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData


protocol MapVCDelegate: class {
    func doneBtnP()
    func saveLoc(sender: Int, location: CLLocationCoordinate2D)
}
protocol MapVCfromInfoDelegate: class {
    
}
class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    let managedObjectContent = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    weak var delegate:MapVCDelegate?
    
    weak var trackdelegate:MapVCfromInfoDelegate?
    
    var tag: Int?
    
    var startSpeed: Int?
    
    var endSpeed: Int?
    
    var startPin:CLLocationCoordinate2D?
    
    var endPin:CLLocationCoordinate2D?
    
    var car:Car?
    
    var track:Track?

    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var speedLbl: UILabel!
    
    @IBOutlet weak var setPtLbl: UILabel!
    
    @IBOutlet weak var doneBtn: UIButton!
    
    
    let manager = CLLocationManager()
    
    var time = 0.0
    var timer = Timer()
    var status = false
    var timer_enabled = false
    var tmeatk = false
    
    var markedLocation: CLLocationCoordinate2D?
    
    var dropPin = false
    
    var zoomed = false
    
    var finished = false
    
    @IBAction func start(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(MapVC.updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime(){
        time += 0.1
        timeLbl.text = "time: " + String(format: "%.1f", time)
    }
    
    @IBAction func doneBtnP(_ sender: Int) {
        if tag != nil{
            if markedLocation != nil {
                delegate?.saveLoc(sender: tag!, location: markedLocation!)
            }
            if tag == 3 {
                delegate?.doneBtnP()
            }
        }
        else {
            delegate?.doneBtnP()
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func longP(_ sender: UILongPressGestureRecognizer) {
        if (tag == 1 || tag == 2) &&  dropPin == true{
            let pressPoint = sender.location(in: map)
            let pressCoordinate = map.convert(pressPoint, toCoordinateFrom: map)
            markedLocation = pressCoordinate
            let pressPin = MKPointAnnotation()
            pressPin.coordinate = pressCoordinate
            map.addAnnotation(pressPin)
            dropPin = false
        }
    }
    
    func loadPins(){
        if startPin != nil {
            let coordinate = startPin
            let pin = MKPointAnnotation()
            pin.coordinate = coordinate!
            pin.title = "🚦"
            map.addAnnotation(pin)
            
        }
        
        if endPin != nil {
            let coordinate2 = endPin
            let pin = MKPointAnnotation()
            pin.coordinate = coordinate2!
            pin.title = "🏁"
            map.addAnnotation(pin)
            let directionRequest = MKDirectionsRequest()
            let start = MKPlacemark(coordinate: startPin!, addressDictionary: nil)
            let end = MKPlacemark(coordinate: endPin!, addressDictionary: nil)
            directionRequest.source = MKMapItem(placemark: start)
            directionRequest.destination = MKMapItem(placemark: end)
            directionRequest.transportType = .automobile
            
            let directions = MKDirections(request: directionRequest)
            directions.calculate { (directionsResponse, error) in
                guard let directionsResponse = directionsResponse else {
                    if let error = error {
                        print("error getting directions: \(error.localizedDescription)")
                    }
                    return
                }
                let route = directionsResponse.routes[0]
                self.map.add(route.polyline, level: .aboveRoads)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        var span:MKCoordinateSpan
        if tmeatk == true {
            span =  MKCoordinateSpanMake(0.001, 0.001)
        }
        else{
           span =  MKCoordinateSpanMake(0.01, 0.01)
        }
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.zoomed == false{
                print("ran")
                self.map.setRegion(region, animated: true)
//                self.zoomed = true
            }
//        }
        
        
        if tag != nil {
            if tag == 1 || tag == 2 {
               manager.delegate = nil
            }
        }
        
        //Speed Timer Function
        if timer_enabled == true {
            if status == false && (location.speed *  2.23693629) > Double(startSpeed!) {
                start()
                status = true
            }
            if (location.speed *  2.23693629) > Double(endSpeed!) {
                timer.invalidate()
            }
        }
        //End Speed Time Function
        if tmeatk == true {
            //        for hitting point a and point b
            if ((myLocation.latitude < (startPin!.latitude + 0.000150)) && (myLocation.latitude > (startPin!.latitude - 0.000150))) && ((myLocation.longitude > (startPin!.longitude - 0.000150)) && (myLocation.longitude < (startPin!.longitude + 0.000150))){
                if status == false{
                    start()
                    status = true
                    
                }
                for annotation in map.annotations {
                    if annotation.title!! == "🏁"{
                        map.selectAnnotation(annotation, animated: true)
                    }
                }
                
            }
            //reaches point b
            if ((myLocation.latitude < (endPin!.latitude + 0.000150)) && (myLocation.latitude > (endPin!.latitude - 0.000150))) && ((myLocation.longitude > (endPin!.longitude - 0.000150)) && (myLocation.longitude < (endPin!.longitude + 0.000150))){
                
                if finished == false {
                    timer.invalidate()
                    addTime(time: timeLbl.text!)
                    let alert = UIAlertController(title: "Time Attack Done", message: "\(timeLbl.text!)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {(alert: UIAlertAction!) in
                        self.delegate?.doneBtnP()
                    }))
                    self.present(alert, animated: true)
                    finished = true
                }
                
            }
        }
        
        speedLbl.text = "speed: " + String(format: "%.2f", location.speed * 2.23693629) + " mph"
        self.map.showsUserLocation = true
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        let color = UIColor(red: 57.0/255, green: 103.0/255, blue: 83.0/255, alpha: 1)
        renderer.strokeColor = color
        renderer.lineWidth = 4.0
        return renderer
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        custom annotation shit
//    }
    func addTime(time: String) {
        let item = NSEntityDescription.insertNewObject(forEntityName: "Time", into: managedObjectContent) as! Time
        item.date = Date()
        item.timeInSeconds = time
        item.car = (car?.make)! + " " + (car?.model)!
        item.track = track!
        appDelegate.saveContext()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        map.camera.heading = newHeading.magneticHeading
        map.setCamera(map.camera, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if tag != nil {
            if tag == 1 {
                setPtLbl.isHidden = false
                timeLbl.isHidden = true
                speedLbl.isHidden = true
                setPtLbl.text = "setting start pt"
            }
            else if tag == 2 {
                setPtLbl.isHidden = false
                timeLbl.isHidden = true
                speedLbl.isHidden = true
                setPtLbl.text = "setting end pt"
            }
            else {
                setPtLbl.isHidden = true
            }
        }
        else {
            setPtLbl.isHidden = true
        }
        setPtLbl.layer.cornerRadius = 5
        setPtLbl.clipsToBounds = true
        timeLbl.layer.cornerRadius = 5
        timeLbl.clipsToBounds = true
        speedLbl.layer.cornerRadius = 5
        speedLbl.clipsToBounds = true
        doneBtn.layer.cornerRadius = 5
        doneBtn.clipsToBounds = true
        loadPins()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
        if (tmeatk == true || timer_enabled == true){
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.zoomed = true
                self.map.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
            }
        }
        
        
        self.map.delegate = self
        if map.annotations.count > 0 {
            for annotation in map.annotations {
                if annotation.title!! == "🚦"{
                    map.selectAnnotation(annotation, animated: true)
                }
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
