# test_hybrid_bargain.py
from hybrid_bargain_ai import HybridBargainAI
from db_manager import DatabaseManager
import time
import json

class BargainingApp:
    def __init__(self):
        self.db = DatabaseManager()
        self.current_ai = None
        self.session_id = None
        
    def print_header(self):
        print("\n" + "="*70)
        print("🤖 HYBRID BARGAINING AI SYSTEM - WITH MYSQL DATABASE")
        print("="*70)
    
    def select_product(self):
        """Let user select a product"""
        products = self.db.get_all_products()
        
        if not products:
            print("❌ No products found in database!")
            return None
        
        print("\n📦 AVAILABLE PRODUCTS:")
        print("-"*50)
        
        for i, product in enumerate(products, 1):
            print(f"{i}. {product['name']}")
            print(f"   Price: ₹{product['selling_price']:,.0f} | Category: {product['category']}")
            print(f"   Brand: {product.get('brand', 'N/A')} | Stock: {product['stock_quantity']}")
            if product.get('features'):
                features = json.loads(product['features']) if isinstance(product['features'], str) else product['features']
                print(f"   Features: {', '.join(features[:3])}")
            print()
        
        while True:
            try:
                choice = int(input("Select product number (1-4): "))
                if 1 <= choice <= len(products):
                    return products[choice-1]['id']
                else:
                    print("Invalid choice. Try again.")
            except ValueError:
                print("Please enter a number.")
    
    def show_analytics(self, ai: HybridBargainAI):
        """Show negotiation analytics"""
        analytics = ai.get_analytics()
        
        print("\n" + "📊"*20)
        print("📊 REAL-TIME ANALYTICS")
        print("📊"*20)
        
        summary = analytics['conversation_summary']
        print(f"\n📈 CONVERSATION SUMMARY:")
        print(f"   • Session: {summary['session_id']}")
        print(f"   • Product: {summary['product']}")
        print(f"   • Turns: {summary['turns']}")
        print(f"   • Strategy: {summary['strategy'].upper()}")
        print(f"   • Customer Type: {summary['customer_personality'].upper()}")
        print(f"   • Patience: {summary['patience']}/100")
        print(f"   • Price: ₹{summary['current_price']:,.0f} (Initial: ₹{summary['initial_price']:,.0f})")
        
        if analytics['product_stats']:
            stats = analytics['product_stats']
            print(f"\n📦 PRODUCT STATISTICS:")
            print(f"   • Total Negotiations: {stats.get('total_negotiations', 0)}")
            print(f"   • Successful Deals: {stats.get('successful_deals', 0)}")
            print(f"   • Average Final Price: ₹{stats.get('avg_final_price', 0):,.0f}")
            print(f"   • Average Turns: {stats.get('avg_turns', 0):.1f}")
        
        if analytics['llm_usage']:
            print(f"\n🤖 LLM USAGE:")
            for usage in analytics['llm_usage']:
                print(f"   • {usage['provider']}: {usage['total_calls']} calls")
                print(f"     Success Rate: {(usage['successful_calls']/usage['total_calls']*100):.1f}%")
                print(f"     Avg Response: {usage['avg_response_time']:.0f}ms")
        
        print("\n💡 TIPS:")
        print("   • Type 'analytics' to see this dashboard")
        print("   • Type 'stats' for product statistics")
        print("   • Type 'help' for bargaining tips")
        print("   • Type 'exit' to end")
        print("-"*50)
    
    def show_help(self):
        """Show bargaining tips"""
        print("\n💡 BARGAINING TIPS:")
        print("="*50)
        print("1. Start with an offer: '₹700 doge'")
        print("2. Be polite: 'Kripya ₹800 kar dijiye'")
        print("3. Compare: 'Amazon pe ₹600 ka mil raha hai'")
        print("4. Ask about features: 'Kya features hai?'")
        print("5. Final offer: '₹750 final hai bhai'")
        print("6. Walk away: 'Nahi chahiye' or 'Bye'")
        print("7. Check warranty: 'Warranty kitne saal ki hai?'")
        print("8. Bulk purchase: 'Do lene par kitna hoga?'")
        print("\n💡 AI will use:")
        print("   • Rule-based system for simple cases (FAST)")
        print("   • LLM AI for complex cases (SMART)")
        print("="*50)
    
    def run(self):
        """Main application loop"""
        self.print_header()
        
        # Select product
        product_id = self.select_product()
        if not product_id:
            return
        
        # Initialize AI
        try:
            self.current_ai = HybridBargainAI(product_id)
            product = self.current_ai.product
            
            print(f"\n✅ Selected: {product['name']}")
            print(f"💰 Display Price: ₹{product['selling_price']:,.0f}")
            print("="*70)
            
            # Opening message
            print(f"\n🤖 Shopkeeper: Namaste ji! Aapka swagat hai!")
            print(f"🤖 Shopkeeper: {product['name']} ke liye ₹{product['selling_price']:,.0f} hai.")
            print(f"🤖 Shopkeeper: Kya aapko pasand aaya? 🤔")
            
            self.show_help()
            
            # Main interaction loop
            start_time = time.time()
            
            while True:
                try:
                    print("\n" + "-"*50)
                    user_input = input("\nYou: ").strip()
                    
                    if not user_input:
                        continue
                    
                    # Special commands
                    if user_input.lower() == 'exit':
                        print("\n🤖 Shopkeeper: Dhanyawad bhai! Phir aana! 👋")
                        break
                    
                    if user_input.lower() == 'analytics':
                        self.show_analytics(self.current_ai)
                        continue
                    
                    if user_input.lower() == 'stats':
                        stats = self.db.get_negotiation_stats(product_id)
                        print(f"\n📊 Product Statistics:")
                        print(f"   Total Negotiations: {stats.get('total_negotiations', 0)}")
                        print(f"   Successful Deals: {stats.get('successful_deals', 0)}")
                        print(f"   Success Rate: {(stats.get('successful_deals', 0)/stats.get('total_negotiations', 1)*100):.1f}%")
                        continue
                    
                    if user_input.lower() == 'help':
                        self.show_help()
                        continue
                    
                    # Process bargaining
                    status, price, response = self.current_ai.bargain(user_input)
                    
                    print(f"\n🤖 Shopkeeper: {response}")
                    print(f"💰 Current Offer: ₹{price:,.0f}")
                    
                    # Show analytics every 3 turns
                    if self.current_ai.turn_count % 3 == 0:
                        print(f"\n📊 Turn {self.current_ai.turn_count} | Patience: {self.current_ai.patience}/100")
                    
                    # Handle end of conversation
                    if status == "ACCEPT":
                        total_time = time.time() - start_time
                        
                        print("\n" + "🎉"*25)
                        print(f"🎉 DEAL CONFIRMED! FINAL PRICE: ₹{price:,}")
                        print("🎉"*25)
                        
                        print(f"\n📈 FINAL REPORT:")
                        print(f"   • Product: {product['name']}")
                        print(f"   • Original Price: ₹{product['selling_price']:,}")
                        print(f"   • Final Price: ₹{price:,}")
                        print(f"   • You Saved: ₹{product['selling_price'] - price:,}")
                        print(f"   • Discount: {((product['selling_price'] - price)/product['selling_price']*100):.1f}%")
                        print(f"   • Total Turns: {self.current_ai.turn_count}")
                        print(f"   • Time: {total_time:.1f} seconds")
                        print(f"   • Customer Type: {self.current_ai.customer_personality.value.upper()}")
                        
                        break
                    
                    elif status == "WALK_AWAY":
                        print("\n🤖 Shopkeeper: Aapka din shubh ho! 🙏")
                        break
                
                except KeyboardInterrupt:
                    print("\n\n🤖 Shopkeeper: Arre bhai! Ja rahe ho? 😅")
                    break
                except Exception as e:
                    print(f"\n⚠️ Error: {e}")
                    print("🤖 Shopkeeper: Phir se try karo bhai...")
                    continue
        
        except Exception as e:
            print(f"\n❌ Fatal Error: {e}")
            print("Please check your database connection.")
        
        print("\n" + "="*70)
        print("🙏 DHANYAWAD - VISIT AGAIN!")
        print("="*70)

def main():
    app = BargainingApp()
    app.run()

if __name__ == "__main__":
    main()