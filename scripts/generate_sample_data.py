#!/usr/bin/env python3
"""
Script pour générer des données d'exemple en format Parquet
"""

import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random

# Configuration
np.random.seed(42)
random.seed(42)

# Paramètres
num_orders = 100
start_date = datetime(2023, 1, 1)
end_date = datetime(2024, 12, 31)

# Génération des données
def generate_orders_data():
    orders = []
    
    for i in range(1, num_orders + 1):
        # Date aléatoire dans la plage
        random_days = random.randint(0, (end_date - start_date).days)
        order_date = start_date + timedelta(days=random_days)
        
        # Customer ID aléatoire (1-10)
        customer_id = random.randint(1, 10)
        
        # Montant aléatoire
        total_amount = round(random.uniform(10, 1000), 2)
        
        # Statut avec pondération réaliste
        statuses = ['delivered'] * 60 + ['shipped'] * 20 + ['processing'] * 10 + ['pending'] * 7 + ['cancelled'] * 3
        status = random.choice(statuses)
        
        orders.append({
            'order_id': i,
            'customer_id': customer_id,
            'order_date': order_date.strftime('%Y-%m-%d'),
            'total_amount': total_amount,
            'status': status
        })
    
    return pd.DataFrame(orders)

# Génération et sauvegarde
if __name__ == "__main__":
    print("Génération des données de commandes...")
    
    orders_df = generate_orders_data()
    
    # Sauvegarde en Parquet
    output_path = "data/raw/orders.parquet"
    orders_df.to_parquet(output_path, index=False)
    
    print(f"✅ Fichier Parquet généré: {output_path}")
    print(f"📊 Nombre de commandes: {len(orders_df)}")
    print(f"📅 Période: {orders_df['order_date'].min()} à {orders_df['order_date'].max()}")
    print(f"💰 Montant total: {orders_df['total_amount'].sum():.2f}€")
    
    # Affichage d'un échantillon
    print("\n📋 Échantillon des données:")
    print(orders_df.head(10).to_string(index=False))
