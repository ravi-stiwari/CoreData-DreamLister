//
//  MainVC.swift
//  DreamLister
//
//  Created by Ravi Tiwari on 3/12/17.
//  Copyright © 2017 SelfStudy. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var itemTableView: UITableView!
    
    var itemNSFetchedResultsController: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTableView.delegate = self
        itemTableView.dataSource = self
        attemptToFetch()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCell = itemTableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(itemCell: itemCell, indexPath: indexPath as NSIndexPath)
        return itemCell
    }
    
    func configureCell(itemCell: ItemCell, indexPath: NSIndexPath) {
        let item = itemNSFetchedResultsController.object(at: indexPath as IndexPath)
        itemCell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = itemNSFetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let obj = itemNSFetchedResultsController.fetchedObjects, obj.count > 0 {
            let item = obj[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = itemNSFetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func attemptToFetch() {
        let itemFetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        let itemTypeSort = NSSortDescriptor(key: "itemType", ascending: true)
        
        let segmentSelectedIndex = segment.selectedSegmentIndex
        if segmentSelectedIndex == 0 {
            itemFetchRequest.sortDescriptors = [dateSort]
        }
        else if segmentSelectedIndex == 1 {
            itemFetchRequest.sortDescriptors = [priceSort]
        }
        else if segmentSelectedIndex == 2 {
            itemFetchRequest.sortDescriptors = [titleSort]
        }
        else if segmentSelectedIndex == 3 {
            itemFetchRequest.sortDescriptors = [itemTypeSort]
        }
        
        itemNSFetchedResultsController = NSFetchedResultsController(fetchRequest: itemFetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        itemNSFetchedResultsController.delegate = self
        do {
            try itemNSFetchedResultsController.performFetch()
        }
        catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        itemTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        itemTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
        case.insert:
            if let indexPath = newIndexPath {
                itemTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                itemTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let itemCell = itemTableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(itemCell: itemCell, indexPath: indexPath as NSIndexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                itemTableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                itemTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        attemptToFetch()
        itemTableView.reloadData()
    }
    
    func generateTestData() {
        let item = Item(context: context)
        item.title = "MacBook Pro"
        item.price = 18000
        item.details = "I can't wait until I will buy my new Macbook Pro"
        
        let item1 = Item(context: context)
        item1.title = "Bose Headphones"
        item1.price = 17000
        item1.details = "I can't wait until I will buy my new Headphones"
        
        let item2 = Item(context: context)
        item2.title = "Tesla Model S"
        item2.price = 28000
        item2.details = "Want to buy this car"
        
        ad.saveContext()
    }
    
}

