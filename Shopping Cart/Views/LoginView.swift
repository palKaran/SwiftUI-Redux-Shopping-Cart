//
//  LoginView.swift
//  Shopping Cart
//
//  Created by Karan Pal on 05/07/25.
//


import SwiftUI

struct LoginView: View {
    private var store: Store<AppState>
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewStore: ViewStore<LoginViewState>
    
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistering = false
    @State private var name = ""
    
    init(store: Store<AppState>) {
        self.store = store
        self._viewStore = StateObject(wrappedValue: ViewStore(
            store: StoreEnvironmentKey.defaultValue,
            observe: { appState in
                LoginViewState(
                    isLoading: appState.user.isLoading,
                    error: appState.user.error,
                    isLoggedIn: appState.user.isLoggedIn
                )
            }
        ))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                headerView
                
                formFields
                
                actionButtons
                
                Spacer()
                
                toggleModeButton
            }
            .padding()
            .navigationTitle(isRegistering ? "Create Account" : "Login")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            viewStore.updateStore(store)
        }
        .onChange(of: viewStore.state.isLoggedIn) { isLoggedIn in
            if isLoggedIn {
                dismiss()
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text(isRegistering ? "Join our community" : "Welcome back")
                .font(.title2)
                .fontWeight(.semibold)
        }
        .padding(.top)
    }
    
    private var formFields: some View {
        VStack(spacing: 16) {
            if isRegistering {
                TextField("Full Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.name)
            }
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .textContentType(isRegistering ? .newPassword : .password)
            
            if let error = viewStore.state.error {
                Text(error.localizedDescription)
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: handlePrimaryAction) {
                HStack {
                    if viewStore.state.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    }
                    Text(isRegistering ? "Create Account" : "Login")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(viewStore.state.isLoading || !isFormValid)
        }
    }
    
    private var toggleModeButton: some View {
        Button(action: {
            isRegistering.toggle()
            password = ""
            if !isRegistering {
                name = ""
            }
        }) {
            Text(isRegistering ? "Already have an account? Login" : "Don't have an account? Sign up")
                .font(.footnote)
        }
    }
    
    private var isFormValid: Bool {
        let emailValid = email.contains("@") && !email.isEmpty
        let passwordValid = password.count >= 6
        let nameValid = !isRegistering || !name.isEmpty
        
        return emailValid && passwordValid && nameValid
    }
    
    private func handlePrimaryAction() {
        if isRegistering {
            viewStore.dispatch(UserActions.register(email: email, password: password, name: name))
        } else {
            viewStore.dispatch(UserActions.login(email: email, password: password))
        }
    }
}

struct LoginViewState: Equatable {
    let isLoading: Bool
    let error: UserError?
    let isLoggedIn: Bool
}
