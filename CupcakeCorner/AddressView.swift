//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Arshya GHAVAMI on 2/14/21.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: OrderClass
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.order.name)
                TextField("Street Address", text: $order.order.streetAddress)
                TextField("City", text: $order.order.city)
                TextField("Zip", text: $order.order.zip)
            }

            Section {
                NavigationLink(destination: CheckoutView(order: order)) {
                    Text("Check out")
                }
            }
            .disabled(order.order.hasValidAddress == false)
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)    }
}

//struct AddressView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddressView(order: Order())
//    }
//}
