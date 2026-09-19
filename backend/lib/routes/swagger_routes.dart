import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

final swaggerRoutes = Router()
  ..get('/swagger', _swaggerUI)
  ..get('/openapi.json', _openapiJson);

Future<Response> _openapiJson(Request request) async {
  final file = File('lib/src/swagger/openapi.json');
  final content = await file.readAsString();
  return Response.ok(content, headers: {'Content-Type': 'application/json'});
}

Future<Response> _swaggerUI(Request request) async {
  return Response.ok(_swaggerHtml, headers: {'Content-Type': 'text/html'});
}

const _swaggerHtml = '''
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Modulos API - Swagger</title>
  <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@5/swagger-ui.css">
  <style>
    body { margin: 0; padding: 0; }
    .topbar { display: none; }
    .info .title { font-size: 2em; }
  </style>
</head>
<body>
  <div id="swagger-ui"></div>
  <script src="https://unpkg.com/swagger-ui-dist@5/swagger-ui-bundle.js"></script>
  <script>
    SwaggerUIBundle({
      url: '/docs/openapi.json',
      dom_id: '#swagger-ui',
      presets: [
        SwaggerUIBundle.presets.apis,
        SwaggerUIBundle.SwaggerUIStandalonePreset
      ],
      layout: "BaseLayout",
      deepLinking: true,
      filter: true,
      tryItOutEnabled: true
    });
  </script>
</body>
</html>
''';
