class BooksController < ApplicationController
  before_action :set_book, only: [ :show, :edit, :update, :destroy ]
  before_action :require_admin, only: [ :new, :create, :edit, :update, :destroy ]

def index
  @books = Book.includes(:current_loan)

  if params[:query].present?
    @books = @books.where("LOWER(title) LIKE ?", "%#{params[:query].downcase}%")
  end

  @books = @books.page(params[:page]).per(50)
end



  def show
    Loan.update_overdue_loans
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to root_path, notice: "Kitap başarıyla eklendi!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: "Kitap başarıyla güncellendi!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    redirect_to root_path, notice: "Kitap başarıyla silindi!"
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
  params.require(:book).permit(:title, :author, :genre, :category, :year, :page_count, :image_url, :image)
end

  def require_admin
    unless admin_logged_in?
      redirect_to root_path, alert: "Bu işlem için admin girişi gerekli!"
    end
  end
end
