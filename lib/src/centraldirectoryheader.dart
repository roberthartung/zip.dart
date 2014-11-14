part of zip;

class _CentralDirectoryHeader {
  static const SIGNATURE = 0x02014b50;
  
  int get length => 2 + 2 + 2 + 2 + 2 + 2 + 4 + 4 + 4 + 2 + 2 + 2 + 2 + 2 + 4 + 4 + file_name_length + extra_field_length + file_comment_length;
  
  @ByteLength(2)
  int version_made_by;
  
  @ByteLength(2)
  int version_needed_to_extract;
  
  @ByteLength(2)
  int general_purpose_bit_flag;
  
  @ByteLength(2)
  int compression_method;
  
  @ByteLength(2)
  int last_mod_file_time;
  
  @ByteLength(2)
  int last_mod_file_date;
  
  @ByteLength(4)
  int crc32;
  
  @ByteLength(4)
  int compressed_size;
  
  @ByteLength(4)
  int uncompressed_size;
  
  @ByteLength(2)
  int file_name_length;
  
  @ByteLength(2)
  int extra_field_length;
  
  @ByteLength(2)
  int file_comment_length;
  
  @ByteLength(2)
  int disk_number_start;
  
  @ByteLength(2)
  int internal_file_attributes;
  
  @ByteLength(4)
  int external_file_attributes;
  
  @ByteLength(4)
  int relative_offset_of_local_header;
  
  @DerivedLength(const [#file_name_length])
  List<int> file_name;
  
  @DerivedLength(const [#extra_field_length])
  List<int> extra_field;
  
  @DerivedLength(const [#file_comment_length])
  List<int> file_comment;
  
  _CentralDirectoryHeader.empty() {
    
  }
  
  _CentralDirectoryHeader({
      int version_made_by: 0, // 0
      int version_needed_to_extract:10,
      int general_purpose_bit_flag:0,
      int compression_method:0,
      int last_mod_file_time: 0, // 0
      int last_mod_file_date: 0, // 0
      int crc32:0,
      int compressed_size:0,
      int uncompressed_size: 0,
      int disk_number_start: 0,
      int internal_file_attributes: 0,
      int external_file_attributes: 0,
      int relative_offset_of_local_header: 0,
      Uint8List file_name: null,
      Uint8List extra_field: null,
      Uint8List file_comment: null
    }) {
    
    if(file_name == null) {
      file_name = new Uint8List(0);
    }
    
    if(extra_field == null) {
      extra_field = new Uint8List(0);
    }
    
    if(file_comment == null) {
      file_comment = new Uint8List(0);
    }
    
    this.version_made_by = version_made_by;
    this.version_needed_to_extract = version_needed_to_extract;
    this.general_purpose_bit_flag = general_purpose_bit_flag;
    this.compression_method = compression_method;
    this.last_mod_file_time = last_mod_file_time;
    this.last_mod_file_date = last_mod_file_date;
    this.crc32 = crc32;
    this.compressed_size = compressed_size;
    this.uncompressed_size = uncompressed_size;
    this.file_name_length = file_name.lengthInBytes;
    this.extra_field_length = extra_field.lengthInBytes;
    this.file_comment_length = file_comment.lengthInBytes;
    this.disk_number_start = disk_number_start;
    this.internal_file_attributes = internal_file_attributes;
    this.external_file_attributes = external_file_attributes;
    this.relative_offset_of_local_header = relative_offset_of_local_header;
    this.file_name = file_name;
    this.extra_field = extra_field;
    this.file_comment = file_comment;
  }
}