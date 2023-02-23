//
//  ViewController+CoreData.swift
//  AndreDaniloFlavioSamuel
//
//  Created by Danilo Santos on 21/02/23.
//


import UIKit
import CoreData

extension UIViewController {
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
