# 🔧 دليل إعداد Nginx للـ Safqa و Control Panel

## 📋 الخطوات الكاملة

### 1️⃣ **نسخ احتياطي من الملف الحالي**

```bash
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.backup
```

---

### 2️⃣ **تعديل ملف Nginx**

```bash
sudo nano /etc/nginx/sites-available/default
```

---

### 3️⃣ **إضافة الكود التالي**

#### للـ **Safqa Landing Page:**

```nginx
location /safqa {
    alias /var/www/html/safqa-landing-page;
    index index.html safqa-ar.html;
    try_files $uri $uri/ /safqa/index.html =404;
}
```

#### للـ **Control Panel (Static Files):**

```nginx
location /controlpanel {
    alias /var/www/html/controlpanel;
    index index.html index.htm;
    try_files $uri $uri/ /controlpanel/index.html =404;
}
```

#### للـ **Control Panel (إذا كان يعمل على Port - مثل Laravel/Node.js):**

```nginx
location /controlpanel {
    proxy_pass http://localhost:8000;  # غير الـ port حسب مشروعك
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_cache_bypass $http_upgrade;
}
```

---

### 4️⃣ **إنشاء المجلدات ونقل الملفات**

#### للـ Safqa:
```bash
# إنشاء المجلد
sudo mkdir -p /var/www/html/safqa-landing-page

# نقل الملفات (من الجهاز المحلي للسيرفر)
# استخدم SCP أو SFTP
scp -r /Users/ahmed/Downloads/safqa-landing-page/* user@server:/var/www/html/safqa-landing-page/

# أو إذا كنت على السيرفر مباشرة:
sudo cp -r /path/to/safqa-landing-page/* /var/www/html/safqa-landing-page/

# ضبط الصلاحيات
sudo chown -R www-data:www-data /var/www/html/safqa-landing-page
sudo chmod -R 755 /var/www/html/safqa-landing-page
```

#### للـ Control Panel:
```bash
# إنشاء المجلد
sudo mkdir -p /var/www/html/controlpanel

# نقل ملفات الـ Control Panel
sudo cp -r /path/to/controlpanel/* /var/www/html/controlpanel/

# ضبط الصلاحيات
sudo chown -R www-data:www-data /var/www/html/controlpanel
sudo chmod -R 755 /var/www/html/controlpanel
```

---

### 5️⃣ **اختبار التكوين**

```bash
sudo nginx -t
```

**النتيجة المتوقعة:**
```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

---

### 6️⃣ **إعادة تشغيل Nginx**

```bash
sudo systemctl restart nginx
```

أو:

```bash
sudo service nginx restart
```

---

### 7️⃣ **التحقق من الحالة**

```bash
sudo systemctl status nginx
```

---

### 8️⃣ **الوصول للمشاريع**

الآن يمكنك زيارة:

- **الصفحة الرئيسية:** `http://yourdomain.com/`
- **Safqa Landing:** `http://yourdomain.com/safqa`
- **Control Panel:** `http://yourdomain.com/controlpanel`

---

## 🔍 استكشاف الأخطاء

### ❌ إذا ظهرت أخطاء:

#### 1. **تحقق من Logs:**
```bash
# Error log
sudo tail -f /var/log/nginx/error.log

# Access log
sudo tail -f /var/log/nginx/access.log
```

#### 2. **تحقق من الصلاحيات:**
```bash
ls -la /var/www/html/safqa-landing-page
ls -la /var/www/html/controlpanel
```

#### 3. **تحقق من وجود الملفات:**
```bash
ls /var/www/html/safqa-landing-page/index.html
ls /var/www/html/controlpanel/index.html
```

#### 4. **إذا كان الـ Control Panel يعمل على Port:**
```bash
# تحقق من أن التطبيق يعمل
sudo netstat -tulpn | grep :8000

# أو
sudo ss -tulpn | grep :8000
```

---

## 🔐 إضافة حماية للـ Control Panel

إذا كنت تريد حماية Control Panel بـ username/password:

### 1. إنشاء ملف الـ passwords:
```bash
# تثبيت apache2-utils
sudo apt-get install apache2-utils

# إنشاء user
sudo htpasswd -c /etc/nginx/.htpasswd admin

# إضافة مستخدمين آخرين (بدون -c)
sudo htpasswd /etc/nginx/.htpasswd user2
```

### 2. تعديل nginx config:
```nginx
location /controlpanel {
    auth_basic "Restricted Access - Control Panel";
    auth_basic_user_file /etc/nginx/.htpasswd;

    alias /var/www/html/controlpanel;
    index index.html;
    try_files $uri $uri/ /controlpanel/index.html =404;
}
```

### 3. إعادة تشغيل nginx:
```bash
sudo systemctl restart nginx
```

---

## 📝 أمثلة لأنواع مختلفة من المشاريع

### **Laravel (PHP):**
```nginx
location /controlpanel {
    alias /var/www/html/controlpanel/public;
    try_files $uri $uri/ @controlpanel;

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $request_filename;
    }
}

location @controlpanel {
    rewrite /controlpanel/(.*)$ /controlpanel/index.php?/$1 last;
}
```

### **Node.js/Express:**
```nginx
location /controlpanel {
    proxy_pass http://localhost:3000;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
}
```

### **React/Vue (SPA):**
```nginx
location /controlpanel {
    alias /var/www/html/controlpanel;
    try_files $uri $uri/ /controlpanel/index.html;
}
```

---

## 🌐 إضافة SSL (اختياري)

### استخدام Let's Encrypt:
```bash
# تثبيت certbot
sudo apt-get install certbot python3-certbot-nginx

# الحصول على SSL Certificate
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# التجديد التلقائي
sudo certbot renew --dry-run
```

---

## ✅ Checklist

- [ ] نسخ احتياطي من nginx config
- [ ] إضافة location blocks للـ /safqa و /controlpanel
- [ ] نقل ملفات المشاريع للسيرفر
- [ ] ضبط الصلاحيات (755 للمجلدات، www-data:www-data)
- [ ] اختبار التكوين (`nginx -t`)
- [ ] إعادة تشغيل nginx
- [ ] اختبار الوصول من المتصفح
- [ ] إضافة SSL (اختياري)
- [ ] إضافة Authentication للـ Control Panel (اختياري)

---

## 📞 معلومات مفيدة

- **Nginx config:** `/etc/nginx/sites-available/default`
- **Nginx logs:** `/var/log/nginx/`
- **Web root:** `/var/www/html/`
- **Restart nginx:** `sudo systemctl restart nginx`
- **Test config:** `sudo nginx -t`

---

🎉 **انتهى! الآن لديك Safqa و Control Panel يعملان على نفس السيرفر!**
