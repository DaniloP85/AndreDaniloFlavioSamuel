//
//  ProductManager.swift
//  AndreDaniloFlavioSamuel
//
//  Created by Danilo Santos on 01/03/23.
//

import CoreData

class ProductManager {
    static let shared = ProductManager()
    var products: [Product] = []
    
    func loadProduct(with context: NSManagedObjectContext, key: String){
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: key, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            products = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteProduct(index: Int, context: NSManagedObjectContext){
        let product = products[index]
        context.delete(product)
        
        do {
            try context.save()
            products.remove(at: index)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    private init(){
        
    }
}
