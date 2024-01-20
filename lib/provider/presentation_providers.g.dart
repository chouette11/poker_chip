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
String _$sidePotsHash() => r'efb9b31300d60d941a22acc0cc7e411d6f151982';

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
String _$roundHash() => r'ee7f9f51214f1645fd749adb5dd886d6fbaf854f';

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
String _$bigIdHash() => r'cb21cb4537823a420479c46637d7bdd7fcac805e';

///
/// position
///
///
/// Copied from [BigId].
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
