//
//  XMarkDismissButton.swift
//  FoundationExtension
//
//  Created by Keith on 8/13/24.
//

#if os(iOS)
import SwiftUI

public struct XMarkDismissButton: View {
    public init() {}

    @Environment(\.dismiss) private var dismiss

    public var body: some View {
        Button {
            dismiss()
        } label: {
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 30, height: 30)
                .overlay {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Color.accentColor)
                }
        }
    }
}

#Preview {
    XMarkDismissButton()
        .background(Color.black)
}
#endif
