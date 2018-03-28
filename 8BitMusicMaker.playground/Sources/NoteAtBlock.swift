/// Note at block is a construct to specify the time at which the sequencer should play the note. Blocks start at `Int: 0`.
public struct NoteAtBlock {
	public let note: Note
	public let block: Int

	/// Note at block is a construct to specify the time at which the sequencer should play the note.
	/// Blocks start at `Int: 0`.
	///
	/// - Parameters:
	///   - note: the note to play.
	///   - block: the block at which to play the note.
	public init(note: Note, block: Int) {
		self.note = note
		self.block = block
	}
}
