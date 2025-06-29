//
//  TabBarView.swift
//  MyCart
//
//  Created by Dilshan Thalagahapitiya on 2025-06-29.
//


import SwiftUI

struct TabBarView: View {
    
    @StateObject var vm: TabBarVM
    @State var hideBar = false
    
    var body: some View {
            VStack {
                switch vm.selectedTab {
                case .homeView:
                    HomeView(hideTabBar: $hideBar)
                    
                case .cart:
                    CartView(hideTabBar: $hideBar)

                }
            } //:VStack
            .foregroundColor(.gray)
            .overlay(
                // Custom Tab Bar..
                TabBar()
                    .offset(y: hideBar ? UIScreen.screenHeight : UIScreen.screenHeight * 0.46)
                
            )
            .environmentObject(vm)
            .navigationBarHidden(true)
    }
}


class TabBarVM: ObservableObject {
    @Published var selectedTab: UserTabType = .homeView
    
    init(selectedTab: UserTabType?) {
        self.selectedTab = selectedTab ?? .homeView
    }
}


enum UserTabType {
    case homeView, cart
}


private struct TabBar: View {
    @EnvironmentObject private var vm: TabBarVM
    
    var body: some View {
        
        HStack(spacing: 0) {
            // Tab Button...
            Spacer()
            
            TabBarButton(
                item: .homeView,
                image: "icon.home",
                title: "Home"
            )
            .onTapGesture {
                vm.selectedTab = .homeView
            }
            
            Spacer()
            
            TabBarButton(
                item: .cart,
                image: "icon.cart",
                title: "My Cart"
            )
            .onTapGesture {
                vm.selectedTab = .cart
            }
            
            Spacer()
        }
        .padding(.top, 4)
        .padding(.bottom, 38)
        //.padding(.horizontal, 22)
        .frame(width: UIScreen.screenWidth)
        .background(Color.primaryElement)
    }
}


private struct TabBarButton: View {
    @EnvironmentObject private var vm: TabBarVM
    @State var item: UserTabType
    var image: String
    var title: String
    var isAddItem: Bool = false
    
    var body: some View {
        if isAddItem == false {
            VStack {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .frame( height: 28)
                Text(title)
                    .font(.system(size: 10, weight: .medium, design: .default))
            }//:VStack
            .foregroundColor(vm.selectedTab == item ? Color.backgroundPrimary : Color.backgroundPrimary.opacity(0.3))
        } else {
            Image(image)
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                .frame( height: 23)
                .foregroundColor(vm.selectedTab == item ? Color.backgroundPrimary : Color.backgroundPrimary.opacity(0.75))
                .background(Color.gray.frame(width: 50,height: 50).cornerRadius(14))
                .padding(.bottom, 10)
        }
    }
}
