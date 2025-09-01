//
//  CustomDatePickers.swift
//  ChickenFeed
//
//  Created by Кирилл Архипов on 28.06.2025.
//

import SwiftUI

extension Date {
    func setTimeBasedOn(procedureTime: ProcedureTime) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: self)

        switch procedureTime {
        case .morning:
            components.hour = 6
            components.minute = 0
        case .day:
            components.hour = 12
            components.minute = 0
        case .evening:
            components.hour = 18
            components.minute = 0
        }

        return calendar.date(from: components) ?? self
    }
}

struct CustomDatePickerSheet: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Text("Select Date")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.textDark)
                    .padding(.top, 30)
                Spacer()
                DatePicker(
                    "Select Date and Time",
                    selection: $selectedDate
                )
                .datePickerStyle(.compact)
                .labelsHidden()
                .colorScheme(.light)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.blueMain)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                .grayMain
            )
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    CustomDatePickerSheet(selectedDate: .constant(.now))
}
