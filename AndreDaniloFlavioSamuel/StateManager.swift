//
//  StateManager.swift
//  AndreDaniloFlavioSamuel
//
//  Created by Danilo Santos on 22/02/23.
//

import CoreData

class StateManager {
    static let shared = StateManager()
    var states: [State] = []
    
    func loadStates(with context: NSManagedObjectContext){
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "state", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            states = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteConsole(index: Int, context: NSManagedObjectContext){
        let state = states[index]
        context.delete(state)
        
        do {
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    private init(){
        
    }
}
