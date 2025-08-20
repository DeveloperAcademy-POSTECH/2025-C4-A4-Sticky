//
//  CalendarSegmentView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI
import SwiftData
import NearbyInteraction

struct CalendarSegmentView: View {
    @StateObject private var viewModel: CalendarSegmentViewModel
    @State private var isModalPresented: Bool = false
    
    @EnvironmentObject private var navigationManager: CHNavigationManager
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(
            wrappedValue: CalendarSegmentViewModel(modelContext: modelContext)
        )
    }

    var body: some View {
       VStack {
           VStack(spacing: 24) {
               monthHeader
               weekdayHeader
               calendarGrid
           }
           .padding(.vertical, 24)
           .background(CHCardBG())
           Spacer()
        }
        .safeAreaPadding(.horizontal, 24)
        .safeAreaPadding(.top, 144)
        .modifier(CHBottomModalModifier(
            isPresented: $isModalPresented,
            minHeight: 200,
            maxHeight: 400
        ) {
            chaapListModal
                .padding(.horizontal, 16)
        })
        .onChange(of: viewModel.selectedDate) { _, _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                isModalPresented = !viewModel.eventsForSelectedDate.isEmpty
            }
        }
    }
    
    private var monthHeader: some View {
        HStack(spacing: 0) {
            Button {
                viewModel.previousMonthWasTapped()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color(hex: "#919191"))
                    .font(.system(size: 16, weight: .medium))
            }
            .disabled(!viewModel.canNavigateMonth(-1))
            
            Spacer()
            
            Text(
                viewModel.monthYearFormatter.string(from: viewModel.currentMonth)
            )
            .font(.chBodyBold)
            .foregroundColor(.white)
            
            Spacer()
            
            Button {
                viewModel.nextMonthWasTapped()
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(hex: "#919191"))
                    .font(.system(size: 16, weight: .medium))
            }
            .disabled(!viewModel.canNavigateMonth(1))
        }
        .frame(width: 160, height: 25)
    }
    
    private var weekdayHeader: some View {
        HStack(alignment: .center, spacing: 33) {
            ForEach(viewModel.weekdays, id: \.self) { weekday in
                Text(weekday)
                    .font(.chPrimaryCaptionRegular)
                    .foregroundColor(Color(hex: "#919191"))
            }
        }
    }
    
    private var calendarGrid: some View {
        let rowCount = Int(ceil(Double(viewModel.daysInMonth.count) / 7.0))

        return VStack(alignment: .center, spacing: 20) {
            ForEach(0..<rowCount, id: \.self) { week in
                HStack(alignment: .center, spacing: 12) {
                    ForEach(0..<7, id: \.self) { day in
                        let index = week * 7 + day
                        if index < viewModel.daysInMonth.count {
                            dayCell(date: viewModel.daysInMonth[index])
                        }
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    minHeight: 36,
                    maxHeight: 36,
                    alignment: .center
                )
            }
        }
    }
    
    private func dayCell(date: Date) -> some View {
        let day = Calendar.current.component(.day, from: date)
        let isSelected = Calendar.current.isDate(
            date,
            inSameDayAs: viewModel.selectedDate
        )
        let isToday = Calendar.current.isDateInToday(date)
        let isCurrentMonth = Calendar.current.isDate(
            date,
            equalTo: viewModel.currentMonth,
            toGranularity: .month
        )

        return Button {
            viewModel.dateWasSelected(date)
        } label: {
            VStack(spacing: 0) {
                ZStack {
                    /// 선택 배경 원 (숫자 텍스트 중앙에 위치)
                    Ellipse()
                        .fill(viewModel.cellBackgroundColor(
                            isSelected: isSelected,
                            isToday: isToday
                        ))
                        .frame(width: 28, height: 27)

                    Text("\(day)")
                        .font(.chPrimaryCaptionRegular)
                        .foregroundColor(viewModel.cellTextColor(
                            for: date,
                            isSelected: isSelected,
                            isToday: isToday,
                            isCurrentMonth: isCurrentMonth
                        ))
                }

                /// 오늘 날짜 표시 (선택되지 않았을 때만)
                if isToday && isCurrentMonth && !isSelected {
                    Text("오늘")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.pointColorPurple)
                } else {
                    /// 빈 공간 유지
                    Text("")
                        .font(.system(size: 9, weight: .medium))
                        .frame(height: 10)
                }
            }
            .frame(width: 35, height: 36)
        }
    }

    private var chaapListModal: some View {
        VStack(spacing: 0) {
            // 챱 목록
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.eventsForSelectedDate, id: \.id) { chaap in
                        Button {
                            if chaap.isEditable {
                                navigationManager.push(.compose(chaap))
                            } else {
                                navigationManager.push(.detail(chaap))
                            }
                        } label: {
                            PeerChaapRow(chaap: chaap)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 12)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

struct CalendarSegmentView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(
            for: Chaap.self,
            Peer.self,
            configurations: config
        )
        
        CalendarSegmentView(modelContext: container.mainContext)
            .background(Color.black)
            .modelContainer(container)
    }
}
