//
//  ChooseCarTVC.swift
//  pinkslips
//
//  Created by Vince Reyes on 3/26/18.
//  Copyright © 2018 VinceReyes. All rights reserved.
//

import UIKit
import CoreData

class ChooseCarTVC: UIViewController, UITableViewDataSource, UITableViewDelegate, SprintListTVCDelegate {
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let managedObjectContent = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var cars = [Car]()
    
    @IBAction func addBtnP(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ChooseCarSegue", sender: nil)
    }
    
    @IBAction func unwindToChooseCar(segue:UIStoryboardSegue) { }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell", for: indexPath) as! CarCell
        if let photo = cars[indexPath.row].photo {
            cell.carImg.image = UIImage(data: photo)
        } else {
            cell.carImg.image = UIImage(named: "car-placeholder")
        }
        cell.carInfoLabel.text = cars[indexPath.row].make! + " " + cars[indexPath.row].model!
        cell.powerLbl.text = String(cars[indexPath.row].power) + " HP"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ChoseCarSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChoseCarSegue" {
                let destination = segue.destination as! UITabBarController
                let tabbar = destination.viewControllers![0] as! UINavigationController
                let sprintTVC = tabbar.topViewController as! SprintListTVC
                sprintTVC.delegate = self
                sprintTVC.indexPath = sender as? IndexPath
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchAllItems()
        // Do any additional setup after loading the view.
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
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
        do {
            let result = try managedObjectContent.fetch(request)
            let fetcheditems = result as! [Car]
            cars = fetcheditems
        } catch {
            print("\(error)")
        }
    }


}
