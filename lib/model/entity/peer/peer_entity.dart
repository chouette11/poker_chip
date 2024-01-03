import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:peerdart/peerdart.dart';

part 'peer_entity.freezed.dart';

@freezed
class PeerEntity with _$PeerEntity {
  const PeerEntity._();

  const factory PeerEntity({
    required String uid,
    required Peer peer,
  }) = _PeerEntity;

}
