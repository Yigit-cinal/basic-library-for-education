class Loan < ApplicationRecord
  belongs_to :book
  belongs_to :borrower

  validates :loan_date, presence: { message: "Ödünç alma tarihi boş bırakılamaz" }
  validates :return_date, presence: { message: "Geri verme tarihi boş bırakılamaz" }
  validates :status, presence: true, inclusion: { in: %w[active returned overdue] }

  validate :return_date_after_loan_date

  scope :active_loans, -> { where(status: [ "active", "overdue" ]) }
  scope :overdue_loans, -> { where(status: "overdue") }
  scope :due_tomorrow, -> { where(return_date: Date.tomorrow, status: "active") }
  scope :due_today, -> { where(return_date: Date.current, status: "active") }
  scope :expired_today, -> { where("return_date < ? AND status = ?", Date.current, "active") }

  def overdue?
    return false if status == "returned"
    return_date.to_date < Date.current
  end

  def days_remaining
    return 0 if overdue? || status == "returned"
    [ (return_date.to_date - Date.current).to_i, 0 ].max
  end

  def days_overdue
    return 0 unless overdue?
    (Date.current - return_date.to_date).to_i
  end

  def formatted_return_date
    return_date.strftime("%d.%m.%Y")
  end

  def formatted_loan_date
    loan_date.strftime("%d.%m.%Y")
  end

  def self.fix_and_debug_dates
    puts "=== FIXING AND DEBUGGING DATES ==="
    puts "Server time zone: #{Time.zone}"
    puts "Current date: #{Date.current}"

    update_count = update_overdue_loans
    puts "Updated #{update_count} loans to overdue"

    overdue_loans.includes(:book, :borrower).each do |loan|
      puts "\n--- Loan ID: #{loan.id} ---"
      puts "Book: #{loan.book.title}"
      puts "Borrower: #{loan.borrower.full_name}"
      puts "Days overdue: #{loan.days_overdue}"
      puts "Status: #{loan.status}"
    end
  end

  def self.update_overdue_loans
    expired_loans = expired_today
    expired_loans.update_all(status: "overdue")
    expired_loans.count
  end

  def active?
    status == "active"
  end

  def returned?
    status == "returned"
  end

  def overdue_status?
    status == "overdue"
  end

  private

  def return_date_after_loan_date
    return unless loan_date && return_date

    if return_date <= loan_date
      errors.add(:return_date, "Geri verme tarihi ödünç alma tarihinden sonra olmalıdır")
    end
  end
end
