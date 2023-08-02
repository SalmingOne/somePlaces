//
//  NewPlaceViewController.swift
//  somePlaces
//
//  Created by Вадим on 29.07.2023.
//

import UIKit

class NewPlaceViewController: UITableViewController {

    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var typeTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var imagePlace: UIImageView!
    
    var saveBtnIsEnabled = false
    
    var place: Place?
    var change = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBtn.isEnabled = saveBtnIsEnabled
        if change{
            imagePlace.contentMode = .scaleAspectFill
            typeTF.text = place?.type
            nameTF.text = place?.name
            locationTF.text = place?.location
            imagePlace.image = UIImage(data: (place?.image)!)
            change = false
        }
        else{
            imagePlace.contentMode = .center
        }
        typeTF.delegate = self
        nameTF.delegate = self
        locationTF.delegate = self
        
        nameTF.addTarget(self, action: #selector(textFieldEditing), for: .editingChanged)
        
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let alertActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            let photoGallery = UIAlertAction(title: "Gallery", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertActionSheet.addAction(camera)
            alertActionSheet.addAction(photoGallery)
            alertActionSheet.addAction(cancel)
            
            present(alertActionSheet, animated: true)
            
            }
        else {
            self.view.endEditing(true)
        }
    }
}


extension NewPlaceViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func chooseImagePicker(source: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePlace.image = info[.editedImage] as? UIImage
        imagePlace.contentMode = .scaleAspectFill
        imagePlace.clipsToBounds = true
        dismiss(animated: true)
    }
    
    func save(){
        place = Place(name: nameTF.text!, location: locationTF.text ?? "", image: imagePlace.image?.pngData(), type: typeTF.text ?? "")
    }
}

extension NewPlaceViewController: UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @objc private func textFieldEditing(){
        
        if nameTF.text?.isEmpty == true{
            saveBtn.isEnabled = false
        } else {
            saveBtn.isEnabled = true
        }
    }
    
}
