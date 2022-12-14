//
//  EditViewController.swift
//  BirthdayReminder
//
//  Created by Gulnaz on 24.10.2022.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBirthDate: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtInstagram: UITextField!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var btnAdd: UIButton!
    
    weak var delegate: BirthdayListViewControllerDelegate?
    
    let datePicker = UIDatePicker()

    var changedContact: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for case let view as UIStackView in self.view.subviews {
            for case let textField as UITextField in view.arrangedSubviews {
                textField.setOnlyBottomBorder()
            }
        }
        createDatePicker()
        createPickerFor(textField: txtAge, tag: 1)
        createPickerFor(textField: txtGender, tag: 2)
        imgPhoto.layer.cornerRadius = imgPhoto.frame.size.width / 2
        btnAdd.isEnabled = false
        
        if let changedContact = changedContact {
            imgPhoto.image = getContactImageBy(path: changedContact.imagePath)
            txtName.text = changedContact.name
            txtBirthDate.text = changedContact.birthday?.date.standartFormat()
            txtAge.text = String(changedContact.birthday?.age ?? 0)
            txtGender.text = changedContact.gender?.rawValue
            txtInstagram.text = changedContact.instagram
        }
    }
    
    @IBAction func cancelAdding(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishEditing(_ sender: UIButton) {
        
        var newContact = changedContact ?? Contact()
     
        if let image = imgPhoto.image, image != getEmptyImage() {
            newContact.imagePath = saveImageToContactImages(image: image)
        }
        if let nameText = txtName.text {
            newContact.name = nameText
        }
        newContact.birthday = Birthday(dateOfBirth: datePicker.date)
        if let genderText = txtGender.text {
            newContact.gender = getElementByRawValue(rawValue: genderText)
        }
        if let instagramText = txtInstagram.text {
            newContact.instagram = instagramText
        }
        if let delegateVC = delegate {
            delegateVC.addNewContact(changedContact: newContact)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func choosePhoto(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func showInstagramAlert(_ sender: UITextField) {
        let alert = UIAlertController(title: "Instagram", message: "?????????????? username Instagram", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak txtInstagram, btnAdd] _ in txtInstagram?.text = alert.textFields?.first?.text
            btnAdd?.isEnabled = true
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak view] _ in view?.endEditing(true)
        }))
        alert.addTextField(configurationHandler: nil)
        self.present(alert, animated: true)
    }
    
    @IBAction func tapOnTxtAge(_ sender: UITextField) {
        if sender.text == "" {
            sender.text = "1"
        }
    }
    
    @IBAction func tapOnTxtGender(_ sender: UITextField) {
        if let genderItem = Gender.allCases.first?.rawValue, sender.text == "" {
            sender.text = genderItem
        }
    }
    
    @IBAction func textEdited(_ sender: UITextField) {
        if let nameText = txtName.text {
            btnAdd.isEnabled = nameText != ""
        }
    }
    
    func createDatePicker() {
        let toolbar = createDoneToolbarWith(action: #selector(datePickerDonePressed))
        txtBirthDate.inputAccessoryView = toolbar
        txtBirthDate.inputView = datePicker
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale.init(identifier: "ru")
    }
    
    func createDoneToolbarWith(action: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: action)
        toolbar.setItems([btnDone], animated: true)
        return toolbar
    }
    
    func createPickerFor(textField: UITextField, tag: Int) {
        let newPicker = UIPickerView()
        let toolbar = createDoneToolbarWith(action: #selector(pickerDonePressed))
        textField.inputView = newPicker
        textField.inputAccessoryView = toolbar
        newPicker.dataSource = self
        newPicker.delegate = self
        newPicker.tag = tag
    }
    
    @objc func pickerDonePressed() {
        self.view.endEditing(true)
        btnAdd.isEnabled = true
    }
    
    @objc func datePickerDonePressed() {
        let birthDate = datePicker.date
        txtBirthDate.text = birthDate.standartFormat()
        txtAge.text = String(birthDate.currentAge())
        btnAdd.isEnabled = true
        self.view.endEditing(true)
    }
    
}

extension EditViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1: return 150
        case 2: return 2
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1: return String(row + 1)
        case 2: return Gender.allCases[row].rawValue
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1: txtAge.text = String(row + 1)
        case 2: txtGender.text = Gender.allCases[row].rawValue
        default: break
        }
    }
}

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgPhoto.image = image
            btnAdd.isEnabled = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
