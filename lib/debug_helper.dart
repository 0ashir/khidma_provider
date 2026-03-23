import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class IAPDebugHelper extends StatefulWidget {
  const IAPDebugHelper({Key? key}) : super(key: key);

  @override
  State<IAPDebugHelper> createState() => _IAPDebugHelperState();
}

class _IAPDebugHelperState extends State<IAPDebugHelper> {
  final InAppPurchase _iap = InAppPurchase.instance;
  List<String> _logs = [];
  bool _testing = false;

  void _log(String message) {
    setState(() {
      _logs.add('${DateTime.now().toString().substring(11, 19)} - $message');
    });
    debugPrint(message);
  }

  Future<void> _runDiagnostics() async {
    setState(() {
      _logs.clear();
      _testing = true;
    });

    _log('🔍 Starting IAP Diagnostics...');
    _log('');

    // Check 1: Platform
    _log('📱 Platform: ${Platform.isIOS ? "iOS" : "Android"}');

    // Check 2: IAP Available
    _log('⏳ Checking if IAP is available...');
    final bool available = await _iap.isAvailable();
    _log(available ? '✅ IAP is available' : '❌ IAP is NOT available');

    if (!available) {
      _log('');
      _log('⚠️ IAP not available. Possible reasons:');
      _log('   • Running on simulator (use real device)');
      _log('   • No internet connection');
      _log('   • App Store not available in region');
      setState(() => _testing = false);
      return;
    }

    // Check 3: Query Products
    _log('');
    _log('⏳ Querying products...');
    const Set<String> productIds = {
      'premium_month_sub',
      'regular_month_sub'
    };

    try {
      final ProductDetailsResponse response = await _iap.queryProductDetails(
        productIds,
      );

      if (response.error != null) {
        _log('❌ Error: ${response.error!.message}');
        _log('   Code: ${response.error!.code}');
        _log('   Source: ${response.error!.source}');
        _log('');
        _log('🔧 Troubleshooting steps:');
        _log('   1. Open Xcode → Runner target');
        _log('   2. Go to Signing & Capabilities');
        _log('   3. Add "In-App Purchase" capability');
        _log('   4. Clean build: flutter clean && cd ios && pod install');
        _log('   5. Rebuild and test on real device');
      } else {
        _log('✅ Query successful');

        if (response.productDetails.isNotEmpty) {
          _log('');
          _log('📦 Found ${response.productDetails.length} products:');
          for (var product in response.productDetails) {
            _log('   • ${product.id}');
            _log('     Title: ${product.title}');
            _log('     Price: ${product.price}');
          }
        } else {
          _log('⚠️ No products found');
        }

        if (response.notFoundIDs.isNotEmpty) {
          _log('');
          _log('❌ Products not found in App Store:');
          for (var id in response.notFoundIDs) {
            _log('   • $id');
          }
          _log('');
          _log('🔧 Fix these issues:');
          _log('   1. Check product IDs in App Store Connect');
          _log('   2. Products must be "Ready to Submit"');
          _log('   3. Wait 2-4 hours after creating products');
          _log('   4. Sign "Paid Applications Agreement"');
        }
      }
    } catch (e) {
      _log('❌ Exception: $e');
    }

    setState(() => _testing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IAP Debug Helper'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => setState(() => _logs.clear()),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _testing ? null : _runDiagnostics,
              icon: _testing
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.play_arrow),
              label: Text(_testing ? 'Testing...' : 'Run Diagnostics'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _logs.isEmpty
                ? const Center(
              child: Text(
                'Tap "Run Diagnostics" to start testing',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    log,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: log.contains('❌')
                          ? Colors.red
                          : log.contains('✅')
                          ? Colors.green
                          : log.contains('⚠️')
                          ? Colors.orange
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}