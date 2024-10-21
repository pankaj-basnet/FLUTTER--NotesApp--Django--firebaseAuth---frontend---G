192.168.61.237

D:\src_dev\flutter\flutter-37hrs-misc\chap-24--step-8--33\sagarmatha\trekkingmap\z----------location---.md

saurav@LAPTOP-JS10JJ6V MINGW64 /d/src_dev/flutter/flutter-37hrs-misc/chap-24--step-8--33/sagarmatha (main)
$ git log
commit ac236b98fbc65f68a173553ede3b3ad61e7632a2 (HEAD -> main, origin/main)
Author: Pankaj Basnet <pankajbasnet2020@hotmail.com>
Date:   Mon Oct 21 12:27:46 2024 +0545

     CRUD complete -- django database -- flutter with firebase auth

commit c6dc832b14fccd7dc04b8b923e09e178bd54c040
Author: Pankaj Basnet <pankajbasnet2020@hotmail.com>
Date:   Mon Oct 21 12:10:59 2024 +0545

     until here, not major changes ---------- next commit will be complete CRUD with django

commit 5b26747b699afc708cde66e73ee3d97ecdb724e1
Author: Pankaj Basnet <pankajbasnet2020@hotmail.com>
Date:   Wed Oct 16 14:38:32 2024 +0545

    create note done ---- list all notes from django already done ------ create note is hard coded-- so, half finished 241016

commit 93a1e6e07427e7cb33f7be8e9e24b48c966f0d2a
Author: Pankaj Basnet <pankajbasnet2020@hotmail.com>
Date:   Tue Oct 15 12:02:10 2024 +0545

    flutter notesAPP ----- removing sqflite local storage database









#####################################################################################
#####################################################################################
#####################################################################################
#####################################################################################

This site uses cookies from Google to deliver and enhance the quality of its services and to analyze traffic.
Learn more
OK, got it

Sign in
Help

rxdart 0.28.0 copy "rxdart: ^0.28.0" to clipboard
Published 4 months ago • verified publisherfluttercommunity.devDart 3 compatible
SDKDartFlutterPlatformAndroidiOSLinuxmacOSwebWindows
2.6k
Readme
Changelog
Installing
Versions
Scores
RxDart 
build

RxDart

Build Status codecov Pub Pub Version (including pre-releases) Gitter Flutter website Build Flutter example License Hits

About 
RxDart extends the capabilities of Dart Streams and StreamControllers.

Dart comes with a very decent Streams API out-of-the-box; rather than attempting to provide an alternative to this API, RxDart adds functionality from the reactive extensions specification on top of it.

RxDart does not provide its Observable class as a replacement for Dart Streams. Instead, it offers several additional Stream classes, operators (extension methods on the Stream class), and Subjects.

If you are familiar with Observables from other languages, please see the Rx Observables vs. Dart Streams comparison chart for notable distinctions between the two.

Upgrading from RxDart 0.22.x to 0.23.x 
RxDart 0.23.x moves away from the Observable class, utilizing Dart 2.6's new extension methods instead. This requires several small refactors that can be easily automated -- which is just what we've done!

Please follow the instructions on the rxdart_codemod package to automatically upgrade your code to support RxDart 0.23.x.

How To Use RxDart 
For Example: Reading the Konami Code 
import 'package:rxdart/rxdart.dart';

void main() {
  const konamiKeyCodes = <int>[
    KeyCode.UP,
    KeyCode.UP,
    KeyCode.DOWN,
    KeyCode.DOWN,
    KeyCode.LEFT,
    KeyCode.RIGHT,
    KeyCode.LEFT,
    KeyCode.RIGHT,
    KeyCode.B,
    KeyCode.A,
  ];

  final result = querySelector('#result')!;

  document.onKeyUp
      .map((event) => event.keyCode)
      .bufferCount(10, 1) // An extension method provided by rxdart
      .where((lastTenKeyCodes) => const IterableEquality<int>().equals(lastTenKeyCodes, konamiKeyCodes))
      .listen((_) => result.innerHtml = 'KONAMI!');
}
API Overview 
RxDart adds functionality to Dart Streams in three ways:

Stream Classes - create Streams with specific capabilities, such as combining or merging many Streams.
Extension Methods - transform a source Stream into a new Stream with different capabilities, such as throttling or buffering events.
Subjects - StreamControllers with additional powers
Stream Classes 
The Stream class provides different ways to create a Stream: Stream.fromIterable or Stream.periodic. RxDart provides additional Stream classes for a variety of tasks, such as combining or merging Streams!

You can construct the Streams provided by RxDart in two ways. The following examples are equivalent in terms of functionality:

