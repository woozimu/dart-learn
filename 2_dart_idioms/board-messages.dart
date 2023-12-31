// Entities
class Board {
  final BoardId id;
  final String name;

  Board(this.id, this.name);
}

class Message {
  final MessageId id;
  final BoardId boardId;
  final String content;
  final String authorName;

  Message(this.id, this.boardId, this.content, this.authorName);
}

class BoardId {
  final String value;

  BoardId(this.value);
}

class MessageId {
  final String value;

  MessageId(this.value);
}

// Repositories
abstract class BoardsRepository {
  Future<Board> createBoard(String name);
  Future<List<Board>> getAllBoards();
}

abstract class MessagesRepository {
  Future<Message> postMessage(BoardId boardId, String content, String authorName);
  Future<List<Message>> getAllMessages(BoardId boardId);
}

// In-memory implementation of Repositories
class InMemoryBoardsRepository implements BoardsRepository {
  List<Board> boards = [];

  @override
  Future<Board> createBoard(String name) async {
    final boardId = BoardId('board_${boards.length + 1}');
    final board = Board(boardId, name);
    boards.add(board);
    return board;
  }

  @override
  Future<List<Board>> getAllBoards() async {
    return boards;
  }
}

class InMemoryMessagesRepository implements MessagesRepository {
  Map<BoardId, List<Message>> messagesMap = {};

  @override
  Future<Message> postMessage(BoardId boardId, String content, String authorName) async {
    final messageId = MessageId('message_${messagesMap[boardId]?.length ?? 0 + 1}');
    final message = Message(messageId, boardId, content, authorName);

    if (messagesMap.containsKey(boardId)) {
      messagesMap[boardId]!.add(message);
    } else {
      messagesMap[boardId] = [message];
    }

    return message;
  }

  @override
  Future<List<Message>> getAllMessages(BoardId boardId) async {
    return messagesMap[boardId] ?? [];
  }
}

void main() async {
  final boardsRepo = InMemoryBoardsRepository();
  final messagesRepo = InMemoryMessagesRepository();

  // Create a board
  final board = await boardsRepo.createBoard('My Board');
  print('Created Board: ${board.name}');

  // Post a message
  final message = await messagesRepo.postMessage(board.id, 'Hello, World!', 'John Doe');
  print('Posted Message: ${message.content} by ${message.authorName}');

  // Get all messages in the board
  final messages = await messagesRepo.getAllMessages(board.id);
  print('All Messages in Board: ${messages.length}');
}
