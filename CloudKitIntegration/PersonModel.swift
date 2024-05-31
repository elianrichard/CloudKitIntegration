//
//  PersonModel.swift
//  CloudKitIntegration
//
//  Created by Elian Richard on 31/05/24.
//

import Foundation
import CloudKit

enum PersonRecordKeys: String {
    case type
    case name
    case dateOfBirth
    case favoriteColor
    
    var id: String {
        switch self {
        case .type: "PersonType" /*This string will be shown in the CloudKit Container as the identifier for the person model type*/
        case .name: "name" /*This string will be the identifier for the person's name value*/
        case .dateOfBirth: "dateOfBirth" /*This string will be the identifier for the person's dob value*/
        case .favoriteColor: "favoriteColor" /*This string will be the identifier for the person's favorite color value*/
        }
    }
}

// The person contact attributes type
struct PersonContact {
    var recordId: CKRecord.ID?
    let name: String
    let dateOfBirth: Date
    let favoriteColor: String
}

// Create a new PersonContact based on the record recieved from CloudKit container
extension PersonContact {
    init?(record: CKRecord) {
        guard let name = record[PersonRecordKeys.name.id] as? String,
              let dateOfBirth = record[PersonRecordKeys.dateOfBirth.id] as? Date,
              let favoriteColor = record[PersonRecordKeys.favoriteColor.id] as? String else {
            return nil
        }
        self.init(recordId: record.recordID, name: name, dateOfBirth: dateOfBirth, favoriteColor: favoriteColor)
    }
}

// New attribute model type based on other value. This variable will be used when inserting data to CloudKit container
extension PersonContact {
    var record: CKRecord {
        let record = CKRecord(recordType: PersonRecordKeys.type.id)
        record[PersonRecordKeys.name.id] = name
        record[PersonRecordKeys.dateOfBirth.id] = dateOfBirth
        record[PersonRecordKeys.favoriteColor.id] = favoriteColor
        return record
    }
}
