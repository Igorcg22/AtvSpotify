// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlayerStore on _PlayerStoreBase, Store {
  Computed<bool>? _$hasActiveTrackComputed;

  @override
  bool get hasActiveTrack =>
      (_$hasActiveTrackComputed ??= Computed<bool>(() => super.hasActiveTrack,
              name: '_PlayerStoreBase.hasActiveTrack'))
          .value;
  Computed<bool>? _$isCurrentTrackLikedComputed;

  @override
  bool get isCurrentTrackLiked => (_$isCurrentTrackLikedComputed ??=
          Computed<bool>(() => super.isCurrentTrackLiked,
              name: '_PlayerStoreBase.isCurrentTrackLiked'))
      .value;

  late final _$currentTrackAtom =
      Atom(name: '_PlayerStoreBase.currentTrack', context: context);

  @override
  Track? get currentTrack {
    _$currentTrackAtom.reportRead();
    return super.currentTrack;
  }

  @override
  set currentTrack(Track? value) {
    _$currentTrackAtom.reportWrite(value, super.currentTrack, () {
      super.currentTrack = value;
    });
  }

  late final _$currentPlaylistAtom =
      Atom(name: '_PlayerStoreBase.currentPlaylist', context: context);

  @override
  Playlist? get currentPlaylist {
    _$currentPlaylistAtom.reportRead();
    return super.currentPlaylist;
  }

  @override
  set currentPlaylist(Playlist? value) {
    _$currentPlaylistAtom.reportWrite(value, super.currentPlaylist, () {
      super.currentPlaylist = value;
    });
  }

  late final _$isPlayingAtom =
      Atom(name: '_PlayerStoreBase.isPlaying', context: context);

  @override
  bool get isPlaying {
    _$isPlayingAtom.reportRead();
    return super.isPlaying;
  }

  @override
  set isPlaying(bool value) {
    _$isPlayingAtom.reportWrite(value, super.isPlaying, () {
      super.isPlaying = value;
    });
  }

  late final _$playbackPositionAtom =
      Atom(name: '_PlayerStoreBase.playbackPosition', context: context);

  @override
  double get playbackPosition {
    _$playbackPositionAtom.reportRead();
    return super.playbackPosition;
  }

  @override
  set playbackPosition(double value) {
    _$playbackPositionAtom.reportWrite(value, super.playbackPosition, () {
      super.playbackPosition = value;
    });
  }

  late final _$isShuffleEnabledAtom =
      Atom(name: '_PlayerStoreBase.isShuffleEnabled', context: context);

  @override
  bool get isShuffleEnabled {
    _$isShuffleEnabledAtom.reportRead();
    return super.isShuffleEnabled;
  }

  @override
  set isShuffleEnabled(bool value) {
    _$isShuffleEnabledAtom.reportWrite(value, super.isShuffleEnabled, () {
      super.isShuffleEnabled = value;
    });
  }

  late final _$isRepeatEnabledAtom =
      Atom(name: '_PlayerStoreBase.isRepeatEnabled', context: context);

  @override
  bool get isRepeatEnabled {
    _$isRepeatEnabledAtom.reportRead();
    return super.isRepeatEnabled;
  }

  @override
  set isRepeatEnabled(bool value) {
    _$isRepeatEnabledAtom.reportWrite(value, super.isRepeatEnabled, () {
      super.isRepeatEnabled = value;
    });
  }

  late final _$likedTrackIdsAtom =
      Atom(name: '_PlayerStoreBase.likedTrackIds', context: context);

  @override
  ObservableList<String> get likedTrackIds {
    _$likedTrackIdsAtom.reportRead();
    return super.likedTrackIds;
  }

  @override
  set likedTrackIds(ObservableList<String> value) {
    _$likedTrackIdsAtom.reportWrite(value, super.likedTrackIds, () {
      super.likedTrackIds = value;
    });
  }

  late final _$_PlayerStoreBaseActionController =
      ActionController(name: '_PlayerStoreBase', context: context);

  @override
  void selectTrack(Track track, {Playlist? playlist}) {
    final _$actionInfo = _$_PlayerStoreBaseActionController.startAction(
        name: '_PlayerStoreBase.selectTrack');
    try {
      return super.selectTrack(track, playlist: playlist);
    } finally {
      _$_PlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void togglePlay() {
    final _$actionInfo = _$_PlayerStoreBaseActionController.startAction(
        name: '_PlayerStoreBase.togglePlay');
    try {
      return super.togglePlay();
    } finally {
      _$_PlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleShuffle() {
    final _$actionInfo = _$_PlayerStoreBaseActionController.startAction(
        name: '_PlayerStoreBase.toggleShuffle');
    try {
      return super.toggleShuffle();
    } finally {
      _$_PlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleRepeat() {
    final _$actionInfo = _$_PlayerStoreBaseActionController.startAction(
        name: '_PlayerStoreBase.toggleRepeat');
    try {
      return super.toggleRepeat();
    } finally {
      _$_PlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void playNextTrack() {
    final _$actionInfo = _$_PlayerStoreBaseActionController.startAction(
        name: '_PlayerStoreBase.playNextTrack');
    try {
      return super.playNextTrack();
    } finally {
      _$_PlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void playPreviousTrack() {
    final _$actionInfo = _$_PlayerStoreBaseActionController.startAction(
        name: '_PlayerStoreBase.playPreviousTrack');
    try {
      return super.playPreviousTrack();
    } finally {
      _$_PlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleLikeTrack(String trackId) {
    final _$actionInfo = _$_PlayerStoreBaseActionController.startAction(
        name: '_PlayerStoreBase.toggleLikeTrack');
    try {
      return super.toggleLikeTrack(trackId);
    } finally {
      _$_PlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updatePosition(double value) {
    final _$actionInfo = _$_PlayerStoreBaseActionController.startAction(
        name: '_PlayerStoreBase.updatePosition');
    try {
      return super.updatePosition(value);
    } finally {
      _$_PlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void seekForward() {
    final _$actionInfo = _$_PlayerStoreBaseActionController.startAction(
        name: '_PlayerStoreBase.seekForward');
    try {
      return super.seekForward();
    } finally {
      _$_PlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void seekBackward() {
    final _$actionInfo = _$_PlayerStoreBaseActionController.startAction(
        name: '_PlayerStoreBase.seekBackward');
    try {
      return super.seekBackward();
    } finally {
      _$_PlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _incrementProgress() {
    final _$actionInfo = _$_PlayerStoreBaseActionController.startAction(
        name: '_PlayerStoreBase._incrementProgress');
    try {
      return super._incrementProgress();
    } finally {
      _$_PlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _handleSongFinished() {
    final _$actionInfo = _$_PlayerStoreBaseActionController.startAction(
        name: '_PlayerStoreBase._handleSongFinished');
    try {
      return super._handleSongFinished();
    } finally {
      _$_PlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentTrack: ${currentTrack},
currentPlaylist: ${currentPlaylist},
isPlaying: ${isPlaying},
playbackPosition: ${playbackPosition},
isShuffleEnabled: ${isShuffleEnabled},
isRepeatEnabled: ${isRepeatEnabled},
likedTrackIds: ${likedTrackIds},
hasActiveTrack: ${hasActiveTrack},
isCurrentTrackLiked: ${isCurrentTrackLiked}
    ''';
  }
}
