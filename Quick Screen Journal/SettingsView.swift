//
//  SettingsView.swift
//  Quick Screen Journal
//
//  Created by Matt Bartie on 12/16/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedTimeDelay") private var selectedTimeDelay: Int = 5
    @AppStorage("customPromptQuestion") private var customPromptQuestion: String = "Do you really need to use this app right now?"
    @State private var isEditingPrompt = false
    
    // Available time delays in minutes
    private let timeDelayOptions = [5, 10, 15, 30, 60]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Delay Timer")) {
                    Picker("Delay Time", selection: $selectedTimeDelay) {
                        ForEach(timeDelayOptions, id: \.self) { minutes in
                            Text("\(minutes) minutes")
                                .tag(minutes)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 120)
                    
                    Text("Apps will be accessible without being redirected to journal for \(selectedTimeDelay) minutes after completing a journal.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
                
                Section(header: Text("Custom Prompt"),
                        footer: Text("This message will be shown when you attempt to open a blocked app.")) {
                    HStack {
                        Text(customPromptQuestion)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Button(action: {
                            isEditingPrompt = true
                        }) {
                            Text("Edit")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $isEditingPrompt) {
                NavigationView {
                    CustomPromptEditView(prompt: $customPromptQuestion, isPresented: $isEditingPrompt)
                }
            }
        }
    }
}

struct CustomPromptEditView: View {
    @Binding var prompt: String
    @Binding var isPresented: Bool
    @State private var tempPrompt: String
    
    init(prompt: Binding<String>, isPresented: Binding<Bool>) {
        _prompt = prompt
        _isPresented = isPresented
        _tempPrompt = State(initialValue: prompt.wrappedValue)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Custom Message")) {
                TextEditor(text: $tempPrompt)
                    .frame(minHeight: 100)
                
                Text("\(tempPrompt.count)/150 characters")
                    .font(.caption)
                    .foregroundColor(tempPrompt.count <= 150 ? .secondary : .red)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .navigationTitle("Edit Prompt")
        .navigationBarItems(
            leading: Button("Cancel") {
                isPresented = false
            },
            trailing: Button("Save") {
                if !tempPrompt.isEmpty && tempPrompt.count <= 150 {
                    prompt = tempPrompt
                    isPresented = false
                }
            }
            .disabled(tempPrompt.isEmpty || tempPrompt.count > 150)
        )
    }
}

#Preview {
    SettingsView()
}
