//
//  SprintListTVC.swift
//  pinkslips
//
//  Created by Vince Reyes on 3/30/18.
//  Copyright © 2018 VinceReyes. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

protocol SprintListTVCDelegate: class {
}

class SprintListTVC: UITableViewController, SprintVCDelegate, TrackInfoDelegate, UITabBarControllerDelegate {
    
    var tracks = [Track]()
    var car:Car?
    
    var indexPath:IndexPath?
    
    weak var delegate: SprintListTVCDelegate?
    
    @IBAction func CarsListBtn(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindFromSprint", sender: nil)
    }
    
    @IBAction func unwindToSpintTVC(segue:UIStoryboardSegue) { }
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let managedObjectContent = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addTrack(pointA: CLLocationCoordinate2D, pointB: CLLocationCoordinate2D, name: String) {
        let item = NSEntityDescription.insertNewObject(forEntityName: "Track", into: managedObjectContent) as! Track
        item.name = name
        item.pointALat = pointA.latitude
        item.pointALong = pointA.longitude
        item.pointBLat = pointB.latitude
        item.pointBLong = pointB.longitude
        appDelegate.saveContext()
        tableView.reloadData()
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllItems()
        fetchCar()
        self.tabBarController?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchAllItems()
        fetchCar()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let vc = viewController as? UINavigationController{
            if let profile = vc.topViewController as? ProfileVC {
                profile.car = car
            }
        }

    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTrackSegue" {
            let destination = segue.destination as! SprintVC
            destination.delegate = self
        }
        if segue.identifier == "showTrackSegue" {
            let ip = sender as? IndexPath
            let destination = segue.destination as! TrackInfoVC
            destination.delegate = self
            destination.startPtLat = tracks[(ip?.row)!].pointALat
            destination.startPtLong = tracks[(ip?.row)!].pointALong
            destination.endPtLat = tracks[(ip?.row)!].pointBLat
            destination.endPtLong = tracks[(ip?.row)!].pointBLong
            destination.car = car
            destination.track = tracks[(ip?.row)!]
        }
        
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath)
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        cell.textLabel?.text = tracks[indexPath.row].name!
        cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        cell.detailTextLabel?.text = "🏎💨"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTrackSegue", sender: indexPath)
    }
    
    func fetchAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Track")
        do {
            let result = try managedObjectContent.fetch(request)
            let fetcheditems = result as! [Track]
            tracks = fetcheditems
        } catch {
            print("\(error)")
        }
    }
    func fetchCar() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
        do {
            let result = try managedObjectContent.fetch(request)
            let fetcheditems = result as! [Car]
            car = fetcheditems[(indexPath?.row)!]
        } catch {
            print("\(error)")
        }
    }
    
    

}
