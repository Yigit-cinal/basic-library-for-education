# 📚 Kütüphane Yönetim Sistemi

Modern ve kullanıcı dostu kütüphane yönetim uygulaması. Ruby on Rails ile geliştirilmiştir.

![Rails Version](https://img.shields.io/badge/Rails-7.0+-red.svg)
![Ruby Version](https://img.shields.io/badge/Ruby-3.0+-red.svg)

## 📋 İçindekiler

- [Özellikler](#özellikler)
- [Teknolojiler](#teknolojiler)
- [Kurulum](#kurulum)
- [Kullanım](#kullanım)
- [Veritabanı Yapısı](#veritabanı-yapısı)

## ✨ Özellikler

### 📖 Kitap Yönetimi
- ✅ Kitap ekleme, düzenleme ve silme
- ✅ Gelişmiş arama sistemi (başlık ve yazar bazlı)
- ✅ Resim yükleme (bilgisayardan veya URL ile)
- ✅ Sayfalama desteği (50 kitap/sayfa)
- ✅ Kitap durumu takibi (Mevcut/Ödünç Verildi)

### 👥 Ödünç Alma Sistemi
- ✅ Ödünç verme ve teslim alma
- ✅ Otomatik süre aşımı kontrolü
- ✅ Aktif ve gecikmiş ödünç takibi
- ✅ Ödünç alan kişi bilgileri (TC, telefon, e-posta)
- ✅ Esnek ödünç süreleri (1-30 gün)

### 🔐 Admin Paneli
- ✅ Güvenli admin girişi
- ✅ Kitap ve ödünç yönetimi
- ✅ Flash mesajları ile kullanıcı geri bildirimi

### 🎨 Kullanıcı Arayüzü
- ✅ Responsive tasarım (mobil uyumlu)
- ✅ Modern ve temiz arayüz
- ✅ Turbo ile hızlı sayfa geçişleri
- ✅ Görsel geri bildirimler

## 🛠 Teknolojiler

- **Ruby on Rails 7.0+** - Web framework
- **SQLite3** - Veritabanı (geliştirme)
- **Active Storage** - Dosya yükleme sistemi
- **Kaminari** - Sayfalama
- **Turbo** - SPA benzeri deneyim
- **CSS3** - Modern stillendirme

### Gems
```ruby
gem 'rails', '~> 7.0'
gem 'sqlite3', '~> 1.4'
gem 'kaminari'              # Sayfalama
gem 'image_processing'      # Resim işleme
```

## 🚀 Kurulum

### Gereksinimler

- Ruby 3.0 veya üzeri
- Rails 7.0 veya üzeri
- SQLite3
- Node.js ve Yarn (Asset pipeline için)

### Adımlar

1. **Projeyi klonlayın:**
```bash
git clone https://github.com/Yigit-cinal/basic-library-for-education.git
cd kutuphane-sistemi
```

2. **Bağımlılıkları yükleyin:**
```bash
bundle install
yarn install
```

3. **Veritabanını oluşturun:**
```bash
rails db:create
rails db:migrate
```

4. **Örnek veri yükleyin (opsiyonel):**
```bash
rails db:seed
```

5. **Sunucuyu başlatın:**
```bash
rails server
```

6. **Tarayıcıda açın:**
```
http://localhost:3000
```

### Admin Girişi

```
Kullanıcı Adı: admin
Şifre: admin123
```

⚠️ **Önemli:** Production ortamında mutlaka şifreyi değiştirin!

## 📖 Kullanım

### Kitap Ekleme

1. Admin olarak giriş yapın
2. "Yeni Kitap Ekle" butonuna tıklayın
3. Kitap bilgilerini doldurun
4. Resim yükleyin (bilgisayardan veya URL ile)
5. "Kitap Ekle" butonuna tıklayın

### Ödünç Verme

1. Ana sayfada kitap bulun
2. "Ödünç Ver" butonuna tıklayın
3. Kişi bilgilerini girin (TC, ad, soyad, telefon, e-posta)
4. Ödünç süresini seçin (varsayılan: 14 gün)
5. "Ödünç Ver" butonuna tıklayın

### Kitap Teslim Alma

**Yöntem 1:** Ödünç Listesi'nden
1. "Ödünç Listesi" butonuna tıklayın
2. Teslim alınacak kitabı bulun
3. "Teslim Al" butonuna tıklayın

**Yöntem 2:** Kitap Detayı'ndan
1. Kitabın detay sayfasına gidin
2. "Kitabı Teslim Al" butonuna tıklayın

### Süre Aşımı Kontrolü

Manuel kontrol:
```bash
rails loans:maintenance
```

## 🗄 Veritabanı Yapısı

### Books (Kitaplar)
|    Alan    |   Tip   |     Açıklama     |
|------------|---------|------------------|
| id         | integer | Benzersiz kimlik |
| title      | string  | Kitap adı |
| author     | string  | Yazar |
| genre      | string  | Tür |
| category   | string  | Kategori |
| year       | integer | Yayın yılı |
| page_count | integer | Sayfa sayısı |
| image_url  | string  | Resim URL (opsiyonel) |
| status     | string  | Durum (available/borrowed) |

### Loans (Ödünçler)
|        Alan        |   Tip   |       Açıklama       |
|--------------------|---------|----------------------|
| id                 | integer | Benzersiz kimlik |
| book_id            | integer | Kitap referansı |
| borrower_id        | integer | Ödünç alan kişi referansı |
| loan_date          | date    | Ödünç alma tarihi |
| return_date        | date    | İade tarihi |
| actual_return_date | date    | Gerçek iade tarihi |
| status             | string  | Durum (active/returned/overdue) |

### Borrowers (Ödünç Alanlar)
|   Alan   |   Tip   |     Açıklama     |
|----------|---------|------------------|
| id       | integer | Benzersiz kimlik |
| tc_no    | string  | TC kimlik no (11 hane) |
| name     | string  | Ad |
| surname  | string  | Soyad |
| phone    | string  | Telefon |
| email    | string  | E-posta |

### İlişkiler

```
Book 1----* Loan *----1 Borrower
Book 1----1 current_loan (active/overdue)
```

## 🔧 Yapılandırma

### Ortam Değişkenleri

`.env` dosyası oluşturun:

```bash
# Admin bilgileri
ADMIN_USERNAME=admin
ADMIN_PASSWORD=super_secret_password

# Veritabanı
DATABASE_URL=sqlite3:db/production.sqlite3

# Active Storage
ACTIVE_STORAGE_SERVICE=local
```

### Production Ayarları

**config/environments/production.rb:**

```ruby
# Active Storage için
config.active_storage.service = :local

# Asset pipeline
config.assets.compile = false

# Güvenlik
config.force_ssl = true
```

## 🧪 Test

```bash
# Tüm testleri çalıştır
rails test

# Belirli bir test dosyası
rails test test/models/book_test.rb

# Coverage raporu
rails test:coverage
```

## 🐛 Bilinen Sorunlar

- [ ] Çoklu admin kullanıcı desteği yok
- [ ] E-posta bildirimleri henüz eklenmedi
- [ ] Excel/PDF export özelliği yok

## 👨‍💻 Geliştirici

**[Yigit Cinal]**
- GitHub: [@Yigit-cinal](https://github.com/Yigit-cinal)


## 🙏 Teşekkürler

- Rails topluluğuna
