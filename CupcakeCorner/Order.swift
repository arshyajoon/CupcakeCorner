//
//  Order.swift
//  CupcakeCorner
//
//  Created by Arshya GHAVAMI on 2/14/21.
//

import Foundation

struct Order: Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        if name.trimmingCharacters(in: .whitespaces).isEmpty || streetAddress.trimmingCharacters(in: .whitespaces).isEmpty || city.trimmingCharacters(in: .whitespaces).isEmpty || zip.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        
        return true
    }
    
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2
        
        // complicated cakes cost more
        cost += (Double(type) / 2)
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }
        
        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost
    }
}

class OrderClass: ObservableObject {
    @Published var order = Order()
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "Order") {
            if let decoded = try? JSONDecoder().decode(Order.self, from: data) {
                self.order = decoded
                return
            }
        }
        self.order = Order()
    }
    func save() {
        if let encoded = try? JSONEncoder().encode(order) {
            UserDefaults.standard.set(encoded, forKey: "Order")
        }
    }
}


