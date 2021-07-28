const GET = 'GET';
const POST = 'POST';
const PUT = 'PUT';
const PATCH = 'PATCH';
const DELETE = 'DELETE';

enum MethodTypes { GET, POST, PUT, PATCH, DELETE }

const List<Map<String, dynamic>> METHODS = [
  {
    "name": "GET",
  },
  {
    "name": "POST",
  },
  {
    "name": "PUT",
  },
  {
    "name": "PATCH",
  },
  {
    "name": "DELETE",
  },
  {"name": "CONTROL"},
];

const NONE = 'none';
const BASIC = 'basic';
const BEARER_TOKEN = 'bearerToken';
const OAUTH2 = 'oAuth2';

const Map<String, String> AUTH_OPTIONS = {
  NONE: 'None',
  BASIC: 'Basic',
  BEARER_TOKEN: 'Bearer Token',
  // OAUTH2: 'OAuth 2.0'
};

// Storage keys
const String ENV_LIST = 'envsList';
const String GLOBAL_VARIABLES = 'globalVariables';
