//
//  Models.swift
//  recipee
//
//  Created by Reema ALhudaian on 24/04/1446 AH.
//
import Foundation
import UIKit

struct Ingredient: Identifiable {
    var id = UUID()
    var name: String
    var amount: Double
    var measurement: String
}

struct Recipe: Identifiable {
    var id = UUID()
    var name: String
    var description: String?
    var ingredients: [Ingredient] = []
    var image: UIImage?
}
