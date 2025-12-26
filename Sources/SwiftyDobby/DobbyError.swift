public enum DobbyError: Error, Equatable {
  case symbolNotFound(Symbol)
  case hookFailed(code: Int32)
  case destroyFailed(code: Int32)
  case missingOriginal
}
