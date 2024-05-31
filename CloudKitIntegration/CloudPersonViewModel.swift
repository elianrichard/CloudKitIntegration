//
//  CloudPersonViewModel.swift
//  CloudKitIntegration
//
//  Created by Elian Richard on 31/05/24.
//

import Foundation
import CloudKit

@Observable class CloudPersonViewModel: ObservableObject {
    private var db = CKContainer(identifier: "iCloud.com.elian.CloudKitIntegration").privateCloudDatabase
    private var personDictionary: [CKRecord.ID: PersonContact] = [:]
    
    var peopleContact: [PersonContact] {
        personDictionary.values.compactMap { $0 }
    }
    
    func addContact(_ personContact: PersonContact) async throws {
        do {
            let record = try await db.save(personContact.record)
            guard let contact = PersonContact(record: record) else { return }
            personDictionary[contact.recordId!] = contact
        } catch {
            print (error)
        }
    }
    
    func editContactName(_ personContact: PersonContact, newName: String) async throws {
        guard let recordId = personContact.recordId else { return }
        do {
            let record = try await db.record(for: recordId)
            record[PersonRecordKeys.name.id] = newName
            let savedRecord = try await db.save(record)
            guard let updatedContact = PersonContact(record: savedRecord) else { return }
            personDictionary[updatedContact.recordId!] = updatedContact
        } catch {
            print(error)
        }
    }
    
    func deleteContact(_ personContact: PersonContact) async throws {
        do {
            try await db.deleteRecord(withID: personContact.recordId!)
            personDictionary.removeValue(forKey: personContact.recordId!)
        } catch {
            print(error)
        }
    }
    
    func populateContact() async throws {
        do {
            let query = CKQuery(recordType: PersonRecordKeys.type.id, predicate: NSPredicate(value: true))
            query.sortDescriptors = [NSSortDescriptor(key: PersonRecordKeys.dateOfBirth.id, ascending: false)]
            let result = try await db.records(matching: query)
            let records = result.matchResults.compactMap { try? $0.1.get() }
            
            records.forEach { record in
                personDictionary[record.recordID] = PersonContact(record: record)
            }
        } catch {
            print(error)
        }
    }
}
