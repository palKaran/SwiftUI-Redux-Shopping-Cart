//
//  ProfileView.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


import SwiftUI

struct ProfileView: View {
    private var store: Store<AppState>
    @StateObject private var viewStore: ViewStore<ProfileViewState>
    
    init(store: Store<AppState>) {
        self.store = store
        self._viewStore = StateObject(wrappedValue: ViewStore(
            observe: { appState in
                ProfileViewState(
                    user: appState.user.currentUser,
                    isLoggedIn: appState.user.isLoggedIn,
                    isLoading: appState.user.isLoading,
                    error: appState.user.error,
                    cartItemCount: appState.cart.totalItems,
                    lastLoginDate: appState.user.lastLoginDate
                )
            }
        ))
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewStore.state.isLoggedIn {
                    loggedInView
                } else {
                    loggedOutView
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            viewStore.updateStore(store)
        }
    }
    
    private var loggedOutView: some View {
        VStack(spacing: 30) {
            Image(systemName: "person.circle")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            VStack(spacing: 12) {
                Text("Welcome to Our Store")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Sign in to access your profile, order history, and personalized recommendations")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 12) {
                Button("Login") {
                    viewStore.dispatch(UIActions.showLoginSheet)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .frame(maxWidth: .infinity)
                
                Button("Browse as Guest") {
                    viewStore.dispatch(UIActions.setCurrentTab(.products))
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
    
    private var loggedInView: some View {
        List {
            // User info section
            Section {
                userInfoCard
            }

            // Quick stats section
            Section("Quick Stats") {
                HStack {
                    Label("\(viewStore.state.cartItemCount)", systemImage: "cart")
                    Spacer()
                    Text("Items in cart")
                        .foregroundColor(.secondary)
                }

                if let lastLogin = viewStore.state.lastLoginDate {
                    HStack {
                        Label("Last login \(lastLogin, style: .relative)", systemImage: "clock")
                        Spacer()
                        Text("Last login")
                            .foregroundColor(.secondary)
                    }
                }
            }
            // Account actions section
            Section("Account") {
                NavigationLink(destination: EditProfileView()) {
                    Label("Edit Profile", systemImage: "person.crop.circle")
                }
                
                NavigationLink(destination: OrderHistoryView()) {
                    Label("Order History", systemImage: "clock.arrow.circlepath")
                }
                
                NavigationLink(destination: AddressBookView()) {
                    Label("Address Book", systemImage: "location")
                }
                
                NavigationLink(destination: PaymentMethodsView()) {
                    Label("Payment Methods", systemImage: "creditcard")
                }
            }
            
            // App settings section
            Section("Settings") {
                NavigationLink(destination: NotificationSettingsView()) {
                    Label("Notifications", systemImage: "bell")
                }
                
                NavigationLink(destination: PrivacySettingsView()) {
                    Label("Privacy", systemImage: "hand.raised")
                }
                
                NavigationLink(destination: AboutView()) {
                    Label("About", systemImage: "info.circle")
                }
            }
            
            // Logout section
            Section {
                Button(action: {
                    viewStore.dispatch(UserActions.logout)
                }) {
                    HStack {
                        if viewStore.state.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(0.8)
                        }
                        Label(viewStore.state.isLoading ? "Logging out..." : "Logout", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }
                .disabled(viewStore.state.isLoading)
            }
        }
        .alert("Profile Error", isPresented: .constant(viewStore.state.error != nil)) {
            Button("OK") { }
        } message: {
            Text(viewStore.state.error?.localizedDescription ?? "")
        }
    }
    
    private var userInfoCard: some View {
        HStack(spacing: 16) {
            // Avatar
            Circle()
                .fill(Color.blue.gradient)
                .frame(width: 60, height: 60)
                .overlay {
                    Text(viewStore.state.user?.name.prefix(1).uppercased() ?? "U")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewStore.state.user?.name ?? "Unknown User")
                    .font(.headline)
                
                Text(viewStore.state.user?.email ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let user = viewStore.state.user {
                    HStack(spacing: 4) {
                        Image(systemName: user.isEmailVerified ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                            .foregroundColor(user.isEmailVerified ? .green : .orange)
                            .font(.caption)
                        
                        Text(user.isEmailVerified ? "Verified" : "Unverified")
                            .font(.caption)
                            .foregroundColor(user.isEmailVerified ? .green : .orange)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct ProfileViewState: Equatable {
    let user: User?
    let isLoggedIn: Bool
    let isLoading: Bool
    let error: UserError?
    let cartItemCount: Int
    let lastLoginDate: Date?
}
