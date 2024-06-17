from rest_framework.response import Response
from rest_framework.views import exception_handler

class HTTPException(Exception):
    """
    Custom exception class to handle HTTP errors.

    Attributes:
        status_code (int): The HTTP status code for the exception.
        message (str): The error message to be displayed.
        details (str, optional): Additional details about the error.
    """

    def __init__(self, status_code, message, details=None):
        self.status_code = status_code
        self.message = message
        self.details = details
        super().__init__(self.message)

    def __str__(self):
        if self.details:
            return f"HTTP {self.status_code}: {self.message} - {self.details}"
        return f"HTTP {self.status_code}: {self.message}"

class HTTPNotFound(HTTPException):
    """
    Exception for 404 Not Found errors.
    """
    def __init__(self, message, details=None):
        super().__init__(404, message, details)

class HTTPBadRequest(HTTPException):
    """
    Exception for 400 Bad Request errors.
    """
    def __init__(self, message, details=None):
        super().__init__(400, message, details)

class HTTPSerializerBadRequest(HTTPException):
    """
    Exception for 400 Bad Request errors specific to serializers.
    """
    def __init__(self, details, message="Invalid data"):
        super().__init__(400, message, details)

def custom_exception_handler(exc, context):
    if isinstance(exc, HTTPException):
        details = {}
        if isinstance(exc, HTTPSerializerBadRequest):
            for e_key, e_value in exc.details.items():
                if isinstance(e_value, list):
                    details[e_key] = str(e_value[0])
                elif isinstance(e_value, dict):
                    details[e_key] = {nested_e_key: str(nested_e_val) for nested_e_key, nested_e_val in e_value.items()}
                else:
                    details[e_key] = str(e_value)
        else:
            details = exc.details

        if details and 'non_field_errors' in details:
            message = details.pop('non_field_errors')[0]
        else:
            message = exc.message

        return Response({
            "status": exc.status_code,
            "error": {
                "message": message,
                "details": details,
            }
        }, status=exc.status_code)
    else:
        response = exception_handler(exc, context)

        if response is not None:
            response.data = {
                "status": response.status_code,
                "error": {
                    "message": response.data.get("detail", "An error occurred."),
                    "details": {}
                }
            }
        return response