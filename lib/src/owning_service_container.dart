import 'dart:async';

import 'package:disposable_resource_management/disposable_resource_management.dart';
import 'package:simple_service_container/simple_service_container.dart';

/// A disposable service container that can own disposable services.
class OwningServiceContainer extends ServiceContainer
    with AsyncDisposableMixin {
  final List<Disposable> _ownedDisposableServices = [];
  final List<AsyncDisposable> _ownedAsyncDisposableServices = [];

  /// Creates a [OwningServiceContainer] with an optional [parent] container,
  /// from which it inherits overrideable services.
  OwningServiceContainer([super.parent]);

  @override
  void flatten() {
    if (isDisposed) {
      throw StateError('Cannot flatten a disposed container.');
    }
    super.flatten();
  }

  @override
  T? tryGet<T extends Object>() {
    if (isDisposed) {
      throw StateError('Cannot get services from a disposed container.');
    }
    return super.tryGet();
  }

  @override
  Iterable<MapEntry<Type, Object>> getAllRegistrations() {
    if (isDisposed) {
      throw StateError('Cannot get services from a disposed container.');
    }
    return super.getAllRegistrations();
  }

  @override
  Future<void> onDisposeAsync() {
    for (final service in _ownedDisposableServices) {
      service.dispose();
    }
    _ownedDisposableServices.clear();

    Future<void> disposeAsyncServices() async {
      for (final service in _ownedAsyncDisposableServices) {
        await service.disposeAsync();
      }
      _ownedAsyncDisposableServices.clear();
    }

    return disposeAsyncServices();
  }

  @override
  T register<T extends Object>(T service) {
    if (isDisposed) {
      throw StateError('Cannot register services to a disposed container.');
    }
    return super.register(service);
  }

  /// Registers an [AsyncDisposable] service as owned by the container, so that
  /// it will be disposed when the container is disposed.
  T registerAsyncDisposable<T extends AsyncDisposable>(T service) {
    register(service);
    _ownedAsyncDisposableServices.add(service);
    return service;
  }

  /// Registers a [Disposable] service as owned by the container, so that it
  /// will be disposed when the container is disposed.
  T registerDisposable<T extends Disposable>(T service) {
    register(service);
    _ownedDisposableServices.add(service);
    return service;
  }

  /// Registers a service as owned by the container with an [asyncDisposer] that
  /// will be called when the container is disposed.
  T registerWithAsyncDisposer<T extends Object>(
    T service,
    Future<void> Function() asyncDisposer,
  ) {
    register(service);
    _ownedAsyncDisposableServices.add(AsyncDisposable.token(asyncDisposer));
    return service;
  }

  /// Registers a service as owned by the container with a [disposer] that will
  /// be called when the container is disposed.
  T registerWithDisposer<T extends Object>(
    T service,
    void Function() disposer,
  ) {
    register(service);
    _ownedDisposableServices.add(Disposable.token(disposer));
    return service;
  }
}
