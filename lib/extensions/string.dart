extension StringParsing on String {
  //

  String telFormat() {
    return this.replaceAll(new RegExp(r'^0+(?=.)'), '');
  }
}
