//
//  MapSegmentView.swift
//  Chaap
//
//  Created by BoMin Lee on 7/17/25.
//

import SwiftUI
import MapKit
import SwiftData

struct MapSegmentView: View {
    @Bindable private var locationManager = TagLocationManager.shared
    @Bindable private var viewModel: MapSegmentViewModel = .init()
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Chaap.createdAt, order: .reverse) private var chaaps: [Chaap]
    
    @Namespace var mapScope
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Map(position: $viewModel.cameraPosition) {
                ForEach(viewModel.markers, id: \.id, content: { marker in
                    Annotation(marker.title, coordinate: marker.coordinate, content: {
                        Button {
                            viewModel.selectedChaaps = marker.chaaps
                        } label: {
                            ZStack(alignment: .top) {
                                Image(.mapMarker)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30)
                                    .shadow(color: .black.opacity(0.1), radius: 4.6087, x: 4.6087, y: 4.6087)
                                if marker.count > 1{
                                    Text("\(marker.count)")
                                        .font(.chBodyBold)
                                        .foregroundStyle(Color.chLabelWhitePrimary)
                                        .padding(.top, 10)
                                }
                            }
                        }
                    })
                })
                UserAnnotation(anchor: .center)
            }
        }
        .task {
            viewModel.loadMarkers(from: chaaps)
        }
        .chBottomModal(isPresented: .constant(viewModel.selectedChaaps != nil)) {
            if let chaaps = viewModel.selectedChaaps {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(chaaps) { chaap in
                            PeerChaapRow(chaap: chaap)
                        }
                    }
                    Spacer()
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}
