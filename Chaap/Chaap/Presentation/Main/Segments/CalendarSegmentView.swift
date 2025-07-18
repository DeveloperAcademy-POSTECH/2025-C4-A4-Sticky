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
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                monthHeader
                weekdayHeader
                calendarGrid
                eventsList
            }
            .frame(width: 360, height: 450.31)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.2))
            )
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            Spacer()
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
                        .foregroundColor(.white)
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
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                }
                .disabled(!viewModel.canNavigateMonth(1))
            }
            .frame(width: 160, height: 25)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 2)
        .frame(height: 50)
    }
    
    private var weekdayHeader: some View {
        HStack {
            ForEach(viewModel.weekdays, id: \.self) { weekday in
                Text(weekday)
                    .font(.chBodyRegular)
                    .foregroundColor(Color(hex: "#919191"))
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 46.86)
    }
    
    private var calendarGrid: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible()), count: 7),
            spacing: 2
        ) {
            ForEach(viewModel.daysInMonth.indices, id: \.self) { index in
                dayCell(date: viewModel.daysInMonth[index])
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 2)
        .padding(.bottom, 8)
        .frame(height: 291.16)
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
                        .frame(width: 37, height: 36)
                    
                    Text("\(day)")
                        .font(.chBodyRegular)
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
            .frame(width: 35, height: 46.86)
        }
    }
    
    private var eventsList: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.eventsForSelectedDate, id: \.id) { event in
                    eventRow(event: event)
                    if event.id != viewModel.eventsForSelectedDate.last?.id {
                        Divider()
                            .padding(.leading, 50)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .frame(height: 74.29)
    }
    
    private func eventRow(event: CalendarEvent) -> some View {
        HStack(spacing: 10) {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 36, height: 36)
                .overlay(
                    Text(String(event.organizer.prefix(1)))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                
                HStack {
                    Text(event.time)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    if !event.location.isEmpty {
                        Image(systemName: "location")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                        Text(event.location)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
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
