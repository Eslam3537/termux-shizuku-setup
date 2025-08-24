#!/data/data/com.termux/files/usr/bin/bash
# 🔰 أداة اسلام رمضان - Termux + Shizuku Setup 🔰

# 🎨 Colors
green='\033[0;32m'
blue='\033[0;34m'
yellow='\033[1;33m'
red='\033[0;31m'
nc='\033[0m' # no color

while true; do
    clear
    echo -e "${blue}=========================================${nc}"
    echo -e "${yellow} 🔰 أداة اسلام رمضان | Islam Ramadan Tool 🔰${nc}"
    echo -e "${blue}=========================================${nc}"
    echo ""
    echo -e "${green}[1] 📦 تثبيت أساسيات Termux | Install Termux Essentials${nc}"
    echo -e "${green}[2] 🌐 تثبيت دعم اللغة العربية | Enable Arabic Support${nc}"
    echo -e "${green}[3] 🔗 تثبيت Shizuku (rish) | Setup Shizuku (rish)${nc}"
    echo -e "${green}[0] ❌ خروج | Exit${nc}"
    echo ""
    read -p "➡️ اختر رقم من القائمة | Choose option: " choice

    case $choice in
        1)
            echo -e "${yellow}📦 جاري تثبيت أساسيات Termux... | Installing essentials...${nc}"
            pkg update -y && pkg upgrade -y
            pkg install -y git curl wget nano
            echo -e "${green}✅ تم التثبيت بنجاح | Installed Successfully${nc}"
            read -p "اضغط Enter للعودة للقائمة... | Press Enter to return..."
            ;;
        2)
            echo -e "${yellow}🌐 جاري إضافة دعم اللغة العربية... | Adding Arabic support...${nc}"
            pkg install -y ncurses-utils
            mkdir -p ~/.termux
            cd ~/.termux
            # تحميل خط Noto Naskh Arabic
            curl -L -o font.ttf https://github.com/google/fonts/raw/main/ofl/notonaskharabic/NotoNaskhArabic-Regular.ttf
            echo "font: ~/.termux/font.ttf" > ~/.termux/termux.properties
            termux-reload-settings
            echo -e "${green}✅ تم إضافة الخط العربي بنجاح | Arabic font installed${nc}"
            echo -e "${yellow}➡️ أعد تشغيل Termux لترى التغييرات | Restart Termux to apply changes${nc}"
            read -p "اضغط Enter للعودة للقائمة... | Press Enter to return..."
            ;;
        3)
            echo -e "${yellow}🔗 جاري إعداد Shizuku (rish)... | Setting up Shizuku (rish)...${nc}"
            if [ -f /sdcard/Android/data/moe.shizuku.privileged.api/files/rish ]; then
                cp /sdcard/Android/data/moe.shizuku.privileged.api/files/rish $PREFIX/bin/rish
                chmod +x $PREFIX/bin/rish
                echo -e "${green}✅ تم نسخ rish بنجاح | rish copied successfully${nc}"
                echo -e "${yellow}✨ شغل Shizuku داخل Termux بكتابة: ${blue}rish${nc}"
            else
                echo -e "${red}❌ لم يتم العثور على rish | rish not found${nc}"
                echo -e "${yellow}➡️ تأكد إن Shizuku مثبت ومشغل قبل تشغيل السكربت${nc}"
            fi
            read -p "اضغط Enter للعودة للقائمة... | Press Enter to return..."
            ;;
        0)
            echo -e "${red}❌ تم الخروج | Exit${nc}"
            exit 0
            ;;
        *)
            echo -e "${red}❌ خيار غير صحيح | Invalid choice${nc}"
            read -p "اضغط Enter للمحاولة مرة أخرى... | Press Enter to try again..."
            ;;
    esac
done
