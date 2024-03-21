//
//  ContentView.swift
//  GoodStore
//
//  Created by Fabrizio Giuliano Stocco Ver 24.003.1 20240321.
//

import SwiftUI
import CloudKit

struct ContentView: View {
    
    @StateObject private var vm: ItemListViewModel
    
    @State private var title: String = ""
    @State private var price: String = ""
    
    init(vm: ItemListViewModel){
        _vm = StateObject(wrappedValue: vm)
    }
    
    func deleteItem(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let item = vm.items[index]
            if let recordId = item.recordID {
                vm.deleteItem(recordId)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter Title", text: $title).textFieldStyle(.roundedBorder)
                TextField("Enter Price", text: $price).textFieldStyle(.roundedBorder)
                
                Button("Save") {
                    
                    guard let price = try? Decimal(price, format: .number) else { return }
                    
                    vm.saveItem(title: title, price: price)
                    
                    self.title = ""
                    self.price = ""   
                    
                }.disabled(title.trimmingCharacters(in: .whitespaces).isEmpty ||
                           price.trimmingCharacters(in: .whitespaces).isEmpty)
                
                Spacer()
                
                List {
                    ForEach(vm.items, id: \.recordID) { item in
                        HStack {
                            Text(item.title)
                            Spacer()
                            Text ("$" + String(describing: item.price))
                        }
                    }.onDelete(perform: deleteItem)
                }
                .navigationTitle("Good Store")
                
            }.padding()
                .onAppear {
                    vm.popolateItems()
                }
        }.navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView(vm: ItemListViewModel(container: CKContainer.default()))
}

