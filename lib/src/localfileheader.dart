part of zipdart;

class _LocalFileHeader { 
  static const int SIGNATURE = 0x04034b50;
  
  int get length => 2 + 2 + 2 + 2 + 2 + 4 + 4 + 4 + 2 + 2 + file_name_length + extra_field_length;
  
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
  
  @DerivedLength(const [#file_name_length])
  List<int> file_name;
  
  @DerivedLength(const [#extra_field_length])
  List<int> extra_field;
  
  _LocalFileHeader.empty() {
    
  }
  
  _LocalFileHeader({
    int version_needed_to_extract:10,
    int general_purpose_bit_flag:0,
    int compression_method:0,
    int last_mod_file_time: 0, // 0
    int last_mod_file_date: 0, // 0
    int crc32:0,
    int compressed_size: 0,
    int uncompressed_size: 0,
    Uint8List file_name: null,
    Uint8List extra_field: null
  }) {
    if(file_name == null) {
      file_name = new Uint8List(0);
    }
    
    if(extra_field == null) {
      extra_field = new Uint8List(0);
    }
    
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
    this.file_name = file_name;
    this.extra_field = extra_field;
  }
}