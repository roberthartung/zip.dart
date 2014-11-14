library zip;

import 'dart:typed_data';
import 'dart:mirrors';

part 'src/offset.dart';
part 'src/bytelength.dart';
part 'src/derivedlength.dart';
part 'src/localfileheader.dart';
part 'src/datadescriptor.dart';
part 'src/file.dart';
part 'src/archiveextradatarecord.dart';
part 'src/centraldirectoryheader.dart';
part 'src/digitalsignature.dart';
part 'src/zip64endofcentraldirectoryrecord.dart';
part 'src/zip64endofcentraldirectorylocator.dart';
part 'src/endofcentraldirectoryrecord.dart';
part 'src/crc32.dart';
part 'src/constants.dart';

/**
 * NOTES
 * 
 * - little-endian order
 */

/**
 * Reads data from [data] at [offset] into [t]
 */

dynamic _readIntoClass(Type t, ByteData data, Offset offset) {
  ClassMirror m = reflectClass(t);
  dynamic instance = m.newInstance(#empty, []);
  m.declarations.values.where((m) => m is VariableMirror).forEach((VariableMirror v) {
    if (v.metadata.length != 1) return;

    var annotation = v.metadata.first.reflectee;
    dynamic val;
    if (annotation is ByteLength) {
      ByteLength b = annotation as ByteLength;
      if (b.length == null) {
        val = _readIntoClass(v.type.reflectedType, data, offset);
      } else {
        switch (b.length) {
          case 1:
            val = data.getUint8(offset.offset);
            break;
          case 2:
            val = data.getUint16(offset.offset, Endianness.LITTLE_ENDIAN);
            break;
          case 4:
            val = data.getUint32(offset.offset, Endianness.LITTLE_ENDIAN);
            break;
          case 8:
            val = data.getUint64(offset.offset, Endianness.LITTLE_ENDIAN);
            break;
        }
        offset += b.length;
      }
    } else if (annotation is DerivedLength) {
      DerivedLength d = annotation as DerivedLength;
      dynamic pntr = instance;
      d.symbols.forEach((Symbol s) {
        pntr = pntr.getField(s);
      });
      int size = pntr.reflectee;
      val = data.buffer.asUint8List(offset.offset, size);
      offset += size;
    }
    instance.setField(v.simpleName, val);
  });

  return instance.reflectee;
}

void _writeToBuffer(dynamic source, ByteData data, Offset offset) {
  InstanceMirror im = reflect(source);
  im.type.declarations.values.where((m) => m is VariableMirror).forEach((VariableMirror v) {
    if (v.metadata.length != 1) return;

    var annotation = v.metadata.first.reflectee;
    dynamic val = im.getField(v.simpleName).reflectee;
    if (annotation is ByteLength) {
      ByteLength b = annotation as ByteLength;

      if (b.length == null) {
        _writeToBuffer(val, data, offset);
      } else {
        switch (b.length) {
          case 1:
            data.setUint8(offset.offset, val);
            break;
          case 2:
            data.setUint16(offset.offset, val, Endianness.LITTLE_ENDIAN);
            break;
          case 4:
            data.setUint32(offset.offset, val, Endianness.LITTLE_ENDIAN);
            break;
          case 8:
            data.setUint64(offset.offset, val, Endianness.LITTLE_ENDIAN);
            break;
        }
        offset += b.length;
      }
    } else if (annotation is DerivedLength) {
      DerivedLength d = annotation as DerivedLength;
      dynamic pntr = im;
      d.symbols.forEach((Symbol s) {
        pntr = pntr.getField(s);
      });
      int size = pntr.reflectee;
      val.forEach((int i) {
        data.setUint8(offset.offset, i);
        offset += 1;
      });
    }
  });
}

class Archive {
  List<File> files = [];

  _CentralDirectoryHeader centralDirectoryHeader;

  _ArchiveExtraDataRecord archiveExtraDataRecord;

  List<_CentralDirectoryHeader> _centralDirectory = [];

  Archive.empty() {
  }

  Uint8List get() {
    // TODO(rh) compress before packing so compressed_size and other attributes get updated correctly
    int length = 0;
    Offset offset = new Offset();
    int centralDirOffset = 0;
    int centralDirSize = 0;
    // Calculate Length
    files.forEach((File f) {
      // length + SIGNATURE
      centralDirOffset += f.length + 4;
    });

    length += centralDirOffset;

    _centralDirectory.forEach((_CentralDirectoryHeader header) {
      centralDirSize += header.length + 4;
    });
    length += centralDirSize;

    // End of Central Directory Record
    _EndOfCentralDirectoryRecord end = new _EndOfCentralDirectoryRecord(number_of_entries: files.length, total_number_of_entries_in_central_directory: files.length, size_of_the_central_directory: centralDirSize, offset_of_start_of_central_directory_with_respect_to_the_starting_disk_number: centralDirOffset);

    length += end.length + 4;

    // Init Buffers
    Uint8List bytes = new Uint8List(length);
    ByteData data = new ByteData.view(bytes.buffer);

    // Files
    files.forEach((File f) {
      data.setUint32(offset.offset, _LocalFileHeader.SIGNATURE, Endianness.LITTLE_ENDIAN);
      offset += 4;
      _writeToBuffer(f, data, offset);
    });

    // Central Directory entries
    _centralDirectory.forEach((_CentralDirectoryHeader cdh) {
      data.setUint32(offset.offset, _CentralDirectoryHeader.SIGNATURE, Endianness.LITTLE_ENDIAN);
      offset += 4;
      _writeToBuffer(cdh, data, offset);
    });

    data.setUint32(offset.offset, _EndOfCentralDirectoryRecord.SIGNATURE, Endianness.LITTLE_ENDIAN);
    offset += 4;
    _writeToBuffer(end, data, offset);

    return bytes;
  }

  Archive.raw(Uint8List bytes) {
    ByteData data = new ByteData.view(bytes.buffer);
    Offset offset = new Offset();
    while (offset < data.lengthInBytes && data.getUint32(offset.offset, Endianness.LITTLE_ENDIAN) == _LocalFileHeader.SIGNATURE) {
      offset += 4;
      File f = _readIntoClass(File, data, offset);
      /*
      if(f.localFileHeader.compressed_size & 0x8 == 0x8) {
        print('deflate');
      }
      */
      files.add(f);
    }

    while (offset < data.lengthInBytes && data.getUint32(offset.offset, Endianness.LITTLE_ENDIAN) == _CentralDirectoryHeader.SIGNATURE) {
      offset += 4;
      _CentralDirectoryHeader h = _readIntoClass(_CentralDirectoryHeader, data, offset);
      print(h);
    }

    while (offset < data.lengthInBytes && data.getUint32(offset.offset, Endianness.LITTLE_ENDIAN) == _DigitalSignature.SIGNATURE) {
      offset += 4;
      _DigitalSignature s = _readIntoClass(_DigitalSignature, data, offset);
      print(s);
    }

    while (offset < data.lengthInBytes && data.getUint32(offset.offset, Endianness.LITTLE_ENDIAN) == _Zip64EndOfCentralDirectoryRecord.SIGNATURE) {
      offset += 4;
      _Zip64EndOfCentralDirectoryRecord e = _readIntoClass(_Zip64EndOfCentralDirectoryRecord, data, offset);
      print(e);
    }

    while (offset < data.lengthInBytes && data.getUint32(offset.offset, Endianness.LITTLE_ENDIAN) == _EndOfCentralDirectoryRecord.SIGNATURE) {
      offset += 4;
      _EndOfCentralDirectoryRecord e = _readIntoClass(_EndOfCentralDirectoryRecord, data, offset);
      print(e);
    }

    if (offset.offset == data.lengthInBytes) return;

    print(data.getUint32(offset.offset, Endianness.LITTLE_ENDIAN).toRadixString(16));

    throw "Parsing Error at ${offset.offset}/${data.lengthInBytes}";
  }

  File addFile(String name, Uint8List data) {
    File f = new File(name, data);
    files.add(f);
    _CentralDirectoryHeader header = new _CentralDirectoryHeader(file_name: new Uint8List.fromList(name.codeUnits), crc32: f.localFileHeader.crc32, uncompressed_size: data.length, compressed_size: data.length);
    _centralDirectory.add(header);
    return f;
  }

  File addFileFromString(String name, String data) {
    return addFile(name, new Uint8List.fromList(data.codeUnits));
  }
}