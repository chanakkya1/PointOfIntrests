//
//  FormViewController.swift
//  Point Of Intrests
//
//  Created by chanakkya mati on 7/29/17.
//  Copyright © 2017 HimaTej. All rights reserved.
//

import UIKit
import CoreData

class FormViewController: UIViewController, UIImagePickerControllerDelegate ,UINavigationControllerDelegate, UIGestureRecognizerDelegate{

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var longitude: UITextField!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryTextField: UITextField!
    let picker = UIImagePickerController()
    var firstResponderView:UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector:#selector(FormViewController.keyBoardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FormViewController.keyBoardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolBar.backgroundColor = UIColor.lightGray
        let barButtonItem = UIBarButtonItem(title: "DONE", style: UIBarButtonItemStyle.done, target: self, action: #selector(FormViewController.dismissPickerView))
        toolBar.items = [barButtonItem,UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)]
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        categoryTextField.inputAccessoryView = toolBar
        categoryTextField.inputView = pickerView
        picker.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.done, target: self, action: #selector(FormViewController.saveRecord))
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveRecord(){
       self.view.endEditing(true)
        
        guard let nameValue = nameTextField.text,
        let cityValue = city.text?.uppercased(),
        let info = descriptionTextView.text,
        let categoryString = categoryTextField.text,
        let category = Category(rawValue: categoryString),
        let longitudeStringValue:String = longitude.text,
        let longitudeNumber = Double(longitudeStringValue),
        let latitudeStringValue:String = latitude.text,
        let latitudeNumber = Double(latitudeStringValue),
        let numberStringValue = numberTextField.text,
        let contactNumber = Int64(numberStringValue),
        let image = imageView.image
         else {
            let alertController = UIAlertController(title: "Error", message: "All fields need a value including the Image", preferredStyle:UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style:
                UIAlertActionStyle.cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
            return
        }

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", cityValue)
        fetchRequest.predicate = predicate
        context.performAndWait {
            var city:City
            if let cities =  try?  fetchRequest.execute(), cities.count > 0 {
                city = cities.first!
            }else{
                city = City(context: context)
                city.name = cityValue
            }
            
            let poi = PointOfIntrest(context: context)
            poi.name = nameValue
            poi.city = city
            poi.latitude = latitudeNumber
            poi.longitude = longitudeNumber
            poi.infoDescription = info
            poi.number = contactNumber
            poi.category = category
            poi.imageData = UIImageJPEGRepresentation(image, 0.5)! as NSData
        }
        do {
            try context.save()
        }catch let error{
            let alertController = UIAlertController(title: error.localizedDescription, message: "SaveFailed", preferredStyle:UIAlertControllerStyle.alert)
            present(alertController, animated: true, completion: nil)
            return
        }
        let alertController = UIAlertController(title:"Save Succesful", message: "", preferredStyle:UIAlertControllerStyle.alert)
        present(alertController, animated: true, completion: nil)
        alertController.addAction(UIAlertAction(title: "OK", style:
            UIAlertActionStyle.cancel, handler: {action in self.navigationController?.popViewController(animated: true)}))
    }
    
    @IBAction func takeImageAction(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }

    @IBAction func swipeGestureActionMethod(_ sender: Any) {
        self.firstResponderView?.resignFirstResponder()
    }
    func keyBoardWillShow(notification:NSNotification){
        let keyBoardRect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        var rect  = (UIApplication.shared.delegate as! AppDelegate).window!.bounds
        rect.size.height -= (keyBoardRect.height+64)
        rect.origin.y = 64
        guard let activeView = firstResponderView, !rect.contains((UIApplication.shared.delegate as! AppDelegate).window!.convert(activeView.frame, from: self.view)) else{
            return
        }
        if (UIApplication.shared.delegate as! AppDelegate).window!.convert(activeView.frame, from: self.view).origin.y > 64 {
        self.view.frame.origin.y -= ((UIApplication.shared.delegate as! AppDelegate).window!.convert(activeView.frame, from: self.view).origin.y + activeView.frame.size.height) - (rect.size.height+64) + 8
        } else {
            self.view.frame.origin.y -= (UIApplication.shared.delegate as! AppDelegate).window!.convert(activeView.frame, from: self.view).origin.y-64-8
        }
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    

    func keyBoardWillHide(notification:NSNotification){
     self.view.frame.origin.y = 64
     self.view.layoutIfNeeded()
    }
    
    func dismissPickerView(){
      let pickerView =  (categoryTextField.inputView as! UIPickerView)
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        if let s = pickerView.delegate?.pickerView?(pickerView, titleForRow: selectedRow, forComponent: 0) {
            categoryTextField.text = s
        }
        self.firstResponderView?.resignFirstResponder()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .scaleAspectFit
        imageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension FormViewController :UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource, UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.firstResponderView = textView
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.firstResponderView = textField
        return true
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
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
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       self.view.viewWithTag(textField.tag + 1)?.becomeFirstResponder()
       return false
    }
    

}


