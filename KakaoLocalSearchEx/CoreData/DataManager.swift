//
//  DataManager.swift
//  KakaoLocalSearchEx
//
//  Created by 민트팟 on 2021/07/05.
//

import Foundation
import CoreData


class DataManager {
    
    // 싱글톤 구현
    static let shared = DataManager()

    private init() {
        
    }

    var mainContenxt: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    var LocationList = [Location]()
    var MapLocationList = [Location]()
    
    // 데이터베이스 조회
    func fetchLocation(_ searchKey: String? = nil) {
        let allLocationTf = searchKey == nil ? true : false
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        // 날짜순내림차순
        
        if let searchKey = searchKey, searchKey != "" {
            let predicate = NSPredicate(format: "address CONTAINS[c] %@", searchKey)
            request.predicate = predicate
        }
        
        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        do {
            if allLocationTf {
                MapLocationList = try mainContenxt.fetch(request)
            }else {
                LocationList = try mainContenxt.fetch(request)
            }
            
        } catch {
            print(error)
        }
        
    }
    
    func addNewLocation(_ location: PlaceInfo) {
        let newLocation = Location(context: mainContenxt)
        newLocation.address = location.addressName
        newLocation.latitude = location.latitudeY
        newLocation.longitude = location.longitudeX
        newLocation.insertDate = Date()
        
        LocationList.insert(newLocation, at: 0)
        saveContext()
    }
    
    func deleteLocation(_ location: Location?) {
        
        guard let location = location else {
            return
        }
        
        mainContenxt.delete(location)
        saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "KakaoLocalSearchEx")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
