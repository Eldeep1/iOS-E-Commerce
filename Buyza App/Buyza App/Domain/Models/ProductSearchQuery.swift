

import Foundation

struct ProductSearchQuery: Encodable, Hashable {
    let text: String
    
    var trimmedText: String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isValid: Bool {
        !trimmedText.isEmpty
    }
}