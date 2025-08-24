import cv2
import telebot
import os
import time

# إدخال بيانات البوت عند البداية
BOT_TOKEN = input("ادخل BOT_TOKEN الخاص بك: ")
CHAT_ID = input("ادخل CHAT_ID الخاص بك: ")
bot = telebot.TeleBot(BOT_TOKEN)

def capture_image():
    cap = cv2.VideoCapture(0)
    ret, frame = cap.read()
    if ret:
        image_filename = "self_image.jpg"
        cv2.imwrite(image_filename, frame)
        print(f"تم التقاط الصورة: {image_filename}")
        # إرسال الصورة للبوت
        with open(image_filename, 'rb') as f:
            bot.send_photo(CHAT_ID, f)
        print("تم إرسال الصورة للبوت!")
    else:
        print("خطأ في الكاميرا")
    cap.release()

def record_video(duration=10):
    cap = cv2.VideoCapture(0)
    fourcc = cv2.VideoWriter_fourcc(*'XVID')
    video_filename = "self_video.avi"
    out = cv2.VideoWriter(video_filename, fourcc, 20.0, (640, 480))
    start_time = time.time()
    print(f"بدء تسجيل الفيديو لمدة {duration} ثانية...")
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        out.write(frame)
        if time.time() - start_time > duration:
            break
    cap.release()
    out.release()
    print(f"انتهى تسجيل الفيديو: {video_filename}")
    # إرسال الفيديو للبوت
    with open(video_filename, 'rb') as f:
        bot.send_video(CHAT_ID, f)
    print("تم إرسال الفيديو للبوت!")

# القائمة الرئيسية
while True:
    print("\nاختر خيارك:")
    print("1. التقاط صورة")
    print("2. تسجيل فيديو")
    print("3. خروج")
    choice = input("أدخل الخيار (1، 2، 3): ")
    if choice == "1":
        capture_image()
    elif choice == "2":
        duration = int(input("ادخل مدة الفيديو بالثواني: "))
        record_video(duration)
    elif choice == "3":
        print("الخروج من الأداة...")
        break
    else:
        print("خيار غير صحيح")
