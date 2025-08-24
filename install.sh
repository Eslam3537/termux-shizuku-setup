#!/data/data/com.termux/files/usr/bin/bash
# أداة اسلام رمضان - Termux + Shizuku Setup

# 🎨 ألوان
green='\033[0;32m'
blue='\033[0;34m'
yellow='\033[1;33m'
red='\033[0;31m'
nc='\033[0m' # no color

clear
echo -e "${blue}=========================================${nc}"
echo -e "${yellow} 🔰 أداة اسلام رمضان 🔰${nc}"
echo -e "${blue}=========================================${nc}"
echo ""

# ---------------------------
# القسم الأول: تثبيت الأساسيات
# ---------------------------
echo -e "${green}[1/2] 📦 جاري تثبيت أساسيات Termux...${nc}"
pkg update -y && pkg upgrade -y
pkg install -y git curl wget nano
echo -e "${green}✅ تم تثبيت الأساسيات بنجاح${nc}"
echo ""

# ---------------------------
# القسم الثاني: تثبيت أوامر Shizuku
# ---------------------------
echo -e "${green}[2/2] 🔗 جاري إعداد Shizuku (rish)...${nc}"

# تحميل rish من مجلد Shizuku (المفروض يكون مثبت على الجهاز)
if [ -f /sdcard/Android/data/moe.shizuku.privileged.api/files/rish ]; then
    cp /sdcard/Android/data/moe.shizuku.privileged.api/files/rish $PREFIX/bin/rish
    chmod +x $PREFIX/bin/rish
    echo -e "${green}✅ تم نسخ rish إلى Termux بنجاح${nc}"
    echo -e "${yellow}✨ الآن يمكنك تشغيل Shizuku داخل Termux بكتابة: ${nc}${blue}rish${nc}"
else
    echo -e "${red}❌ لم يتم العثور على rish في مجلد Shizuku${nc}"
    echo -e "${yellow}➡️ تأكد إنك مثبت Shizuku ومشغله قبل تشغيل السكربت${nc}"
fi

echo ""
echo -e "${blue}=========================================${nc}"
echo -e "${green} 🎉 تم إعداد بيئة Termux + Shizuku بنجاح${nc}"
echo -e "${blue}=========================================${nc}"
