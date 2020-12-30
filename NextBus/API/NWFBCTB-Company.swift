//
//  NWFBCTBCompany.swift
//  NextBus
//
//  Created by Julian Schiavo on 20/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

struct NWFBCTBRawCompany: Codable {
    var type: String
    var version: String
    var data: NWFBCTBCompany
    var generated: Date
    
    enum CodingKeys: String, CodingKey {
        case type
        case version
        case data
        case generated = "generated_timestamp "
    }
    
    var company: Company {
        Company(id: data.id, generated: generated, englishName: data.englishName, simplifiedChineseName: data.simplifiedChineseName, traditionalChineseName: data.traditionalChineseName)
    }
}

struct NWFBCTBCompany: Hashable, Codable, Identifiable {
    var id: CompanyID
    
    var englishName: String
    var simplifiedChineseName: String
    var traditionalChineseName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "co"
        case englishName = "name_en"
        case simplifiedChineseName = "name_sc"
        case traditionalChineseName = "name_tc"
    }
}
