//
//  TabBarView.swift
//  JPMCNasaAPOD
//
//  Created by Bhushan Abhyankar on 11/11/2024.
//

import SwiftUI

struct TabBarView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.nasaBackgroundColor)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.gray.opacity(0.6))
    }
    
    var body: some View {
        ZStack {
            Color.nasaBackgroundColor
                .ignoresSafeArea()
            TabView {
                PicOfTheDayView()
                    .tabItem {
                        Image(systemName: "photo.artframe.circle.fill")
                        Text("Today")
                    }
                
                FutureView()
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("Select Date")
                    }
            }
        }
        .accentColor(.nasaAccentColor)

    }
}

#Preview {
    TabBarView()
}
