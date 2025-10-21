class Book < ApplicationRecord
  has_many :loans, dependent: :destroy
  has_one :current_loan, -> { where(status: [ "active", "overdue" ]) }, class_name: "Loan"

  has_one_attached :image

  validates :title, presence: { message: "Kitap adı boş bırakılamaz" }
  validates :author, presence: { message: "Yazar adı boş bırakılamaz" }
  validates :genre, presence: { message: "Tür boş bırakılamaz" }
  validates :category, presence: { message: "Kategori boş bırakılamaz" }
  validates :year, presence: { message: "Yıl boş bırakılamaz" },
                   numericality: {
                     greater_than: 0,
                     less_than_or_equal_to: Date.current.year,
                     message: "Geçerli bir yıl giriniz"
                   }
  validates :page_count, presence: { message: "Sayfa sayısı boş bırakılamaz" },
                         numericality: {
                           greater_than: 0,
                           message: "Sayfa sayısı 0'dan büyük olmalıdır"
                         }
  validates :image_url, format: {
    with: URI::DEFAULT_PARSER.make_regexp(%w[http https]),
    message: "Geçerli bir URL giriniz",
    allow_blank: true
  }

  scope :search_by_name, ->(query) {
    where("title ILIKE ? OR author ILIKE ?", "%#{query}%", "%#{query}%")
  }

   def display_image
    if image.attached?
      image
    elsif image_url.present?
      image_url
    else
      nil
    end
  end

  def has_image?
    image.attached? || image_url.present?
  end

  def available?
    status != "borrowed"
  end

  def borrowed?
    status == "borrowed"
  end

  def status_text
    case status
    when "borrowed"
      "Ödünç Verildi"
    else
      "Mevcut"
    end
  end
end
