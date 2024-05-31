//
//  ContentView.swift
//  CloudKitIntegration
//
//  Created by Elian Richard on 30/05/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var cloudPersonViewModel: CloudPersonViewModel
    var body: some View {
        NavigationStack {
            VStack {
                Text("My Contacts")
                Button {
                    let newContact = PersonContact(name: "John", dateOfBirth: Date(), favoriteColor: "blue")
                    Task {
                        try await cloudPersonViewModel.addContact(newContact)
                    }
                } label: {
                    Text("Send Contact")
                }
                List {
                    ForEach(cloudPersonViewModel.peopleContact, id: \.self.recordId) { contact in
                        NavigationLink(destination: DetailView(contactPerson: contact), label: {
                            Text(contact.name)
                        })
                    }
                    .onDelete(perform: { indexSet in
                        for index in indexSet {
                            Task {
                                try await cloudPersonViewModel.deleteContact(cloudPersonViewModel.peopleContact[index])
                            }
                        }
                    })
                }
            }
            .padding()
            .onAppear {
                Task {
                    try await cloudPersonViewModel.populateContact()
                }
            }
        }
    }
}

struct DetailView: View {
    @EnvironmentObject private var cloudPersonViewModel: CloudPersonViewModel
    var contactPerson: PersonContact
    @State private var name: String = ""

    var body: some View {
        VStack (alignment: .leading) {
            Text("Name: \(contactPerson.name)")
            Text("Birthday: \(contactPerson.dateOfBirth)")
            Text("Color: \(contactPerson.favoriteColor)")
            TextField(
                "Edit name",
                text: $name
            )
            .onSubmit {
                Task {
                    try await cloudPersonViewModel.editContactName(contactPerson, newName: name)
                }
            }
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .border(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
