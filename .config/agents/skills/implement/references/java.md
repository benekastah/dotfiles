# Java
- Put constant values in `private static final` fields of the class that uses
  them, especially a value used more than once.
- Put a large SQL query (10 lines or more) in its own file (usually in a
  `resources` package), loaded the project's usual way.
- Write good javadocs for new classes, interfaces, methods and properties, and
  for fields whose purpose isn't obvious; update the existing ones a change
  makes untrue.
- Don't use bare `assert`: use `assertThat` in tests, and throw an exception
  elsewhere.
