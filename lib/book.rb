class Book
  attr_reader(:title, :checkout, :author_id, :patron_id, :id)
  
  def initialize(attributes)
    @title = attributes.fetch(:title)
    @checkout = attributes.fetch(:checkout)
    @author_id = attributes.fetch(:author_id)
    @patron_id = attributes.fetch(:patron_id)
    @id = attributes.fetch(:id)
  end
  
  def save()
    id = DB.exec("INSERT INTO books (title)")
  end
  
  def ==(comparison)
    self.title() == comparison.title()
  end
end