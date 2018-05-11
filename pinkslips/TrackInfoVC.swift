//
//  TrackInfoVC.swift
//  pinkslips
//
//  Created by Vince Reyes on 4/4/18.
//  Copyright © 2018 VinceReyes. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

protocol TrackInfoDelegate: class{
}


class TrackInfoVC: UIViewController, MKMapViewDelegate,MapVCfromInfoDelegate  {
    
    var delegate: TrackInfoDelegate?
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func startBtnP(_ sender: UIButton) {
        performSegue(withIdentifier: "trackInfoToMapSegue", sender: nil)
    }
    
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var distanceLbl: UILabel!
    
    var startPtLat:Double?
    var startPtLong:Double?
    var endPtLat:Double?
    var endPtLong:Double?
    var car:Car?
    var track: Track?
    var times = [Time]()
    
    
    var coordinate:CLLocationCoordinate2D?
    var coordinate2:CLLocationCoordinate2D?
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let managedObjectContent = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func loadPins() {
        coordinate = CLLocationCoordinate2DMake(startPtLat!, startPtLong!)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate!
        pin.title = "🚦"
        map.addAnnotation(pin)
        
        coordinate2 = CLLocationCoordinate2DMake(endPtLat!, endPtLong!)
        let pin2 = MKPointAnnotation()
        pin2.coordinate = coordinate2!
        pin2.title = "🏁"
        map.addAnnotation(pin2)
        
        let directionRequest = MKDirectionsRequest()
        let start = MKPlacemark(coordinate: coordinate!, addressDictionary: nil)
        let end = MKPlacemark(coordinate: coordinate2!, addressDictionary: nil)
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
            self.distanceLbl.text = " \(route.distance / 1000) km "
            self.map.add(route.polyline, level: .aboveRoads)
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        let color = UIColor(red: 57.0/255, green: 103.0/255, blue: 83.0/255, alpha: 1)
        renderer.strokeColor = color
        renderer.lineWidth = 4.0
        return renderer
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! MapVC
        destination.trackdelegate = self
        destination.startPin = coordinate!
        destination.endPin = coordinate2!
        destination.dropPin = false
        destination.tmeatk = true
        destination.car = car
        destination.track = track
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTimes()
        tableView.delegate = self
        tableView.dataSource = self
        startBtn.layer.cornerRadius = 5
        startBtn.clipsToBounds = true
        distanceLbl.layer.cornerRadius = 5
        distanceLbl.clipsToBounds = true
        self.map.delegate = self
        loadPins()
        self.map.showAnnotations(self.map.annotations, animated: true)
        self.title = track!.name
        // Do any additional setup after loading the view.
    }
    
    func fetchTimes() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Time")
        request.predicate = NSPredicate(format: "track == %@", track!)
        do {
            let result = try managedObjectContent.fetch(request)
            self.times = result as! [Time]
        } catch {
            print("\(error)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchTimes()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension TrackInfoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TrackTimeCell
        cell.carLbl.text = times[indexPath.row].car!
        cell.dateLbl.text = dateFormatter.string(from: times[indexPath.row].date!)
        cell.timeLbl.text = times[indexPath.row].timeInSeconds
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
}

