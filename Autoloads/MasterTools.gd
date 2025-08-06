extends Node

enum MyColor {
	WHITE = 2,
	BLACK = 3,
	NONE = 0,
}

enum Type {
	PAWN = 0,
	ROOK = 1,
	KNIGHT = 2,
	BISHOP = 3,
	QUEEN = 4,
	KING = 5,
	UNKOWN = 10,
}

@warning_ignore("unused_signal")
signal on_to_main()
@warning_ignore("unused_signal")
signal on_piece_arrived(who:Piece , cords:Vector2i)
@warning_ignore("unused_signal")
signal marco_piece(cords:Vector2i)
@warning_ignore("unused_signal")
signal marco_space(cords:Vector2i)
@warning_ignore("unused_signal")
signal polo(who:CharacterBody3D , cords:Vector2i)
