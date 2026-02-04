// A helper function to capitalize the first letter of each word in a string.
String capitalize(String value) {
  if (value.isEmpty) return value;

  return value
      .split(' ')
      .map((word) => word.isEmpty
          ? word
          : word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join(' ');
}
