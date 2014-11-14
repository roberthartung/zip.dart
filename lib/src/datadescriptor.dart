part of zipdart;

// TODO(rh) - depends on flags!
// @DependsFlag([#syb], 3)
class _DataDescriptor {
  @ByteLength(4)
  int _crc32;
  
  @ByteLength(4)
  int _compressed_size;
  
  @ByteLength(4)
  int _uncompressed_size;
  
  int get crc32 => _crc32;
  int get compressed_size => _compressed_size;
  int get uncompressed_size => uncompressed_size;
  int get length => 4 + 4 + 4;
  
  _DataDescriptor.empty() {
      
  }
  
  _DataDescriptor({
    int crc32: 0,
    int compressed_size: 0,
    int uncompressed_size: 0
  }) {
    this._crc32 = crc32;
    this._compressed_size = compressed_size;
    this._uncompressed_size = uncompressed_size;
  }
}