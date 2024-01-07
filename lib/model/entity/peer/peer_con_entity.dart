import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:peerdart/peerdart.dart';

part 'peer_con_entity.freezed.dart';

@freezed
class PeerConEntity with _$PeerConEntity {
  const PeerConEntity._();

  const factory PeerConEntity({
    required String uid,
    required String peerId,
    required DataConnection con,
  }) = _PeerConEntity;

}
