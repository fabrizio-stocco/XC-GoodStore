//
//  ItemListing.swift
//  GoodStore
//
//  Created by Fabrizio Giuliano Stocco Ver 24.001.1 January 12nd 2024
//

import Foundation
import CloudKit

struct ItemListing {
    
    var recordId: CKRecord.ID?
    let title: String
    let price: Decimal
    
    init(recordId: CKRecord.ID? = nil, title: String, price: Decimal) {
        self.title = title
        self.price = price
        self.recordId = recordId
    }
    
    func toDictionary() -> [String: Any] {
        return ["title": title, "price": price]
    }
    
    static func fromRecord(_ record: CKRecord) -> ItemListing? {
        
        guard let title = record.value(forKey: "title") as? String, let price = record.value(forKey: "price") as? Double
        else {
            return nil
        }
        return ItemListing(recordId: record.recordID, title: title, price: Decimal(price))
    }
}
