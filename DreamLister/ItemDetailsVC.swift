//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Ravi Tiwari on 3/13/17.
//  Copyright © 2017 SelfStudy. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var itemImagePickerImageView: UIImageView!
    @IBOutlet weak var itemTitleTxtField: CustomTextField!
    @IBOutlet weak var itemPriceTxtField: CustomTextField!
    @IBOutlet weak var itemDetailsTxtField: CustomTextField!
    @IBOutlet weak var storeSelectLabel: UILabel!
    @IBOutlet weak var itemTypeAndstorePickerView: UIPickerView!
    
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    var itemTypes = [ItemType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        itemTypeAndstorePickerView.dataSource = self
        itemTypeAndstorePickerView.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        //generateStoreData()
        //generateItemTypesData()
        getStores()
        getItemTypes()
        
        if itemToEdit != nil {
            loadItemData()
        }
    }
    
    @IBAction func itemImagePickerBtnPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            itemImagePickerImageView.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return itemTypes.count
        }
        else if component == 1 {
            return stores.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //let store = stores[row]
        //storeSelectLabel.text = store.name
        //Update label
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let itemType = itemTypes[row]
            return itemType.type
        }
        else if component == 1 {
            let store = stores[row]
            return store.name
        }
        return "Unknown Name"
    }
    
    func generateStoreData() {
        let store = Store(context: context)
        store.name = "Amazon"
        
        let store1 = Store(context: context)
        store1.name = "Flipkart"
        
        let store2 = Store(context: context)
        store2.name = "Snapdeal"
        
        let store3 = Store(context: context)
        store3.name = "Ebay"
        
        let store4 = Store(context: context)
        store4.name = "ShopClues"
        
        let store5 = Store(context: context)
        store5.name = "Others"
        
        ad.saveContext()
    }
    
    func generateItemTypesData() {
        let itemType = ItemType(context: context)
        itemType.type = "Electronics"
        
        let itemType1 = ItemType(context: context)
        itemType1.type = "Home Appliances"
        
        let itemType2 = ItemType(context: context)
        itemType2.type = "Daily Soaps"
        
        let itemType3 = ItemType(context: context)
        itemType3.type = "Goods"
        
        let itemType4 = ItemType(context: context)
        itemType4.type = "Skin care"
        
        let itemType5 = ItemType(context: context)
        itemType5.type = "Others"
        
        ad.saveContext()
    }
    
    func getItemTypes() {
        let itemTypeFetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        do {
            self.itemTypes = try context.fetch(itemTypeFetchRequest)
            self.itemTypeAndstorePickerView.reloadComponent(0)
        }
        catch {
            
        }
    }
    
    func getStores() {
        
        let storeFetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do {
            self.stores = try context.fetch(storeFetchRequest)
            self.itemTypeAndstorePickerView.reloadComponent(1)
        }
        catch {
            
        }
    }
    
    @IBAction func itemSavePressed(_ sender: Any) {
        
        var item: Item!
        
        if itemToEdit != nil {
            item = itemToEdit        }
        else {
            item = Item(context: context)
        }
        
        let picture = Image(context: context)
        picture.image = itemImagePickerImageView.image
        item.image = picture
        
        if let itemTitle = itemTitleTxtField.text {
            item.title = itemTitle
            
            if let itemPrice = itemPriceTxtField.text {
                item.price = (itemPrice as NSString).doubleValue
            }
            
            if let itemDetails = itemDetailsTxtField.text {
                item.details = itemDetails
            }
            
            item.store = stores[itemTypeAndstorePickerView.selectedRow(inComponent: 1)]
            item.itemType = itemTypes[itemTypeAndstorePickerView.selectedRow(inComponent: 0)]
            
            ad.saveContext()
            
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    func loadItemData() {
        if let item = itemToEdit {
            itemTitleTxtField.text = item.title
            itemPriceTxtField.text = "\(item.price)"
            itemDetailsTxtField.text = item.details
            itemImagePickerImageView.image = item.image?.image as? UIImage
            
            if let store = item.store {
                var index = 0
                repeat {
                    let currentStore = stores[index]
                    if currentStore.name == store.name {
                        itemTypeAndstorePickerView.selectRow(index, inComponent: 1, animated: false)
                        break
                    }
                    index += 1
                } while (index < stores.count)
            }
            
            if let itemType = item.itemType {
                var index = 0
                repeat {
                    let currentItemType = itemTypes[index]
                    if currentItemType.type == itemType.type {
                        itemTypeAndstorePickerView.selectRow(index, inComponent: 0, animated: false)
                    }
                    index += 1
                } while (index < itemTypes.count)
            }
        }
    }
    
    @IBAction func itemDeletePressed(_ sender: UIBarButtonItem) {
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        _ = navigationController?.popViewController(animated: true)
    }
}
