//
//  RemindCareWidget.swift
//  RemindCareWidget
//
//  Created by Evelyn Lie on 23/11/2023.
//

import WidgetKit
import SwiftUI

// place app stuff in timelineprovider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DayEntry {
        DayEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (DayEntry) -> ()) {
        let entry = DayEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DayEntry] = []
  
//        app snapshot stuff for when the widget updates
        let currentDate = Date()
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
//            let startOfDate = Calendar.current.startOfDay(for: entryDate)
            let entry = DayEntry(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct DayEntry: TimelineEntry {
    let date: Date
}

// how do we make hourly update? hourly because medication may need to be taken every 2 hours to 4 to 12 hours.
//struct HourEntry: TimelineEntry {
//    let hour: Hour
//}

struct RemindCareWidgetEntryView : View {
    var entry: DayEntry
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(Color.customBlue)
            
            VStack {
                HStack(spacing: 4) {
                    Text("💉")
                        .font(.title)
                    Text(entry.date.weekdayDisplayFormat)
                        .font(.title3)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .minimumScaleFactor(0.6)
                        .foregroundColor(.white.opacity(0.6))
                    Spacer()
                }
                Text(entry.date.dayDisplayFormat)
                    .font(.system(size: 80, weight: .heavy))
                    .foregroundColor(.white.opacity(80))
            }
            .padding(2)
        }
        .containerBackground(for: .widget) {
            Color.customGrey
        }
    }
}

@main
struct RemindCareWidget: Widget {
    let kind: String = "RemindCareWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RemindCareWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("RemindCare Widget")
        .description("The widget changes chnages with the day.")
        .supportedFamilies([.systemMedium])
    }
}

extension Date {
    var weekdayDisplayFormat: String {
        self.formatted(.dateTime.weekday(.wide))
    }
    
    var dayDisplayFormat: String {
        self.formatted(.dateTime.day())
    }
}

struct RemindCarw_Previews: PreviewProvider {
    static var previews: some View {
        RemindCareWidgetEntryView(entry: DayEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
