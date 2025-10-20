namespace :loans do
  desc "Update overdue loans and send notifications"
  task maintenance: :environment do
    puts "Starting loan maintenance task..."
    puts "Current date: #{Date.current}"
    
    # Önce tüm active loan'ları kontrol edelim
    all_active_loans = Loan.where(status: 'active')
    puts "Total active loans: #{all_active_loans.count}"
    
    all_active_loans.each do |loan|
      puts "Loan ID: #{loan.id}, Return Date: #{loan.return_date}, Status: #{loan.status}"
      puts "  Return date < current date? #{loan.return_date < Date.current}"
    end
    
    # Manuel SQL sorgusu ile kontrol edelim
    puts "\n--- Manual SQL Query ---"
    expired_loans_sql = Loan.where('return_date < ? AND status = ?', Date.current, 'active')
    puts "SQL query result count: #{expired_loans_sql.count}"
    
    expired_loans_sql.each do |loan|
      puts "Expired loan found - ID: #{loan.id}, Return Date: #{loan.return_date}"
    end
    
    # Süre aşımı kitapları güncelle
    overdue_count = expired_loans_sql.update_all(status: 'overdue')
    puts "Updated #{overdue_count} loans to overdue status"
    
    # Yarın süresi dolacak kitaplar için bildirim
    due_tomorrow = Loan.where(return_date: Date.tomorrow, status: 'active').includes(:book, :borrower)
    puts "Books due tomorrow (#{due_tomorrow.count}):"
    due_tomorrow.each do |loan|
      puts "- #{loan.book.title} | #{loan.borrower.full_name} | #{loan.borrower.phone}"
    end
    
    # Bugün süresi dolacak kitaplar için bildirim
    due_today = Loan.where(return_date: Date.current, status: 'active').includes(:book, :borrower)
    puts "Books due today (#{due_today.count}):"
    due_today.each do |loan|
      puts "- #{loan.book.title} | #{loan.borrower.full_name} | #{loan.borrower.phone}"
    end
    
    puts "Loan maintenance task completed!"
  end
end