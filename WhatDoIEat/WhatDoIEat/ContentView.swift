//
//  ContentView.swift
//  WhatDoIEat
//
//  Created by Shaggy Bremnath on 2020-06-09.
//  Copyright © 2020 Shaggy Bremnath. All rights reserved.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
  
    @ObservedObject var obs = obserever()
    @ObservedObject var locationManager = LocationManager()
   
    
    
    
    
    
    
 
    var body: some View {
       
        let coordinate = self.locationManager.location != nil ?
            self.locationManager.location!.coordinate :CLLocationCoordinate2D()
        
        
        return VStack(alignment: .center, spacing: 20) {
            ZStack{
                
                VStack{
                     Text("What do you want to eat?")
                    Text("\(coordinate.latitude), \(coordinate.longitude)").onAppear{
                    self.obs.loadwithcoordinates(coordinate: coordinate)
                    }
                    List(obs.Rests){
                        i in
                        Text(i.name)
                    }
                    
   
                }
            }
            
            
            
        }
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class obserever : ObservableObject{

    
    @Published var Rests = [r]()
    
    init() {
     
    }
    
    func load(){
        
  
        let url1 = "https://developers.zomato.com/api/v2.1/geocode?lat=0.00&lon=0.00"
        let api = "7f99f4022b4612cf1711ebfd5198d544"
        
        let url = URL(string: url1)
        var request = URLRequest(url: url!)
        
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue( api , forHTTPHeaderField: "user-key")
        request.httpMethod = "GET"
        
        let sess = URLSession(configuration: .default)
        sess.dataTask(with: request){ (data, _, _) in
            
            do{
                let fetch = try JSONDecoder().decode(Type.self, from: data!)
                
                
                for i in fetch.nearby_restaurants{
                    
                    DispatchQueue.main.async {
                                self.Rests.append(r(id: i.restaurant.id, name: i.restaurant.name, image: i.restaurant.thumb, rating: i.restaurant.user_rating.aggregate_rating, webUrl: i.restaurant.url))
                    }
            
                }
                
            }
            catch{
                print(error.localizedDescription)
            }
            
        }.resume()
        
    }
    
       func loadwithcoordinates(coordinate: CLLocationCoordinate2D){
           
     
           let url1 = "https://developers.zomato.com/api/v2.1/geocode?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)"
           let api = "7f99f4022b4612cf1711ebfd5198d544"
           
           let url = URL(string: url1)
           var request = URLRequest(url: url!)
           
           
           request.addValue("application/json", forHTTPHeaderField: "Accept")
           request.addValue( api , forHTTPHeaderField: "user-key")
           request.httpMethod = "GET"
           
           let sess = URLSession(configuration: .default)
           sess.dataTask(with: request){ (data, _, _) in
               
               do{
                   let fetch = try JSONDecoder().decode(Type.self, from: data!)
                   print(coordinate.latitude)
                   
                   for i in fetch.nearby_restaurants{
                       
                       DispatchQueue.main.async {
                                   self.Rests.append(r(id: i.restaurant.id, name: i.restaurant.name, image: i.restaurant.thumb, rating: i.restaurant.user_rating.aggregate_rating, webUrl: i.restaurant.url))
                       }
               
                   }
                   
               }
               catch{
                   print(error.localizedDescription)
               }
               
           }.resume()
           
       }
    
}



struct r : Identifiable{
    var id:String
    var name : String
    var image : String
    var rating : String
    var webUrl : String
}

struct Type : Decodable {
    
    var nearby_restaurants : [Type1]
}

struct Type1 : Decodable {
    var restaurant : Type2
    
}


struct Type2 : Decodable {
    var id : String
    var name : String
    var url : String
    var thumb : String
    var user_rating : Type3
}

struct Type3 : Decodable {
    var aggregate_rating : String
}
