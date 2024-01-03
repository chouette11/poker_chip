// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presentation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$consHash() => r'c98da550b2421a5dc3bc166d503e16dbeb5a1628';

/// See also [Cons].
@ProviderFor(Cons)
final consProvider =
    AutoDisposeNotifierProvider<Cons, List<PeerConEntity>>.internal(
  Cons.new,
  name: r'consProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$consHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Cons = AutoDisposeNotifier<List<PeerConEntity>>;
String _$isConnHash() => r'995033f8f993cb9f482918b9a6ec8a151527e564';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$IsConn extends BuildlessAutoDisposeNotifier<bool> {
  late final Peer peer;

  bool build(
    Peer peer,
  );
}

/// See also [IsConn].
@ProviderFor(IsConn)
const isConnProvider = IsConnFamily();

/// See also [IsConn].
class IsConnFamily extends Family<bool> {
  /// See also [IsConn].
  const IsConnFamily();

  /// See also [IsConn].
  IsConnProvider call(
    Peer peer,
  ) {
    return IsConnProvider(
      peer,
    );
  }

  @override
  IsConnProvider getProviderOverride(
    covariant IsConnProvider provider,
  ) {
    return call(
      provider.peer,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'isConnProvider';
}

/// See also [IsConn].
class IsConnProvider extends AutoDisposeNotifierProviderImpl<IsConn, bool> {
  /// See also [IsConn].
  IsConnProvider(
    this.peer,
  ) : super.internal(
          () => IsConn()..peer = peer,
          from: isConnProvider,
          name: r'isConnProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isConnHash,
          dependencies: IsConnFamily._dependencies,
          allTransitiveDependencies: IsConnFamily._allTransitiveDependencies,
        );

  final Peer peer;

  @override
  bool operator ==(Object other) {
    return other is IsConnProvider && other.peer == peer;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, peer.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  bool runNotifierBuild(
    covariant IsConn notifier,
  ) {
    return notifier.build(
      peer,
    );
  }
}

String _$btnIdHash() => r'fa2319b231ff32ebb76d2f91ac8951b1fe39a3a0';

/// See also [BtnId].
@ProviderFor(BtnId)
final btnIdProvider = AutoDisposeNotifierProvider<BtnId, int>.internal(
  BtnId.new,
  name: r'btnIdProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$btnIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BtnId = AutoDisposeNotifier<int>;
String _$smallIdHash() => r'a1cf829340e2b3658ac23a7e2c904aa4311b3e48';

/// See also [SmallId].
@ProviderFor(SmallId)
final smallIdProvider = AutoDisposeNotifierProvider<SmallId, int>.internal(
  SmallId.new,
  name: r'smallIdProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$smallIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SmallId = AutoDisposeNotifier<int>;
String _$bigIdHash() => r'973126f25dcce0ac08b9353a70640e6d5ff97a64';

/// See also [BigId].
@ProviderFor(BigId)
final bigIdProvider = AutoDisposeNotifierProvider<BigId, int>.internal(
  BigId.new,
  name: r'bigIdProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$bigIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BigId = AutoDisposeNotifier<int>;
String _$playerDataHash() => r'e636bbcf5544fd90b9cb5a3adefff0d89a0e2278';

/// See also [PlayerData].
@ProviderFor(PlayerData)
final playerDataProvider =
    AutoDisposeNotifierProvider<PlayerData, List<UserEntity>>.internal(
  PlayerData.new,
  name: r'playerDataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$playerDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PlayerData = AutoDisposeNotifier<List<UserEntity>>;
String _$limitTimeHash() => r'71d4c1309866b62184df56c11be77e8ad0567d73';

/// See also [LimitTime].
@ProviderFor(LimitTime)
final limitTimeProvider = AutoDisposeNotifierProvider<LimitTime, int>.internal(
  LimitTime.new,
  name: r'limitTimeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$limitTimeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LimitTime = AutoDisposeNotifier<int>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
