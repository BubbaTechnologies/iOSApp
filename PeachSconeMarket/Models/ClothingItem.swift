//
//  ClothingItem.swift
//  Bubba
//
//  Created by Matt Groholski on 11/2/22.
//
import Foundation

struct ClothingItem: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let imageURL: [String]
    let productURL: String
    
    init() {
        self.id = -1
        self.name = ""
        self.imageURL = []
        self.productURL = ""
    }
    
    init (id: Int, name: String, imageURL: [String], productURL: String) {
        self.id  = id
        self.name = name
        self.imageURL = imageURL
        self.productURL = productURL
    }
}


extension ClothingItem {
    static let sampleItems: [ClothingItem] = [
        ClothingItem(id: 12695, name: "Kate Pictures 1", imageURL: [
            "https://d5spi2ikipycd.cloudfront.net/kate1/IMG_5878.jpeg",
            "https://d5spi2ikipycd.cloudfront.net/kate1/IMG_5944.jpeg"
        ], productURL: "https://www.taylorstitch.com/collections/the-agave-edit/products/slim-jean-in-black-3-month-wash-selvage-2111"),
        ClothingItem(id: 3882, name:"Megan Pictures", imageURL: [
            "https://d5spi2ikipycd.cloudfront.net/megan1/IMG_6300.jpeg",
            "https://d5spi2ikipycd.cloudfront.net/megan1/IMG_6325.jpeg",
            "https://d5spi2ikipycd.cloudfront.net/megan1/IMG_6340.jpeg",
            "https://d5spi2ikipycd.cloudfront.net/megan1/IMG_6389.jpeg",
            "https://d5spi2ikipycd.cloudfront.net/megan1/IMG_6409.jpeg"
        ], productURL: "https://us.princesspolly.com/products/hale-midi-skirt-black-white-curve"),
        ClothingItem(id: 615, name: "Kate Pictures 2", imageURL: [
        "https://d5spi2ikipycd.cloudfront.net/kate2/IMG_6691.jpeg",
        "https://d5spi2ikipycd.cloudfront.net/kate2/IMG_6685.jpeg",
        "https://d5spi2ikipycd.cloudfront.net/kate2/IMG_6751.jpeg"
        ], productURL: "https://www.bonobos.com/products/fielder-lightweight-anorak?color=light%20blue"),
        ClothingItem(id: 1, name: "Saltwater Slub Pocket Tee", imageURL:["https://cdn.shopify.com/s/files/1/2445/4975/products/1210096_Saltwater_Slub_Pocket_Tee_FDO_1.jpg?v=1678729658","https://cdn.shopify.com/s/files/1/2445/4975/products/FDO_SWT_44a05eca-3021-45d3-92ef-346bc23a079f.png?v=1682451906","https://cdn.shopify.com/s/files/1/2445/4975/files/1210096_Saltwater_Slub_Pocket_Tee_FDO_1.jpg?v=1682451906","https://cdn.shopify.com/s/files/1/2445/4975/products/1210096_Saltwater_Slub_Pocket_Tee_FDO_3.jpg?v=1682451906"], productURL: "https://www.outerknown.com/products/saltwater-slub-pocket-tee-faded-olive"),
        ClothingItem(id:2, name: "GOAT Vintage Upcycled Adidas '80s T-Shirt", imageURL: ["https://www.pacsun.com/dw/image/v2/AAJE_PRD/on/demandware.static/-/Sites-pacsun_storefront_catalog/default/dwc9a7132a/product_images/0702526000029NEW_00_001.jpg?sw=700"], productURL: "https://www.pacsun.com/goat-vintage/upcycled-adidas-80s-t-shirt-0702526000029.html"),
        ClothingItem(id: 3, name: "Holly Asymmetric Straight Leg Jean Green Denim", imageURL: ["https://www.pacsun.com/dw/image/v2/AAJE_PRD/on/demandware.static/-/Sites-pacsun_storefront_catalog/default/dw60bf305b/product_images/0870604270003NEW_00_089.jpg?sw=700","https://www.pacsun.com/dw/image/v2/AAJE_PRD/on/demandware.static/-/Sites-pacsun_storefront_catalog/default/dw30605c47/product_images/0870604270003NEW_02_089.jpg?sw=400"], productURL: "https://www.pacsun.com/ngorder/green-purple-checkerboard-romper-0870604270003.html")
    ]
}
