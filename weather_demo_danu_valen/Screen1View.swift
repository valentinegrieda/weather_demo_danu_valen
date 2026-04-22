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

struct SunnyEffect: View {
    @State private var rotate = false
    @State private var pulse = false
    
    var body: some View {
        ZStack {
            
            // warm sky glow
            RadialGradient(
                colors: [
                    Color.yellow.opacity(0.35),
                    Color.orange.opacity(0.15),
                    Color.clear
                ],
                center: .topTrailing,
                startRadius: 50,
                endRadius: 400
            )
            .ignoresSafeArea()
            
            // sun rays
            ForEach(0..<8) { i in
                Rectangle()
                    .fill(Color.yellow.opacity(0.15))
                    .frame(width: 4, height: 200)
                    .offset(y: -150)
                    .rotationEffect(.degrees(Double(i) * 45))
                    .rotationEffect(.degrees(rotate ? 360 : 0))
                    .animation(.linear(duration: 40).repeatForever(autoreverses: false), value: rotate)
            }
            
            // sun core
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.yellow,
                            Color.orange.opacity(0.7)
                        ],
                        center: .center,
                        startRadius: 10,
                        endRadius: 60
                    )
                )
                .frame(width: 120, height: 120)
                .scaleEffect(pulse ? 1.05 : 0.95)
                .offset(x: 0, y: 0)
                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: pulse)
        }
        .onAppear {
            rotate = true
            pulse = true
        }
    }
}

struct RainEffect: View {
    @State private var move = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                // darker sky (helps rain visibility)
                Color.black.opacity(0.08)
                    .ignoresSafeArea()
                
                ForEach(0..<120) { _ in
                    Capsule()
                        .fill(Color.white.opacity(0.7))
                        .frame(width: 2, height: 18)
                        .rotationEffect(.degrees(15))
                        .position(
                            x: CGFloat.random(in: 0...geo.size.width),
                            y: move ? geo.size.height + 40 : -40
                        )
                        .animation(
                            .linear(duration: Double.random(in: 0.6...1.0))
                            .repeatForever(autoreverses: false),
                            value: move
                        )
                }
            }
        }
        .blur(radius: 0.3)
        .ignoresSafeArea()
        .onAppear { move = true }
    }
}

struct CloudyEffect: View {
    @State private var move = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<3) { i in
                    Image(systemName: "cloud.fill")
                        .font(.system(size: CGFloat(120 - i * 20)))
                        .foregroundColor(.gray.opacity(0.25))
                        .offset(
                            x: move ? geo.size.width : -geo.size.width,
                            y: CGFloat(i * 40)
                        )
                        .animation(
                            .linear(duration: Double(8 + i * 4)) // faster
                            .repeatForever(autoreverses: false),
                            value: move
                        )
                }
            }
        }
        .ignoresSafeArea()
        .onAppear { move = true }
    }
}

struct StormEffect: View {
    @State private var flash = false
    
    var body: some View {
        ZStack {
            
            // dark sky
            Color.black.opacity(0.15)
                .ignoresSafeArea()
            
            // rain
            RainEffect()
            
            // lightning flash
            Color.white
                .opacity(flash ? 0.25 : 0)
                .ignoresSafeArea()
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                flash = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                    flash = false
                }
            }
        }
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
                
                // Weather Effect Layer
                Group {
                    switch selectedWeather.condition {
                    case "Sunny":
                        SunnyEffect()
                    case "Rainy":
                        RainEffect()
                    case "Cloudy":
                        CloudyEffect()
                    case "Stormy":
                        StormEffect()
                    default:
                        EmptyView()
                    }
                }
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
                            .foregroundStyle(Color(.black))
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
                    .foregroundStyle(Color(.black))
                }
                
                
                VStack(alignment: .leading, spacing: -15) {
                    //degree
                    Text("\(selectedWeather.temperature)°")
                        .font(.system(size: 50, weight: .light))
                        .fontWidth(.expanded)
                        .padding([.leading,.bottom],20)
                        .foregroundStyle(Color(.black))
                    
                    
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
                        .foregroundStyle(Color(.black))
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
