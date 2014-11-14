part of zipdart;

class Offset {
  int offset = 0;
  
  operator + (int other) {
    offset += other;
    return this;
  }
  
  operator < (int other) => offset < other;
}