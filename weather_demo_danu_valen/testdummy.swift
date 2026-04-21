//
//  testdummy.swift
//  weather_demo_danu_valen
//
//  Created by Valentine Grieda Sahuburua on 17/04/26.
//

import SwiftUI

struct testdummy: View {
    
    struct Message {
        var title: String
        var from: String
        var inbox: String
    }

    
    let message = Message(
        title: "Hello",
        from: "John",
        inbox: "New message received"
    )
        
    
    func open () {
        print("Opening mail from \(message.from) with title: \(message.title) and the inbox messages are: \(message.inbox)")
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
    }
}

#Preview {
    testdummy()
}
