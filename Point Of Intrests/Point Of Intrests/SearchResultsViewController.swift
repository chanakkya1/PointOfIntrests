//
//  SearchResultsViewController.swift
//  Point Of Intrests
//
//  Created by chanakkya mati on 7/30/17.
//  Copyright © 2017 HimaTej. All rights reserved.
//

import UIKit
import CoreData
class SearchResultsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    var citiesList:[City] = []
    let cityPickerView = UIPickerView()
    var dataSource :[PointOfIntrest] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70;
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolBar.backgroundColor = UIColor.lightGray
        let barButtonItem = UIBarButtonItem(title: "DONE", style: UIBarButtonItemStyle.done, target: self, action: #selector(SearchResultsViewController.dismissPickerView))
        toolBar.items = [barButtonItem,UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)]
        let pickerView1 = UIPickerView()
        pickerView1.dataSource = self
        pickerView1.delegate = self
        categoryTextField.inputAccessoryView = toolBar
        categoryTextField.inputView = pickerView1
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        var fetchedcities: [City]?
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.performAndWait {
            fetchedcities = try? fetchRequest.execute()
        }
        
        cityPickerView.dataSource = self
        cityPickerView.delegate = self
        if let cities = fetchedcities {
            citiesList = cities
        }
        let toolBar2 = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolBar2.backgroundColor = UIColor.lightGray
        let barButtonItem2 = UIBarButtonItem(title: "DONE", style: UIBarButtonItemStyle.done, target: self, action: #selector(SearchResultsViewController.dismissCityPickerView))
        toolBar2.items = [barButtonItem2,UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)]
        placeTextField.inputView = cityPickerView
        placeTextField.inputAccessoryView = toolBar2
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func dismissCityPickerView(){
        let pickerView =  (placeTextField.inputView as! UIPickerView)
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        if let s = pickerView.delegate?.pickerView?(pickerView, titleForRow: selectedRow, forComponent: 0) {
            placeTextField.text = s
        }
        self.placeTextField.resignFirstResponder()
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        
        guard let catagoryValue = categoryTextField.text,
            let cityValue = placeTextField.text else {
                let alertController = UIAlertController(title: "Error", message: "All fields need a value", preferredStyle:UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style:
                    UIAlertActionStyle.cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
                return
                
        }
        let fetchRequest: NSFetchRequest<PointOfIntrest> = PointOfIntrest.fetchRequest()
        let predicate = NSPredicate(format: "city.name = %@ AND categoryValue = %@", cityValue,catagoryValue)
        fetchRequest.predicate = predicate
        
        var fetchedPOI: [PointOfIntrest]?
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.performAndWait {
            fetchedPOI = try? fetchRequest.execute()
        }
        if let poiArray = fetchedPOI {
            dataSource = poiArray
        }else{
            dataSource = []
        }
        self.tableView.reloadSections(IndexSet(integer:0), with: UITableViewRowAnimation.automatic)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count != 0 ? dataSource.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataSource.count == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NORESULTSCELL",
                                                     for: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "POICEll",
                                                 for: indexPath) as! POICell
        let poi = self.dataSource[indexPath.row]
        cell.nameLabel.text = poi.name
        cell.cityLabel.text = poi.city.name
        cell.contactNumberLabel.text = String(poi.number)
        cell.categoryLabel.text = poi.category.rawValue
        cell.poiImageView.image = UIImage(data: poi.imageData as Data)
        return cell
    }
    
    
    func dismissPickerView(){
        let pickerView =  (categoryTextField.inputView as! UIPickerView)
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        if let s = pickerView.delegate?.pickerView?(pickerView, titleForRow: selectedRow, forComponent: 0) {
            categoryTextField.text = s
        }
        self.categoryTextField.resignFirstResponder()
    }
    
    
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? DetailViewController,
            let selectedRow = self.tableView.indexPathForSelectedRow?.row
            else{
                return
        }
        detailViewController.pointOfIntrest = dataSource[selectedRow]
    }
    
}
extension SearchResultsViewController :UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if (pickerView === cityPickerView){
            return citiesList.count
        }else{
            return 5
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if !(pickerView === cityPickerView) {
            switch row {
            case 0:
                return Category.Bank.rawValue
            case 1:
                return Category.Hospital.rawValue
            case 2:
                return Category.Home.rawValue
            case 3:
                return Category.Park.rawValue
            case 4:
                return Category.School.rawValue
            default:
                fatalError()
            }
        } else {
            return citiesList[row].name
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
}
