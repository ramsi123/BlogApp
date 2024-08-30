// What is RegExp(r'\s+')?
// It's a regular expression to check from a sentence if it's a space or a new line character.

int calculateReadingTime(String content) {
  final wordCount = content.split(RegExp(r'\s+')).length;
  // speed = d/t (distance upon time formula to calculate reading time)
  // speed = 225 (you can get it from google on average human speed reading)
  final readingTime = wordCount / 225;

  return readingTime.ceil();
}
