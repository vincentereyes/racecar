//
//  AccelTVC.swift
//  pinkslips
//
//  Created by Vince Reyes on 3/30/18.
//  Copyright © 2018 VinceReyes. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class AccelTVC: UITableViewController, MapVCDelegate {
    func doneBtnP() {
        dismiss(animated: true, completion: nil)
    }
    
    func saveLoc(sender: Int, location: CLLocationCoordinate2D) {
        return
    }
    
    @IBAction func GarageBtnP(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindFromAccel", sender: nil)
    }
    
    var accelerations = [Acceleration]()
    
    @IBAction func addBtnP(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showTimerVCSegue", sender: nil)
    }
    
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let managedObjectContent = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllItems()
        print(accelerations.count)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchAllItems()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Acceleration")
        do {
            let result = try managedObjectContent.fetch(request)
            let fetcheditems = result as! [Acceleration]
            accelerations = fetcheditems
        } catch {
            print("\(error)")
        }
    }
    

    // MARK: - Table view data source
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTimerVCSegue"{
            let destination = segue.destination as! TimerVC
            destination.delegate = self
        }
        else if segue.identifier == "AccelToMapSegue" {
            let destination = segue.destination as! MapVC
            if let ip = sender as? IndexPath {
                destination.startSpeed = Int(accelerations[ip.row].start)
                destination.endSpeed = Int(accelerations[ip.row].end)
                destination.timer_enabled = true
                destination.delegate = self
            }
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return accelerations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccelerationCell", for: indexPath)
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        cell.textLabel?.text = String(accelerations[indexPath.row].start) + " to " + String(accelerations[indexPath.row].end)
        cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        cell.detailTextLabel?.text = "⏱"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "AccelToMapSegue", sender: indexPath)
    }


}

extension AccelTVC: TimerVCDelegate {
    func saveAccelTime(start: String, end: String) {
        let item = NSEntityDescription.insertNewObject(forEntityName: "Acceleration", into: managedObjectContent) as! Acceleration
        item.start = Int16(start)!
        item.end = Int16(end)!
        dismiss(animated: true, completion: nil)
        appDelegate.saveContext()
        tableView.reloadData()
    }
    
    
}
