// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presentation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hostConsHash() => r'97c17673a2c4c37a66d5398710e3bb59a19c2db6';

/// See also [HostCons].
@ProviderFor(HostCons)
final hostConsProvider =
    AutoDisposeNotifierProvider<HostCons, List<PeerConEntity>>.internal(
  HostCons.new,
  name: r'hostConsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$hostConsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HostCons = AutoDisposeNotifier<List<PeerConEntity>>;
String _$hostConnOpenHash() => r'fd6032a290d3774116ae281668c5bf66c557cec1';

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

abstract class _$HostConnOpen extends BuildlessAutoDisposeNotifier<bool> {
  late final Peer peer;

  bool build(
    Peer peer,
  );
}

/// See also [HostConnOpen].
@ProviderFor(HostConnOpen)
const hostConnOpenProvider = HostConnOpenFamily();

/// See also [HostConnOpen].
class HostConnOpenFamily extends Family<bool> {
  /// See also [HostConnOpen].
  const HostConnOpenFamily();

  /// See also [HostConnOpen].
  HostConnOpenProvider call(
    Peer peer,
  ) {
    return HostConnOpenProvider(
      peer,
    );
  }

  @override
  HostConnOpenProvider getProviderOverride(
    covariant HostConnOpenProvider provider,
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
  String? get name => r'hostConnOpenProvider';
}

/// See also [HostConnOpen].
class HostConnOpenProvider
    extends AutoDisposeNotifierProviderImpl<HostConnOpen, bool> {
  /// See also [HostConnOpen].
  HostConnOpenProvider(
    this.peer,
  ) : super.internal(
          () => HostConnOpen()..peer = peer,
          from: hostConnOpenProvider,
          name: r'hostConnOpenProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hostConnOpenHash,
          dependencies: HostConnOpenFamily._dependencies,
          allTransitiveDependencies:
              HostConnOpenFamily._allTransitiveDependencies,
        );

  final Peer peer;

  @override
  bool operator ==(Object other) {
    return other is HostConnOpenProvider && other.peer == peer;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, peer.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  bool runNotifierBuild(
    covariant HostConnOpen notifier,
  ) {
    return notifier.build(
      peer,
    );
  }
}

String _$potHash() => r'30a58516f69f39d118f87ad09bce1856c320aa9f';

/// See also [Pot].
@ProviderFor(Pot)
final potProvider = AutoDisposeNotifierProvider<Pot, int>.internal(
  Pot.new,
  name: r'potProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$potHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Pot = AutoDisposeNotifier<int>;
String _$roundHash() => r'c01ceb389361ad6940136d7835540d06a98f1c74';

/// See also [Round].
@ProviderFor(Round)
final roundProvider = AutoDisposeNotifierProvider<Round, GameTypeEnum>.internal(
  Round.new,
  name: r'roundProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$roundHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Round = AutoDisposeNotifier<GameTypeEnum>;
String _$optionAssignedIdHash() => r'5a5d5ec94049e2d114b6b3d47300be13bf928f47';

/// See also [OptionAssignedId].
@ProviderFor(OptionAssignedId)
final optionAssignedIdProvider =
    AutoDisposeNotifierProvider<OptionAssignedId, int>.internal(
  OptionAssignedId.new,
  name: r'optionAssignedIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$optionAssignedIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OptionAssignedId = AutoDisposeNotifier<int>;
String _$btnIdHash() => r'3f14d167aae55c7f490e6ef2e58a2b97c5f650a4';

///
/// position
///
///
/// Copied from [BtnId].
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
String _$smallIdHash() => r'3464f5f1e14af3574635085017239195ba5518b9';

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
String _$bigIdHash() => r'7d021a507c75958e2ce4713d0e5f3ab9bf31058c';

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
String _$playerDataHash() => r'1dbdcb5273d76317e967254072a2471f0ff1fd89';

///
/// player
///
///
/// Copied from [PlayerData].
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
