//
//  StatsDetailView.swift
//  Quick Screen Journal
//
//  Created by Matt Bartie on 10/30/24.
//

import SwiftUI
import Charts
import SwiftData

struct UsageData: Identifiable {
    let day: String
    let total: Double
    let stopped: Double
    
    var id: String { day }
    
    static var weekExample: [UsageData] {
        let calendar = Calendar.current
        let days = (0..<7).map { daysAgo -> String in
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: Date())!
            return date.formatted(.dateTime.weekday(.abbreviated))
        }.reversed()
        
        return [
            UsageData(day: "1", total: 120, stopped: 45),
            UsageData(day: "2", total: 150, stopped: 60),
            UsageData(day: "3", total: 180, stopped: 75),
            UsageData(day: "4", total: 140, stopped: 50),
            UsageData(day: "5", total: 160, stopped: 70),
            UsageData(day: "6", total: 130, stopped: 40),
            UsageData(day: "7", total: 170, stopped: 65)
        ]
    }
    
}

struct StatsDetailView: View {
    let appName: String
    let openCount: Int
    let notOpenCount: Int
    @Query private var items: [JournalEntry]

    let data = UsageData.weekExample
    let gradientColors = Gradient(colors: [
        Color.accentColor.opacity(0.4),
        Color.accentColor.opacity(0)
    ])
    
    var body: some View {
        VStack {
            Text("Screen Time Stats")
                .font(.largeTitle)
                .bold()
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Your screen time activity for the past week")
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

            let data = returnStats(for: appName)
            VStack {
                Chart {
                    ForEach(data) { item in
                        BarMark(
                            x: .value("Day", item.day),
                            y: .value("Total", item.total - item.stopped)
                        )
                        .foregroundStyle(Color.accentColor.opacity(0.4))
                        
                        BarMark(
                            x: .value("Day", item.day),
                            y: .value("Stopped", item.stopped)
                        )
                        .foregroundStyle(Color.accentColor)
                    }
                }
                .chartLegend(position: .bottom) {
                    HStack {
                        Text("Active Time")
                            .foregroundStyle(Color.accentColor.opacity(0.4))
                        Text("Stopped Time")
                            .foregroundStyle(Color.accentColor)
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .gray.opacity(0.4), radius: 8, x: 0, y: 4)
            )
            .padding()
            Spacer()
        }
    }
    
    func returnStats(for appName: String) -> [UsageData] {
        let calendar = Calendar.current
        let now = Date()
        
        // Filter past data for the specific app and within the last 7 days
        let pastWeekData = SharedData.pastData.filter { entry in
            let daysDifference = calendar.dateComponents([.day], from: entry.date, to: now).day ?? 0
            return entry.appName == appName && daysDifference < 7
        }
        
        // Create an array of the last 7 days with their abbreviated weekday names
        let days = (0..<7).map { daysAgo -> String in
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: now)!
            return date.formatted(.dateTime.weekday(.abbreviated))
        }
        
        // Calculate stats for each day
        return days.enumerated().map { (index, day) in
            let dailyEntries = pastWeekData.filter { entry in
                let entryDay = calendar.dateComponents([.day], from: entry.date)
                let targetDay = calendar.dateComponents([.day], from: calendar.date(byAdding: .day, value: -index, to: now)!)
                
                return entryDay.day == targetDay.day &&
                       entryDay.month == targetDay.month &&
                       entryDay.year == targetDay.year
            }
            
            let total = dailyEntries.count
            let stopped = dailyEntries.filter { !$0.wasOpened }.count
            
            return UsageData(
                day: day,  // Use the abbreviated weekday name instead of a number
                total: Double(total),
                stopped: Double(stopped)
            )
        }
    }
    
   
}

#Preview {
    StatsDetailView(appName: "Instagram", openCount: 23, notOpenCount: 5)
        .frame(maxHeight: .infinity, alignment: .top)
}
