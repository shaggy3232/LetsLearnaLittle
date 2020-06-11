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
                    Text("\(coordinate.latitude), \(coordinate.longitude)")
                    
   
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
    
    @Published var Rests = [restaurant]()
    
    init(){
        let url = "https://developers.zomato.com/api/v2.1/geocode?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)"
        let api = "7f99f4022b4612cf1711ebfd5198d544"
    }
    
}

struct restaurant : Identifiable{
    var id:String
    var name : String
    var image : String
    var rating : String
    var webUrl : String
}


