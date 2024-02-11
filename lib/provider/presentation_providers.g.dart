// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presentation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sittingUidsHash() => r'3fbf289e2d4458ae0c65925dd00b3e139b1de86a';

/// See also [SittingUids].
@ProviderFor(SittingUids)
final sittingUidsProvider =
    AutoDisposeNotifierProvider<SittingUids, List<String>>.internal(
  SittingUids.new,
  name: r'sittingUidsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sittingUidsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SittingUids = AutoDisposeNotifier<List<String>>;
String _$errorTextHash() => r'a50cffbf42c3ee751f00c13721025752e6ecc205';

/// See also [ErrorText].
@ProviderFor(ErrorText)
final errorTextProvider =
    AutoDisposeNotifierProvider<ErrorText, String>.internal(
  ErrorText.new,
  name: r'errorTextProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$errorTextHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ErrorText = AutoDisposeNotifier<String>;
String _$roundHash() => r'420334f968341c7b9566c2757234868030d86eae';

///
/// Round
///
///
/// Copied from [Round].
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
String _$bigIdHash() => r'6dac66508b13072cf6f343a12507fcc977a36087';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
