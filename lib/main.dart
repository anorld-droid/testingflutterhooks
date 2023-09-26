import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// Reduce an iterable to values removing null if a transform func is not passed!!
extension CompactMap<T> on Iterable<T?> {
  Iterable<T> compactMap<E>([E? Function(T?)? transform]) => map(
        transform ?? (e) => e,
      ).where((e) => e != null).cast();
}

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    ),
  );
}

Stream<String> getTime() => Stream.periodic(
      const Duration(seconds: 1),
      (_) => DateTime.now().toIso8601String(),
    );

const url = 'https://bit.ly/3qYOtDm';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final dateTime = useStream(getTime());
    // final controller = useTextEditingController();
    // final text = useState('');
    // useEffect(
    //   () {
    //     controller.addListener(() {
    //       text.value = controller.text;
    //     });
    //     return null;
    //   },
    //   [controller],
    // );
    // To avoid the flicker where useFuture continously loads data, we use useMemoized for caching
    final future = useMemoized(() => NetworkAssetBundle(Uri.parse(url))
        .load(url)
        .then((data) => data.buffer.asUint8List())
        .then((data) => Image.memory(data)));
    final snapshot = useFuture(future);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [snapshot.data].compactMap().toList(),
      ),
      // body: Column(children: [
      //   TextField(
      //     controller: controller,
      //   ),
      //   Text('New Typed: ${text.value}'),
      // ]),
    );
  }
}
