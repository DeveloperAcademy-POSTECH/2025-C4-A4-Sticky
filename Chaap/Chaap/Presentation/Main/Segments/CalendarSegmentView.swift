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
           VStack(spacing: 16) {
               monthHeader
               VStack(spacing: 5) {
                   weekdayHeader
                   calendarGrid
               }
           }
           .padding(.vertical, 32)
           .background(CHCardBG())
           Spacer()
        }
        .safeAreaPadding(.horizontal, 16)
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
        HStack(alignment: .center, spacing: 0) {
            ForEach(viewModel.weekdays, id: \.self) { weekday in
                Text(weekday)
                    .font(.chPrimaryCaptionRegular)
                    .foregroundColor(Color(hex: "#919191"))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16.5)
            }
        }
    }
    
    private var calendarGrid: some View {
        let rowCount = Int(ceil(Double(viewModel.daysInMonth.count) / 7.0))
        
        return VStack(alignment: .center, spacing: 5) {
            ForEach(0..<rowCount, id: \.self) { week in
                HStack(alignment: .center, spacing: 0) {
                    ForEach(0..<7, id: \.self) { day in
                        let index = week * 7 + day
                        if index < viewModel.daysInMonth.count {
                            dayCell(date: viewModel.daysInMonth[index])
                        }
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    minHeight: 46.85,
                    maxHeight: 46.85,
                    alignment: .center
                )
            }
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 {
                        viewModel.nextMonthWasTapped()
                    } else if value.translation.width > 50 {
                        viewModel.previousMonthWasTapped()
                    }
                }
        )
    }
    
    private func dayCell(date: Date) -> some View {
        let day = Calendar.current.component(.day, from: date)
        let isSelected = viewModel.selectedDate.map {
            Calendar.current.isDate(date, inSameDayAs: $0)
        } ?? false
        let isToday = Calendar.current.isDateInToday(date)
        let isCurrentMonth = Calendar.current.isDate(
            date,
            equalTo: viewModel.currentMonth,
            toGranularity: .month
        )

        let hasEvents = viewModel.hasEvents(on: date)
        
        return Button {
            if hasEvents {
                viewModel.dateWasSelected(date)
                isModalPresented = !viewModel.eventsForSelectedDate.isEmpty
            }
        } label: {
            ZStack {
                Ellipse()
                    .fill(viewModel.cellBackgroundColor(
                        isSelected: isSelected,
                        isToday: isToday
                    ))
                    .frame(width: 37, height: 36)
                    .padding(.vertical, 5.43)
                    .padding(.horizontal, 4.93)
                
                Text("\(day)")
                    .font(.chPrimaryCaptionRegular)
                    .lineHeight(1.4, fontSize: 16)
                    .foregroundColor(viewModel.cellTextColor(
                        for: date,
                        isSelected: isSelected,
                        isToday: isToday,
                        hasEvents: hasEvents,
                        isCurrentMonth: isCurrentMonth
                    ))
                
                if isToday && isCurrentMonth && !isSelected {
                    Text("오늘")
                        .font(.chSecondaryCaptionMedium)
                        .foregroundColor(.chPointColorPurple)
                        .padding(.top, 34)
                        .padding(.bottom, 3)
                }
            }
        }
        .disabled(!hasEvents)
    }

    private var chaapListModal: some View {
        VStack(spacing: 0) {
            Capsule()
                .frame(width: 40, height: 4)
                .foregroundColor(.white)
                .padding(.bottom, 12)
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(viewModel.eventsForSelectedDate, id: \.id) { chaap in
                        Button {
                            if chaap.isEditable {
                                navigationManager.push(.compose(chaap))
                            } else {
                                navigationManager.push(.detail(chaap))
                            }
                        } label: {
                            PeerChaapRow(chaap: chaap)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .scrollIndicators(.hidden)
        }
    }
}
