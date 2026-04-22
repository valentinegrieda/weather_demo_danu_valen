//
//  Screen2View.swift
//  weather_demo_danu_valen
//
//  Created by Valentine Grieda Sahuburua on 17/04/26.
//

import SwiftUI



struct Screen2View: View {
    
    @State private var goToScreen1 = false //check on click
    @Binding var weather: Screen1View.Weather
    var weatherList: [Screen1View.Weather] = []
    
    @State private var showSheet = false
    
    var suggestionActivity: [String] {
        switch weather.condition {
        case "Cloudy":
            return ["Strolling Around in the park", "Go Cafe Hopping and have some fun", "Walk on the beach and enjoy the view"]
            
        case "Sunny":
            return ["Hang your clothes", "Go to the beach", "Do some outdoor sport"]
            
        case "Rainy":
            return ["Bring your umbrella", "Drive your vehicle safely", "Don't hang your clothes"]
            
        case "Stormy":
            return ["Go back home soon and be careful", "Don't go out if possible", "Stay in safe place"]
            
        default:
            return ["", "", ""]
        }
    }
    
    @State private var index = -1
    @State private var timer: Timer?
    
    var locations: [String] {
        ["Kota Denpasar","Kabupaten Badung","Canggu","Jimbaran","Singaraja","Ubud"]
    }
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                //background
                Color.white
                    .ignoresSafeArea()
                
                //gradient
                Ellipse()
                    .fill(Color(hex:weather.color).opacity(0.8))
                    .frame(width: 350, height: 400)
                    .blur(radius: 120)
                    .offset(x: 0, y: -450)
                
                //location position
                VStack {
                    HStack {
                        
                        Text(weather.location.uppercased())
                            .font(.system(size: 20, weight: .light))
                            .fontWidth(.expanded)
                        Image(systemName: "chevron.down")
                            .onTapGesture {
                                showSheet = true
                            }
                            .sheet(isPresented: $showSheet) {
                                VStack(spacing: 20) {
                                    ForEach(locations, id: \.self) { location in
                                        Text(location)
                                            .font(.title3)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding()
                                            .contentShape(Rectangle())
                                        
                                            .onTapGesture {
                                                if let selected = weatherList.first(where: { $0.location == location }) {
                                                    weather = selected
                                                    index = -1
                                                    startAnimation()
                                                }
                                                showSheet = false
                                            }
                                            .background(
                                                weather.location == location
                                                ? Color.gray.opacity(0.2)
                                                : Color.clear
                                            )
                                            .cornerRadius(10)
                                    }
                                }
                                .padding()
                                .presentationDetents([.medium, .large])
                            }
                    }
                    .frame(alignment:.leading)
                    .foregroundStyle(Color(.black))
                    .opacity(0.8)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding (.top, 20)
                    
                }
                
                
                VStack {
                    
                    Spacer().frame(height: 60)
                    
                    //weather type + next
                    HStack(spacing:5) {
                        Text(weather.condition.uppercased())
                            .foregroundStyle(.black)
                            .font(.default)
                            .fontWeight(.bold)
                        
                        Text(weather.extras.uppercased())
                            .foregroundStyle(.black)
                            .font(.default)
                        //.font(.system(size: 20))
                        
                    }
                    
                    Spacer().frame(height: 100)
                    
                    //activities
                    ZStack(alignment: .topLeading) {
                        
                        // invisible layout holder
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(suggestionActivity, id: \.self) { item in
                                Text(item.uppercased())
                                    .font(.largeTitle)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.bottom, 20)
                                    .hidden()
                            }
                        }
                        
                        // animated visible stack
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(Array(suggestionActivity.enumerated()), id: \.offset) { i, item in
                                if i <= index {
                                    Text(item.uppercased())
                                        .font(.largeTitle)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding(.bottom, 20)
                                        .transition(.move(edge: .leading).combined(with: .opacity))
                                }
                            }
                        }
                    }
                    .animation(.easeInOut, value: index)
                    .onAppear {
                        startAnimation()
                    }
                    
                    //back button
                    Button {
                        print("Tapped 2")
                        dismiss()
                    } label: {
                        Image(systemName: "lessthan")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Color(.black))
                            .frame(width: 56, height: 56)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    //.padding([.leading,.trailing,.bottom],20)
                    
                    
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding([.leading,.trailing,.bottom],20)
                .navigationBarBackButtonHidden(true) //hide back on top
                
                
                
                
            }
        }
    }
    
    
    func startAnimation() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if index < suggestionActivity.count - 1 {
                withAnimation(.easeInOut) {
                    index += 1
                }
            } else {
                t.invalidate()
            }
        }
    }    
    
}



#Preview {
    Screen2View(
        weather: .constant(
            Screen1View.Weather(
                id: 1,
                condition: "Cloudy",
                temperature: 29,
                location: "Kabupaten Badung",
                extras: "Rain at 5pm",
                color: "FFFFFF",
                img: "SUN"
            )
        )
    )
    .preferredColorScheme(.light)

}
