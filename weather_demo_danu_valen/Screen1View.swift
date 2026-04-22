//
//  Screen1View.swift
//  weather_demo_danu_valen
//
//  Created by Valentine Grieda Sahuburua on 16/04/26.
//

import SwiftUI

extension Color {
    init(hex: String) { //define hex color
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}


struct Screen1View: View {
    
    struct Weather: Identifiable {
        var id: Int
        var condition: String
        var temperature: Int
        var location: String
        var extras: String
        var color: String
        var img: String
    }

    var dummyWeather = [
        Weather(id: 1, condition: "Cloudy", temperature: 29, location: "Kabupaten Badung", extras: "Rain at 5pm", color: "9CFFF5", img: "CLOUDY"),
        Weather(id: 2, condition: "Sunny", temperature: 30, location: "Canggu", extras: "All day", color: "FFE890", img: "SUN"),
        Weather(id: 3, condition: "Stormy", temperature: 28, location: "Kota Denpasar", extras: "Rain at 8pm", color: "6A74A1", img: "STORMY"),
        Weather(id: 4, condition: "Rainy", temperature: 28, location: "Jimbaran", extras: "Cloudy at 6pm", color: "60BBFF", img: "RAIN"),
        Weather(id: 5, condition: "Stormy", temperature: 28, location: "Singaraja", extras: "Rain at 8pm", color: "6A74A1", img: "STORMY"),
        Weather(id: 6, condition: "Sunny", temperature: 30, location: "Ubud", extras: "All day", color: "FFE890", img: "SUN")
        
    ]
    
    struct LocationList: Identifiable {
        var id: Int
        var location: String
    }
    
    var dummyLocation = [
        LocationList(id: 1, location: "Kota Denpasar"),
        LocationList(id: 2, location: "Kabupaten Badung"),
        LocationList(id: 3, location: "Canggu"),
        LocationList(id: 4, location: "Jimbaran"),
        LocationList(id: 5, location: "Singaraja"),
        LocationList(id: 6, location: "Ubud")
    ]
    
    //random weather
    //@State private var selectedID = Int.random(in: 1...4)
    
    //testing purpose
    //@State private var selectedID = 2
    
    //@State public var colorBG: String
    
//    var randomWeather: Weather {
//        dummyWeather.first(where: { $0.id == selectedID })!
//    }
    
    //check on click to move to second screen
    @State private var goToScreen2 = false
    @State private var showSheet = false
    
    //initial data
    @State private var selectedWeather = Weather(
        id: 1,
        condition: "Cloudy",
        temperature: 29,
        location: "Kabupaten Badung",
        extras: "Rain at 5pm",
        color: "9CFFF5",
        img: "CLOUDY"
    )
    

    
    var body: some View {
        NavigationStack {
            ZStack {
                
                //background?
                Color.white
                    .ignoresSafeArea()
                
                Ellipse()
                //.fill(randomWeather.color.opacity(0.45))
                    .fill(Color(hex: selectedWeather.color).opacity(0.8))
                    .frame(width: 300, height: 200)
                    .blur(radius: 80)
                    .offset(x: 70, y: -130)
                
                
                //location position
                VStack {
                    HStack {
                        Text(selectedWeather.location.uppercased())
                            .font(.system(size: 20, weight: .light))
                            .fontWidth(.expanded)
                        Image(systemName: "chevron.down")
                            .onTapGesture {
                                    showSheet = true
                                }
                                .sheet(isPresented: $showSheet) {
                                    
                                    VStack(spacing: 20) {
                                        ForEach(dummyLocation) { item in
                                            Text(item.location)
                                                .font(.title3)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding()
                                                .contentShape(Rectangle())
                                                .onTapGesture {
                                                    
                                                    if let weather = dummyWeather.first(where: { $0.location == item.location }) {
                                                        selectedWeather = weather
                                                    }
                                                    
                                                }
                                                    
                                                .background(
                                                    selectedWeather.location == item.location
                                                    ? Color.gray.opacity(0.2)
                                                    : Color.clear
                                                )
                                                .cornerRadius(10)
                                                }
                                        }
                                        
                                    .foregroundStyle(Color(.black))
                                        .padding()
                                        .presentationDetents([.medium, .large])
                                        
                                        
                                }
                                .presentationBackground(
                                    Color.white.opacity(0.8)
                                )
                    }
                    .frame(alignment:.leading)
                    //.foregroundStyle(Color(.black))
                    .opacity(0.8)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding (.top, 20)
                }
                
                
                VStack(alignment: .leading, spacing: -15) {
                    //degree
                    Text("\(selectedWeather.temperature)°")
                        .font(.system(size: 50, weight: .light))
                        .fontWidth(.expanded)
                        .padding([.leading,.bottom],20)
                    
                    
                    //old weather
                    //                    Text(randomWeather.condition.uppercased())
                    //                        .font(.system(size: 80, weight: .bold))
                    //                        .padding([.leading],-13)
                    
                    
                    //weather
                    Image(selectedWeather.img)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                    
                    //change weather
                    Text(selectedWeather.extras.uppercased())
                        .font(.system(size: 30, weight: .light))
                        .fontWidth(.expanded)
                        .padding([.top,.trailing],20)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    print("Tapped")
                    goToScreen2 = true // confirming that the button on click
                } label: {
                    Image(systemName: "figure.walk")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color(.black))
                        .frame(width: 56, height: 56)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(20)
                
            }
            .navigationBarBackButtonHidden(true) //hide back on top
            .navigationDestination(isPresented: $goToScreen2) {Screen2View(
                weather: $selectedWeather,
                weatherList: dummyWeather
            )} //move to second screen
            
        }
        
        
    }
}

#Preview {
    NavigationStack {
        Screen1View()
            .preferredColorScheme(.light)
    }
}
