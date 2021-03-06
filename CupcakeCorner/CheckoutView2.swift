//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Arshya GHAVAMI on 2/14/21.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: OrderClass
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var isShowingAlert = false
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(order.order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                self.isShowingAlert = true
                return
            }
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                self.showingConfirmation = true
            } else {
                print("Invalid response from server")
                self.isShowingAlert = true
            }
        }.resume()
    }
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text("Your total is $\(self.order.order.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    Button("Place Order") {
                        self.placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Check out", displayMode: .inline)
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("No connection"), message: Text("Check your connection and try again"), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showingConfirmation) {
            Alert(title: Text("Thank you!"), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
            
               
        }
    }
}
//    struct CheckoutView_Previews: PreviewProvider {
//        static var previews: some View {
//            CheckoutView(order:  Order())
//        }
//    }
