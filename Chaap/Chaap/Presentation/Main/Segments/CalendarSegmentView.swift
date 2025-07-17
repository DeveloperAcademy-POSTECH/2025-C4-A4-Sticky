//
//  CalendarSegmentView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI

struct CalendarSegmentView: View {
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    
    private let calendar = Calendar.current
    private let startYear = 2025
    private let endYear = 2034 /// 10년간
    
    /// 날짜 포맷터들
    private let monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        return formatter
    }()
    
    /// 한국식 월요일 시작 요일
    private let weekdays = ["월", "화", "수", "목", "금", "토", "일"]
    
    /// 한국 공휴일 데이터 (예시)
    private let holidays: [String: String] = [
        "2025-01-01": "신정",
        "2025-01-28": "설날연휴",
        "2025-01-29": "설날",
        "2025-01-30": "설날연휴",
        "2025-03-01": "3·1절",
        "2025-05-05": "어린이날",
        "2025-05-13": "석가탄신일",
        "2025-06-06": "현충일",
        "2025-08-15": "광복절",
        "2025-10-03": "개천절",
        "2025-10-09": "한글날",
        "2025-12-25": "성탄절",
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                monthHeader
                weekdayHeader
                calendarGrid
                eventsList
            }
            .frame(width: 360, height: 336.29)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.4))
            )
            .padding(.horizontal, 16)
            .padding(.top, 16)
            Spacer()
        }
        .onAppear {
            calendarDidInitialize()
        }
    }
    
    private var monthHeader: some View {
        HStack {
            Spacer()
            
            HStack(spacing: 6) {
                Button {
                    monthWasChanged(-1)
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                }
                .disabled(!canNavigateMonth(-1))
                
                Text(monthYearFormatter.string(from: currentMonth))
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 160, height: 25)
                    .background(Color.clear)
                
                Button {
                    monthWasChanged(1)
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                }
                .disabled(!canNavigateMonth(1))
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(height: 50)
    }
    
    private var weekdayHeader: some View {
        HStack {
            ForEach(weekdays, id: \.self) { weekday in
                Text(weekday)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .frame(height: 32)
    }
    
    private var calendarGrid: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible()), count: 7),
            spacing: 4
        ) {
            ForEach(daysInMonth.indices, id: \.self) { index in
                dayCell(date: daysInMonth[index])
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(height: 180)
    }
    
    private func dayCell(date: Date) -> some View {
        let day = calendar.component(.day, from: date)
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        let isToday = calendar.isDateInToday(date)
        let isCurrentMonth = calendar.isDate(
            date,
            equalTo: currentMonth,
            toGranularity: .month
        )
        let isHoliday = isHolidayDate(date)
        let isWeekend = isWeekendDate(date)
        let hasEventData = hasEvents(on: date)
        
        return Button {
            dateWasSelected(date)
        } label: {
            VStack(spacing: 2) {
                ZStack {
                    /// 선택 배경 원 (숫자 텍스트 중앙에 위치)
                    Circle()
                        .fill(cellBackgroundColor(
                            isSelected: isSelected,
                            isToday: isToday
                        ))
                        .frame(width: 28, height: 28)
                    
                    Text("\(day)")
                        .font(.system(
                            size: 15,
                            weight: isSelected ? .bold : .regular
                        ))
                        .foregroundColor(cellTextColor(
                            isSelected: isSelected,
                            isToday: isToday,
                            isCurrentMonth: isCurrentMonth,
                            isHoliday: isHoliday,
                            isWeekend: isWeekend,
                            hasEventData: hasEventData
                        ))
                }
                
                /// 오늘 날짜 표시 (선택되지 않았을 때만)
                if isToday && isCurrentMonth && !isSelected {
                    Text("오늘")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.red)
                } else {
                    /// 빈 공간 유지
                    Text("")
                        .font(.system(size: 9, weight: .medium))
                        .frame(height: 10)
                }
            }
            .frame(width: 35, height: 34)
        }
    }
    
    private var eventsList: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(eventsForSelectedDate, id: \.id) { event in
                    eventRow(event: event)
                    if event.id != eventsForSelectedDate.last?.id {
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
    
    // MARK: - 날짜 계산 및 처리 함수들
    
    /// 캘린더를 초기화하는 함수
    private func calendarDidInitialize() {
        let currentYear = calendar.component(.year, from: Date())
        if currentYear < startYear {
            currentMonth = createDate(year: startYear, month: 1, day: 1) ?? Date()
        } else if currentYear > endYear {
            currentMonth = createDate(year: endYear, month: 12, day: 1) ?? Date()
        }
    }
    
    /// 월이 변경되었을 때 호출되는 함수
    private func monthWasChanged(_ direction: Int) {
        guard canNavigateMonth(direction) else { return }
        
        if let newMonth = calendar.date(
            byAdding: .month,
            value: direction,
            to: currentMonth
        ) {
            currentMonth = newMonth
        }
    }
    
    private func canNavigateMonth(_ direction: Int) -> Bool {
        guard let targetMonth = calendar.date(
            byAdding: .month,
            value: direction,
            to: currentMonth
        ) else {
            return false
        }
        
        let targetYear = calendar.component(.year, from: targetMonth)
        return targetYear >= startYear && targetYear <= endYear
    }
    
    /// 날짜가 선택되었을 때 호출되는 함수
    private func dateWasSelected(_ date: Date) {
        selectedDate = date
    }
    
    private func createDate(year: Int, month: Int, day: Int) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return calendar.date(from: components)
    }
    
    // MARK: - 날짜 배열 생성
    
    private var daysInMonth: [Date] {
        guard let monthInterval = calendar.dateInterval(
            of: .month,
            for: currentMonth
        ) else {
            return []
        }
        
        let firstOfMonth = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        
        /// 월요일 시작으로 조정 (일요일=1, 월요일=2 -> 월요일=0, 일요일=6)
        let adjustedFirstWeekday = (firstWeekday + 5) % 7
        
        var days: [Date] = []
        
        /// 이전 달 날짜들로 첫 주 채우기
        for dayOffset in (1...adjustedFirstWeekday).reversed() {
            if let previousDate = calendar.date(
                byAdding: .day,
                value: -dayOffset,
                to: firstOfMonth
            ) {
                days.append(previousDate)
            }
        }
        
        /// 해당 월의 모든 날짜 추가
        let numberOfDays = calendar.range(
            of: .day,
            in: .month,
            for: currentMonth
        )?.count ?? 0
        
        for day in 1...numberOfDays {
            if let date = calendar.date(
                byAdding: .day,
                value: day - 1,
                to: firstOfMonth
            ) {
                days.append(date)
            }
        }
        
        /// 다음 달 날짜들로 마지막 주 채우기 (7의 배수로 맞추기)
        let lastOfMonth = calendar.date(
            byAdding: .day,
            value: numberOfDays,
            to: firstOfMonth
        ) ?? firstOfMonth
        
        let remainingCells = 7 - (days.count % 7)
        if remainingCells < 7 {
            for dayOffset in 0..<remainingCells {
                if let nextDate = calendar.date(
                    byAdding: .day,
                    value: dayOffset,
                    to: lastOfMonth
                ) {
                    days.append(nextDate)
                }
            }
        }
        
        return days
    }
    
    // MARK: - 날짜 상태 확인 함수들
    
    private func isHolidayDate(_ date: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        return holidays[dateString] != nil
    }
    
    private func isWeekendDate(_ date: Date) -> Bool {
        let weekday = calendar.component(.weekday, from: date)
        return weekday == 1 || weekday == 7 // 일요일 또는 토요일
    }
    
    private func hasEvents(on date: Date) -> Bool {
        return !eventsForDate(date).isEmpty
    }
    
    private func eventsForDate(_ date: Date) -> [CalendarEvent] {
        let selectedDay = calendar.component(.day, from: date)
        let selectedMonth = calendar.component(.month, from: date)
        let selectedYear = calendar.component(.year, from: date)
        
        /// 예시 데이터 (실제로는 데이터베이스나 API에서 가져와야 함)
        if selectedYear == 2025 && selectedMonth == 7 && selectedDay == 2 {
            return [
                CalendarEvent(
                    id: "1",
                    title: "학식 데이트~!",
                    time: "18:00",
                    location: "포항공과대학교",
                    organizer: "peppr"
                ),
                CalendarEvent(
                    id: "2",
                    title: "학식 데이트~!",
                    time: "18:00",
                    location: "포항공과대학교",
                    organizer: "peppr"
                ),
            ]
        }
        
        return []
    }
    
    private var eventsForSelectedDate: [CalendarEvent] {
        return eventsForDate(selectedDate)
    }
    
    // MARK: - UI 스타일 함수들
    
    private func cellTextColor(
        isSelected: Bool,
        isToday: Bool,
        isCurrentMonth: Bool,
        isHoliday: Bool,
        isWeekend: Bool,
        hasEventData: Bool
    ) -> Color {
        if isSelected {
            return .white
        }
        
        if !isCurrentMonth {
            return .white.opacity(0.3)
        }
        
        if isToday {
            return .red
        }
        
        if isHoliday {
            return .red
        }
        
        if hasEventData {
            return .white
        }
        
        return .white.opacity(0.6)
    }
    
    private func cellBackgroundColor(
        isSelected: Bool,
        isToday: Bool
    ) -> Color {
        if isSelected {
            return .black.opacity(0.6)
        }
        
        if isToday {
            return .clear
        }
        
        return .clear
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
