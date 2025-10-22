Provides extensions to
[`simple_service_container`](https://pub.dev/packages/simple_service_container)
for containers to own resources and dispose them via
[`disposable_resource_management`](https://pub.dev/packages/disposable_resource_management).

## Set-up

Just add following dependencies to your `pubspec.yaml`:
```yaml
dependencies:
  disposable_resource_management: ^4.0.0
  owning_simple_service_container: ^1.0.0
  simple_service_container: ^1.0.0
```

## Usage and Getting Started

`OwningServiceContainer` is a `ServiceContainer` that can be used to register
services as owned by the container, as well as registered normally. Owned
services will be disposed when the container is disposed.
```dart
final services = OwningServiceContainer();
```

If your services implement `Disposable` or `AsyncDisposable` from 
`disposable_resource_management` then you can register them as owned like so:
```dart
services.registerDisposable(disposableService);
services.registerAsyncDisposable(asyncDisposableService);
```

If the service comes from another library/package and does not implement
Disposable or AsyncDisposable from disposable_resource_management, then you
can register it as owned by specifying a custom synchronous or asynchronous
disposal method like this:
```dart
services.registerWithDisposer(
disposableFromAnotherLibrary,
disposableFromAnotherLibrary.dispose,
);
services.registerWithAsyncDisposer(
asyncDisposableFromAnotherLibrary,
asyncDisposableFromAnotherLibrary.disposeAsync,
);
```

The container can then be used as normal, and then disposed when itself and its
services are no longer required.

Dispose like this if we need to await disposal.
```dart
await services.disposeAsync();
```
Or like this if we don't need to wait for services to dispose.
```dart
unawaited(services.disposeAsync());
```

## Extensions
You may also wish to check out the following packages that also extend the
functionality of `simple_service_container`:
 - [`flutter_simple_service_container`](https://pub.dev/packages/flutter_simple_service_container)
   : When working with flutter, this provides extension methods for scoping
   access to services and obtaining them via the `BuildContext` and watching
   listenable services for rebuild on changes via [`context_watch`](https://pub.dev/packages/context_watch)
