class Author
  attr_reader(:last_name, :first_name, :id)

  def initialize(attributes)
    @last_name = attributes.fetch(:last_name)
    @first_name = attributes.fetch(:first_name)
    @id = attributes.fetch(:id)
  end
  
  def save()
    id = DB.exec("INSERT INTO authors (last_name, first_name) VALUES ('#{@last_name}', '#{@first_name}') RETURNING id;")
    @id = id.first().fetch('id').to_i()
  end
  
  def delete()
    DB.exec("DELETE FROM authors WHERE id = #{self.id()}")
  end
  
  def update(updates)
    attributes = {:last_name => @last_name, :first_name => @first_name}
    attributes.merge!(updates)
    @last_name = attributes.fetch(:last_name)
    @first_name = attributes.fetch(:first_name)
  end
  
  def self.all()
    returned_authors = DB.exec("SELECT * FROM authors;")
    authors = []
    returned_authors.each() do |author|
      last_name = author.fetch('last_name')
      first_name = author.fetch('first_name')
      authors.push(Author.new({:last_name => last_name, :first_name => first_name, :id => nil}))
    end
    authors
  end
  
  def ==(comparison)
    self.last_name() == comparison.last_name() && self.first_name() == comparison.first_name()
  end
end