# riverpod default

In this project I've examined riverpod's default value mechanism.

## digging into the project
this project does not have any platform specific code. all the observations has been made using widget tests. see [widget_test.dart](test/widget_test.dart), you can start reading the code from there and see how it works, all the lines are described by comments.

## what I've learned:
apparently, when you pass a watcher on `B` to a State Provider `A`, even if you change the value of `A`, `A` will keep watching `B`'s changes and update its value whenever `B` changes.
