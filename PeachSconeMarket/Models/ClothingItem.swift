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
        //The Matlow Short in Arid Eucalyptus Washed Herringbone
        ClothingItem(id: 13511, name: "The Matlow Short", imageURL:  [
            "https://cdn.shopify.com/s/files/1/0070/1922/files/The_Matlow_Short_AridEucalyptusWashedHerringbone_Front.jpg?v=1683920710",
            "https://cdn.shopify.com/s/files/1/0070/1922/files/instock_m_q223_MatlowShort_AridEucalyptus_002.jpg?v=1683920710",
            "https://cdn.shopify.com/s/files/1/0070/1922/files/instock_m_q223_MatlowShort_AridEucalyptus_001.jpg?v=1683920710",
            "https://cdn.shopify.com/s/files/1/0070/1922/files/instock_m_q223_MatlowShort_AridEucalyptus_003.jpg?v=1683920710",
            "https://cdn.shopify.com/s/files/1/0070/1922/files/The_Matlow_Short_AridEucalyptusWashedHerringbone_Back.jpg?v=1683920710",
            "https://cdn.shopify.com/s/files/1/0070/1922/files/The_Matlow_Short_AridEucalyptusWashedHerringbone_Detail2.jpg?v=1683920710",
            "https://cdn.shopify.com/s/files/1/0070/1922/files/The_Matlow_Short_AridEucalyptusWashedHerringbone_Detail1.jpg?v=1683920710"
        ], productURL: "https://www.taylorstitch.com/collections/organic-cotton/products/matlow-short-in-arid-eucalyptus-washed-herringbone-2305"),
        ClothingItem(id: 3882, name:"Sherpa Pullover", imageURL: [
            "https://cdn.shopify.com/s/files/1/2362/2159/products/sherpapullovergreenfront.jpg?v=1671159400",
            "https://cdn.shopify.com/s/files/1/2362/2159/products/sherpapullovergreendetail1.jpg?v=1671159400",
            "https://cdn.shopify.com/s/files/1/2362/2159/products/sherpapullovergreenback.jpg?v=1671159400",
            "https://cdn.shopify.com/s/files/1/2362/2159/products/sherpapullovergreendetail2.jpg?v=1671159399"
        ], productURL: "https://cherryla.com/collections/shop/products/sherpa-pullover-green"),
        ClothingItem(id: 615, name: "Accolade Hoodie", imageURL: [
            "https://cdn.shopify.com/s/files/1/2185/2813/products/U3032RG_03299_b1_s3_a1_1_m75.jpg?v=1681411157",
            "https://cdn.shopify.com/s/files/1/2185/2813/products/U3032RG_03299_b1_s3_a2_1_m75.jpg?v=1681411157",
            "https://cdn.shopify.com/s/files/1/2185/2813/products/U3032RG_03299_b1_s3_a3_1_m75.jpg?v=1681411157",
            "https://cdn.shopify.com/s/files/1/2185/2813/products/U3032RG_03299_b1_s3_a4_1_m75.jpg?v=1681411157",
            "https://cdn.shopify.com/s/files/1/2185/2813/products/U3032RG_03299_b1_s3_a4_2_m75.jpg?v=1681411157"
        ], productURL: "https://www.aloyoga.com/products/u3032rg-accolade-hoodie-ivory-mens"),
        ClothingItem(id: 1, name: "Saltwater Slub Pocket Tee", imageURL:["https://cdn.shopify.com/s/files/1/2445/4975/products/1210096_Saltwater_Slub_Pocket_Tee_FDO_1.jpg?v=1678729658","https://cdn.shopify.com/s/files/1/2445/4975/products/FDO_SWT_44a05eca-3021-45d3-92ef-346bc23a079f.png?v=1682451906","https://cdn.shopify.com/s/files/1/2445/4975/files/1210096_Saltwater_Slub_Pocket_Tee_FDO_1.jpg?v=1682451906","https://cdn.shopify.com/s/files/1/2445/4975/products/1210096_Saltwater_Slub_Pocket_Tee_FDO_3.jpg?v=1682451906"], productURL: "https://www.outerknown.com/products/saltwater-slub-pocket-tee-faded-olive"),
        ClothingItem(id:2, name: "GOAT Vintage Upcycled Adidas '80s T-Shirt", imageURL: ["https://www.pacsun.com/dw/image/v2/AAJE_PRD/on/demandware.static/-/Sites-pacsun_storefront_catalog/default/dwc9a7132a/product_images/0702526000029NEW_00_001.jpg?sw=700"], productURL: "https://www.pacsun.com/goat-vintage/upcycled-adidas-80s-t-shirt-0702526000029.html"),
        ClothingItem(id: 3, name: "Holly Asymmetric Straight Leg Jean Green Denim", imageURL: ["https://www.pacsun.com/dw/image/v2/AAJE_PRD/on/demandware.static/-/Sites-pacsun_storefront_catalog/default/dw60bf305b/product_images/0870604270003NEW_00_089.jpg?sw=700","https://www.pacsun.com/dw/image/v2/AAJE_PRD/on/demandware.static/-/Sites-pacsun_storefront_catalog/default/dw30605c47/product_images/0870604270003NEW_02_089.jpg?sw=400"], productURL: "https://www.pacsun.com/ngorder/green-purple-checkerboard-romper-0870604270003.html")
    ]
}
