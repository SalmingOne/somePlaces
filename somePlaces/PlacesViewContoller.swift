//
//  TableViewController.swift
//  somePlaces
//
//  Created by Вадим on 28.07.2023.
//

import UIKit

class PlacesViewContoller: UITableViewController {
    
    
    @IBOutlet weak var sortedBtn: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationItem!
    var index:Int?
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var sortFlag = 0
    var places: [Place] = []
    var placesBeforeSorting: [Place] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        for place in deserilize(){
            places.append(place)
        }
        placesBeforeSorting = places
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PlaceCell
        let place = places[indexPath.row]
        
        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type

        cell.imagePlace.contentMode = .scaleAspectFill
        cell.imagePlace.image = UIImage(data: (place.image ?? UIImage(named: "Photo")?.pngData())!)
        cell.imagePlace.layer.cornerRadius = cell.imagePlace.frame.height / 2
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        
        let deleteAction = UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "Delete", handler: { (action, swipeButtonView, completion) in
            
            self.places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.delete(index: indexPath.row)
            completion(true)
        })])
        return deleteAction
    }
    
    @IBAction func saveBtn(segue: UIStoryboardSegue){
        guard let vc = segue.source as? NewPlaceViewController else {return}
        vc.save()
        guard let place = vc.place else {return}
        if index == nil{
            serialize(place: place)
            places.append(place)
        } else {
            places[index!] = place
            self.changePlace(index: index!, place: place)
            index = nil
        }
        
        tableView.reloadData()
    }
    
    @IBAction func sortedBtnTap(_ sender: UIBarButtonItem) {
        if sortFlag == 0{
            places = places.sorted(by: { place1, place2 in
                place1.name < place2.name
            })
            sortFlag = 1
            sortedBtn.image = UIImage(named: "ZA")
        } else if sortFlag == 1  {
            places = places.sorted(by: { place1, place2 in
                place1.name > place2.name
            })
            sortFlag = 2
            sortedBtn.image = UIImage(named: "AZ")
        } else {
            places = placesBeforeSorting
            sortedBtn.image = UIImage(named: "minus")
            sortFlag = 0
        }
        
        tableView.reloadData()
    }
    
    
    func changePlace(index:Int, place:Place){
        let destinationURL = documentsDirectory.appendingPathComponent("places_data.json")
        do {
            let data = try Data(contentsOf: destinationURL)
            
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            if let jsonArray = json as? [[String: Any]] {
                
                var updatedArray = jsonArray
                var newPlace: [String: Any] = [
                    "type": place.type,
                    "location": place.location,
                    "name": place.name
                ]
                if let image = place.image{
                    let JSONImage = image.base64EncodedString()
                    newPlace["image"] = JSONImage
                }
                updatedArray[index] = newPlace
                let updatedData = try JSONSerialization.data(withJSONObject: updatedArray)
                
                try updatedData.write(to: destinationURL)
            }
        }catch{ print("Error") }
    }
    
    func delete(index:Int){
        let destinationURL = documentsDirectory.appendingPathComponent("places_data.json")
        do {
            let data = try Data(contentsOf: destinationURL)
            
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            if let jsonArray = json as? [[String: Any]] {
                
                var updatedArray = jsonArray
                
                updatedArray.remove(at: index)
                
                let updatedData = try JSONSerialization.data(withJSONObject: updatedArray)
                
                try updatedData.write(to: destinationURL)
            }
            
        } catch {
            print("Error")
        }
    }
    
    func serialize(place: Place){
        let destinationURL = documentsDirectory.appendingPathComponent("places_data.json")
        do{
            if !FileManager.default.fileExists(atPath: destinationURL.path) {
                let emptyArray: [[String: Any]] = []
                do {
                    let data = try JSONSerialization.data(withJSONObject: emptyArray)
                    try data.write(to: destinationURL)
                    
                } catch {
                    print("Error creating places_data.json file: \(error)")
                }
            }
            
            let data = try Data(contentsOf: destinationURL)
            
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            if let jsonArray = json as? [[String: Any]] {
                
                var updatedArray = jsonArray
                
                var newPlace: [String: Any] = [
                    "type": place.type,
                    "location": place.location,
                    "name": place.name
                ]
                if let image = place.image{
                    let JSONImage = image.base64EncodedString()
                    newPlace["image"] = JSONImage
                }
                
                
                updatedArray.append(newPlace)
                
                let updatedData = try JSONSerialization.data(withJSONObject: updatedArray)
                
                try updatedData.write(to: destinationURL)
          }
        }
        catch {print("Error")}
        
    }
    
    func deserilize() -> [Place]{
        var places:[Place] = []
        let destinationURL = documentsDirectory.appendingPathComponent("places_data.json")
        print(destinationURL)
        do{
            let data = try Data(contentsOf: destinationURL)
            let decoder = JSONDecoder()
            let jsonObject = try decoder.decode([Place].self, from: data)
            
            places += (jsonObject)
            
        }
        catch {print("Error")}
        
        return places
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changePlace"{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                index = indexPath.row
                let vc = segue.destination as! NewPlaceViewController
                vc.saveBtnIsEnabled = true
                vc.place = places[indexPath.row]
                vc.change = true
            }
        }
        if segue.identifier == "addNewPlace"{
            self.index = nil
        }
    }
}