Instantiating the Stream class directly.
Example: final mergedStream = MergeStream([myFirstStream, mySecondStream]);
Using static factories from the Rx class, which are useful for discovering which types of Streams are provided by RxDart. Under the hood, these factories call the corresponding Stream constructor.
Example: final mergedStream = Rx.merge([myFirstStream, mySecondStream]);
List of Classes / Static Factories
CombineLatestStream (combine2, combine3... combine9) / Rx.combineLatest2...Rx.combineLatest9
ConcatStream / Rx.concat
ConcatEagerStream / Rx.concatEager
DeferStream / Rx.defer
ForkJoinStream (join2, join3... join9) / Rx.forkJoin2...Rx.forkJoin9
FromCallableStream / Rx.fromCallable
MergeStream / Rx.merge
NeverStream / Rx.never
RaceStream / Rx.race
RangeStream / Rx.range
RepeatStream / Rx.repeat
RetryStream / Rx.retry
RetryWhenStream / Rx.retryWhen
SequenceEqualStream / Rx.sequenceEqual
SwitchLatestStream / Rx.switchLatest
TimerStream / Rx.timer
UsingStream / Rx.using
ZipStream (zip2, zip3, zip4, ..., zip9) / Rx.zip...Rx.zip9
If you're looking for an Interval equivalent, check out Dart's Stream.periodic for similar behavior.
Extension Methods 
The extension methods provided by RxDart can be used on any Stream. They convert a source Stream into a new Stream with additional capabilities, such as buffering or throttling events.

Example
Stream.fromIterable([1, 2, 3])
  .throttleTime(Duration(seconds: 1))
  .listen(print); // prints 1
List of Extension Methods
buffer
bufferCount
bufferTest
bufferTime
concatWith
debounce
debounceTime
defaultIfEmpty
delay
delayWhen
dematerialize
distinctUnique
doOnCancel
doOnData
doOnDone
doOnEach
doOnError
doOnListen
doOnPause
doOnResume
endWith
endWithMany
exhaustMap
flatMap
flatMapIterable
groupBy
interval
mapNotNull
mapTo
materialize
max
mergeWith
min
onErrorResume
onErrorResumeNext
onErrorReturn
onErrorReturnWith
pairwise
sample
sampleTime
scan
skipLast
skipUntil
startWith
startWithMany
switchIfEmpty
switchMap
takeLast
takeUntil
takeWhileInclusive
throttle
throttleTime
timeInterval
timestamp
whereNotNull
whereType
window
windowCount
windowTest
windowTime
withLatestFrom
zipWith
Subjects 
Dart provides the StreamController class to create and manage a Stream. RxDart offers two additional StreamControllers with additional capabilities, known as Subjects:

BehaviorSubject - A broadcast StreamController that caches the latest added value or error. When a new listener subscribes to the Stream, the latest value or error will be emitted to the listener. Furthermore, you can synchronously read the last emitted value.
ReplaySubject - A broadcast StreamController that caches the added values. When a new listener subscribes to the Stream, the cached values will be emitted to the listener.
Rx Observables vs Dart Streams 
In many situations, Streams and Observables work the same way. However, if you're used to standard Rx Observables, some features of the Stream API may surprise you. We've included a table below to help folks understand the differences.

Additional information about the following situations can be found by reading the Rx class documentation.

Situation	Rx Observables	Dart Streams
An error is raised	Observable Terminates with Error	Error is emitted and Stream continues
Cold Observables	Multiple subscribers can listen to the same cold Observable, and each subscription will receive a unique Stream of data	Single subscriber only
Hot Observables	Yes	Yes, known as Broadcast Streams
Is {Publish, Behavior, Replay}Subject hot?	Yes	Yes
Single/Maybe/Completable ?	Yes	Yes, uses rxdart_ext Single (Completable = Single<void>, Maybe<T> = Single<T?>)
Support back pressure	Yes	Yes
Can emit null?	Yes, except RxJava	Yes
Sync by default	Yes	No
Can pause/resume a subscription*?	No	Yes
Examples 
Web and command-line examples can be found in the example folder.

Web Examples 
In order to run the web examples, please follow these steps:

Clone this repo and enter the directory
Run dart pub get
Run dart run build_runner serve example
Navigate to http://localhost:8080/web/index.html in your browser
Command Line Examples 
In order to run the command line example, please follow these steps:

Clone this repo and enter the directory
Run pub get
Run dart examples/fibonacci/lib/example.dart 10
Flutter Example 
Install Flutter
To run the flutter example, you must have Flutter installed. For installation instructions, view the online documentation.

Run the app
Open up an Android Emulator, the iOS Simulator, or connect an appropriate mobile device for debugging.
Open up a terminal
cd into the examples/flutter/github_search directory
Run flutter doctor to ensure you have all Flutter dependencies working.
Run flutter packages get
Run flutter run
Notable References 
Documentation on the Dart Stream class
Tutorial on working with Streams in Dart
ReactiveX (Rx)
Changelog 
Refer to the Changelog to get all release notes.

Extensions 
Check out rxdart_ext, which provides many extension methods and classes built on top of RxDart.

2617
likes
145
pub points
100%
popularity
screenshot

Publisher
verified publisherfluttercommunity.dev

Metadata
RxDart is an implementation of the popular ReactiveX api for asynchronous programming, leveraging the native Dart Streams api.

Repository (GitHub)
View/report issues
Contributing

Topics
#rxdart #reactive-programming #streams #observables #rx

Documentation
API reference

License
Apache-2.0 (license)

More
Packages that depend on rxdart

Dart languageReport packagePolicyTermsAPI TermsSecurityPrivacyHelpRSSbug report

#####################################################################################
#####################################################################################
#####################################################################################

