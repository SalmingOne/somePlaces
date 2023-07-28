//
//  TableViewController.swift
//  somePlaces
//
//  Created by Вадим on 28.07.2023.
//

import UIKit

class TableViewController: UITableViewController {

    
    let names = [
    "Балкан Гриль","Бочка","Вкусные истории","Дастархан","Индокитай","Классик","Шок","Bonsai","Burger Heroes","Kitchen","Love&Life","Morris Pub","Sherlock Holmes","Speak Easy","X.O"]
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
        cell.imageView?.image = UIImage(named: names[indexPath.row])
        cell.imageView?.layer.cornerRadius = cell.frame.height / 2
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
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
