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
        return Response({
            "status": exc.status_code,
            "message": exc.message,
            "details": exc.details if not isinstance(exc, HTTPSerializerBadRequest) else { e_item[0]: e_item[1][0] for e_item in exc.details.items() },
        }, status=exc.status_code)
    else:
        response = exception_handler(exc, context)

        if response is not None:
            response.data = {
                "status": response.status_code,
                "message": response.data["detail"],
                "details": {}
            }
        return response