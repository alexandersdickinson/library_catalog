class Book
  attr_reader(:title, :checkout, :author_id, :patron_id, :is_checked_out, :id)
  
  def initialize(attributes)
    @title = attributes.fetch(:title)
    @checkout = attributes.fetch(:checkout)
    @author_id = attributes.fetch(:author_id)
    @patron_id = attributes.fetch(:patron_id)
    @is_checked_out = false
    @id = attributes.fetch(:id)
  end
  
  def save()
    id = DB.exec("INSERT INTO books (title, checkout, author_id, patron_id, is_checked_out) VALUES ('#{@title}', '#{@checkout}', #{@author_id}, #{@patron_id}, #{@is_checked_out}) RETURNING id;")
    @id = id.first().fetch('id').to_i()
  end
  
  def delete()
    DB.exec("DELETE FROM books WHERE id = #{self.id()};")
  end
  
  def update(updates)
    attributes = {:title => @title, :checkout => @checkout, :author_id => @author_id, :patron_id => @patron_id, :is_checked_out => @is_checked_out}
    attributes.merge!(updates)
    @title = attributes.fetch(:title)
    @checkout = attributes.fetch(:checkout)
    @author_id = attributes.fetch(:author_id)
    @patron_id = attributes.fetch(:patron_id)
    @is_checked_out = attributes.fetch(:is_checked_out)
    DB.exec("UPDATE books SET title = '#{@title}', checkout = '#{@checkout}', author_id = #{@author_id}, patron_id = #{@patron_id}, is_checked_out = #{@is_checked_out} WHERE id = #{self.id()};")
  end
  
  def self.all()
    returned_books = DB.exec("SELECT * FROM books;")
    books = []
    returned_books.each() do |book|
      title = book.fetch('title')
      checkout = book.fetch('checkout')
      author_id = book.fetch('author_id').to_i()
      patron_id = book.fetch('patron_id').to_i()
      id = book.fetch('id').to_i()
      is_checked_out = book.fetch('is_checked_out')
      books.push(Book.new({:title => title, :checkout => checkout, :author_id => author_id, :patron_id => patron_id, :is_checked_out => is_checked_out, :id => id}))
    end
    books
  end
  
  def self.find(id)
    Book.all().each() do |book|
      return book if book.id() == id
    end
  end
  
  def ==(comparison)
    self.title() == comparison.title()
  end
end