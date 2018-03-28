/// Note at block is a construct to specify the time at which the sequencer should play the note. Blocks start at `Int: 0`.
public struct NoteAtBlock {
	public let note: Note
	public let block: Int

	public init(note: Note, block: Int) {
		self.note = note
		self.block = block
	}
}
