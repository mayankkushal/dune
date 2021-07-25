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

// Storage keys
const String ENV_LIST = 'envsList';
const String GLOBAL_VARIABLES = 'globalVariables';
