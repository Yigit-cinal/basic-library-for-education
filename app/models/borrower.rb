class Borrower < ApplicationRecord
  has_many :loans, dependent: :destroy
  has_many :books, through: :loans

  validates :tc_no, presence: { message: "TC kimlik numarası boş bırakılamaz" },
                    length: { is: 11, message: "TC kimlik numarası 11 haneli olmalıdır" },
                    numericality: { only_integer: true, message: "TC kimlik numarası sadece rakam içermelidir" },
                    uniqueness: { message: "Bu TC kimlik numarası zaten kayıtlı" }
  validates :name, presence: { message: "İsim boş bırakılamaz" }
  validates :surname, presence: { message: "Soyisim boş bırakılamaz" }
  validates :phone, presence: { message: "Telefon numarası boş bırakılamaz" }
  validates :email, presence: { message: "E-posta adresi boş bırakılamaz" },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "Geçerli bir e-posta adresi giriniz" }

  def full_name
    "#{name} #{surname}"
  end
end
