//
//  DateFormatter.swift
//  NextBus
//
//  Created by Julian Schiavo on 19/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import Foundation

//class LastUpdatedDateFormatter: DateFormatter {
//    init() {
//        super.init()
//        dateStyle = 
//    }
//}

extension JSONDecoder.DateDecodingStrategy {
    static let dateSpaceTime: JSONDecoder.DateDecodingStrategy = .custom { decoder -> Date in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        guard let date = DateFormatter.dateSpaceTime.date(from: string)
        else { throw DecodingError.dataCorruptedError(in: container, debugDescription: "Failed to decode \(string) as a Date-Space-Time formatted date.") }
        return date
    }
}

extension DateFormatter {
    static let dateSpaceTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Hong_Kong")
        return formatter
    }()
    static let iso8601FractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}

extension JSONDecoder.DateDecodingStrategy {
    static let iso8601FractionalSeconds: Self = .custom { decoder -> Date in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        guard let date = DateFormatter.iso8601FractionalSeconds.date(from: string)
        else { throw DecodingError.dataCorruptedError(in: container, debugDescription: "Failed to decode \(string) as a ISO8601 formatted date.") }
        return date
    }
}
