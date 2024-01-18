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
String _$hostSidePotsHash() => r'57fc190fc1d21d559b79c7239ac39a29879f40dd';

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
String _$potHash() => r'b5de5d1217ad2b5ffed1c690a593052ef7881283';

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
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
