//
//  ProgramModal.swift
//  Custimer
//
//  Created by Jonathan Diehl on 07.10.20.
//

import SwiftUI

struct ProgramModal: View {
  @EnvironmentObject var state: AppState
  @State var editMode = EditMode.inactive

  @State private var programSelection: Int? = nil
  @State private var showInsert = false
  @State private var showAbout = false

  var body: some View {
    ScrollViewReader { scrollView in
      NavigationView {
        VStack {
          NavigationLink(destination: EditProgramView(program: $state.programs[state.programs.count - 1], editMode: .active).onAppear(perform: { onInserted(scrollView: scrollView) }), isActive: $showInsert) {
            EmptyView()
          }
          NavigationLink(destination: AboutView(), isActive: $showAbout) {
            EmptyView()
          }
          List {
            ForEach(0..<state.programs.count, id: \.self) { i in
              NavigationLink(destination: EditProgramView(program: $state.programs[i]), tag: i, selection: $programSelection) {
                ProgramCell(program: state.programs[i])
                  .id(i)
              }
              .onTapGesture { programSelection = i }
            }
            .onDelete { state.remove(atOffsets: $0) }
            .onMove { state.move(fromOffsets: $0, toOffset: $1) }
          }
          .listStyle(PlainListStyle())
        }
        .navigationTitle("Timers")
        .navigationBarItems(
          leading: IconButton(systemName: "multiply") { dismiss() },
          trailing: EditButton()
        )
        .toolbar {
          ToolbarItemGroup(placement: .bottomBar) {
            IconButton(systemName: "info.circle") { showAbout = true }
            Spacer()
            IconButton(systemName: "plus") { insert() }
          }
        }
        .environment(\.editMode, $editMode)
      }
    }
  }
  
  private func dismiss() {
    state.showPrograms = false
  }
  
  private func insert() {
    state.insert()
    showInsert = true
  }
  
  private func onInserted(scrollView: ScrollViewProxy) {
    scrollView.scrollTo(state.programs.count - 1)
  }
}

struct ProgramModal_Previews: PreviewProvider {
  static var previews: some View {
    ProgramModal()
      .environmentObject(AppState.mock())
  }
}
