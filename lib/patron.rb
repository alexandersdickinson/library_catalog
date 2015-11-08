class Patron
  attr_reader(:last_name, :first_name, :id)
  
  def initialize(attributes)
    @last_name = attributes.fetch(:last_name)
    @first_name = attributes.fetch(:first_name)
    @id = attributes.fetch(:id)
  end
  
  def check_out(book)
    if book.is_checked_out()
      return false
    else
      book.update({:is_checked_out => true, :patron_id => self.id(), :checkout => Date.today().to_s()})
      DB.exec("INSERT INTO checkouts (patron_id, book_id) VALUES (#{self.id()}, #{book.id()});")
    end
  end
  
  def books()
    books = []
    Book.all().each { |book| books.push(book) if book.patron_id() == self.id() }
    books
  end 
  
  def overdue()
    overdue_books = []
    self.books().each { |book| overdue_books.push(book) if book.overdue?() }
    overdue_books
  end
  
  def checkout_history()
    returned_checkouts = DB.exec("SELECT * FROM checkouts WHERE patron_id = #{self.id()};")
    books = returned_checkouts.map { |checkout| Book.find(checkout.fetch('book_id').to_i())}
  end
  
  def return(book)
    book.update({:is_checked_out => false, :patron_id => 0})
  end
    
  def save()
    id = DB.exec("INSERT INTO patrons (last_name, first_name) VALUES ('#{@last_name}', '#{@first_name}') RETURNING id;")
    @id = id.first().fetch('id').to_i()
  end
  
  def delete()
    DB.exec("DELETE FROM patrons WHERE id = #{self.id()};")
  end
  
  def update(updates)
    attributes = {:last_name => @last_name, :first_name => @first_name}
    attributes.merge!(updates)
    @last_name = attributes.fetch(:last_name)
    @first_name = attributes.fetch(:first_name)
    DB.exec("UPDATE patrons SET last_name = '#{@last_name}', first_name = '#{@first_name}' WHERE id = #{self.id()};")
  end
  
  def self.all()
    returned_patrons = DB.exec("SELECT * FROM patrons;")
    patrons = []
    returned_patrons.each() do |patron|
      last_name = patron.fetch('last_name')
      first_name = patron.fetch('first_name')
      id = patron.fetch('id').to_i()
      patrons.push(Patron.new({:last_name => last_name, :first_name => first_name, :id => id}))
    end
    patrons
  end
  
  def self.find(id)
    Patron.all().each() do |patron|
      return patron if patron.id() == id
    end
  end
  
  def ==(comparison)
    self.last_name() == comparison.last_name() && self.first_name() == self.first_name()
  end
end