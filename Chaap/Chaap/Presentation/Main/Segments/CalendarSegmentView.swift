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
    @State private var showChaapDetail = false
    @State private var selectedChaap: Chaap?
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(
            wrappedValue: CalendarSegmentViewModel(modelContext: modelContext)
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(alignment: .center, spacing: 16) {
                monthHeader
                
                VStack(alignment: .leading, spacing: 5) {
                    weekdayHeader
                    calendarGrid
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                eventsList
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
    }
    
    private var monthHeader: some View {
        HStack {
            Spacer()

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

            Spacer()
        }
        .padding(0)
        .frame(width: 160, alignment: .center)
    }
    
    private var weekdayHeader: some View {
        HStack(alignment: .center) {
            ForEach(viewModel.weekdays, id: \.self) { weekday in
                Spacer()
                Text(weekday)
                    .font(.chPrimaryCaptionRegular)
                    .foregroundColor(Color(hex: "#919191"))
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .frame(
            maxWidth: .infinity,
            minHeight: 36,
            maxHeight: 36,
            alignment: .center
        )
    }
    
    private var calendarGrid: some View {
        VStack(alignment: .center, spacing: 5) {
            ForEach(0..<6, id: \.self) { week in
                HStack(alignment: .center) {
                    ForEach(0..<7, id: \.self) { day in
                        Spacer()
                        let index = week * 7 + day
                        if index < viewModel.daysInMonth.count {
                            dayCell(date: viewModel.daysInMonth[index])
                        } else {
                            Spacer()
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
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
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.chPrimary)
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

    //TODO: Custom Modal로 변경해야 함.
    private var eventsList: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.eventsForSelectedDate, id: \.id) { chaap in
                    PeerChaapRow(chaap: chaap)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 6)
                        .onTapGesture {
                            selectedChaap = chaap
                            showChaapDetail = true
                        }
                    
                    if chaap.id != viewModel.eventsForSelectedDate.last?.id {
                        Divider()
                            .padding(.leading, 38)
                    }
                }
            }
        }
        .padding(.top, 6)
        .frame(maxHeight: 150)
        .chBottomModal(isPresented: $showChaapDetail) {
            if let selectedChaap = selectedChaap {
                CHCardShow(viewModel: CHCardShowViewModel(chaap: selectedChaap))
                    .frame(height: 400)
            }
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
