//
//  AIView.swift
//  Money on Track
//
//  Created by Arda Berktin on 2024-01-03.
//

import SwiftUI

struct AIView: View {
    @State private var messages: [ChatMessage] = []
    @State private var promttf = ""
    @State private var Answer = ""
    let theopenaiclass = OpenAIConnector()
    @FocusState private var isEditing: Bool
    
    init(){
        _messages = State(initialValue: [ChatMessage(id: UUID(), content: "How can I help you today?", role: .assistant)])
    }

    var body: some View {
        NavigationStack{
            VStack {
                ScrollView {
                    ForEach(messages) { message in
                        MessageView(message: message)
                            .padding(.horizontal)
                    }
                }
                .onTapGesture {
                    // Make the TextField first responder when tapped
                    isEditing = false
                }
                
                HStack {
                    ZStack {
//                        RoundedRectangle(cornerRadius: 10)
//                            .foregroundColor(Color(.systemGray5))
//                            .frame(height: 70)
                        
//                        TextField("Question", text: $promttf, onEditingChanged: { editing in
//                            isEditing = editing
//                        })
                        HStack{
                            TextField("Question", text: $promttf, axis: .vertical)
                                .focused($isEditing)
                                .textFieldStyle(.roundedBorder)
                                .lineLimit(5)
                                .background(Color.white)
                                .border(Color.gray)
                      
                            
                            Button(action: {
                                sendMessage()
                            }) {
                                Image(systemName: "arrow.up.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.blue)
                                    .padding(.trailing)
                            }
                        }
                        .padding()
                            
                        }//ZStack
                            
                    }//HStack
               
            }//VStack
            .navigationBarTitle("Budget Buddy AI")
            .MyToolbar()
        }//NavStack
    }//body
    
    private func sendMessage() {
            if !promttf.isEmpty {
                let userMessage = ChatMessage(id: UUID(), content: promttf, role: .user)
                messages.append(userMessage)

                // Add a "typing" message
                let typingMessage = ChatMessage(id: UUID(), content: "AI is typing...", role: .assistant)
                messages.append(typingMessage)

                // Clear the input
                promttf = ""

                // Introduce a delay before AI response
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    // Remove the "typing" message
                    if let index = messages.firstIndex(where: { $0.id == typingMessage.id }) {
                        messages.remove(at: index)
                    }

                    // Get the actual AI response
                    self.Answer = self.theopenaiclass.processPrompt(prompt: "\(userMessage.content)") ?? "Error: No answer available"

                    // Add the AI response
                    let aiMessage = ChatMessage(id: UUID(), content: self.Answer, role: .assistant)
                    messages.append(aiMessage)
                }
            } else {
                Answer = "Error: Empty prompt"
            }
        }

}//struct

struct MessageView: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
                Text(message.content)
                    .padding(8)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            } else {
                Text(message.content)
                    .padding(8)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                Spacer()
            }
        }
    }
}

struct AIView_Previews: PreviewProvider {
    static var previews: some View {
        AIView()
    }
}

struct ChatMessage: Identifiable {
    var id: UUID
    var content: String
    var role: Role
}

enum Role {
    case user
    case assistant
}
