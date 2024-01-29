// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pot.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
