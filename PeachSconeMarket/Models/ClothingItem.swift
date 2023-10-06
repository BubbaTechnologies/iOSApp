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
        ClothingItem(id:2, name: "GOAT Vintage Upcycled Adidas '80s T-Shirt", imageURL: ["https://www.pacsun.com/dw/image/v2/AAJE_PRD/on/demandware.static/-/Sites-pacsun_storefront_catalog/default/dwc9a7132a/product_images/0702526000029NEW_00_001.jpg?sw=700"], productURL: "https://www.pacsun.com/goat-vintage/upcycled-adidas-80s-t-shirt-0702526000029.html"),
        ClothingItem(id: 3, name: "Holly Asymmetric Straight Leg Jean Green Denim", imageURL: ["https://www.pacsun.com/dw/image/v2/AAJE_PRD/on/demandware.static/-/Sites-pacsun_storefront_catalog/default/dw60bf305b/product_images/0870604270003NEW_00_089.jpg?sw=700","https://www.pacsun.com/dw/image/v2/AAJE_PRD/on/demandware.static/-/Sites-pacsun_storefront_catalog/default/dw30605c47/product_images/0870604270003NEW_02_089.jpg?sw=400"], productURL: "https://www.pacsun.com/ngorder/green-purple-checkerboard-romper-0870604270003.html"),
        ClothingItem(id: 19012, name: "Gymshark Crest Sweatshirt", imageURL: ["https://cdn.shopify.com/s/files/1/0156/6146/products/CrestCrewNavyA2A1V-UBCY-2890.297.jpg?v=1680644147",
           "https://cdn.shopify.com/s/files/1/0156/6146/products/CrestCrewNavyA2A1V-UBCY-2919.298.jpg?v=1680644146",
           "https://cdn.shopify.com/s/files/1/0156/6146/products/CrestCrewNavyA2A1V-UBCY-2921.299.jpg?v=1680644147",
           "https://cdn.shopify.com/s/files/1/0156/6146/products/CrestCrewNavyA2A1V-UBCY-2932.300.jpg?v=1680644147"], productURL: "https://us.shop.gymshark.com/products/gymshark-crest-sweatshirt-navy-ss22"),
        ClothingItem(id: 21793, name: "EVERETT GREY CHECK STRAIGHT TROUSER", imageURL: ["https://cdn.shopify.com/s/files/1/0533/2572/5850/products/B01075.jpg?v=1665592274",
            "https://cdn.shopify.com/s/files/1/0533/2572/5850/products/B01112.jpg?v=1665592289",
            "https://cdn.shopify.com/s/files/1/0533/2572/5850/products/B01120.jpg?v=1665592274",
            "https://cdn.shopify.com/s/files/1/0533/2572/5850/products/B01094.jpg?v=1665592305"], productURL: "https://wearebound.co.uk/collections/all/products/grey-check-straight-trouser?variant=43472640573679"),
        ClothingItem(id: 4997, name: "Travel Trouser", imageURL: ["https://bonobos-prod-s3.imgix.net/products/308296/original/PANT_ELASTIC-WAIST-PANT_BPT11263N1105G_1.jpg?1691031167=&w=750",
               "https://bonobos-prod-s3.imgix.net/products/308297/original/PANT_ELASTIC-WAIST-PANT_BPT11263N1105G_2_hover.jpg?1691031167=&w=750",
               "https://bonobos-prod-s3.imgix.net/products/308298/original/PANT_ELASTIC-WAIST-PANT_BPT11263N1105G_3_category.jpg?1691031167=&w=750",
               "https://bonobos-prod-s3.imgix.net/products/308299/original/PANT_ELASTIC-WAIST-PANT_BPT11263N1105G_4.jpg?1691031167=&w=750",
               "https://bonobos-prod-s3.imgix.net/products/308300/original/PANT_ELASTIC-WAIST-PANT_BPT11263N1105G_20.jpg?1691031167=&w=750",
               "https://bonobos-prod-s3.imgix.net/products/308301/original/PANT_ELASTIC-WAIST-PANT_BPT11263N1105G_40_outfitter.jpg?1691031167=&w=750"], productURL: "https://www.bonobos.com/products/travel-trouser?color=lava%20smoke%20dark%20grey")
    ]
}
