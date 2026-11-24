import 'dart:convert';
import 'dart:isolate';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../network/api_exception.dart';

/// Top-level solver function that executes inside Isolate.run off the main thread.
/// Finds the first nonce 0, 1, 2, ... for which SHA-256(challenge + nonce) starts with `difficulty` zero bits.
int _solveChallengeWorker(Map<String, dynamic> args) {
  final challenge = args['challenge'] as String;
  final difficulty = args['difficulty'] as int;

  for (var nonce = 0; ; nonce++) {
    final hash = sha256.convert(utf8.encode('$challenge$nonce')).bytes;
    var bits = 0;
    for (final byte in hash) {
      if (byte == 0) {
        bits += 8;
        continue;
      }
      bits += 8 - byte.bitLength;
      break;
    }
    if (bits >= difficulty) return nonce;
  }
}

/// Represents the solved challenge headers needed for unauthenticated API requests.
class ChallengeSolution {
  final String challenge;
  final String nonce;

  const ChallengeSolution({
    required this.challenge,
    required this.nonce,
  });

  Map<String, String> toHeaders() => {
    'X-Challenge': challenge,
    'X-Challenge-Nonce': nonce,
  };
}

/// Service managing the GSTSOF Proof-of-Work Bot Check challenge.
/// Requests a fresh challenge and computes the mathematical nonce solution off-thread.
class ChallengeService {
  static final ChallengeService _instance = ChallengeService._internal();
  factory ChallengeService() => _instance;

  final Dio _dio = ApiClient().dio;

  ChallengeService._internal();

  /// Requests a fresh challenge from /api/v1/auth/challenge and solves it in a background Isolate.
  Future<ChallengeSolution> getSolvedChallenge() async {
    try {
      final stopwatch = Stopwatch()..start();

      final response = await _dio.post(ApiEndpoints.challenge);

      if (response.statusCode != 200 || response.data == null) {
        throw ApiException(message: 'Failed to obtain bot-check challenge');
      }

      final data = response.data['data'];
      final challenge = data['challenge'] as String;
      final difficulty = (data['difficulty'] as num?)?.toInt() ?? 18;

      // Solve the Proof-of-Work challenge off the main UI thread to prevent any UI frame drop
      final nonce = await Isolate.run(
        () => _solveChallengeWorker({
          'challenge': challenge,
          'difficulty': difficulty,
        }),
      );

      stopwatch.stop();
      debugPrint('[GSTSOF_DEBUG] -> Challenge solved in ${stopwatch.elapsedMilliseconds}ms: Nonce=$nonce (Difficulty: $difficulty bits)');

      return ChallengeSolution(
        challenge: challenge,
        nonce: nonce.toString(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Challenge computation error: $e');
    }
  }
}

