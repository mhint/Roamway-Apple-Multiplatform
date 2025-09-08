import SwiftUI

struct JourneyDateRangeView: View {
    let startDate: Date
    let endDate: Date
    @Environment(\.font) private var envFont
    
    var body: some View {
        Text(dateRangeText)
            .font(envFont ?? .title3)
    }
    
    private var dateRangeText: String {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let startYear = calendar.component(.year, from: startDate)
        let endYear = calendar.component(.year, from: endDate)
        
        if calendar.isDate(startDate, inSameDayAs: endDate) {
            let showYear = startYear != currentYear
            let singleFormat: Date.FormatStyle = showYear
                ? .dateTime.weekday(.abbreviated).month(.abbreviated).day().year()
                : .dateTime.weekday(.abbreviated).month(.abbreviated).day()
            
            return startDate.formatted(singleFormat)
        }
        
        let showYears = (startYear != currentYear) || (endYear != currentYear)
        
        let rangeFormat: Date.FormatStyle = showYears
            ? .dateTime.year().month(.abbreviated).day()
            : .dateTime.month(.abbreviated).day()
        
        return "\(startDate.formatted(rangeFormat)) – \(endDate.formatted(rangeFormat))"
    }
}

