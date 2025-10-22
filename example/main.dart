// Printing is fine in examples
// ignore_for_file: avoid_print

import 'dart:async';

import 'package:disposable_resource_management/disposable_resource_management.dart';
import 'package:owning_simple_service_container/owning_simple_service_container.dart';

void main() async {
  final services = OwningServiceContainer();

  final disposableService = DisposableService();
  final asyncDisposableService = AsyncDisposableService();
  final asyncDisposableFromAnotherLibrary = AsyncDisposableFromAnotherLibrary();
  final disposableFromAnotherLibrary = DisposableFromAnotherLibrary();

  // Register Disposable or AsyncDisposable services as owned like this
  services.registerDisposable(disposableService);
  services.registerAsyncDisposable(asyncDisposableService);

  // If the service comes from another library/package and does not implement
  // Disposable or AsyncDisposable from disposable_resource_management, then you
  // can specify a custom synchronous or asynchronous disposal method like this:
  services.registerWithDisposer(
    disposableFromAnotherLibrary,
    disposableFromAnotherLibrary.dispose,
  );
  services.registerWithAsyncDisposer(
    asyncDisposableFromAnotherLibrary,
    asyncDisposableFromAnotherLibrary.disposeAsync,
  );

  print('registered services');

  // Use container here...

  print('beginning dispose');

  // Dispose like this if we need to await disposal.
  await services.disposeAsync();

  // Or like this if we don't need to wait for services to dispose.
  unawaited(services.disposeAsync());

  print('finished disposing services');
}

class AsyncDisposableFromAnotherLibrary {
  Future<void> disposeAsync() async {
    print('disposed SomeAsyncDisposableFromAnotherLibrary asynchronously');
  }
}

class AsyncDisposableService with AsyncDisposableMixin {
  @override
  Future<void> onDisposeAsync() async {
    print('disposed AsyncDisposableService asynchronously');
  }
}

class DisposableFromAnotherLibrary {
  void dispose() {
    print('disposed SomeDisposableFromAnotherLibrary');
  }
}

class DisposableService with DisposableMixin {
  @override
  void onDispose() {
    print('disposed DisposableService');
  }
}
