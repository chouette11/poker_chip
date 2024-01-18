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
String _$hostConnOpenHash() => r'dd5e2d687088a8059242bfcf14bfab09e5d0cea0';

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

abstract class _$HostConnOpen extends BuildlessNotifier<bool> {
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
class HostConnOpenProvider extends NotifierProviderImpl<HostConnOpen, bool> {
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

String _$hostSidePotsHash() => r'8865538fb991034a65a06f18f563e80fd91dce0a';

/// See also [HostSidePots].
@ProviderFor(HostSidePots)
final hostSidePotsProvider =
    AutoDisposeNotifierProvider<HostSidePots, List<SidePotEntity>>.internal(
  HostSidePots.new,
  name: r'hostSidePotsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$hostSidePotsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HostSidePots = AutoDisposeNotifier<List<SidePotEntity>>;
String _$rankingHash() => r'c13f6b57cf6574b114f69a3159509e53319fd894';

/// See also [Ranking].
@ProviderFor(Ranking)
final rankingProvider =
    AutoDisposeNotifierProvider<Ranking, List<List<String>>>.internal(
  Ranking.new,
  name: r'rankingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$rankingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Ranking = AutoDisposeNotifier<List<List<String>>>;
String _$sidePotsHash() => r'3b652a84218353db0d75b383bcb344bb9de217c3';

/// See also [SidePots].
@ProviderFor(SidePots)
final sidePotsProvider =
    AutoDisposeNotifierProvider<SidePots, List<int>>.internal(
  SidePots.new,
  name: r'sidePotsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sidePotsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SidePots = AutoDisposeNotifier<List<int>>;
String _$potHash() => r'a4f29bd4a01706422862ab08707daa1763f32999';

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
String _$roundHash() => r'9ca0f60a9ebf732351f4cdc1ae61872d27f8f145';

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
String _$optionAssignedIdHash() => r'617299c47d2c32db7f9022c7ffd58ae6bab23d75';

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
String _$btnIdHash() => r'8e99823213080ab071c77cd4822eb415c3f43ebf';

///
/// position
///
///
/// Copied from [BtnId].
@ProviderFor(BtnId)
final btnIdProvider = NotifierProvider<BtnId, int>.internal(
  BtnId.new,
  name: r'btnIdProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$btnIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BtnId = Notifier<int>;
String _$smallIdHash() => r'2abea5ee88749f5ccfe245f4466d7918294b6fda';

/// See also [SmallId].
@ProviderFor(SmallId)
final smallIdProvider = NotifierProvider<SmallId, int>.internal(
  SmallId.new,
  name: r'smallIdProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$smallIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SmallId = Notifier<int>;
String _$bigIdHash() => r'cb21cb4537823a420479c46637d7bdd7fcac805e';

/// See also [BigId].
@ProviderFor(BigId)
final bigIdProvider = NotifierProvider<BigId, int>.internal(
  BigId.new,
  name: r'bigIdProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$bigIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BigId = Notifier<int>;
String _$playerDataHash() => r'c98a5f7f0856e8e2f34522e69f6f2261645799dd';

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
