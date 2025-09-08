//
//  AutoGrowingTextEditor.swift
//  Chaap
//
//  Created by BoMin Lee on 9/4/25.
//

import SwiftUI

struct AutoGrowingTextEditor: View {
    @Binding var text: String
    @FocusState private var focused: Bool

    // 스타일 & 동작 세팅
    let placeholder: String
    let font: Font
    let fontSize: CGFloat
    let maxLines: Int = 5

    // 색상
    var textColor: Color = Color.chLabelWhitePrimary
    var placeholderColor: Color = Color.chLabelWhiteSecondary

    // 현재 줄 수(명시적 개행 기준) 계산
    private var explicitLineCount: Int {
        // trailing newline까지 고려: 빈 문자열이면 1줄로 취급
        let parts = text.split(separator: "\n", omittingEmptySubsequences: false)
        return max(1, parts.count)
    }

    // 목표 높이 계산: 시작 높이와 (줄 수 × lineHeight)를 비교해서 더 큰 값 사용. 상한은 maxLines.
    private var targetHeight: CGFloat {
        let contentHeight = CGFloat(explicitLineCount) * (fontSize * 1.8)
        let capped = min(contentHeight, CGFloat(maxLines) * (fontSize * 1.8))
        return max(fontSize*1.8, capped)
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            if text.isEmpty && !focused {
                Text(placeholder)
                    .font(font)
                    .lineHeight(1.4, fontSize: fontSize)
                    .foregroundStyle(placeholderColor)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture { focused = true }
            }
            
            TextEditor(text: $text)
                .font(font)
                .lineHeight(1.4, fontSize: fontSize)
                .foregroundStyle(textColor)
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                .multilineTextAlignment(.center)
                .background(Color.clear)
                .tint(textColor)
                .focused($focused)
                .opacity(text.isEmpty && !focused ? 0 : 1) // placeholder 시엔 숨김
                .frame(height: targetHeight)
                .animation(.easeInOut(duration: 0.18), value: targetHeight)
                .onChange(of: text) { _, new in
                    let parts = new.components(separatedBy: .newlines)
                    
                    // 각 줄 검사
                    var adjusted: [String] = []
                    for (_, line) in parts.enumerated() {
                        if line.count > 15 {
                            // 줄이 15자 초과한 경우
                            let head = String(line.prefix(15))
                            let tail = String(line.dropFirst(15))
                            
                            adjusted.append(head)
                            
                            // 마지막 줄이 아니거나, 아직 최대 줄 수를 넘지 않았으면 tail을 새 줄로 보냄
                            if adjusted.count < maxLines {
                                adjusted.append(tail)
                            }
                        } else {
                            adjusted.append(line)
                        }
                    }
                    
                    // 줄 수 제한 적용
                    if adjusted.count > maxLines {
                        adjusted = Array(adjusted.prefix(maxLines))
                    }
                    
                    let limited = adjusted.joined(separator: "\n")
                    
                    if new != limited {
                        text = limited
                    }
                }
        }
    }
    
    private func limitLinesAndChars(_ input: String, maxLines: Int, maxCharsPerLine: Int) -> String {
        // 개행 단위로 나누기
        let parts = input.components(separatedBy: .newlines)
        
        // 각 줄을 15자 이내로 잘라내고, 최대 5줄까지만 유지
        let limited = parts.prefix(maxLines).map { line in
            if line.count > maxCharsPerLine {
                return String(line.prefix(maxCharsPerLine))
            } else {
                return line
            }
        }
        
        return limited.joined(separator: "\n")
    }
}
