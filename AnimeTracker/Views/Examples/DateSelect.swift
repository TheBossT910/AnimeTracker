//
//  DateSelect.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-03-20.
//

import SwiftUI

struct DateSelect: View {
    @State private var date = Date()
    
    var body: some View {
        DatePicker(
            "Week",
            selection: $date,
            displayedComponents: [.date]
        )
        .datePickerStyle(.compact)
    }
}

#Preview {
    DateSelect()
}
