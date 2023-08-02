//
//  Place.swift
//  somePlaces
//
//  Created by Вадим on 31.07.2023.
//

import UIKit



struct Place: Codable {
    var name:String
    var location: String
    var image: Data?
    var type: String
    
    static let names = [
    "Балкан Гриль","Бочка","Вкусные истории","Дастархан","Индокитай","Классик","Шок","Bonsai","Burger Heroes","Kitchen","Love&Life","Morris Pub","Sherlock Holmes","Speak Easy","X.O"]
    
    static func places() -> [Place]{
        var places:[Place] = []
        
        for name in Place.names {
            places.append(Place(name: name,location: "Moscow",image: UIImage(named: name)?.pngData()!,type: "Bar"))
        }
        
        return places
    }
}
