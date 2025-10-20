//
//  ContentView.swift
//  CustomNavigationPopItems
//
//  Created by Balaji Venkatesh on 26/11/24.
//

import SwiftUI

@Observable
class NavigationHelper: NSObject, UIGestureRecognizerDelegate {
    var path: NavigationPath = .init()
    var popProgress: CGFloat = 1.0
    /// Properties
    private var isAdded: Bool = false
    private var navController: UINavigationController?
    
    func addPopGestureListner(_ controller: UINavigationController) {
        guard !isAdded else { return }
        controller.interactivePopGestureRecognizer?.addTarget(self, action: #selector(didInteractivePopGestureChange))
        navController = controller
        /// Optional
        /// This will make interactive pop gesture to work even when the navigation bar is hidden
        controller.interactivePopGestureRecognizer?.delegate = self
        isAdded = true
    }
    
    @objc
    func didInteractivePopGestureChange() {
        if let completionProgress = navController?.transitionCoordinator?.percentComplete, let state = navController?.interactivePopGestureRecognizer?.state,
            navController?.viewControllers.count == 1 {
            popProgress = completionProgress
            
            if state == .ended || state == .cancelled {
                if completionProgress > 0.5 {
                    /// Popped
                    popProgress = 1
                } else {
                    /// Reset
                    popProgress = 0
                }
            }
        }
    }
    
    /// This will make interactive pop gesture to work even when the navigation bar is hidden
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        navController?.viewControllers.count ?? 0 > 1
    }
}

struct ContentView: View {
    var navigationHelper: NavigationHelper = .init()
    var body: some View {
        VStack(spacing: 0) {
            @Bindable var bindableHelper = navigationHelper
            NavigationStack(path: $bindableHelper.path) {
                List {
                    Button {
                        navigationHelper.path.append("iJustine")
                    } label: {
                        Text("iJustine's Post")
                            .foregroundStyle(Color.primary)
                    }
                }
                .navigationTitle("Home")
                .navigationDestination(for: String.self) { navTitle in
                    List {
                        Button {
                            navigationHelper.path.append("More Post's")
                        } label: {
                            Text("More iJustine's Post")
                                .foregroundStyle(Color.primary)
                        }
                    }
                    .navigationTitle(navTitle)
                }
            }
            .viewExtractor {
                if let navController = $0.next as? UINavigationController {
                    navigationHelper.addPopGestureListner(navController)
                }
            }
            
            CustomBottomBar()
        }
        .environment(navigationHelper)
    }
}

struct CustomBottomBar: View {
    @Environment(NavigationHelper.self) private var navigationHelper
    @State private var selectedTab: TabModel = .home
    var body: some View {
        HStack(spacing: 0) {
            let blur = (1 - navigationHelper.popProgress) * 5
            let scale = (1 - navigationHelper.popProgress) * 0.1
            let offset = (1 - navigationHelper.popProgress) * -15
            
            ForEach(TabModel.allCases, id: \.rawValue) { tab in
                Button {
                    if tab == .newPost {
                        
                    } else {
                        selectedTab = tab
                    }
                } label: {
                    Image(systemName: tab.rawValue)
                        .font(.title3)
                        .foregroundStyle(selectedTab == tab || tab == .newPost ? Color.primary : Color.gray)
                        .blur(radius: tab != .newPost ? blur : 0)
                        .scaleEffect(tab == .newPost ? 1.8 : 1 - scale)
                        .offset(x: tab == .newPost ? 0 : offset)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .contentShape(.rect)
                }
                .opacity(tab != .newPost ? navigationHelper.popProgress : 1)
                .overlay {
                    let offset = (1 - navigationHelper.popProgress) * 15
                    let blur = (navigationHelper.popProgress) * 10
                    ZStack {
                        if tab == .home {
                            Button {
                                
                            } label: {
                                Image(systemName: "exclamationmark.bubble")
                                    .font(.title3)
                                    .foregroundStyle(Color.primary)
                            }
                        }
                        
                        if tab == .settings {
                            Button {
                                
                            } label: {
                                Image(systemName: "ellipsis")
                                    .font(.title3)
                                    .foregroundStyle(Color.primary)
                            }
                        }
                    }
                    .opacity(1 - navigationHelper.popProgress)
                    .blur(radius: blur)
                    .offset(x: 15 - offset)
                }
            }
        }
        .onChange(of: navigationHelper.path) { oldValue, newValue in
            guard newValue.isEmpty || oldValue.isEmpty else { return }
            if newValue.count > oldValue.count {
                navigationHelper.popProgress = 0.0
            } else {
                navigationHelper.popProgress = 1.0
            }
        }
        .animation(.easeInOut(duration: 0.25), value: navigationHelper.popProgress)
    }
}

enum TabModel: String, CaseIterable {
    case home = "house.fill"
    case search = "magnifyingglass"
    case newPost = "square.and.pencil.circle.fill"
    case notifications = "bell.fill"
    case settings = "gearshape.fill"
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
