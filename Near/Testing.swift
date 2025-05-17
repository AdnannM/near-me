//
//  Testing.swift
//  Near
//
//  Created by Adnann Muratovic on 17.05.25.
//

import SwiftUI

struct TodoItems: Identifiable, Hashable {
    var id: UUID
    var name: String
    var email: String
    var date: Date
}

@Observable
class TodoViewModel {
     var todoItems: [TodoItems] = []
    
    func addTodoItem(name: String, email: String, date: Date) {
        todoItems.append(TodoItems(id: UUID(), name: name, email: email, date: Date()))
    }
    
    func deleteItem(at offsets: IndexSet) {
        todoItems.remove(atOffsets: offsets)
    }

}


import SwiftUI

struct Todo: View {
    @State private var viewModel = TodoViewModel()
    @State private var showAddView = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.todoItems) { item in
                    VStack(alignment: .leading) {
                        Text(item.name).font(.headline)
                        Text(item.email).font(.subheadline).foregroundColor(.secondary)
                        Text(item.date.formatted(date: .long, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete { offsets in
                    viewModel.deleteItem(at: offsets)
                }

            }
            
            .navigationTitle("Todo List")
            .toolbar {
                Button(action: {
                    showAddView = true
                }) {
                    Label("Add", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showAddView) {
                AddTodoView(viewModel: viewModel)
            }
        }
    }
}

import SwiftUI

struct AddTodoView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: TodoViewModel
    
    @State private var name = ""
    @State private var email = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Details")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("New Todo")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.addTodoItem(name: name, email: email, date: date)
                        dismiss()
                    }
                    .disabled(name.isEmpty || email.isEmpty)
                }
            }
        }
    }
}

#Preview {
    Todo()
}
