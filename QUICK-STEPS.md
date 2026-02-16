# ⚡ خطوات سريعة لإضافة /controlpanel

## 🎯 الهدف:
إضافة `/controlpanel` على نفس الدومين `safqa.wiz-tech.co`

---

## 📝 الخطوات:

### 1️⃣ **إنشاء مجلد Control Panel**
```bash
sudo mkdir -p /var/www/html/controlpanel
sudo chown -R www-data:www-data /var/www/html/controlpanel
sudo chmod -R 755 /var/www/html/controlpanel
```

---

### 2️⃣ **نقل ملفات Control Panel**
```bash
# إذا كانت الملفات على جهازك المحلي:
scp -r /path/to/controlpanel/* user@server:/var/www/html/controlpanel/

# أو مباشرة على السيرفر:
sudo cp -r /path/to/controlpanel/* /var/www/html/controlpanel/
```

---

### 3️⃣ **نسخ احتياطي من nginx config**
```bash
sudo cp /etc/nginx/sites-available/safqa.wiz-tech.co /etc/nginx/sites-available/safqa.wiz-tech.co.backup
```

---

### 4️⃣ **تعديل nginx config**
```bash
sudo nano /etc/nginx/sites-available/safqa.wiz-tech.co
```

**أضف هذا الكود بعد `location /` وقبل `location ~* \.(js|css|...)`:**

```nginx
# Control Panel
location /controlpanel {
    alias /var/www/html/controlpanel;
    index index.html index.htm;
    try_files $uri $uri/ /controlpanel/index.html =404;
}
```

**الملف الكامل سيصبح:**

```nginx
server {
    server_name safqa.wiz-tech.co;

    root /var/www/html/safqa.wiz-tech.co;
    index index.html safqa-ar.html;

    # Safqa Landing Page
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Control Panel - NEW
    location /controlpanel {
        alias /var/www/html/controlpanel;
        index index.html index.htm;
        try_files $uri $uri/ /controlpanel/index.html =404;
    }

    # Static files caching
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    access_log /var/log/nginx/safqa.wiz-tech.co-access.log;
    error_log /var/log/nginx/safqa.wiz-tech.co-error.log;

    listen 443 ssl;
    listen [::]:443 ssl;
    ssl_certificate /etc/letsencrypt/live/safqa.wiz-tech.co/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/safqa.wiz-tech.co/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
}

server {
    listen 80;
    listen [::]:80;
    server_name safqa.wiz-tech.co;

    if ($host = safqa.wiz-tech.co) {
        return 301 https://$host$request_uri;
    }
    return 404;
}
```

---

### 5️⃣ **اختبار التكوين**
```bash
sudo nginx -t
```

يجب أن ترى:
```
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

---

### 6️⃣ **إعادة تشغيل nginx**
```bash
sudo systemctl restart nginx
```

---

### 7️⃣ **التحقق**
```bash
sudo systemctl status nginx
```

---

### 8️⃣ **الوصول للـ Control Panel**

افتح المتصفح واذهب إلى:
```
https://safqa.wiz-tech.co/controlpanel
```

---

## 🔐 إضافة حماية للـ Control Panel (اختياري)

### إنشاء username/password:
```bash
# تثبيت apache2-utils
sudo apt-get install apache2-utils

# إنشاء user
sudo htpasswd -c /etc/nginx/.htpasswd admin
# سيطلب منك كتابة password

# إضافة مستخدم آخر
sudo htpasswd /etc/nginx/.htpasswd user2
```

### تحديث nginx config:
```nginx
location /controlpanel {
    # إضافة Authentication
    auth_basic "Restricted Access - Control Panel";
    auth_basic_user_file /etc/nginx/.htpasswd;

    alias /var/www/html/controlpanel;
    index index.html index.htm;
    try_files $uri $uri/ /controlpanel/index.html =404;
}
```

### إعادة تشغيل nginx:
```bash
sudo nginx -t
sudo systemctl restart nginx
```

---

## 🔍 استكشاف الأخطاء

### إذا لم يعمل:

1. **تحقق من الـ logs:**
```bash
sudo tail -f /var/log/nginx/safqa.wiz-tech.co-error.log
```

2. **تحقق من وجود الملفات:**
```bash
ls -la /var/www/html/controlpanel/
```

3. **تحقق من الصلاحيات:**
```bash
ls -la /var/www/html/controlpanel/index.html
```

4. **إذا ظهر 404:**
   - تأكد من وجود `index.html` في `/var/www/html/controlpanel/`
   - تأكد من الصلاحيات (755 للمجلدات، 644 للملفات)

5. **إذا ظهر 403:**
   - تحقق من الصلاحيات
   - تأكد من أن المجلد مملوك لـ `www-data:www-data`

---

## 🎯 URLs النهائية:

- **Safqa Landing:** https://safqa.wiz-tech.co/
- **Control Panel:** https://safqa.wiz-tech.co/controlpanel

---

## ✅ Checklist

- [ ] إنشاء مجلد `/var/www/html/controlpanel`
- [ ] نقل ملفات Control Panel
- [ ] ضبط الصلاحيات (www-data:www-data, 755)
- [ ] نسخ احتياطي من nginx config
- [ ] إضافة `location /controlpanel` في nginx
- [ ] اختبار التكوين `nginx -t`
- [ ] إعادة تشغيل nginx
- [ ] فتح المتصفح واختبار الوصول
- [ ] إضافة authentication (اختياري)

---

🎉 **انتهى! الآن Control Panel يعمل على `/controlpanel`**
