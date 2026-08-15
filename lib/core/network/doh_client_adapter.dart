import 'dart:convert';
import 'dart:io';

import 'package:dio/io.dart';

IOHttpClientAdapter createDohAdapter() {
  return IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient();
      
      client.connectionFactory = (uri, proxyHost, proxyPort) async {
        if (uri.host == 'api.jikan.moe') {
          // Resolve DNS via Cloudflare DoH
          final dnsClient = HttpClient();
          // Optional: Ignore certificate errors for the DNS request if the environment requires it
          // dnsClient.badCertificateCallback = (cert, host, port) => true; 
          
          final dnsReq = await dnsClient.getUrl(Uri.parse('https://cloudflare-dns.com/dns-query?name=api.jikan.moe&type=A'));
          dnsReq.headers.add('Accept', 'application/dns-json');
          final dnsRes = await dnsReq.close();
          final dnsBody = await dnsRes.transform(utf8.decoder).join();
          final json = jsonDecode(dnsBody);
          
          if (json['Answer'] != null && json['Answer'].isNotEmpty) {
            final ip = json['Answer'][0]['data'];
            
            final socket = await Socket.startConnect(ip, uri.port);
            final connectedSocket = await socket.socket;
            
            final secureSocket = await SecureSocket.secure(
              connectedSocket,
              host: uri.host,
            );
            
            return ConnectionTask.fromSocket(Future.value(secureSocket), () => secureSocket.close());
          }
        }
        
        // Fallback to normal behavior
        final socket = await Socket.startConnect(uri.host, uri.port);
        return ConnectionTask.fromSocket(socket.socket, () => {});
      };
      return client;
    },
  );
}
