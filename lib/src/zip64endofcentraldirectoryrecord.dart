part of zipdart;

class _Zip64EndOfCentralDirectoryRecord {
  static const int SIGNATURE = 0x06064b50;
  
  @ByteLength(8)
  int size;
  
  _Zip64EndOfCentralDirectoryRecord.empty() {
    
  }
}