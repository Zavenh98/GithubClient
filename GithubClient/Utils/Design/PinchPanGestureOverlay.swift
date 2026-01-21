//
//  PinchPanGestureOverlay.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 21.01.26.
//

import SwiftUI

struct PinchPanGestureOverlay: UIViewRepresentable {
    @Binding var zoom: CGFloat
    @Binding var zoomAnchor: UnitPoint
    @Binding var dragOffset: CGSize
    
    func makeCoordinator() -> Coordinator {
        Coordinator(zoom: $zoom,
                    zoomAnchor: $zoomAnchor,
                    dragOffset: $dragOffset)
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        
        // Pan Gesture
        let panGesture = UIPanGestureRecognizer()
        panGesture.name = "PINCHPANGESTURE"
        panGesture.minimumNumberOfTouches = 2
        panGesture.addTarget(context.coordinator, action: #selector(Coordinator.panGesture(gesture:)))
        panGesture.delegate = context.coordinator
        view.addGestureRecognizer(panGesture)
        
        // Pinch Gesture
        let pinchGesture = UIPinchGestureRecognizer()
        pinchGesture.name = "PINCHZOOMGESTURE"
        pinchGesture.addTarget(context.coordinator, action: #selector(Coordinator.pinchGesture(gesture:)))
        pinchGesture.delegate = context.coordinator
        view.addGestureRecognizer(pinchGesture)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        @Binding var zoom: CGFloat
        @Binding var zoomAnchor: UnitPoint
        @Binding var dragOffset: CGSize
        
        init(zoom: Binding<CGFloat>,
             zoomAnchor: Binding<UnitPoint>,
             dragOffset: Binding<CGSize>
        ) {
            self._zoom = zoom
            self._zoomAnchor = zoomAnchor
            self._dragOffset = dragOffset
        }
        
        @objc func panGesture(gesture: UIPanGestureRecognizer) {
            if gesture.state == .began || gesture.state == .changed {
                let translation = gesture.translation(in: gesture.view)
                dragOffset = .init(width: translation.x * 0.7, height: translation.y * 0.7)
            } else {
                
                withAnimation(.snappy(duration: 0.3, extraBounce: 0), completionCriteria: .logicallyComplete) {
                    dragOffset = .zero
                    
                } completion: {
                    self.zoom  = 1
                    self.zoomAnchor = .center
                    self.dragOffset = .zero
                }

            }
        }
        
        @objc func pinchGesture(gesture: UIPinchGestureRecognizer) {
            if gesture.state == .began {
                let location = gesture.location(in: gesture.view)
                if let bounds = gesture.view?.bounds {
                    zoomAnchor = .init(x: location.x / bounds.width, y: location.y / bounds.height)
                }
            }
            
            if gesture.state == .began || gesture.state == .changed {
                
                let scale = gesture.scale
                let damping: CGFloat = 0.15
                
                if scale < 0.8 {
                    let delta = 0.8 - scale
                    zoom = 0.8 - delta * damping
                } else if scale > 3.0 {
                    let delta = scale - 3
                    zoom = 3 + delta * damping
                } else {
                    zoom = scale
                }
                
            } else {
                
                withAnimation(.snappy(duration: 0.3, extraBounce: 0), completionCriteria: .logicallyComplete) {
                    zoom = 1
                    zoomAnchor = .center
                    
                } completion: {
                    self.zoom  = 1
                    self.zoomAnchor = .center
                    self.dragOffset = .zero
                }
                
                zoom = 1
                zoomAnchor = .center
            }
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            if gestureRecognizer.name == "PINCHPANGESTURE" && otherGestureRecognizer.name == "PINCHZOOMGESTURE" {
                return true
            }
            return false
        }
    }
}
