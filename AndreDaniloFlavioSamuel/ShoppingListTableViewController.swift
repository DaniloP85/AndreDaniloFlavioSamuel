//
//  ShoppingListTableViewController.swift
//  AndreDaniloFlavioSamuel
//
//  Created by Danilo Santos on 21/02/23.
//

import UIKit
import CoreData

class ShoppingListTableViewController: UITableViewController {
    
    // MARK: - Properties
    var fetchedResultController: NSFetchedResultsController<Product>!
    var label = UILabel()
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProduct()
        label.text = "Sua lista está vazia"
        label.textAlignment = .center
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "productSegue" {
            guard let vc = segue.destination as? AddAndEditProductViewController,
                  let indexPath = tableView.indexPathForSelectedRow else { return }
            
            vc.product = fetchedResultController.object(at: indexPath)
        }
    }
    
    func loadProduct(){
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescritor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedResultController.fetchedObjects?.count ?? 0
        tableView.backgroundView = count == 0 ? label : nil
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductTableViewCell
        
        guard let product = fetchedResultController.fetchedObjects?[indexPath.row] else {
            return cell
        }

        cell.prepare(with: product)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let product = fetchedResultController.fetchedObjects?[indexPath.row] else { return }
            context.delete(product)
            try? context.save()
        }
    }
}

extension ShoppingListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            case .delete:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                break
            default:
                tableView.reloadData()
        }
    }
}
