class LoansController < ApplicationController
  before_action :require_admin
  before_action :set_loan, only: [ :show, :update, :return_book ]
  before_action :set_book, only: [ :new, :create ]

  def index
    Loan.update_overdue_loans

    @active_loans = Loan.includes(:book, :borrower)
                       .where(status: "active")
                       .order(:return_date)

    @overdue_loans = Loan.includes(:book, :borrower)
                        .where(status: "overdue")
                        .order(:return_date)
  end

  def show
  end

  def new
    @loan = @book.loans.build
    @borrower = Borrower.new
  end

  def create
    @borrower = Borrower.find_by(tc_no: loan_params[:borrower_attributes][:tc_no])

    if @borrower.nil?
      @borrower = Borrower.new(loan_params[:borrower_attributes])
      unless @borrower.save
        @loan = @book.loans.build
        render :new and return
      end
    end

    @loan = @book.loans.build(
      borrower: @borrower,
      loan_date: Date.current,
      return_date: Date.current + loan_params[:loan_duration].to_i.days,
      status: "active"
    )

    if @loan.save
      @book.update(status: "borrowed")
      redirect_to @book, notice: "Kitap başarıyla ödünç verildi!"
    else
      render :new
    end
  end

  def return_book
    if @loan.update(status: "returned", actual_return_date: Date.current)
      @loan.book.update(status: "available")
      redirect_to loans_path, notice: "Kitap başarıyla teslim alındı!"
    else
      redirect_to loans_path, alert: "Teslim alma işlemi başarısız!"
    end
  end

  private

  def set_loan
    @loan = Loan.find(params[:id])
  end

  def set_book
    @book = Book.find(params[:book_id])
  end

  def loan_params
    params.require(:loan).permit(:loan_duration, borrower_attributes: [ :tc_no, :name, :surname, :phone, :email ])
  end

  def require_admin
    unless admin_logged_in?
      redirect_to root_path, alert: "Bu işlem için admin girişi gerekli!"
    end
  end
end
