//
//  CoreDataManager.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 06/11/25.
//


import Foundation
import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "BirreDaManicomio") // Nome del tuo model .xcdatamodeld
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("CoreData failed to load: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext { container.viewContext }

    // MARK: - Products
    func saveProducts(_ products: [Product]) {
        DispatchQueue.global(qos: .background).async {
            let context = self.container.newBackgroundContext()
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

            for p in products {
                let cdProduct = CDProduct(context: context)
                cdProduct.productID = Int64(p.id)
                cdProduct.name = p.name
                cdProduct.desc = p.description
                cdProduct.shortDesc = p.short_description
                cdProduct.imageURL = p.images?.first?.src
                cdProduct.priceHTML = p.price_html
            }

            do {
                try context.save()
            } catch {
                print("Failed to save products: \(error)")
            }
        }
    }
    
    func fetchProducts() -> [Product] {
        let request: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        do {
            let results = try context.fetch(request)
            return results.map { cd in
                Product(
                    id: Int(bitPattern: cd.id),
                    name: cd.name ?? "",
                    description: cd.desc,
                    short_description: cd.shortDesc,
                    images: cd.imageURL != nil ? [ProductImage(src: cd.imageURL)] : [],
                    price_html: cd.priceHTML,
                    beerType: Int(cd.beerType)
                )
            }
        } catch {
            print("Failed to fetch products: \(error)")
            return []
        }
    }

    // MARK: - Categories
    func saveCategories(_ categories: [Category]) {
        DispatchQueue.global(qos: .background).async {
            let context = self.container.newBackgroundContext()
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

            for c in categories {
                let cdCat = CDCategory(context: context)
                cdCat.categoryID = Int64(c.id)
                cdCat.name = c.name
                cdCat.slug = c.slug
            }

            do {
                try context.save()
            } catch {
                print("Failed to save categories: \(error)")
            }
        }
    }
    
    func fetchCategories() -> [Category] {
        let request: NSFetchRequest<CDCategory> = CDCategory.fetchRequest()
        do {
            let results = try context.fetch(request)
            return results.map { cd in
                Category(
                    id: Int(bitPattern: cd.id),
                    name: cd.name ?? "",
                    slug: cd.slug
                )
            }
        } catch {
            print("Failed to fetch categories: \(error)")
            return []
        }
    }
}
