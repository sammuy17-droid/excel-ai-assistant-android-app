# Android Client (Flutter)

✅ 3 til: Uzbek / English / Russian (tanlansa — ilova to‘liq o‘sha tilda qoladi)  
✅ Kun/Tun rejimi (System / Light / Dark)  
✅ Backend URL foydalanuvchidan yashirilgan (`--dart-define`)  
✅ Internet bo‘lsa — ilova o‘zi /health bilan tekshiradi, keyin faylni /process ga yuboradi  
✅ Pastda doim: **Made by Muhammadullo Qodirov**

## 1) Backend URL ni qo‘yish (HTTPS)
Deploy qilgan domeningizni ishlating:
```bash
flutter run --dart-define=BACKEND_BASE_URL=https://YOUR_BACKEND_DOMAIN_HERE
```

Release build:
```bash
flutter build apk --release --dart-define=BACKEND_BASE_URL=https://YOUR_BACKEND_DOMAIN_HERE
```

## 2) Icon
Iconlarni generatsiya qilish:
```bash
dart run flutter_launcher_icons
```

## 3) GitHub
Shu papkani to‘g‘ridan-to‘g‘ri GitHub repo qilib push qilsangiz bo‘ladi.
