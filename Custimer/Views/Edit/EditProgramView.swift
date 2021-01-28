//
//  EditProgramView.swift
//  Custimer
//
//  Created by Jonathan Diehl on 10.10.20.
//

import SwiftUI

// TODO: changes are not saved
struct EditProgramView: View {
  enum SheetType {
    case importProgram
    case exportProgram
  }
  
  @EnvironmentObject var state: AppState
  @Binding var program: Program
  @State var editMode = EditMode.inactive
  
  @State private var stepSelection: Int? = nil
  @State private var showInsert = false
  @State private var showSheet = false
  @State private var sheetType: SheetType? = nil
  @State private var importString = ""
  @State private var importError: String? = nil

  var exportString: String { ProgramService.shared.exportProgram(program) }
  
  var body: some View {
    ScrollViewReader { scrollView in
      VStack {
        NavigationLink(destination: EditStepView(step: $program.steps[program.steps.count - 1]).onAppear(perform: { onInserted(scrollView: scrollView) }), isActive: $showInsert) {
          EmptyView()
        }
        List {
          Section(header: Text("Title")) {
            EditableText(label: "Title", text: $program.title)
          }
          
          Section(header: Text("Apperance")) {
            EditableAppearance(appearance: $program.appearance)
          }
          
          Section(header: Text("Notifications")) {
            EditableBool(label: "Sounds", isOn: $program.sound)
            EditableBool(label: "Speech", isOn: $program.speech)
            EditableBool(label: "Halftime Warning", isOn: $program.halftime)
          }
          
          Section(header: Text("Timing")) {
            EditableTime(label: "Pause", time: $program.pause)
          }
          
          Section(header: Text("Steps")) {
            ForEach(0..<program.steps.count, id: \.self) { i in
              NavigationLink(destination: EditStepView(step: $program.steps[i]), tag: i, selection: $stepSelection) {
                StepCell(index: i, step: program.steps[i], appearance: program.appearance)
                  .id(i)
              }
              .onTapGesture { stepSelection = i }
            }
            .onDelete { program.steps.remove(atOffsets: $0) }
            .onMove { program.steps.move(fromOffsets: $0, toOffset: $1) }
          }
        }
        .listStyle(PlainListStyle())
      }
      .navigationTitle(program.title)
      .navigationBarItems(trailing: EditButton())
      .toolbar {
        ToolbarItemGroup(placement: .bottomBar) {
          TextButton(text: "Select") { select() }
            .disabled(editMode == .active)
          Spacer()
          IconButton(systemName: "square.and.arrow.up") { show(sheet: .exportProgram) }
          Spacer()
          IconButton(systemName: "square.and.arrow.down") { show(sheet: .importProgram) }
          Spacer()
          TextButton(text: "Add Step") { addStep() }
        }
      }
    }
    .sheet(isPresented: $showSheet) {
      if sheetType == .exportProgram {
        ShareSheet(sharing: [exportString])
      } else {
        NavigationView {
          VStack {
            TextField("Import String", text: $importString)
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .padding()
            if importError != nil {
              Text(importError!)
                .foregroundColor(Color.red)
            }
            Spacer()
            Button("Import") { importProgram() }
              .padding()
          }
          .navigationTitle("Import Program")
          .navigationBarItems(leading: IconButton(systemName: "multiply") { showSheet = false })
        }
        .environment(\.horizontalSizeClass, .compact)
      }
    }
    .environment(\.editMode, $editMode)
    .onDisappear { update() }
  }
  
  private func select() {
    state.select(program: program)
    state.showPrograms = false
  }
  
  private func update() {
    state.update(program: program)
  }
  
  private func show(sheet: SheetType) {
    importString = ""
    importError = nil
    sheetType = sheet
    showSheet = true
  }
  
  private func importProgram() {
    if let program = ProgramService.shared.importProgram(from: importString) {
      self.program = program
      showSheet = false
    } else {
      importError = "Invalid Import String"
    }
  }
  
  private func addStep() {
    program.addStep()
    showInsert = true
  }
  
  private func onInserted(scrollView: ScrollViewProxy) {
    scrollView.scrollTo(program.steps.count - 1)
  }
}

struct EditProgramView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NavigationView {
        EditProgramView(program: .constant(Program()))
      }
      NavigationView {
        EditProgramView(program: .constant(Program()), editMode: EditMode.active)
      }
    }
    .environmentObject(AppState.mock())
  }
}
