part of zip;

class File {
  @ByteLength()
  _LocalFileHeader localFileHeader;
  
  @DerivedLength(const [#localFileHeader, #compressed_size])
  List<int> data;
  
  /**
   * This file's name and path
   */
  
  String name;
  
  //@ByteLength()
  //_DataDescriptor dataDescriptor;
  //  + (dataDescriptor != null ? dataDescriptor.length : 0)
  
  /**
   * Length of headers + data
   */
  
  int get length => localFileHeader.length + data.length;
  
  /**
   * Constructor for an empty file
   * @note As dart:mirrors/dart2js does not support internal constructors, we have to use .empty
   */
  
  File.empty() {
    
  }
  
  /**
   * Create a new, regular file
   */
  
  File(this.name, Uint8List data) {
    this.data = data;
    // unencrypted === encrypted
    localFileHeader = new _LocalFileHeader(
      file_name: new Uint8List.fromList(name.codeUnits),
      crc32: CRC32.compute(this.data),
      compressed_size: data.length,
      uncompressed_size: data.length
    );
    // dataDescriptor = new _DataDescriptor();
  }
}
