//
//  CoreDataManager.swift
//  Conversor de moeda
//
//  Created by vinicius dev on 23/12/19.
//  Copyright © 2019 vinicius dev. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ConversorHistorico")
        container.loadPersistentStores(completionHandler: { _, error in
            _ = error.map { fatalError("Unresolved error \($0)") }
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func backgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    func loadHistorico() -> [Historico] {
        let mainContext = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<Historico> = Historico.fetchRequest()
        do {
            let results = try mainContext.fetch(fetchRequest)
            return results
        }
        catch {
            debugPrint(error)
            return []
        }
    }
    
    func saveHistorico(data: Date,moedaDestino: String, moedaDestinoValor: Double, moedaOrigem: String, valorInformado: Double) {
        let context = CoreDataManager.shared.backgroundContext()
        context.perform {
            let entity = Historico.entity()
            let historico = Historico(entity: entity, insertInto: context)
            historico.data = data
            historico.moedaDestino = moedaDestino
            historico.moedaDestinoValor = moedaDestinoValor
            historico.moedaOrigem = moedaOrigem
            historico.valorInformado = valorInformado
            do {
                try context.save()
            } catch {
                return
            }
        }
    }
    
}
