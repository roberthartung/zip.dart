part of zipdart;

class _EndOfCentralDirectoryRecord {
  static const int SIGNATURE = 0x06054b50;
  
  @ByteLength(2)
  int number_of_disk;
  
  @ByteLength(2)
  int start_of_central_directory;
  
  @ByteLength(2)
  int number_of_entries;
  
  @ByteLength(2)
  int total_number_of_entries_in_central_directory;
  
  @ByteLength(4)
  int size_of_the_central_directory;
  
  @ByteLength(4)
  int offset_of_start_of_central_directory_with_respect_to_the_starting_disk_number;
  
  @ByteLength(2)
  int zip_file_comment_length;
  
  @DerivedLength(const [#zip_file_comment_length])
  Uint8List zip_file_comment;
  
  int get length => 2 + 2 + 2 + 2 + 4 + 4 + 2 + zip_file_comment_length;
  
  _EndOfCentralDirectoryRecord.empty() {
    
  }
  
  _EndOfCentralDirectoryRecord({
    int number_of_disk: 0,
    int start_of_central_directory: 0,
    int number_of_entries: 0,
    int total_number_of_entries_in_central_directory: 0,
    int size_of_the_central_directory: 0,
    int offset_of_start_of_central_directory_with_respect_to_the_starting_disk_number: 0,
    Uint8List zip_file_comment: null
  }) {
    if(zip_file_comment == null) {
      zip_file_comment = new Uint8List(0);
    }
    this.number_of_disk = number_of_disk;
    this.start_of_central_directory = start_of_central_directory;
    this.number_of_entries = number_of_entries;
    this.total_number_of_entries_in_central_directory = total_number_of_entries_in_central_directory;
    this.size_of_the_central_directory = size_of_the_central_directory;
    this.offset_of_start_of_central_directory_with_respect_to_the_starting_disk_number = offset_of_start_of_central_directory_with_respect_to_the_starting_disk_number;
    this.zip_file_comment_length = zip_file_comment.lengthInBytes;
    this.zip_file_comment = zip_file_comment;
  }
}