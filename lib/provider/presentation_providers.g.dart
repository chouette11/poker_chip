// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presentation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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
String _$roundHash() => r'066be42d9bdab19526970e6162a4c1ed449706c4';

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
String _$bigIdHash() => r'864f08a054ad2916ff187ea210dbd9549d901200';

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
