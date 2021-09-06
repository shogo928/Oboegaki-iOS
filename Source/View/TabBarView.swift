//
//  TabBarView.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/09/04.
//

import Combine
import SwiftUI

struct TabBarView: View {
    
    init(){
        UITabBar.appearance().barTintColor = UIColor(named: "White240")
        UITabBar.appearance().unselectedItemTintColor = UIColor(named: "Gray150")
    }
    
    var body: some View {
        ZStack {
            Color("White240").edgesIgnoringSafeArea(.all)
            
            TabView {
                HomeView(viewModel: HomeViewModel())
                    .tabItem {
                        VStack {
                            Image(systemName: "calendar")
                            Text("List")
                        }
                    }.tag(1)
                CreateToDoView(viewModel: CreateToDoViewModel())
                    .tabItem {
                        VStack {
                            Image(systemName: "pencil")
                            Text("ToDo")
                        }
                    }.tag(2)
                SettingView(viewModel: SettingViewModel())
                    .tabItem {
                        VStack {
                            Image(systemName: "gearshape.fill")
                            Text("Setting")
                        }
                    }.tag(3)
            }.accentColor(Color("Primary"))
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
