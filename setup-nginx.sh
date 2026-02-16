#!/bin/bash

# ========================================
# Nginx Setup Script for Safqa & Control Panel
# ========================================

echo "🚀 Starting Nginx Setup..."
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ========================================
# 1. Backup current config
# ========================================
echo -e "${YELLOW}📦 Creating backup...${NC}"
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.backup.$(date +%Y%m%d_%H%M%S)
echo -e "${GREEN}✅ Backup created${NC}"
echo ""

# ========================================
# 2. Create directories
# ========================================
echo -e "${YELLOW}📁 Creating directories...${NC}"
sudo mkdir -p /var/www/html/safqa-landing-page
sudo mkdir -p /var/www/html/controlpanel
echo -e "${GREEN}✅ Directories created${NC}"
echo ""

# ========================================
# 3. Set permissions
# ========================================
echo -e "${YELLOW}🔐 Setting permissions...${NC}"
sudo chown -R www-data:www-data /var/www/html/safqa-landing-page
sudo chown -R www-data:www-data /var/www/html/controlpanel
sudo chmod -R 755 /var/www/html/safqa-landing-page
sudo chmod -R 755 /var/www/html/controlpanel
echo -e "${GREEN}✅ Permissions set${NC}"
echo ""

# ========================================
# 4. Show next steps
# ========================================
echo -e "${YELLOW}📝 Next Steps:${NC}"
echo ""
echo "1️⃣  Copy your files to the server:"
echo "   - Safqa: /var/www/html/safqa-landing-page/"
echo "   - Control Panel: /var/www/html/controlpanel/"
echo ""
echo "2️⃣  Edit nginx config:"
echo "   sudo nano /etc/nginx/sites-available/default"
echo ""
echo "3️⃣  Add these location blocks:"
echo ""
echo "   # Safqa Landing Page"
echo "   location /safqa {"
echo "       alias /var/www/html/safqa-landing-page;"
echo "       index index.html safqa-ar.html;"
echo "       try_files \$uri \$uri/ /safqa/index.html =404;"
echo "   }"
echo ""
echo "   # Control Panel"
echo "   location /controlpanel {"
echo "       alias /var/www/html/controlpanel;"
echo "       index index.html;"
echo "       try_files \$uri \$uri/ /controlpanel/index.html =404;"
echo "   }"
echo ""
echo "4️⃣  Test nginx config:"
echo "   sudo nginx -t"
echo ""
echo "5️⃣  Restart nginx:"
echo "   sudo systemctl restart nginx"
echo ""
echo -e "${GREEN}🎉 Setup preparation completed!${NC}"
echo ""
echo -e "${YELLOW}📖 For detailed instructions, read: NGINX-SETUP-GUIDE.md${NC}"
