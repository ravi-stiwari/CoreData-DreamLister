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
    @IBOutlet weak var storePickerView: UIPickerView!
    
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        storePickerView.dataSource = self
        storePickerView.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        //generateStoreData()
        getStores()
        
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
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //let store = stores[row]
        //storeSelectLabel.text = store.name
        //Update label
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
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
    
    func getStores() {
        
        let storeFetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do {
            self.stores = try context.fetch(storeFetchRequest)
            self.storePickerView.reloadAllComponents()
        }
        catch {
            
        }
    }
    
    @IBAction func itemSavePressed(_ sender: Any) {
        
        var item: Item!
        
        let picture = Image(context: context)
        picture.image = itemImagePickerImageView.image
        
        if itemToEdit != nil {
            item = itemToEdit        }
        else {
            item = Item(context: context)
        }
        item.image = picture
        
        if let itemTitle = itemTitleTxtField.text {
            item.title = itemTitle
            
            if let itemPrice = itemPriceTxtField.text {
                item.price = (itemPrice as NSString).doubleValue
            }
            
            if let itemDetails = itemDetailsTxtField.text {
                item.details = itemDetails
            }
            
            item.store = stores[storePickerView.selectedRow(inComponent: 0)]
            
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
                        storePickerView.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                } while (index < stores.count)
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
