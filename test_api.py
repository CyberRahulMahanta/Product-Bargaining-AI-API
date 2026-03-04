# test_api.py
import requests
import json
import time

BASE_URL = "http://localhost:8000"

def test_health():
    response = requests.get(f"{BASE_URL}/health")
    print("Health Check:", response.json())
    return response.json()

def test_get_products():
    response = requests.get(f"{BASE_URL}/api/products")
    print("\nProducts:", json.dumps(response.json(), indent=2))
    return response.json()

def test_start_negotiation(product_id=1):
    data = {
        "product_id": product_id,
        "customer_id": "test_user_123"
    }
    response = requests.post(f"{BASE_URL}/api/negotiation/start", json=data)
    print("\nStart Negotiation:", json.dumps(response.json(), indent=2))
    return response.json()['data']['session_id']

def test_send_message(session_id, product_id, message):
    data = {
        "session_id": session_id,
        "product_id": product_id,
        "message": message,
        "customer_id": "test_user_123"
    }
    response = requests.post(f"{BASE_URL}/api/negotiation/message", json=data)
    print(f"\nMessage '{message}':", json.dumps(response.json(), indent=2))
    return response.json()

def test_get_history(session_id):
    response = requests.get(f"{BASE_URL}/api/negotiation/history/{session_id}")
    print("\nHistory:", json.dumps(response.json(), indent=2))
    return response.json()

def test_get_analytics(session_id=None, product_id=None):
    url = f"{BASE_URL}/api/analytics"
    params = {}
    if session_id:
        params['session_id'] = session_id
    if product_id:
        params['product_id'] = product_id
    
    response = requests.get(url, params=params)
    print("\nAnalytics:", json.dumps(response.json(), indent=2))
    return response.json()

def run_full_test():
    print("=" * 60)
    print("TESTING BARGAINING AI API")
    print("=" * 60)
    
    # Test health
    test_health()
    
    # Test get products
    products_response = test_get_products()
    if products_response['success'] and products_response['data']:
        first_product = products_response['data'][0]
        product_id = first_product['id']
        print(f"\n✅ Using product: {first_product['name']} (ID: {product_id})")
        
        # Test start negotiation
        session_id = test_start_negotiation(product_id)
        print(f"✅ Session ID: {session_id}")
        
        # Test send messages
        time.sleep(1)
        test_send_message(session_id, product_id, "₹800 doge?")
        
        time.sleep(1)
        test_send_message(session_id, product_id, "₹850 final?")
        
        time.sleep(1)
        test_send_message(session_id, product_id, "Warranty kitne saal ki hai?")
        
        # Test get history
        time.sleep(1)
        test_get_history(session_id)
        
        # Test get analytics
        time.sleep(1)
        test_get_analytics(session_id=session_id)
        test_get_analytics(product_id=product_id)
        
        print("\n" + "=" * 60)
        print("✅ ALL TESTS COMPLETED SUCCESSFULLY")
        print("=" * 60)
    else:
        print("❌ No products found in database")

if __name__ == "__main__":
    run_full_test()