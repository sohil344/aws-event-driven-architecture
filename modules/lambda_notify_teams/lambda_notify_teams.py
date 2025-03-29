import json
import os
import urllib3

def lambda_handler(event, context):
    # Initialize HTTP connection pool
    http = urllib3.PoolManager()
    
    # Get webhook URL from environment variable
    webhook_url = os.environ.get("teams_webhook_url")
    
    if not webhook_url:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Teams webhook URL not configured"})
        }
    
    # Prepare the message payload
    message = f"Notification: {json.dumps(event, indent=2)}"
    
    payload = {
        "text": message
    }
    
    # Encode payload to JSON
    encoded_payload = json.dumps(payload).encode('utf-8')
    
    try:
        # Send POST request to Teams webhook
        response = http.request(
            'POST', 
            webhook_url,
            body=encoded_payload,
            headers={'Content-Type': 'application/json'}
        )
        
        # Return response details
        return {
            "statusCode": response.status,
            "body": response.data.decode('utf-8')
        }
    
    except Exception as e:
        # Handle any errors during the request
        return {
            "statusCode": 500,
            "body": json.dumps({
                "error": str(e),
                "message": "Failed to send Teams notification"
            })
        }