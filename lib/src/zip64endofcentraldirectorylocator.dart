part of zipdart;

class _Zip64EndOfCentralDirectoryLocator {
  static const int SIGNATURE = 0x07064b50;
  
  @ByteLength(4)
  int start_offset;
  
  _Zip64EndOfCentralDirectoryLocator.empty() {
    
  }
}