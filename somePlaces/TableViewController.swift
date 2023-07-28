//
//  TableViewController.swift
//  somePlaces
//
//  Created by Вадим on 28.07.2023.
//

import UIKit

class TableViewController: UITableViewController {

    
    let names = [
    "123","rt","das","12f3","a","gdf","h","a","dfsga",]
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return names.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goTo"{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let infoVC = segue.destination as! InfoViewController
                infoVC.text = names[indexPath.row]
            }
        }
    }

}
