part of zip;

class _DigitalSignature {
  static const int SIGNATURE = 0x05054b50;
  
  @ByteLength(2)
  int size_of_data;
  
  @DerivedLength(const [#size_of_data])
  List<int> signature_data;
  
  _DigitalSignature.empty() {
    
  }
}