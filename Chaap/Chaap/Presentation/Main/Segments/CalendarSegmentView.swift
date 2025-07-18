//
//  CalendarSegmentView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI

struct CalendarSegmentView: View {
    @StateObject private var viewModel = CalendarSegmentViewModel()
    
    var body: some View {
        ZStack {
            // 전체화면 배경
            Color.gray.opacity(0.2)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                Spacer()
                
                VStack(alignment: .center, spacing: 16) {
                    monthHeader
                    
                    VStack(alignment: .leading, spacing: 5) {
                        weekdayHeader
                        calendarGrid
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 0)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    eventsList
                }
                .padding(0)
                .frame(width: 360, alignment: .top)
                
                Spacer()
            }
        }
    }
    
    private var monthHeader: some View {
        HStack {
            Spacer()
            
            HStack(spacing: 0) {
                Button {
                    viewModel.changeMonth(-1)
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(hex: "#919191"))
                        .font(.system(size: 16, weight: .medium))
                }
                .disabled(!viewModel.canNavigateMonth(-1))
                
                Spacer()
                
                Text(viewModel.monthYearFormatter.string(from: viewModel.currentMonth))
                    .font(.chBodyBold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button {
                    viewModel.changeMonth(1)
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
        HStack(alignment: .center, spacing: 10) {
            ForEach(viewModel.weekdays, id: \.self) { weekday in
                Text(weekday)
                    .font(.chPrimaryCaptionRegular)
                    .foregroundColor(Color(hex: "#919191"))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, minHeight: 36, maxHeight: 36, alignment: .center)
    }
    
    private var calendarGrid: some View {
        VStack(alignment: .center, spacing: 5) {
            ForEach(0..<6, id: \.self) { week in
                HStack(alignment: .center, spacing: 10) {
                    ForEach(0..<7, id: \.self) { day in
                        let index = week * 7 + day
                        if index < viewModel.daysInMonth.count {
                            dayCell(date: viewModel.daysInMonth[index])
                        } else {
                            Spacer()
                        }
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity, minHeight: 36, maxHeight: 36, alignment: .center)
            }
        }
    }
    
    private func dayCell(date: Date) -> some View {
        let day = Calendar.current.component(.day, from: date)
        let isSelected = Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate)
        let isToday = Calendar.current.isDateInToday(date)
        let isCurrentMonth = Calendar.current.isDate(
            date,
            equalTo: viewModel.currentMonth,
            toGranularity: .month
        )
        
        return Button {
            viewModel.selectDate(date)
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
                        .foregroundColor(Color(hex: "#1C3E98"))
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
    
    private var eventsList: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.eventsForSelectedDate, id: \.id) { event in
                    eventRow(event: event)
                    if event.id != viewModel.eventsForSelectedDate.last?.id {
                        Divider()
                            .padding(.leading, 38)
                    }
                }
            }
        }
        .padding(.top, 6)
        .frame(height: 60)
    }
    
    private func eventRow(event: CalendarEvent) -> some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 27, height: 27)
                .overlay(
                    Text(String(event.organizer.prefix(1)))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.black)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.black)
                
                HStack {
                    Text(event.time)
                        .font(.system(size: 9))
                        .foregroundColor(.gray)
                    
                    if !event.location.isEmpty {
                        Image(systemName: "location")
                            .font(.system(size: 8))
                            .foregroundColor(.gray)
                        Text(event.location)
                            .font(.system(size: 9))
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 6)
    }
}

// MARK: - CalendarEvent 모델

struct CalendarEvent {
    let id: String
    let title: String
    let time: String
    let location: String
    let organizer: String
}

#Preview {
    CalendarSegmentView()
        .background(Color.black)
}
