import 'dart:developer';

import 'package:googleapis_auth/auth_io.dart';

class NotificationAccessToken {
  static String? _token;

  /// to generate token only once for an app run
  static Future<String?> get getToken async =>
      _token ?? await _getAccessToken();

  static Future<String?> _getAccessToken() async {
    try {
      const String fMessageScope =
          "https://www.googleapis.com/auth/firebase.messaging";

      final client = await clientViaServiceAccount(
          // to get Admin Json File : Go to Firebase > Project Settings > Service Accounts
          // > Click on 'Generate new private key' Btn & Json file will downloaded
          /// Paste Your Generated Json File Content
          ServiceAccountCredentials.fromJson({
            "type": "service_account",
            "project_id": "chat-app-2eb15",
            "private_key_id": "04667a160f68c34ee7dd64a529df0b241a61f019",
            "private_key":
                "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDCB9nLJM0nnvDK\n4eYbBkET9Ii/kqGiIvdXgejo+MJtkHHSvl5EXv0YCy8JCd2xIgxR4VT/qhv8kP9e\nZGw6dSmNMcP7YqeEXGxgrIzi7hY53xO02Wg88fA1xJ1KjmJdNVnaZq1PXrZWhnRH\n295CHBdykJrGRTKELGeWb/qmxTySyZ6Atc1dUnh+A8zbGRX06SGf9TQcT9aXsqH5\n0RoHxQdPlAQDko9CTWWRb3zGw1GPoMIs7iersa/Z3IzssoOcibTB5PamKVCvvev7\n4wDZvfqm1uLk6kDNkIodvtmVv41RtTnxVf2u8LulmE6Rvr3znp2LMoS4LCbqYkG0\nWHe4i4gZAgMBAAECggEAIwCEjwt0AO5AtPC8cGqX6dAmrRx4EQYqxXv3drONa3Nv\nvRs/aSkTkjdORFylw/MG8uxpx3c59j13++C0z3TcSo7MMnixDIUZvfTSs4tMsiLm\nbKz9i2T/tsthrpXx86uQqn/0SsmkrgYyStZEiXuE1VN1wEeyXbqe8zn/Jv+Utkvd\nMT50oxiz2tZMETCcbacEJkPfDWTaYqqUcnUByxZ8vlaQiQd/PR6qnP31FfU/NsUx\n8IDrku0DLW04exWthHdOkq/vFI6oc03rCirRXkL/zk2Jpe8foDp/U5EPsXsrc62u\n35AgQQo8lHuUY1+9Wro4vPwDhDNQ5qeRdxXUvBK6yQKBgQDvTwLsG9NvJotU+UNV\ngkyksLeihec1L0KMz3l5+Zblp6TuMYuVi7T3KyevMV0NYN3mUBfNT+3dnIODHyvv\ndeJfqR/hT19tbP36tXc2qqQ8HEJeT9hQbZBjsj/jUo2XEDvHNTRsMr9ofqrtZrbP\n1KPaY+bYYTyccj8nxkiyp+MefQKBgQDPkGBDWHwrHtfSdaZLlpRDkWdwn/4T6XNs\n+xsb1hdbAmgs0IWI+2FW4VjrJ0iY3p+BN10D41YfKlwasmauQxw9T3S4kHJzQheZ\niGGOw8QzP3IJGmV6NBsj38zNFlIsVAHKA+x6Qg2KIv5hZX41SU+MPwtOypHX7Mku\nmFFRt+D2zQKBgQCw4twsHd1JGVp/8sc8m1V/nkf+T6+49jfg0TLfYAeTtTkJ/4FH\nhr66vCFXM8uuKd2bcbRGREB0QE5NS2s0UxSC1QYFip/kyF1rRVrbA4LmE5VTFP21\nZWcG6iijJNAXyx4Ef2VCXLhyyr4ZQIT8VhbPRGzLoAQnN6NLCRuPQt10GQKBgHIq\nWDhSoCFbmpwA6BHlZfFwNbQF3Et5eWp1B2kdLcV6InCb1QcONXEDC9RzzAOBV7xM\nBlZQIZuMwhJRFBc/hHXYkTu+/6STssVY9UgAN5d0izWkljJMHK1zuIMJhvMo1b8W\nv2hTknzrWH2bxHpss1tRhde1pdhdPh7p2riW6h71AoGABR04Jtc/pDTE4pVPVGo4\nWNkuOJwtZHX4mH7N3mlxMoqEn8uAnXYLOELRac76jpPoL/0Z4Z2ci18YrdjhxwQ3\nG79db77dRGyRXZHeIUl9X6fVH33+oTOcyqudQDj1U+yEk1Ce3yfDEZ2X515t0UnG\nTDO43Weyjveg+1F0LhKhbuw=\n-----END PRIVATE KEY-----\n",
            "client_email":
                "firebase-adminsdk-alynf@chat-app-2eb15.iam.gserviceaccount.com",
            "client_id": "108753536938085483921",
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://oauth2.googleapis.com/token",
            "auth_provider_x509_cert_url":
                "https://www.googleapis.com/oauth2/v1/certs",
            "client_x509_cert_url":
                "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-alynf%40chat-app-2eb15.iam.gserviceaccount.com",
            "universe_domain": "googleapis.com"
          }),
          [fMessageScope]);
      _token = client.credentials.accessToken.data;
      return _token;
    } catch (e) {
      log('$e');
      return null;
    }
  }
}
