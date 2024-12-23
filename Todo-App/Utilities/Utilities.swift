//
//  Format.swift
//  Todo-App
//
//  Created by Lê Tiến Đạt on 21/12/2024.
//

import Foundation

class Utilities {
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd'/'MM'/'yyyy"
        formatter.locale = Locale(identifier: "vi_VN")
        return formatter.string(from: date)
    }
}
