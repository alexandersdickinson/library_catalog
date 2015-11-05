class Patron
  attr_reader(:last_name, :first_name, :id)
  
  def initialize(attributes)
    @last_name = attributes.fetch(:last_name)
    @first_name = attributes.fetch(:first_name)
    @id = attributes.fetch(:id)
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
    DB.exec("UPDATE patrons SET last_name = '#{@last_name}', first_name = '#{@first_name}' WHERE id = #{self.id()}")
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