part of zipdart;

class _ArchiveExtraDataRecord {
  static const ARCHIVE_EXTRA_DATA_SIGNATURE = 0x08064b50;
  
  int extra_field_length;
  
  List<int> extra_field_data;
  
  _ArchiveExtraDataRecord.empty() {
    
  }
}