# Deta Cloud for Flutter
deta_dart is meant for easy usage of Deta Base, Drive and Auth. All rigths of the beformentioned belong to [Deta](deta.sh).

## Getting started
Simply import:

```dart
import 'package:deta_dart/deta_dart.dart';
```

and intialize with:

```dart
// deta base
DetaBase.instance.init("deta_project_id", "deta_project_key");
// deta drive
DetaDrive.instance.init("deta_project_id", "deta_project_key");
```

Although it is possible to init as often as you want I recommend to do this once at program start.


## Usage

### Base
There are multiple options to access a Base instance. The simplest version is to use the default methods:
- [`addItem`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/base/base.dart#L39)
- [`addMultipleItems`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/base/base.dart#L46)
- [`getItem`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/base/base.dart#L60)
- [`updateItem`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/base/base.dart#L53)
- [`queryItem`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/base/base.dart#L67)
- [`deleteitem`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/base/base.dart#L74)

those all expect at least the Deta Base path you want to edit. `addItem` also expects the object to post for example. The default methods allow flexible path usage but automatically parse your object to fullfill the object format that Deta expects. So there is *no need* to format those yourself.

Example:
```dart
await DetaBase.instance.addItem(
        "/stats/items", {"key": "I'm_a_key", "wins": 0, "losses": 0});
```

There are also generic versions of the default methods provided. In order to use those `DetaBase` has to additionally be intialized with a map of types and factory functions (btw I'm using the [json_serializable](https://pub.dev/packages/json_serializable) package here):
```dart
final factories = <Type, Function>{
    UserStats: (json) => UserStats.fromJson(json)
};

DetaBase.instance.initGenericFactories(factories);
```

Once that's done you can call the generic versions like the following:
```dart
final resp = await DetaBase.instance
    .getGenericItem<UserStats>("/stats/items/$uid");
```
which will return an instance of `UserStats`. If you wonder what `UserStats` consists of, see [here](test/testModels/UserStats.dart).
Following generic methods are available:
- [`addGenericItem`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/base/base.dart#L89)
- [`addMultipleGenericItems`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/base/base.dart#L98)
- [`updateGenericItem`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/base/base.dart#L107)
- [`getGenericItem`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/base/base.dart#L116)
- [`querySingleGenericItem`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/base/base.dart#L125)
- [`queryGenericItems`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/base/base.dart#L135)

For those who want the outmost flexibility there is also a "raw" version of modifying calls:
- [`addRawItem`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/base/base.dart#L146)
- [`addMultipleRawItems`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/base/base.dart#L153)
- [`queryRaw`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/base/base.dart#L160)

Those calls can be used if you want to alter the Deta format or if sudden changes of the format are made and this package isn't update soon enough. Though keep in mind that you have to fullfill all Deta [format requirements](https://docs.deta.sh/docs/base/http).

Example:
```dart
await DetaBase.instance.addRawItem(
        "/stats/items", {"items": {"key": "I'm_a_key", "wins": 0, "losses": 0}});
```

Finally for the shy ones there are "safe" calls available:
- [`addItemSafe`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/base/base.dart#L169)
- [`addMultipleItemsSafe`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/base/base.dart#L176)
- [`updateItemSafe`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/base/base.dart#L183)
- [`getItemSafe`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/base/base.dart#L193)
- [`queryItemSafe`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/base/base.dart#L200)
- [`deleteItemSafe`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/base/base.dart#L207)

Those calls make sure that:
1. The Deta URL structure is fullfilled
2. The Deta object structure is fullfilled

To use them you just have to provide your Deta Base name (**name only; no slashes**) and the object / key (depending on the call).

Example:
```dart
await DetaBase.instance.addItemSafe(
        "stats", {"key": "I'm_a_key", "wins": 0, "losses": 0});
```

### Drive
The Deta Drive api is built for easy usage and error reduction. E.g. Deta only allows uploads of files smaller than 10MB with their direct upload call. In order to fullfill this requirement the `uploadSmallFile` method throws an error once the file exceeds 10MB. On the other hand, if you use the `chunkedUpload` method, a file that is smaller than 5MB (which is the minimal size for a chunk) automatically switches to the `uploadSmallFile` method. It also warns you btw, indicating that you probably should add a size check before calling the method.  
Long story short, after intialization following methods are available:
- [`uploadSmallFile`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/drive/drive.dart#L33)
- [`chunkedUpload`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/drive/drive.dart#L47) -> which is a `Stream`; more on that later
- [`downloadFile`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/drive/drive.dart#L89)
- [`listFiles`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/drive/drive.dart#L97)
- [`listFilesStream`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/drive/drive.dart#L107)
- [`deleteFiles`](https://github.com/liquidiert/deta_dart/blob/537f9013f8dd37c732b1d8decb62fb7cef12e3a1/lib/src/drive/drive.dart#L120)

`uploadSmallFile` should be used for files that are smaller than 10MB, it throws an `ArgumentError` exception if the file is larger than that.

`chunkedUpload` is meant for files larger than 10MB as mentioned before this method is a `Stream`. So you can listen for changes and probably display a loading bar. If the file is smaller than 10MB only the result of the `uploadSmallFile` will be returned otherwise intermediate results are a JSON object of the [upload chunked part](https://docs.deta.sh/docs/drive/http#upload-chunked-part) call response and the `last` yield is the response of the [end chunked upload](https://docs.deta.sh/docs/drive/http#end-chunked-upload) call.  
If something failes during the upload process the chunked upoad will automatically be [aborted](https://docs.deta.sh/docs/drive/http#abort-chunked-upload).

From the remaining calls only `listFiles` and `listFilesStream` are special. Both return instances of `FileList` which is a helper class.  
`listFilesStream` is also a stream, which polls for changes every **five seconds**. You can change that behavior via the `timeOut` parameter.

Example (simple CRD):
```dart
// upload a file < 10MB
final imgBytes =
        await File.fromUri(Uri.parse("./test/testSrc/Cat03.jpg")).readAsBytes();
final resp =
    await DetaDrive.instance.uploadSmallFile("test", "test.jpg", imgBytes);

// download a file
final img = await DetaDrive.instance.downloadFile("test", "test.jpg");

// delete files -> the name list can contain up to 1000 names
final nameList = ["test.jpg"];
final delResp = await DetaDrive.instance.deleteFiles("test", nameList);
```

Example (chunked C):
```dart
final bytes =
        await File.fromUri(Uri.parse("./test/testSrc/test.pdf")).readAsBytes();
// .last is the last stream response; in this case the response from the end chunked upload call
// if the provided bytes are smaller than 5MB uploadSmallFile will be used instead; also a warning is logged
final resp = await DetaDrive.instance
    .chunkedUpload("test", "test.pdf", bytes)
    .last;
```