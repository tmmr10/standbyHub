import SwiftUI
import WidgetKit

struct SmartDashboardView: View {
    let entry: DashboardEntry

    private var enabledSlots: [DashboardSlotData] {
        entry.settings.dashboardSlots
            .filter { $0.enabled }
            .sorted { $0.position < $1.position }
    }

    var body: some View {
        HStack(spacing: 12) {
            ForEach(enabledSlots.prefix(3), id: \.type) { slot in
                slotView(for: slot)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(OLEDColors.trueBlack)
    }

    @ViewBuilder
    private func slotView(for slot: DashboardSlotData) -> some View {
        switch slot.type {
        case "calendar":
            CalendarSlotView(theme: entry.theme)
        case "weather":
            WeatherSlotView(theme: entry.theme)
        case "battery":
            BatterySlotView(theme: entry.theme)
        default:
            EmptyView()
        }
    }
}
